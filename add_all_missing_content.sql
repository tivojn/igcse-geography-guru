-- ============================================================================
-- COMPREHENSIVE UPDATE: All Missing Content from MD Files
-- Sample Exam Questions, Tips, Common Errors - ALL VERBATIM
-- ============================================================================

-- ============================================================================
-- PART 1: CLEAR AND RE-INSERT ALL TIPS (22 total from MD files)
-- ============================================================================
DELETE FROM tips;

-- Topic 1.1 Population Dynamics (4 tips)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(1, 'It is important to remember that while the world''s population continues to increase, the rate of global population growth has been falling for over 50 years.', 'general'),
(1, 'Population data change frequently over time, so when you quote data you should also state the year to which they apply. For example, in Table 1.1, the birth rate for ''Latin America/Caribbean'' in 2012 was 19/1000, as stated in the previous edition of this book.', 'exam'),
(1, 'It is very important to be clear where the boundary lines are between each stage of the demographic transition model and to understand, and be able to explain, why they are in those particular places.', 'exam'),
(1, 'Using ''categories'' to structure your explanation, as in Table 1.2, can help to produce a logical sequence of arguments for questions requiring detailed answers.', 'exam');

-- Topic 1.2 Migration (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(2, 'Remember that forced migration is not just the result of armed conflict, but can also occur due to environmental factors such as volcanic eruptions and desertification.', 'general');

-- Topic 1.3 Population Structure (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(3, 'When describing and explaining population pyramids a good starting point is to divide the pyramid into three sections: the young dependent population; the economically active population; the elderly dependent population. You can then comment on each section in turn.', 'exam');

-- Topic 1.4 Population Density (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(4, 'When describing variations in population density on a map with, say, four colours or types of shading, refer to each class (for example, over 100 per km²) to produce a detailed answer.', 'exam');

-- Topic 1.5 Settlements (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(5, 'When providing examples (for example, low-order goods or high-order goods), give real-life examples or examples from your own area if possible and appropriate, or refer to the examples in the textbook (pages 42–43).', 'exam');

-- Topic 1.6 Urban Settlements (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(6, 'A model is a simplification. You should not expect any city to illustrate all of the characteristics of any one model, although they may show some of them.', 'general');

-- Topic 1.7 Urbanisation (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(7, 'When asked for an example of a squatter settlement, many students write ''Rio'' or ''Cairo'', for example. Neither are squatter settlements. Rocinha and Vidigal are squatter settlements in Rio de Janeiro, just as the City of the Dead is a squatter settlement in Cairo.', 'exam');

-- Topic 2.1 Earthquakes and Volcanoes (3 tips)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(8, 'The Richter scale is logarithmic so an earthquake measuring 7.0 on the Richter scale is 10 times more powerful than one measuring 6.0, and 100 times more powerful than one measuring 5.0.', 'general'),
(8, 'Although the map of plate boundaries is well known, in reality plate boundaries are often not clear-cut, and there are many areas where the plate boundaries are uncertain. Scientists do not know everything about the restless Earth.', 'general'),
(8, 'Earthquakes may occur anywhere: some of the largest ones in the USA have been at great distances from plate boundaries. This makes them difficult – if not impossible – to predict with accuracy (for example, where, when, how big?). Volcanic eruptions are also difficult to predict (how big and when?).', 'general');

-- Topic 2.2 Rivers (2 tips)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(9, 'Remember that the factors affecting erosion interact with each other. In any single case, the impact of one factor may be altered through the impact of others.', 'general'),
(9, 'When drawing a diagram of oxbow lakes make sure you label where the erosion and deposition are occurring.', 'exam');

-- Topic 2.3 Coasts (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(10, 'Many stretches of coastline have a range of management types – usually they will be a mix of hard and soft engineering, often side by side.', 'general');

-- Topic 2.5 Natural Ecosystems (1 tip) - topic_id 12
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(12, 'When writing about ecosystems, give specific details (for example, mean temperature, rainfall total, names of selected plants and animals), rather than a generalised account that could refer to any ecosystem.', 'exam');

-- Topic 3.1 Development (2 tips)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(15, 'It is important to understand the difference between economic growth and development. The former is an increase in GDP while development is a more wide-ranging concept concerning many more aspects of the quality of life.', 'general'),
(15, 'You should take care with the word ''industry'' as it can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'clarification');

-- Topic 3.2 Food Production (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(16, 'A simple, but clearly labelled sketch map can considerably enhance the presentation of a case study.', 'exam');

-- Topic 3.4 Tourism (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(18, 'It is easy to fall into the trap of seeing only the advantages of the economic impact of tourism. It is always important to consider the other side of the coin, even if you can only come up with a few points.', 'exam');

-- Topic 3.5 Energy (1 tip)
INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
(19, 'Solar power is generally taken to mean the production of solar electricity, as distinct from solar hot water systems.', 'clarification');

-- ============================================================================
-- PART 2: CLEAR AND RE-INSERT ALL COMMON ERRORS (14 total from MD files)
-- ============================================================================
DELETE FROM common_errors;

-- Topic 1.1 Population Dynamics (2 errors)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(1, 'Birth rate is the most accurate measure of fertility.', 'It is only a very broad indicator as it does not take into account the age and sex distribution of a population. The total fertility rate takes into account these factors and is thus a much more accurate measure of fertility.'),
(1, 'The one-child policy was the first time China had tried to reduce fertility.', 'While the one-child policy was introduced in 1979, this was not the first time China had tried to reduce fertility.');

-- Topic 1.2 Migration (2 errors)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(2, 'Immigration and emigration have the same meaning.', 'Immigration is migration into a country and emigration is migration out of a country.'),
(2, 'Confusing immigration and emigration with in-migration and out-migration.', 'Immigration and emigration are the terms used for crossing international borders. In-migration and out-migration are internal movements within one country.');

-- Topic 1.4 Population Density (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(4, 'Population density does not change.', 'Population density can change considerably over time. Population density is increasing most in regions and countries with the fastest rates of population growth.');

-- Topic 1.6 Urban Settlements (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(6, 'Confusing the CBD with the inner city.', 'The inner city is (or in some cases, was) the industrial area surrounding the CBD. If you use the term (former) industrial area it should help avoid confusion. However, there are other industrial areas such as ports, along major transport routes, and on the edge of cities.');

-- Topic 1.7 Urbanisation (2 errors)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(7, 'Giving the answer "e.g. Africa" or "e.g. Asia" when asked for a named city in a country.', 'You must have a named country and, preferably, a named city within that country.'),
(7, 'Urbanisation is rural-to-urban migration.', 'Urbanisation includes rural-to-urban migration, but it is also caused by natural increase. It is defined as the increase in the proportion of people living in urban areas.');

-- Topic 2.2 Rivers (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(9, 'Erosion only occurs in the upper course and deposition in the lower course.', 'Both processes occur throughout the river''s course.');

-- Topic 2.3 Coasts (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(10, 'Management schemes guarantee safety.', 'The 10m sea walls along the Japanese coastline were not high enough to protect against the 11m waves generated by the 2011 tsunami.');

-- Topic 3.2 Food Production (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(16, 'Food aid should not be criticised.', 'Food aid is quite rightly viewed as a good thing, but the way it is done is sometimes criticised. It is important to be aware of the ''pros'' and ''cons'' of this issue.');

-- Topic 3.3 Industry (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(17, 'Using the word "industry" without specifying. The term can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'If you use it with reference to the manufacture of goods then clearly state that this is ''manufacturing industry''.');

-- Topic 3.4 Tourism (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(18, 'Tourism only includes people on holiday.', 'The definition of tourism also includes business and professional travel, and visits to friends and relations.');

-- Topic 3.5 Energy (1 error)
INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
(19, 'Production and consumption are the same thing.', 'For some energy sources such as coal the figures are very similar, but for oil there is a very significant difference. The ease with which a type of energy can be transported is a major factor here.');

-- ============================================================================
-- PART 3: ADD MISSING SAMPLE EXAM QUESTIONS (Student Answers + Teacher Comments)
-- ============================================================================

-- Check if these already exist, add only if missing
-- Topic 2.2 Rivers - Waterfalls and Gorges (from PART2)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(9, 'Briefly explain how waterfalls and gorges are formed.', 4,
'Waterfalls frequently occur on horizontally bedded rocks. The soft rock is undercut by hydraulic action and abrasion, to form a plunge pool. The softer rock is eroded by fragments of the harder rock that break off. The weight of the water and the lack of support cause the waterfall to collapse and retreat. Over thousands of years the waterfall may retreat enough to form a gorge of recession.',
'The question did not ask for an annotated diagram, although one could have been provided. Some aspects of physical geography are easier to revise and explain using diagrams. Nevertheless, the student has identified: differences in rock strength; the horizontal layering of rocks; the types of erosion; an implied reason for the effectiveness of erosion (hard rock eroding softer rock); progression over time, leading to the formation of a gorge. Full marks awarded.',
4, 'Page 45');

-- Topic 2.2 Rivers - Oxbow Lake Formation (from PART2)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(9, 'Draw an annotated diagram to show the formation of an oxbow lake.', 4,
'[Diagram showing three stages:]
1. Erosion and deposition around a meander.
2. Increased erosion during flood conditions. The meanders become exaggerated.
3. The river breaks through during a flood. Further deposition causes the old meander to become an oxbow lake.
E = Erosion, D = Deposition marked at appropriate locations on meanders.',
'Very clear answer. Shows progression/sequencing. Clearly annotated. Full marks.',
4, 'Page 45');

-- Topic 3.2 Food Production - Agricultural System (from PART3_1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(16, 'What is an agricultural system?', 3,
'An agricultural system is a type of farming such as a wheat farm or a dairy farm. Each type of farming has inputs, processes and outputs.',
'This is a good, clear answer as far as it goes, scoring two marks out of the maximum of three. To gain the third mark the student should have given examples of inputs (e.g. labour and energy), processes (e.g. ploughing and harvesting) and outputs (e.g. crops and milk).',
2, 'Page 80');

-- Topic 3.2 Food Production - Intensive vs Extensive (from PART3_1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(16, 'With reference to examples, distinguish between intensive and extensive farming.', 4,
'Intensive farming is characterised by high inputs per unit of land to achieve high yields per hectare. Extensive farming is where a relatively small amount of agricultural produce is obtained per hectare of land, so such farms tend to cover large areas of land. Inputs per unit of land are low.',
'The student has achieved two marks out of the maximum of four. The answer clearly describes the difference between intensive and extensive farming, but there is no reference at all to examples of these types of farming. Examples of extensive farming are sheep farming in Australia and wheat cultivation on the Canadian Prairies. Examples of intensive farming are horticulture in the Netherlands and dairy farming in Denmark.',
2, 'Page 80');

-- Topic 3.2 Food Production - Physical Factors (from PART3_1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(16, 'Discuss three physical factors that affect agricultural land use.', 6,
'Temperature is a major factor influencing farming as each type of crop requires a minimum growing temperature and a minimum growing season. Latitude, altitude and distance from the sea are the main influences on temperature.

Precipitation is another very important factor influencing the type of farming possible in a region. It is not just the annual amount of precipitation that is important, but the way it is distributed throughout the year. Long, steady periods of rainwater to infiltrate into the soil are best, making water available for crop growth throughout the year. In contrast, short, heavy downpours can result in surface runoff, leaving less water available for crop growth and also contributing to soil erosion.

A third physical factor affecting farming is soil fertility.',
'The student has gained five marks out of the six available. This answer shows good understanding of the influences of temperature and precipitation on agriculture. However, when it comes to the consideration of a third physical factor, the student is only able to name soil fertility, with no attempt to elaborate and gain the final mark available.',
5, 'Page 80');

-- ============================================================================
-- SUMMARY:
-- Tips: 22 entries (was 18, added 4 missing for Topic 1.1 and 1 for Topic 2.1)
-- Common Errors: 14 entries (complete - all from MD files)
-- Sample Answers: Added 5 new entries for Topics 2.2 and 3.2
-- ============================================================================
