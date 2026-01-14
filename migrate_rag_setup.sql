-- ============================================================================
-- RAG SETUP: Enable pgvector and create tables for PDF chat feature
-- ============================================================================

-- Enable the pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- ============================================================================
-- PDF Documents Table - Stores metadata about uploaded PDFs
-- ============================================================================
CREATE TABLE IF NOT EXISTS pdf_documents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    filename TEXT NOT NULL,
    original_filename TEXT NOT NULL,
    storage_path TEXT NOT NULL,
    file_size INTEGER,
    page_count INTEGER,
    status TEXT DEFAULT 'pending', -- pending, processing, ready, error
    error_message TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- PDF Chunks Table - Stores text chunks with embeddings
-- ============================================================================
CREATE TABLE IF NOT EXISTS pdf_chunks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    document_id UUID REFERENCES pdf_documents(id) ON DELETE CASCADE,
    chunk_index INTEGER NOT NULL,
    page_number INTEGER NOT NULL,
    content TEXT NOT NULL,
    token_count INTEGER,
    embedding vector(1536), -- OpenAI text-embedding-3-small dimension
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create index for fast similarity search
CREATE INDEX IF NOT EXISTS pdf_chunks_embedding_idx ON pdf_chunks
USING ivfflat (embedding vector_cosine_ops) WITH (lists = 100);

-- Create index for document lookups
CREATE INDEX IF NOT EXISTS pdf_chunks_document_idx ON pdf_chunks(document_id);

-- ============================================================================
-- User Settings Table - Stores user API keys and preferences
-- ============================================================================
CREATE TABLE IF NOT EXISTS user_settings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE,
    openai_api_key TEXT, -- Encrypted in production
    anthropic_api_key TEXT,
    default_llm TEXT DEFAULT 'gpt-4o-mini', -- gpt-4o-mini, gpt-4o, claude-3-sonnet, etc.
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- Chat History Table - Stores conversation history
-- ============================================================================
CREATE TABLE IF NOT EXISTS chat_messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    document_id UUID REFERENCES pdf_documents(id) ON DELETE CASCADE,
    role TEXT NOT NULL, -- 'user' or 'assistant'
    content TEXT NOT NULL,
    sources JSONB, -- Array of {page_number, chunk_content, relevance_score}
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- Function to search similar chunks using cosine similarity
-- ============================================================================
CREATE OR REPLACE FUNCTION search_pdf_chunks(
    query_embedding vector(1536),
    match_count INT DEFAULT 5,
    filter_document_id UUID DEFAULT NULL
)
RETURNS TABLE (
    id UUID,
    document_id UUID,
    chunk_index INTEGER,
    page_number INTEGER,
    content TEXT,
    similarity FLOAT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        pc.id,
        pc.document_id,
        pc.chunk_index,
        pc.page_number,
        pc.content,
        1 - (pc.embedding <=> query_embedding) AS similarity
    FROM pdf_chunks pc
    WHERE (filter_document_id IS NULL OR pc.document_id = filter_document_id)
    ORDER BY pc.embedding <=> query_embedding
    LIMIT match_count;
END;
$$;

-- ============================================================================
-- Row Level Security Policies
-- ============================================================================

-- Enable RLS
ALTER TABLE pdf_documents ENABLE ROW LEVEL SECURITY;
ALTER TABLE pdf_chunks ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE chat_messages ENABLE ROW LEVEL SECURITY;

-- PDF Documents policies
CREATE POLICY "Users can view their own documents"
    ON pdf_documents FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own documents"
    ON pdf_documents FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own documents"
    ON pdf_documents FOR UPDATE
    USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own documents"
    ON pdf_documents FOR DELETE
    USING (auth.uid() = user_id);

-- PDF Chunks policies (access through document ownership)
CREATE POLICY "Users can view chunks of their documents"
    ON pdf_chunks FOR SELECT
    USING (
        EXISTS (
            SELECT 1 FROM pdf_documents
            WHERE pdf_documents.id = pdf_chunks.document_id
            AND pdf_documents.user_id = auth.uid()
        )
    );

-- User Settings policies
CREATE POLICY "Users can view their own settings"
    ON user_settings FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own settings"
    ON user_settings FOR INSERT
    WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own settings"
    ON user_settings FOR UPDATE
    USING (auth.uid() = user_id);

-- Chat Messages policies
CREATE POLICY "Users can view their own messages"
    ON chat_messages FOR SELECT
    USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own messages"
    ON chat_messages FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- ============================================================================
-- Allow anonymous/public read for development (remove in production)
-- ============================================================================
CREATE POLICY "Allow public read pdf_documents" ON pdf_documents
    FOR SELECT USING (true);

CREATE POLICY "Allow public insert pdf_documents" ON pdf_documents
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public update pdf_documents" ON pdf_documents
    FOR UPDATE USING (true);

CREATE POLICY "Allow public delete pdf_documents" ON pdf_documents
    FOR DELETE USING (true);

CREATE POLICY "Allow public read pdf_chunks" ON pdf_chunks
    FOR SELECT USING (true);

CREATE POLICY "Allow public insert pdf_chunks" ON pdf_chunks
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public read user_settings" ON user_settings
    FOR SELECT USING (true);

CREATE POLICY "Allow public insert user_settings" ON user_settings
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Allow public update user_settings" ON user_settings
    FOR UPDATE USING (true);

CREATE POLICY "Allow public read chat_messages" ON chat_messages
    FOR SELECT USING (true);

CREATE POLICY "Allow public insert chat_messages" ON chat_messages
    FOR INSERT WITH CHECK (true);

-- ============================================================================
-- SUMMARY:
-- Tables created:
--   - pdf_documents: PDF metadata and status
--   - pdf_chunks: Text chunks with vector embeddings
--   - user_settings: User API keys and preferences
--   - chat_messages: Conversation history
--
-- Functions created:
--   - search_pdf_chunks: Similarity search for RAG
--
-- Next steps:
--   1. Create storage bucket for PDFs
--   2. Build API endpoints for upload/embed/chat
-- ============================================================================
