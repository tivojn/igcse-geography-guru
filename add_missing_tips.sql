-- ============================================================================
-- Add Missing Tips - All tips verbatim from MD files
-- ============================================================================

-- Clear existing tips and re-insert all
DELETE FROM tips;

-- ============================================================================
-- Topic 1.1 Population Dynamics (4 tips from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(1, 'It is important to remember that while the world''s population continues to increase, the rate of global population growth has been falling for over 50 years.', 'general'),
(1, 'Population data change frequently over time, so when you quote data you should also state the year to which they apply. For example, in Table 1.1, the birth rate for ''Latin America/Caribbean'' in 2012 was 19/1000, as stated in the previous edition of this book.', 'exam'),
(1, 'It is very important to be clear where the boundary lines are between each stage of the demographic transition model and to understand, and be able to explain, why they are in those particular places.', 'exam'),
(1, 'Using ''categories'' to structure your explanation, as in Table 1.2, can help to produce a logical sequence of arguments for questions requiring detailed answers.', 'exam');

-- ============================================================================
-- Topic 1.2 Migration (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(2, 'Remember that forced migration is not just the result of armed conflict, but can also occur due to environmental factors such as volcanic eruptions and desertification.', 'general');

-- ============================================================================
-- Topic 1.3 Population Structure (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(3, 'When describing and explaining population pyramids a good starting point is to divide the pyramid into three sections: the young dependent population; the economically active population; the elderly dependent population. You can then comment on each section in turn.', 'exam');

-- ============================================================================
-- Topic 1.4 Population Density (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(4, 'When describing variations in population density on a map with, say, four colours or types of shading, refer to each class (for example, over 100 per km²) to produce a detailed answer.', 'exam');

-- ============================================================================
-- Topic 1.5 Settlements (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(5, 'When providing examples (for example, low-order goods or high-order goods), give real-life examples or examples from your own area if possible and appropriate, or refer to the examples in the textbook (pages 42–43).', 'exam');

-- ============================================================================
-- Topic 1.6 Urban Settlements (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(6, 'A model is a simplification. You should not expect any city to illustrate all of the characteristics of any one model, although they may show some of them.', 'general');

-- ============================================================================
-- Topic 1.7 Urbanisation (1 tip from PART1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(7, 'When asked for an example of a squatter settlement, many students write ''Rio'' or ''Cairo'', for example. Neither are squatter settlements. Rocinha and Vidigal are squatter settlements in Rio de Janeiro, just as the City of the Dead is a squatter settlement in Cairo.', 'exam');

-- ============================================================================
-- Topic 2.1 Earthquakes and Volcanoes (3 tips from PART2)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(8, 'The Richter scale is logarithmic so an earthquake measuring 7.0 on the Richter scale is 10 times more powerful than one measuring 6.0, and 100 times more powerful than one measuring 5.0.', 'general'),
(8, 'Although the map of plate boundaries is well known, in reality plate boundaries are often not clear-cut, and there are many areas where the plate boundaries are uncertain. Scientists do not know everything about the restless Earth.', 'general'),
(8, 'Earthquakes may occur anywhere: some of the largest ones in the USA have been at great distances from plate boundaries. This makes them difficult – if not impossible – to predict with accuracy (for example, where, when, how big?). Volcanic eruptions are also difficult to predict (how big and when?).', 'general');

-- ============================================================================
-- Topic 2.2 Rivers (2 tips from PART2)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(9, 'Remember that the factors affecting erosion interact with each other. In any single case, the impact of one factor may be altered through the impact of others.', 'general'),
(9, 'When drawing a diagram of oxbow lakes make sure you label where the erosion and deposition are occurring.', 'exam');

-- ============================================================================
-- Topic 2.3 Coasts (1 tip from PART2)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(10, 'Many stretches of coastline have a range of management types – usually they will be a mix of hard and soft engineering, often side by side.', 'general');

-- ============================================================================
-- Topic 2.5 Natural Ecosystems (1 tip from PART2) - assuming topic_id 12
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(12, 'When writing about ecosystems, give specific details (for example, mean temperature, rainfall total, names of selected plants and animals), rather than a generalised account that could refer to any ecosystem.', 'exam');

-- ============================================================================
-- Topic 3.1 Development (2 tips from PART3_1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(15, 'It is important to understand the difference between economic growth and development. The former is an increase in GDP while development is a more wide-ranging concept concerning many more aspects of the quality of life.', 'general'),
(15, 'You should take care with the word ''industry'' as it can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'clarification');

-- ============================================================================
-- Topic 3.2 Food Production (1 tip from PART3_1)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(16, 'A simple, but clearly labelled sketch map can considerably enhance the presentation of a case study.', 'exam');

-- ============================================================================
-- Topic 3.4 Tourism (1 tip from PART3_2)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(18, 'It is easy to fall into the trap of seeing only the advantages of the economic impact of tourism. It is always important to consider the other side of the coin, even if you can only come up with a few points.', 'exam');

-- ============================================================================
-- Topic 3.5 Energy (1 tip from PART3_3)
-- ============================================================================
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(19, 'Solar power is generally taken to mean the production of solar electricity, as distinct from solar hot water systems.', 'clarification');

-- ============================================================================
-- END - Total: 22 tips from MD files
-- ============================================================================
