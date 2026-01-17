# IGCSE Geography Guru - AI Guidelines

## Project Overview
AI-powered study platform for IGCSE Geography students with Topics, Flashcards, Quiz, Exam Questions, Case Studies, and RAG-powered Document Chat.

## Tech Stack
- Frontend: React (single HTML file with embedded JSX)
- Backend: Python (Vercel Serverless Functions)
- Database: Supabase (PostgreSQL with pgvector)
- AI: OpenAI embeddings + Claude/Gemini/OpenAI for chat

## Skills Reference

### React Best Practices
See `.claude/skills/react-best-practices/SKILL.md` for performance optimization rules.

Key priorities:
1. Eliminate async waterfalls
2. Optimize bundle size
3. Server-side performance
4. Minimize re-renders

### Web Design Guidelines
See `.claude/skills/web-design-guidelines/SKILL.md` for UI/UX rules.

Key principles:
- Accessibility first (semantic HTML, keyboard support, focus states)
- Visual feedback (hover/focus states, reduced-motion support)
- URL reflects state (deep-linkable UI)
- Handle empty states and edge cases

## Code Conventions
- Keep React components in `public/index.html`
- API routes in `api/index.py`
- Use Tailwind CSS for styling
- Follow existing patterns for consistency
