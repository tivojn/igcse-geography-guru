-- ============================================================================
-- IGCSE Geography Guru - Database Migration v5 FIXED
-- Contains ONLY actual content from MD source files
-- NO generated/made-up questions - all content from Cambridge Study Guide
-- ============================================================================

-- PART 0: Drop existing tables and policies (clean slate)
-- ============================================================================
DROP POLICY IF EXISTS "Allow authenticated read exam_questions" ON exam_questions;
DROP POLICY IF EXISTS "Allow authenticated read sample_answers" ON sample_answers;
DROP POLICY IF EXISTS "Allow authenticated read tips" ON tips;
DROP POLICY IF EXISTS "Allow authenticated read common_errors" ON common_errors;
DROP POLICY IF EXISTS "Allow authenticated read case_studies" ON case_studies;
DROP POLICY IF EXISTS "Allow authenticated read learning_objectives" ON learning_objectives;
DROP POLICY IF EXISTS "Allow anon read exam_questions" ON exam_questions;
DROP POLICY IF EXISTS "Allow anon read sample_answers" ON sample_answers;
DROP POLICY IF EXISTS "Allow anon read tips" ON tips;
DROP POLICY IF EXISTS "Allow anon read common_errors" ON common_errors;
DROP POLICY IF EXISTS "Allow anon read case_studies" ON case_studies;
DROP POLICY IF EXISTS "Allow anon read learning_objectives" ON learning_objectives;

DROP TABLE IF EXISTS exam_questions CASCADE;
DROP TABLE IF EXISTS sample_answers CASCADE;
DROP TABLE IF EXISTS tips CASCADE;
DROP TABLE IF EXISTS common_errors CASCADE;
DROP TABLE IF EXISTS case_studies CASCADE;
DROP TABLE IF EXISTS learning_objectives CASCADE;

-- PART 1: Create new tables for enhanced features
-- ============================================================================

-- Exam questions table (exam-style questions with model answers)
CREATE TABLE exam_questions (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    question_number VARCHAR(10),
    question_text TEXT NOT NULL,
    marks INTEGER,
    model_answer TEXT,
    examiner_comments TEXT,
    source_page VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Sample answers table (sample exam questions with student answers and teacher feedback)
CREATE TABLE sample_answers (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    question_text TEXT NOT NULL,
    marks INTEGER,
    student_answer TEXT,
    teacher_comments TEXT,
    marks_awarded INTEGER,
    source_page VARCHAR(20),
    created_at TIMESTAMP DEFAULT NOW()
);

-- Tips table
CREATE TABLE tips (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    tip_text TEXT NOT NULL,
    tip_type VARCHAR(50) DEFAULT 'general',
    created_at TIMESTAMP DEFAULT NOW()
);

-- Common errors table
CREATE TABLE common_errors (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    error_description TEXT NOT NULL,
    why_wrong TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Case studies table
CREATE TABLE case_studies (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    key_facts TEXT[],
    created_at TIMESTAMP DEFAULT NOW()
);

-- Learning objectives table
CREATE TABLE learning_objectives (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER REFERENCES topics(id),
    objective_text TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- PART 2: Enable RLS on new tables
-- ============================================================================
ALTER TABLE exam_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE sample_answers ENABLE ROW LEVEL SECURITY;
ALTER TABLE tips ENABLE ROW LEVEL SECURITY;
ALTER TABLE common_errors ENABLE ROW LEVEL SECURITY;
ALTER TABLE case_studies ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_objectives ENABLE ROW LEVEL SECURITY;

-- Create policies for authenticated users
CREATE POLICY "Allow authenticated read exam_questions" ON exam_questions FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated read sample_answers" ON sample_answers FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated read tips" ON tips FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated read common_errors" ON common_errors FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated read case_studies" ON case_studies FOR SELECT TO authenticated USING (true);
CREATE POLICY "Allow authenticated read learning_objectives" ON learning_objectives FOR SELECT TO authenticated USING (true);

-- Create policies for anon users (for public access)
CREATE POLICY "Allow anon read exam_questions" ON exam_questions FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon read sample_answers" ON sample_answers FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon read tips" ON tips FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon read common_errors" ON common_errors FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon read case_studies" ON case_studies FOR SELECT TO anon USING (true);
CREATE POLICY "Allow anon read learning_objectives" ON learning_objectives FOR SELECT TO anon USING (true);

-- ============================================================================
-- PART 3: SAMPLE EXAM QUESTIONS (Student Answers with Teacher Comments)
-- These are ACTUAL questions from the MD files with student responses
-- ============================================================================

-- Topic 1.1: Population Dynamics - Sample Exam Questions (from PART1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(1, 'Define birth rate.', 2,
'The number of births per 1000 population.',
'The student has achieved 1 mark out of the maximum of 2 because no time frame has been stated. The correct definition is ''The number of live births per 1000 population per year''. At IGCSE/GCSE a student would not be penalised for omitting ''live''.',
1, 'Page 11'),

(1, 'Describe and explain the rate of natural change at each stage of the model of demographic transition.', 5,
'In stage 1 the birth rate is high and slightly above the death rate, which varies due to factors such as disease and famine. There is a low rate of natural increase.

In stage 2 the birth rate remains high while the death rate falls significantly. The rate of natural increase becomes greater as stage 2 progresses, reaching a maximum at the boundary between stages 2 and 3.

In stage 3 the birth rate begins to fall, gradually reducing the gap with the death rate. As a result the rate of natural increase declines to reach a low level at the end of this stage.

In stage 4 birth and death rates are low, resulting in a low rate of natural increase.

In stage 5 the birth rate is lower than the death rate, resulting in natural decrease.

In summary, natural increase is low in stages 1 and 4. It is high in stages 2 and 3. Stage 5 is characterised by natural decrease.',
'This is a very good answer, scoring the maximum 5 marks. The student has accurately described and explained the situation in each of the five stages as well as supplying a concise summary.',
5, 'Page 11');

-- Topic 1.6: Urban Settlements - Sample Exam Question (from PART1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(6, 'Explain two characteristics of the CBD.', 4,
'The CBD has lots of shops and offices. It also has many high-rise buildings.',
'This is purely descriptive and does not explain the characteristics. The CBD has many shops and offices because it is very accessible and can be reached by many potential customers and workers. The buildings are high-rise because there is a shortage of land, and the land value is very high. Therefore, developers create new land by building upwards. Two marks awarded.',
2, 'Page 28');

-- Topic 2.2: Rivers - Sample Exam Question (from PART2)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(9, 'Outline the hazards and opportunities of living in a named river valley.', 7,
'The Nile Delta is one of the oldest intensively cultivated areas in the world. It is heavily populated and has a population density of about 16,000 people per km². Only 2.5 per cent of Egypt''s land area is suitable for intensive agriculture – up to 95 per cent of Egypt''s agricultural production comes from the Nile valley and delta. The delta has long been a source of freshwater and fertile silt, as well as an excellent location for the import and export of goods. The flat land makes building easy. However, it is increasingly under stress.

The delta covers around 25,000km², is home to around 66 per cent of the country''s rapidly growing population and provides over 60 per cent of the nation''s food supply. However, most of the delta is very low lying, and an increase in sea level of just 1m would flood 20 per cent of the area. Flooding by the river Nile is a potential problem. Excessive irrigation has led to waterlogging, whilst significant amounts of fertilisers and pesticides are leached into water courses along the delta. Seawater intrusion has led to the salinisation of groundwater.',
'The student has offered a range of benefits, two of which are supported with quantification. The student has made some general points about the risk of flooding – a recent example would be useful, or mention of the 2016 floods that killed 98 people in the upper Nile valley. A reason for the increased flood risk is given – numbers of people at risk, or names of cities at risk, or dates of the floods would have made this answer complete. Six marks awarded out of a maximum of seven.',
6, 'Page 45');

-- Topic 3.1: Development - Sample Exam Questions (from PART3_1)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(15, 'Which activities make up the primary sector of an economy?', 2,
'The primary sector exploits the raw materials in a country. The main economic activities in the primary sector are farming, fishing, forestry, mining and quarrying.',
'A clear and concise answer, gaining the two marks available. The answer comprises a good opening statement followed by relevant and accurate elaboration.',
2, 'Page 70'),

(15, 'Why does the primary sector dominate employment in the poorest countries of the world?', 3,
'The poorest countries of the world have more than 70% of their employment in the primary sector. Lack of investment in general means that agriculture and other areas of the primary sector are very labour intensive and jobs in the secondary and tertiary sectors are limited in number.',
'The opening sentence includes a useful statistic showing the extent of the dominance of the primary sector in poor countries. The following sentence provides the necessary explanation in terms of both the primary sector and the other sectors of the economy. The student gains the full three marks available.',
3, 'Page 70'),

(15, 'Explain the changes in employment structure that have occurred in NICs.', 4,
'In NICs such as China and Brazil employment in manufacturing has risen rapidly in recent decades. NICs have attracted high levels of foreign direct investment from transnational corporations. This has not just been in manufacturing, but in the service sector in some countries such as India. The increasing wealth of NICs allows for greater investment in agriculture. This includes mechanisation, which results in falling demand for labour on the land. So, as employment in the secondary and tertiary sectors rises, employment in the primary sector falls.',
'This answer shows clear knowledge and understanding of employment changes in the different sectors in NICs. Relevant use of examples adds to the quality of the answer. The student gains all four marks available.',
4, 'Page 70');

-- Topic 3.5: Energy - Sample Exam Questions (from PART3_3)
INSERT INTO sample_answers (topic_id, question_text, marks, student_answer, teacher_comments, marks_awarded, source_page) VALUES
(19, 'Define renewable energy.', 2,
'Renewable energy can be used over and over again. These resources are mainly forces of nature that are sustainable and which usually cause little or no environmental pollution. Examples are wind and solar power.',
'A good, clear definition with two examples provided. Full marks.',
2, 'Page 92'),

(19, 'Why is fuelwood such an important source of energy in the developing world?', 3,
'In developing countries about 2.5 billion people rely on fuelwood, charcoal and animal dung for cooking. Fuelwood and charcoal are collectively called fuelwood, which accounts for just over half of global wood production. Fuelwood provides much of the energy needs for sub-Saharan Africa. It is also the most important use of wood in Asia. So many people rely on fuelwood because other sources of energy are either not available where they live or they cannot afford to pay for them.',
'A very good answer that (a) shows how many people are reliant on fuelwood worldwide, (b) accurately defines fuelwood, and (c) states why so many people do not have access to other forms of energy. The student gains all three marks here.',
3, 'Page 92'),

(19, 'Discuss the advantages and disadvantages of nuclear power.', 6,
'There are many disadvantages of nuclear power. A nuclear power plant accident could release radiation into the atmosphere. There are big concerns about the storage of nuclear waste, particularly high-level waste. Nuclear power stations cost a great deal of money not just to build, but also to decommission when they can no longer produce energy effectively. There are also big security concerns about nuclear power. An advantage of nuclear power is that it does not produce greenhouse gases.',
'This is a good answer with regard to disadvantages with four significant concerns identified. However, only one advantage is considered. Because of this lack of balance the student only achieves four marks out of the six available. Other advantages that could be considered include: (a) reduced reliance on imported fossil fuels, (b) the increasing efficiency and reliability of nuclear energy, and (c) the fact that nuclear power is not as vulnerable to fuel price fluctuations as oil and gas.',
4, 'Page 92');

-- ============================================================================
-- PART 4: EXAM-STYLE QUESTIONS WITH MODEL ANSWERS
-- These are ACTUAL questions from the MD files with examiner model answers
-- ============================================================================

-- Topic 1.1: Population Dynamics - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(1, '1a', 'Define the birth rate and the total fertility rate.', 3,
'The birth rate is the number of live births per 1000 population per year in a country or region. The total fertility rate is the average number of children women have during their lifetimes in a country or region.',
'A clear and accurate distinction between the two definitions.',
'Page 128'),

(1, '1b', 'Which continent has the highest total fertility rate and which has the lowest?', 2,
'Africa has the highest total fertility rate, while Europe has the lowest.',
NULL,
'Page 128'),

(1, '1c', 'Suggest why the total fertility rate is a more detailed measure of fertility than the birth rate.', 3,
'Unlike the crude birth rate the total fertility rate takes account of both age structure and gender. It focuses only on women in the reproductive age range. It is thus a much more accurate measure of fertility than the birth rate.',
'Clearly identifies the key elements in the total fertility rate (TFR).',
'Page 128'),

(1, '2a', 'How does the infant mortality rate influence fertility?', 3,
'Where infant mortality is high, it is usual for many children to die before reaching adult life. In such societies, parents often have many children to compensate for these expected deaths. In many poor countries children are viewed as an economic asset. The infant mortality rate for the world as a whole was 41/1000 in 2012, ranging from 5/1000 in Europe to 67/1000 in Africa. It is not just coincidence that the continent with the lowest fertility is Europe and the continent with the highest fertility is Africa. There is a strong relationship between the infant mortality rate and the total fertility rate.',
'An answer with good sequence and progression, and good use of relevant data.',
'Page 128'),

(1, '2b', 'Explain the relationship between education and fertility illustrated by Figure 1.9.', 4,
'Education, especially female literacy, is seen by most experts as the key to lower fertility. With education comes a knowledge of birth control, greater social awareness, more opportunity for employment and a wider choice of action generally for women. When women have wider choices they generally marry later, start their families later and also have fewer children. Figure 1.9 shows that there is a strong negative correlation on the scatter graph which compares a large number of countries. As the percentage of girls in secondary education increases, the total fertility rate falls.',
'Shows clear understanding of the relationship between the two variables with accurate reference to the trend shown on the scatter graph.',
'Page 128');

-- Topic 1.2: Migration - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(2, '1a', 'Define migration.', 2,
'Migration is the movement of people across a specified boundary, national or international, to establish a new permanent place of residence.',
NULL,
'Page 128'),

(2, '1b', 'Explain the difference between voluntary and involuntary (forced) migration.', 2,
'In voluntary migration, the individual has a free choice about whether to migrate or not. In involuntary migrations, people are made to move against their will and this may be due to human or environmental factors. An example of a human factor would be ''ethnic cleansing''. An example of an environmental factor would be a volcanic eruption.',
'A good, clear distinction with relevant examples.',
'Page 128'),

(2, '1c', 'Discuss the barriers to migration.', 3,
'Prior to 1914, government controls on international migration were almost non-existent. The main obstacles to migration at the time were financial cost and the physical dangers associated with the journey, for example, the long voyage across the Atlantic Ocean from Europe to America in the eighteenth and nineteenth centuries. Since the early twentieth century, government controls on migration have been steadily tightened. Thus, immigration restrictions are by far the greatest barrier to legal migration today. Most governments are looking for migrants whose skills they need and who are likely to make a strong contribution to their new country. However, other barriers to migration remain, such as language, lack of awareness of opportunities and intolerance in receiving countries. For illegal migrants, the financial costs and physical dangers can be substantial as they try to avoid the barriers to entry. Thousands of people have died on the journey across the Mediterranean Sea from North Africa to Europe when overcrowded boats run by people traffickers have sunk.',
'Very good understanding of the way in which the barriers to migration have changed over time with excellent reference to recent illegal migration and the difficulties involved.',
'Page 129'),

(2, '2a', 'What is the distinction between push and pull factors?', 3,
'Push factors are negative conditions at the point of origin which encourage or force people to move. For example, a high level of unemployment is a major push factor in a region or a country. In contrast, pull factors are positive conditions at the point of destination which encourage people to migrate. An important pull factor is often much higher wages in another country or region. The nature of push and pull factors varies from country to country (and from person to person) and changes over time.',
'Clear distinction between push and pull factors with relevant examples.',
'Page 129'),

(2, '2b', 'Discuss the reasons for an international migration you have studied.', 6,
'One of the largest labour migrations in the world has been from Mexico to the USA. This migration has largely been the result of:
- much higher average incomes in the USA
- lower unemployment rates in the USA
- the faster growth of the labour force in Mexico, with significantly higher population growth in Mexico compared with the USA
- the overall difference in the quality of life: on virtually every aspect of the quality of life, conditions are better in the USA than Mexico.

All of these factors have made the USA an attractive destination for migrants from Mexico. Over time, large Mexican communities have developed, particularly in the four states along the US/Mexican border: California, Arizona, New Mexico and Texas. These communities provide important networks for new would-be migrants. Most migration between Mexico and the USA has taken place in the last three decades. Although previous surges occurred in the 1920s and 1950s when the US government allowed the recruitment of Mexican workers as guest workers, persistent mass migration between the two countries did not take hold until the late twentieth century.',
'A detailed answer identifying the relevant factors with good case study information.',
'Page 129');

-- Topic 1.3: Population Structure - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(3, '1a', 'What aspects of population structure are shown in a population pyramid?', 2,
'The two aspects of population structure shown in a population pyramid are age and gender.',
NULL,
'Page 129'),

(3, '1c', 'Describe the age structure of the Gambia.', 3,
'The very wide base of the Gambia''s population pyramid illustrates its very young population: 44 per cent of the population are classed as young dependents as they are under 15 years of age. The considerable reduction in the width of each successive bar with increasing age indicates high mortality and relatively low life expectancy. There are very few people indeed in the older age groups. Only 2 per cent of the population are over 65 and classed as elderly dependents. This gives a dependency ratio of 85. This means that for every 100 people in the economically active population in the Gambia there are 85 people dependent on them.',
'A clear sequence of discussion with detailed analysis of the population pyramid.',
'Page 129'),

(3, '2a', 'Define the dependency ratio.', 2,
'The dependency ratio is the relationship between the working or economically active population and the non-working population.',
NULL,
'Page 129'),

(3, '2b', 'What does a dependency ratio of 80 mean?', 1,
'For every 100 people in the economically active population there are 80 people dependent on them.',
NULL,
'Page 129'),

(3, '2c', 'How does the structure of dependency vary between developed and developing countries?', 4,
'The dependency ratio in developed countries is usually between 50 and 75, with the elderly forming an increasingly high proportion of dependents. Developing countries typically have higher dependency ratios, which can reach over 100, with young people making up the majority of dependents.',
'Good understanding, with reference to data.',
'Page 129');

-- Topic 1.4: Population Density - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(4, '1a', 'Explain the difference between population density and population distribution.', 2,
'Population density is the average number of people per square kilometre in a country or region. Population distribution is the way that the population is spread out over a given area, from a small region to the Earth as a whole.',
NULL,
'Page 129'),

(4, '2a', 'What are the main reasons for low population density?', 4,
'People have always tried to avoid harsh environments where making a living is particularly difficult. Thus, the world''s lowest population densities are found in deserts (the Sahara desert), high mountain regions (the Himalayas), very cold landscapes (Canadian Northlands) and rainforests (the Amazon basin). In areas which are, in general, more hospitable, poor soil fertility can deflect people to areas of more fertile soils. Likewise, restricted water supply can deter settlement.',
'Good identification of the factors resulting in low population density and reference to relevant examples.',
'Page 130'),

(4, '2b', 'For a densely populated region you have studied, discuss the reasons for high population density.', 6,
'In the USA the greatest concentration of population is in the north-east, the first region of substantial European settlement. By the end of the nineteenth century it had become the greatest manufacturing region in the world. The region stretches inland from Boston and Washington to Chicago and St Louis. By the 1960s the very highly urbanised area between Boston and Washington had reached the level of a megalopolis. This is the term used to describe an area where many conurbations exist in relatively close proximity. The region is sometimes referred to as ''Boswash'' after the main cities at its northern and southern extremities. Apart from Boston and Washington, the other main cities in this region are New York, Philadelphia and Baltimore.

New York is classed as a ''global city'', being one of the world''s three great financial cities along with Tokyo and London. With a population of 8.4 million, New York is the most densely populated major city in the USA. The population of the larger Metropolitan Area of New York is 18.9 million.

The region also contains many smaller urban areas. Much of the area has an average density over 100 per km². Population densities are, of course, much higher in the main urban areas. The rural parts of the region are generally fertile and intensively farmed. The climate and soils at this latitude are conducive to agriculture. Many people living in the rural communities commute to work in the towns and cities. The region has the most highly developed transport networks in North America. Although other parts of the country are growing at a faster rate, the intense concentration of job opportunities in the north-east will ensure that it remains the most densely populated part of the continent in the foreseeable future.',
'A detailed answer showing good, clear case study knowledge. Relevant data included.',
'Page 130');

-- Topic 1.5: Settlements - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(5, '1', 'Compare the characteristics of a linear village shape with those of a nucleated village shape.', 2,
'A linear settlement is spread along a single road whereas a nucleated shape is one which is compact and concentrated around a number of roads.',
'Sound definitions.',
'Page 130'),

(5, '2', 'Describe the relationship between population size and number of services, as shown in Figure 1.66.', 2,
'Generally, as population size increases, the number of services increases. This is a positive relationship. However, there are two main anomalies. Dormitory settlements are settlements with a relatively large population but limited services. In contrast, tourist locations may have a small population but a large number of services, for example, Villefort and St-André-Capcèze.',
'Accurate description and useful use of data.',
'Page 130');

-- Topic 1.6: Urban Settlements - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(6, '1', 'Suggest the environmental problems likely to be experienced in the area shown in the photo.', 4,
'Air pollution is likely, as there is very little open space so wind/breezes will be limited. There is likely to be much traffic congestion – there is a high density of buildings, and many tall buildings, and the space for roads appears to be limited. There is likely to be a high level of noise due to the combination of vehicles and large population density.',
'Logical suggestions.',
'Page 130'),

(6, '2a', 'Describe the changes in Detroit''s population between 1900 and 2015.', 3,
'It increased from about 0.5 million in 1900 to a peak of about 1.8 million in 1950, and then declined to around 0.7 million in 2013.',
'Good use of data.',
'Page 130'),

(6, '2b', 'Suggest reasons for its changes.', 4,
'The decline in the car industry has left Detroit far less attractive for migrants, as there are fewer jobs available. As there are fewer jobs, many residents have left the area, too. Also, the ''white flight'' of the 1950s to 1970s led to a fall in the population.',
'Identifies the main reasons.',
'Page 130');

-- Topic 1.7: Urbanisation - Exam-style Questions (from PART1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(7, '1', 'Suggest reasons for rapid urbanisation in low-income countries.', 4,
'Rapid urbanisation is caused by economic development and the perceived availability of employment and a better standard of living in urban areas, combined with poorer opportunities in rural areas. In addition, as a result of rural–urban migration, the urban area has a younger population structure than the rural area, and so has a higher rate of natural increase.',
'Covers both aspects clearly.',
'Page 130'),

(7, '2', 'Contrast the advantages and disadvantages of living in squatter settlements.', 5,
'For people living in a squatter settlement (for example, Vidigal in Rio de Janeiro), they have a house or an apartment. They may also be a part of a community that looks after each other, especially with respect to education. They may also be able to tap into electricity from the electricity power supply. However, there are many negative aspects of living in a squatter settlement. The quality of housing is poor, the nature of the jobs available is limited and the pay is quite poor. Access to healthcare and formal education is limited. Nevertheless, there are differences between squatter settlements. Those that are closer to the city centre offer more jobs. These are known as ''slums of hope''. In contrast, squatter settlements on the edge of the city may be far from centres of employment, and may be known as ''slums of despair''.',
'Covers both aspects clearly – an introductory sentence stating ''The advantages of living in a squatter settlement include …'' would be useful.',
'Page 130'),

(7, '3', 'Outline ways in which it is possible to improve housing in squatter settlements in LICs.', 3,
'The government could legalise the squatter settlements; they could provide a site and service scheme to help people without homes; they could improve the infrastructure such as running water and sanitation; they could provide loans for residents to improve their housing.',
'Identifies a range of possibilities.',
'Page 130');

-- Topic 2.1: Earthquakes and Volcanoes - Exam-style Questions (from PART2)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(8, '1', 'State the main differences between cone volcanoes and shield volcanoes.', 4,
'Cone volcanoes are steep sided and formed of acidic ash and cinders, and are formed at destructive plate boundaries. In contrast, shield volcanoes are low-angled volcanoes – they may still be very high – formed of runny, basaltic lava at constructive plate margins and hot spots.',
'A clear answer.',
'Page 130'),

(8, '2', 'State the meaning of the terms epicentre and focus.', 2,
'The focus is the exact position within the Earth where an earthquake takes place. The epicentre is the point on the Earth''s surface immediately above the focus.',
'Two clear definitions.',
'Page 130'),

(8, '3', 'Describe the advantages of volcanoes.', 3,
'The advantages of volcanoes include: the creation of new land; the production of fertile soil; rich minerals; and they are important tourist destinations.',
'Four advantages identified.',
'Page 130'),

(8, '4', 'Compare the primary and secondary effects of earthquakes.', 4,
'The primary hazards are the direct hazards associated with earthquakes such as land shaking and surface faulting (subsidence). In contrast, secondary hazards are the indirect hazards such as landslides, tsunamis and rock falls.',
'Two definitions, both with support.',
'Page 130');

-- Topic 2.2: Rivers - Exam-style Questions (from PART2)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(9, '1', 'Compare infiltration and throughflow.', 2,
'Infiltration is the movement of water into the soil, whereas throughflow is the downward movement of water under the soil (subsoil).',
'Clear definitions.',
'Page 130'),

(9, '2', 'Compare the cross-section of a river in its upper course with that of a river in its lower course.', 4,
'An upper course river has a narrow, deep/steep-sided cross-section, whereas a lower course river has a wider, flatter cross-section.',
'Clear description.',
'Page 130'),

(9, '3', 'Compare the long profile of an upper-course river with that of a lower-course river.', 2,
'The upper course generally has a steeper long profile, whereas the lower course has a much gentler long profile.',
'Clear description.',
'Page 130');

-- Topic 2.3: Coasts - Exam-style Questions (from PART2)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(10, '1', 'Describe the process of longshore drift.', 3,
'Longshore drift occurs when the waves break at an angle to the shoreline. The swash moves up the beach at an angle whereas the backwash moves sediment down the beach at right angles to the shoreline. The net movement is along the beach, i.e. longshore drift.',
'A clear description.',
'Page 131'),

(10, '2', 'Explain how a stack is formed.', 4,
'On a rocky headland, hydraulic action erodes a line of weakness (such as a fault line) or wave refraction concentrates wave energy on the flanks of the headland, causing a cave to be formed. Continual erosion may, in time, form an arch in the headland. Over time the arch is weathered and eroded, until eventually it collapses, leaving a stack.',
'A good description, with the use of geographical terminology.',
'Page 131'),

(10, '3', 'Explain the formation of spits.', 4,
'A spit is formed by longshore drift. It carries material and deposits it where there is an indent in the coastline or a river mouth causes an obstruction to longshore drift. A spit is attached at one end and unattached at the other end.',
'A good answer, although a diagram would help to show why longshore drift occurs.',
'Page 131'),

(10, '4', 'Identify the hazards associated with tropical storms (hurricanes).', 2,
'Hazards include a combination of high wind speeds, storm surges (high tides), heavy rainfall leading to flooding and wind damage.',
'An appropriate answer.',
'Page 131'),

(10, '5', 'Suggest why the Nile Delta is vulnerable to sea level change.', 3,
'The Nile Delta is low lying and a great many people live there. These factors, as well as it being an important agricultural and industrial region, make it vulnerable to sea level rising.',
'Clear reasons for vulnerability.',
'Page 131'),

(10, '6', 'Identify the advantages of the Nile Delta for people.', 4,
'It is low lying, therefore easy to build on; it is fertile, so good for farming; it has a good supply of fresh water; it has good potential for trade because the river is navigable and has access to the coast; and it has good potential for tourism.',
'A range of reasons given.',
'Page 131');

-- Topic 3.1: Development - Exam-style Questions (from PART3_1)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(15, '1a', 'Define the primary sector of an economy.', 2,
'The primary sector exploits raw materials from land, water and air. Farming, fishing, forestry, mining and quarrying make up most of the jobs in this sector.',
NULL,
'Page 131'),

(15, '1b', 'Why does the primary sector dominate employment in the poorest countries of the world?', 3,
'The poorest countries of the world have more than 70 per cent of their employment in the primary sector. Lack of investment in general means that agriculture and other parts of the primary sector are very labour intensive, and jobs in the secondary and tertiary sectors are limited in number.',
NULL,
'Page 131'),

(15, '1c', 'Explain the changes in employment structure that have occurred in NICs.', 4,
'In NICs employment in manufacturing has increased rapidly in recent decades. NICs have reached the stage of development whereby they attract foreign direct investment from TNCs in many sectors of the economy. As NICs expand their economies they develop their own domestic companies. Such companies usually start in a small way, but some go on to reach a considerable size. Both processes create employment in manufacturing and services. The increasing wealth of NICs allows for greater investment in agriculture. This includes mechanisation which results in falling demand for labour on the land. So, as employment in the secondary and tertiary sectors rises, employment in the primary sector falls. NICs may become so advanced that the quaternary sector begins to develop.',
'Shows detailed understanding of the ways in which employment structure has changed in NICs in recent decades.',
'Page 132'),

(15, '2a', 'Define a transnational corporation.', 2,
'A transnational corporation is a firm that owns or controls productive operations in more than one country through foreign direct investment.',
NULL,
'Page 132'),

(15, '2b', 'Describe and explain the role of transnational corporations in the global economy.', 6,
'TNCs and nation states are the two main elements of the global economy. The governments of countries individually and collectively set the rules for the global economy, but the bulk of investment is through TNCs. Under this process, manufacturing industry at first, and more recently services, have relocated in significant numbers from developed countries to selected developing countries as TNCs have taken advantage of lower labour costs and other ways to reduce costs. It is this process which has resulted in the emergence of an increasing number of newly industrialised countries since the 1960s. It has resulted in deindustrialisation in many regions of the developed world.

Twenty years ago, the vast majority of the world''s TNCs had their headquarters in North America, Western Europe and Japan. However, over the last two decades NICs such as South Korea, China and India have been accounting for an increasing slice of the global economy. Much of this economic growth has been achieved through the expansion of their own most important companies. TNCs have a huge impact on the global economy in general and in the countries in which they choose to locate in particular. They play a major role in world trade in terms of what and where they buy and sell. They are major employers and can have a huge influence on the countries in which they locate.',
'Clear understanding of the respective roles of TNCs and nation states, with important reference to the development of NICs and resultant deindustrialisation in developed countries.',
'Page 132');

-- Topic 3.3: Industry - Exam-style Questions (from PART3_2)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(17, '1a', 'What is the difference between processing and assembly industries? Give one example of each.', 4,
'Processing industries are based on the direct processing of raw materials. The iron and steel industry is an example, using large quantities of iron ore, coal and limestone. Processing industries are often located close to their raw materials. In contrast, assembly industries put together parts and components which have been made elsewhere. A large car assembly plant will use thousands of components to build a car. Assembly industries are more footloose in their choice of location.',
NULL,
'Page 132'),

(17, '1b', 'Define high-technology industry.', 2,
'High-technology industry uses or makes silicon chips, computers, software, robots, aerospace components and other very technically advanced products. These companies put a great deal of money into scientific research. Their aim is to develop newer, even more advanced products.',
NULL,
'Page 132'),

(17, '1c', 'Discuss the factors that cause high-technology industries to cluster together.', 3,
'High-technology industries often cluster together in science parks which were originally created in the USA. They are often found in close proximity to leading universities because of the need to employ well-qualified graduates in science and technology, and to be aware of the latest research taking place in universities. The Cambridge Science Park is a major example in the UK. The clustering of high-technology industry means that companies can collaborate easily on joint projects and highly skilled workers can move easily from one company to another.',
NULL,
'Page 133'),

(17, '2', 'Discuss the reasons for the development of an industrial area you have studied.', 6,
'Bangalore is the most important city in India for high-technology industry. Bangalore''s pleasant climate is a significant attraction to foreign and domestic companies alike. Because of its dust-free environment, large public sector undertakings, such as Hindustan Aeronautics Ltd and the Indian Space Research Organisation, were established in Bangalore by the Indian government. In addition, the state government has a long history of support for science and technology. There are many colleges of higher education in this sector and there has been large-scale investment in science and technology parks. The city prides itself on a ''culture of learning'' which gives it an innovative leadership within India.

In the 1980s Bangalore became the location for the first large-scale foreign investment in high technology in India when Texas Instruments selected the city above a number of other possibilities. Other TNCs soon followed as the reputation of the city grew. Important backward and forward linkages were steadily established over time. Apart from ICT industries, Bangalore is also India''s most important centre for aerospace and biotechnology.

India''s ICT sector has benefited from the filter down of business from the developed world. Many European and North American companies which previously outsourced their ICT requirements to local companies are now using Indian companies. Outsourcing to India occurs because: labour costs are considerably lower; a number of developed countries have significant ICT skills shortages; India has a large and able English-speaking workforce.',
'A good answer with a clear sequence of discussion, showing detailed case study knowledge.',
'Page 133');

-- Topic 3.4: Tourism - Exam-style Questions (from PART3_2)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(18, '1a', 'Define tourism.', 2,
'Tourism is travel away from the home environment (i) for leisure, recreation and holidays, (ii) to visit friends and relatives, and (iii) for business and professional reasons.',
'A precise definition – students can sometimes be very vague when defining tourism.',
'Page 133'),

(18, '1b', 'Discuss three reasons for the growth of international tourism.', 3,
'Steadily rising real incomes have enabled more and more people, particularly in developed countries, to afford a holiday away from home. An increasing number of people take more than one holiday trip each year. An increase in the average number of days of paid leave has given people more time in which to travel. And holiday pay helps with cost of travel. People have raised expectations of international travel with increasing media coverage of holidays, travel and nature. The range of available holidays has increased so that virtually all income levels are catered for.',
NULL,
'Page 133'),

(18, '1c', 'Examine the major social issues associated with the development of tourism.', 4,
'The traditional cultures of many communities in the developing world have suffered because of the development of tourism. The disadvantages include the following: the loss of locally owned land; the abandonment of traditional values; displacement of people; the weakening of traditional community structures; the increasing availability of alcohol and drugs; crime and prostitution, sometimes involving children; visitor congestion at key locations; denying local people access to beaches; the loss of housing for local people as more visitors buy second homes.

However, tourism may also generate cultural advantages such as: leading to greater understanding between people of different cultures; increasing the range of social facilities for local people; helping to develop foreign language skills in host communities.',
'A well-organised answer that does not just concentrate on the disadvantages, but also recognises that there can be some social/cultural advantages.',
'Page 133'),

(18, '2a', 'Why is it important to be aware of the carrying capacity of a tourist destination?', 3,
'The carrying capacity is the number of tourists a destination can take without placing too much pressure on local resources and infrastructure. If the carrying capacity of a tourist location is soon to be reached, important decisions have to be made. Will measures be taken to restrict the number of tourists to remain within the carrying capacity or are there possible management techniques that will allow the carrying capacity to be increased, but continue to be sustainable?',
NULL,
'Page 133'),

(18, '2b', 'With reference to an example, explain the meaning of ecotourism.', 4,
'Ecotourism is a specialised form of tourism where people experience relatively untouched natural environments such as coral reefs, tropical forests and remote mountain areas, and ensure that their presence does no further damage to these environments. In Ecuador, ecotourism has helped to bring needed income to some of the poorest parts of the country. It has provided local people with a new, alternative way of making a living. As such it has reduced human pressure on ecologically sensitive areas. The main geographical focus of ecotourism has been in the Amazon rainforest around Tena, which has become the main access point. The ecotourism schemes in the region are usually run by small groups of indigenous Quichua Indians.',
'A detailed and accurate definition followed by a succinct reference to a relevant case study.',
'Page 133');

-- Topic 3.5: Energy - Exam-style Questions (from PART3_3)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(19, '1a', 'What is meant by the ''energy mix'' of a country?', 2,
'The energy mix of a country is the relative contribution of different energy sources to a country''s energy consumption.',
NULL,
'Page 133'),

(19, '1b', 'Describe and explain the variation in energy consumption per capita shown in Figure 3.18.', 4,
'The highest consumption countries, such as the USA, Canada and Saudi Arabia, use more than 6 tonnes oil equivalent per person, while almost all of Africa and much of South America and Asia use less than 1.5 tonnes oil equivalent per person. Other high energy-use regions, with consumption between 4.5 and 6.0 tonnes of oil equivalent, include Russia, Australia and Scandinavia.

There is a strong relationship between energy usage and the wealth of individual countries. Richer countries can afford to use more energy while poorer nations are greatly restricted by the cost of energy. However, climate is also an important influence, which helps to explain the high consumption of energy in Russia.',
'A good balance between description and explanation, with clear reference to the map key.',
'Page 133'),

(19, '1c', 'How important is fuelwood in developing countries?', 3,
'In developing countries about 2.5 billion people rely on fuelwood, charcoal and animal dung for cooking. Fuelwood and charcoal are collectively called fuelwood, which accounts for just over half of global wood production. Fuelwood provides much of the energy needs for sub-Saharan Africa. It is also the most important use of wood in Asia.',
NULL,
'Page 134'),

(19, '2', 'Discuss the concerns that some people have about nuclear power.', 5,
'No other source of energy creates such heated discussion as nuclear power. A major concern about nuclear power is the risk of power plant accidents, which could release radiation into air, land and sea. Radioactive waste storage/disposal is another big problem. Most concern is over the small proportion of ''high-level waste''. This is so radioactive it generates heat and corrodes all containers. It would cause death within a few days to anyone directly exposed to it. No country has yet implemented a long-term solution to the nuclear waste problem.

There are serious concerns about rogue state or terrorist use of nuclear fuel for weapons. As the number of countries with access to nuclear technology rises, such concerns are likely to increase. High construction and decommissioning costs mean that the investment required is very high with only a limited number of countries being able to afford it. Because of the genuine risks associated with nuclear power and the level of security secrecy required, it is seen by some people as less ''democratic'' than other sources of power.

There has also been debate about the possible increase in certain types of cancer near nuclear plants. There has been much debate about this issue, but the evidence appears to be becoming more convincing.',
'A good sequence of discussion covering all the major concerns about nuclear power.',
'Page 134');

-- Topic 3.6: Water - Exam-style Questions (from PART3_3)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(20, '1a', 'Why do some water experts talk about a ''global water crisis''?', 3,
'In about 80 countries, with 40 per cent of the world''s population, lack of water is a constant threat. And the situation is getting worse, with demand for water doubling every 20 years. In those parts of the world where there is enough water, it is being wasted, mismanaged and polluted on a large scale. In the poorest nations it is not just a question of lack of water; the paltry supplies available are often heavily polluted.',
NULL,
'Page 134'),

(20, '1b', 'Define the term water supply.', 2,
'Water supply is the provision of water by public utilities, commercial organisations or by community endeavours. The objective in all cases is to supply water from its source to the point of usage.',
NULL,
'Page 134'),

(20, '1c', 'How important are dams and reservoirs to global water supply?', 3,
'In the twentieth century, global water consumption grew sixfold, twice the rate of population growth. Much of this increased consumption was made possible by significant investment in water infrastructure, particularly dams and reservoirs, affecting nearly 60 per cent of the world''s major river basins. The world''s major dams are really massive structures capable of holding huge amounts of water in the reservoirs behind them. This water can be released gradually as and when required by the settlements downstream of the dam. Reservoir storage needs have increased as world population has grown. There are approximately 80000 dams of varying sizes in the USA alone. Globally, the construction of dams has declined since the height of the era in the 1960s and 1970s. This is because most of the best sites for dams are already in use or such sites are strongly protected by environmental legislation and, therefore, off-limits for construction. An alternative to building new dams and reservoirs is to increase the capacity of existing reservoirs by extending the height of the dam.',
'A good understanding of the importance of dams and reservoirs to global water supply, backed up by some useful data.',
'Page 134'),

(20, '2a', 'How are wells and boreholes used to provide water supply?', 2,
'A well or borehole is a means of tapping into various types of aquifers (water-bearing rocks), gaining access to groundwater. Thus, they are sunk directly down to the water table. The water table is the highest level of underground water. For many communities, groundwater is the only water supply source. Aquifers provide approximately half of the world''s drinking water, 40 per cent of the water used by industry and up to 30 per cent of irrigation water.

Typically, a borehole is drilled by machine and is relatively small in diameter. Wells are relatively large in diameter and are often sunk by hand, although machinery may be used. Water from groundwater sources can be used directly or stored to build up a considerable surface supply. The greatest reliance on groundwater is in arid and semi-arid areas. This is the main source of water of oasis settlements such as those in the Sahara Desert in North Africa.',
NULL,
'Page 134');

-- Topic 3.7: Environmental Risks - Exam-style Questions (from PART3_3)
INSERT INTO exam_questions (topic_id, question_number, question_text, marks, model_answer, examiner_comments, source_page) VALUES
(21, '1a', 'Define pollution.', 2,
'Pollution is contamination of the environment. It can take many forms – air, water, soil, noise, visual and others.',
NULL,
'Page 134'),

(21, '1b', 'What are the main greenhouse gases?', 2,
'The main greenhouse gases being created by human activity are carbon dioxide, methane, nitrous oxides, chlorofluorocarbons and ozone.',
NULL,
'Page 135'),

(21, '1c', 'Explain the enhanced greenhouse effect.', 4,
'The Earth–atmosphere system has a natural greenhouse effect that is essential to all life on Earth, but large-scale pollution of the atmosphere by economic activities has created an enhanced greenhouse effect. The increase in greenhouse gases due to human activity is causing more radiation from the Earth''s surface to be trapped in the atmosphere. This is causing temperatures to increase beyond the limits of the natural greenhouse effect. Many parts of the world are experiencing changes in their weather that are unexpected. Some of these changes could have disastrous consequences for the populations of the areas affected, if they continue to get more severe.',
'A good clear answer, following a logical sequence of argument.',
'Page 135'),

(21, '2a', 'Describe two possible consequences of enhanced global warming.', 3,
'A major consequence of enhanced global warming is the melting of ice caps and glaciers. Satellite photographs show ice melting at its fastest rate ever. The area of sea ice in the Arctic Ocean has decreased by 15 per cent since 1960, while the thickness of the ice has fallen by 40 per cent. In 2007, the sea ice around Antarctica had melted back to a record low. At the same time, the movement of glaciers towards the sea has speeded up. A satellite survey between 1996 and 2006 found that the net loss of ice rose by 75 per cent. Temperatures in western Antarctica have increased sharply in recent years, melting ice shelves and changing plant and animal life on the Antarctic Peninsula. Ice melting could cause sea levels to rise by a further 5m (on top of thermal expansion). Hundreds of millions of people live in coastal areas within this range.

Another consequence is increasing acidity in oceans. As carbon dioxide levels rise in the atmosphere, more of the gas is dissolved in surface waters creating carbonic acid. Since the start of the Industrial Revolution, the acidity of the oceans has increased by 30 per cent. This is having a significant impact on coral reefs and shellfish.',
'Two relevant, but distinctly different consequences selected. Shows clear understanding of both processes, supplemented with relevant data.',
'Page 135'),

(21, '2b', 'Explain the causes of land degradation.', 4,
'The main cause of soil degradation is the removal of the natural vegetation cover, leaving the surface exposed to the elements. Deforestation and overgrazing are the two main problems.

Deforestation occurs for a number of reasons, including the clearing of land for agricultural use, for timber, and for other activities such as mining. Such activities tend to happen quickly whereas the loss of vegetation for fuelwood, a massive problem in many developing countries, is generally a more gradual process. Overgrazing is the grazing of natural pastures at stocking intensities above the livestock carrying capacity. Population pressure in many areas and poor agricultural practices have resulted in serious overgrazing. This is a major problem in many parts of the world, particularly in marginal ecosystems. Agricultural mismanagement is also a major problem due to a combination of lack of knowledge and the pursuit of short-term gain against consideration of longer-term damage. Such activities include shifting cultivation without adequate fallow periods, absence of soil conservation measures, cultivation of fragile or marginal lands, unbalanced fertiliser use and the use of poor irrigation techniques.',
NULL,
'Page 135');

-- ============================================================================
-- PART 5: COMMON ERRORS (VERBATIM from MD files)
-- ============================================================================

INSERT INTO common_errors (topic_id, error_description, why_wrong) VALUES
-- Topic 1.1 Population Dynamics (from PART1)
(1, 'Birth rate is the most accurate measure of fertility.', 'It is only a very broad indicator as it does not take into account the age and sex distribution of a population. The total fertility rate takes into account these factors and is thus a much more accurate measure of fertility.'),
(1, 'The one-child policy was the first time China had tried to reduce fertility.', 'While the one-child policy was introduced in 1979, this was not the first time China had tried to reduce fertility.'),

-- Topic 1.2 Migration (from PART1)
(2, 'Immigration and emigration have the same meaning.', 'Immigration is migration into a country and emigration is migration out of a country.'),
(2, 'Confusing immigration and emigration with in-migration and out-migration.', 'Immigration and emigration are the terms used for crossing international borders. In-migration and out-migration are internal movements within one country.'),

-- Topic 1.4 Population Density (from PART1)
(4, 'Population density does not change.', 'Population density can change considerably over time. Population density is increasing most in regions and countries with the fastest rates of population growth.'),

-- Topic 1.6 Urban Settlements (from PART1)
(6, 'Confusing the CBD with the inner city.', 'The inner city is (or in some cases, was) the industrial area surrounding the CBD. If you use the term (former) industrial area it should help avoid confusion. However, there are other industrial areas such as ports, along major transport routes, and on the edge of cities.'),

-- Topic 1.7 Urbanisation (from PART1)
(7, 'Giving the answer "e.g. Africa" or "e.g. Asia" when asked for a named city in a country.', 'You must have a named country and, preferably, a named city within that country.'),
(7, 'Urbanisation is rural-to-urban migration.', 'Urbanisation includes rural-to-urban migration, but it is also caused by natural increase. It is defined as the increase in the proportion of people living in urban areas.'),

-- Topic 2.2 Rivers (from PART2)
(9, 'Erosion only occurs in the upper course and deposition in the lower course.', 'Both processes occur throughout the river''s course.'),

-- Topic 2.3 Coasts (from PART2)
(10, 'Management schemes guarantee safety.', 'The 10m sea walls along the Japanese coastline were not high enough to protect against the 11m waves generated by the 2011 tsunami.'),

-- Topic 3.2 Food Production (from PART3_1)
(16, 'Food aid should not be criticised.', 'Food aid is quite rightly viewed as a good thing, but the way it is done is sometimes criticised. It is important to be aware of the ''pros'' and ''cons'' of this issue.'),

-- Topic 3.3 Industry (from PART3_2)
(17, 'Using the word "industry" without specifying. The term can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'If you use it with reference to the manufacture of goods then clearly state that this is ''manufacturing industry''.'),

-- Topic 3.4 Tourism (from PART3_2)
(18, 'Tourism only includes people on holiday.', 'The definition of tourism also includes business and professional travel, and visits to friends and relations.'),

-- Topic 3.5 Energy (from PART3_3)
(19, 'Production and consumption are the same thing.', 'For some energy sources such as coal the figures are very similar, but for oil there is a very significant difference. The ease with which a type of energy can be transported is a major factor here.');

-- ============================================================================
-- PART 6: TIPS (VERBATIM from MD files)
-- ============================================================================

INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
-- Topic 1.1 Population Dynamics (from PART1)
(1, 'It is important to remember that while the world''s population continues to increase, the rate of global population growth has been falling for over 50 years.', 'general'),
(1, 'Population data change frequently over time, so when you quote data you should also state the year to which they apply. For example, in Table 1.1, the birth rate for ''Latin America/Caribbean'' in 2012 was 19/1000, as stated in the previous edition of this book.', 'exam'),

-- Topic 1.2 Migration (from PART1)
(2, 'Remember that forced migration is not just the result of armed conflict, but can also occur due to environmental factors such as volcanic eruptions and desertification.', 'general'),

-- Topic 1.3 Population Structure (from PART1)
(3, 'When describing and explaining population pyramids a good starting point is to divide the pyramid into three sections: the young dependent population; the economically active population; the elderly dependent population. You can then comment on each section in turn.', 'exam'),

-- Topic 1.4 Population Density (from PART1)
(4, 'When describing variations in population density on a map with, say, four colours or types of shading, refer to each class (for example, over 100 per km²) to produce a detailed answer.', 'exam'),

-- Topic 1.5 Settlements (from PART1)
(5, 'When providing examples (for example, low-order goods or high-order goods), give real-life examples or examples from your own area if possible and appropriate, or refer to the examples in the textbook (pages 42–43).', 'exam'),

-- Topic 1.6 Urban Settlements (from PART1)
(6, 'A model is a simplification. You should not expect any city to illustrate all of the characteristics of any one model, although they may show some of them.', 'general'),

-- Topic 1.7 Urbanisation (from PART1)
(7, 'When asked for an example of a squatter settlement, many students write ''Rio'' or ''Cairo'', for example. Neither are squatter settlements. Rocinha and Vidigal are squatter settlements in Rio de Janeiro, just as the City of the Dead is a squatter settlement in Cairo.', 'exam'),

-- Topic 2.1 Earthquakes and Volcanoes (from PART2)
(8, 'The Richter scale is logarithmic so an earthquake measuring 7.0 on the Richter scale is 10 times more powerful than one measuring 6.0, and 100 times more powerful than one measuring 5.0.', 'general'),
(8, 'Although the map of plate boundaries is well known, in reality plate boundaries are often not clear-cut, and there are many areas where the plate boundaries are uncertain. Scientists do not know everything about the restless Earth.', 'general'),

-- Topic 2.2 Rivers (from PART2)
(9, 'Remember that the factors affecting erosion interact with each other. In any single case, the impact of one factor may be altered through the impact of others.', 'general'),
(9, 'When drawing a diagram of oxbow lakes make sure you label where the erosion and deposition are occurring.', 'exam'),

-- Topic 2.3 Coasts (from PART2)
(10, 'Many stretches of coastline have a range of management types – usually they will be a mix of hard and soft engineering, often side by side.', 'general'),

-- Topic 2.5 Natural Ecosystems (from PART2) - assuming topic_id 12
(12, 'When writing about ecosystems, give specific details (for example, mean temperature, rainfall total, names of selected plants and animals), rather than a generalised account that could refer to any ecosystem.', 'exam'),

-- Topic 3.1 Development (from PART3_1)
(15, 'It is important to understand the difference between economic growth and development. The former is an increase in GDP while development is a more wide-ranging concept concerning many more aspects of the quality of life.', 'general'),
(15, 'You should take care with the word ''industry'' as it can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'clarification'),

-- Topic 3.2 Food Production (from PART3_1)
(16, 'A simple, but clearly labelled sketch map can considerably enhance the presentation of a case study.', 'exam'),

-- Topic 3.4 Tourism (from PART3_2)
(18, 'It is easy to fall into the trap of seeing only the advantages of the economic impact of tourism. It is always important to consider the other side of the coin, even if you can only come up with a few points.', 'exam'),

-- Topic 3.5 Energy (from PART3_3)
(19, 'Solar power is generally taken to mean the production of solar electricity, as distinct from solar hot water systems.', 'clarification');

-- ============================================================================
-- PART 7: CASE STUDIES (from MD files)
-- ============================================================================

INSERT INTO case_studies (topic_id, title, content, key_facts) VALUES
-- Topic 1.7 Urbanisation
(7, 'Urban Sprawl in Seoul',
'Seoul has grown dramatically since the early 1960s. It currently has a population of about 10 million in the main city (municipality) and between 26 million and 36 million in the Metropolitan Region. This includes important cities in their own right, such as Incheon and Gwanju, as well as new towns. Seoul experiences a number of problems, just like most large cities. These include pollution, inequality, housing, traffic congestion and conflicts over land use change.

Pollution: As Seoul has grown, the amount of air and water pollution has increased. The Cheong Gye Cheon River in central Seoul had become heavily polluted with lead, chromium and manganese and was a health risk. Restoration of the river has been a central part of the regeneration of central Seoul.

Inequality: There has been increased inequality in Seoul since the financial crisis of 1997. The richer area of Seoul is Gangnam-Gu, to the south of the city. In contrast, the poor tend to be north of the river.

Housing shortage: Seoul''s population has grown from 2.5 million in 1960 to around 10 million today. Less than 45 per cent of the land around Seoul is available for urban development due to steep terrain and mountains.

Traffic congestion: In 1975 South Korea manufactured fewer than 20,000 cars. By 1994 there were over 2 million cars registered in the Seoul area.

Land use conflicts: In 1971, Seoul introduced a green belt system. In 1979 the government released 40 per cent of the green belt land for development.',
ARRAY['Population: 10 million (city), 26-36 million (metropolitan region)', 'Population growth: 2.5 million (1960) to 10 million (today)', 'Housing: Only 45% of land available for development', 'Car ownership: From 20,000 (1975) to over 2 million (1994)', 'Green belt: 40% released for development in 1979']),

-- Topic 3.3 Industry
(17, 'Bangalore – India''s High-tech City',
'Bangalore is the most important city in India for high-technology industry. Known as the "Garden City", Bangalore claims to have the highest quality of life in the country.

In the 1980s Bangalore became the location for the first large-scale foreign investment in high technology in India when Texas Instruments selected the city. Other TNCs soon followed as the reputation of the city grew. Important backward and forward linkages were steadily established over time.

Apart from ICT industries, Bangalore is also India''s most important centre for aerospace and biotechnology. Many European and North American companies that previously outsourced their ICT requirements to local companies are now using Indian companies.

The city''s population grew from 2.4 million in 1981 to over 12 million in 2017. The city has grown into a major international hub for ICT companies. Bangalore has built up a large pool of highly-skilled labour. There has been very high investment into the city''s infrastructure.',
ARRAY['Known as the "Garden City"', 'First major foreign investment: Texas Instruments (1980s)', 'Population: 2.4 million (1981) to over 12 million (2017)', 'Key sectors: ICT, aerospace, biotechnology', 'Large pool of highly-skilled labour']),

-- Topic 3.4 Tourism
(18, 'Jamaica – The Benefits and Disadvantages Associated with the Growth of Tourism',
'Tourism has become an increasingly vital part of Jamaica''s economy in recent decades.

Tourism''s direct and indirect contribution to GDP in 2014 amounted to almost 27.2 per cent of total GDP. Direct employment in the industry amounted to 90,000. Tourism is the largest source of foreign exchange for the country.

The Jamaican government sees the designation of the National and Marine Parks as a positive environmental impact of tourism. Entry fees to the Parks pay for conservation. The Marine Parks are attempting to conserve the coral reef environments off the coast of Jamaica. Ecotourism is a developing sector of the industry.

Considerable efforts are being made to promote community tourism, which is seen as an important aspect of "pro-poor tourism". The physical attractions of Jamaica almost sell themselves, so the government is putting much effort into trying to boost the island''s human attractions.

During the off-season, 25 per cent of hotel workers are laid off. Other negative aspects include: the environmental impact of tourism; the heavy use of resources, particularly water, by hotels; socio-cultural problems between residents and visitors.',
ARRAY['Tourism GDP contribution: 27.2% (2014)', 'Direct employment: 90,000 jobs', 'Tourism is largest source of foreign exchange', 'Off-season: 25% of hotel workers laid off', 'National and Marine Parks designated for conservation', 'Ecotourism and community tourism developing']),

-- Topic 3.5 Energy
(19, 'Energy Supply in China',
'China uses more energy than any other country in the world. In 2015 China''s main sources of energy were: coal (63.7 per cent), oil (18.6 per cent) and hydro-electricity (8.5 per cent).

China was an exporter of oil until the early 1990s although it is now a very significant importer. Chinese investment in energy resources abroad has risen rapidly in order to achieve long-term energy security.

In recent years China has tried to take a more balanced approach to energy supply and at the same time sought to reduce its environmental impact. The development of clean coal technology is an important aspect of this approach. The further development of nuclear and hydropower is another important strand of Chinese policy.

China aims to increase the production of oil while augmenting that of natural gas and improving the national oil and gas network. Priority has also been given to building up the national oil reserve.

Total renewable energy capacity in China reached 502GW in 2015. This included 319GW of hydro-electricity, 129GW of wind energy, 43GW of solar PV and 10GW of bioenergy.

The Three Gorges Dam across the Yangtze river is the world''s largest electricity generating plant of any kind. This is a major part of China''s policy in reducing its reliance on coal.',
ARRAY['Energy mix (2015): Coal 63.7%, Oil 18.6%, Hydro 8.5%', 'Total renewable capacity: 502GW (2015)', 'Hydro: 319GW, Wind: 129GW, Solar: 43GW', 'Three Gorges Dam: World''s largest electricity plant', 'China: World''s largest energy consumer']),

-- Topic 3.6 Water
(20, 'The Water Problem in Southwestern USA',
'The USA is a huge user of water. The western states of the USA, covering 60 per cent of the land area with 40 per cent of the total population, receive only 25 per cent of the country''s mean annual precipitation. Yet each day the west uses as much water as the east.

The southwest in particular has prospered due to a huge investment in water transfer schemes. This has benefited agriculture, industry and settlement. California has benefited most from this investment in water supply. Seventy per cent of runoff originates in the northern one-third of the state but 80 per cent of the demand for water is in the southern two-thirds.

The 2333-km long Colorado river is an important source of water in the southwest. Over 30 million people in the region depend on water from the river. Despite the interstate and international agreements (between the USA and Mexico), major problems over the river''s resources have arisen because population has increased along with rising demand from agriculture and industry.

The $4 billion Central Arizona Project (CAP) is the latest, and probably the last, big money scheme to divert water from this great river.

Resource management strategies include: measures to reduce leakage and evaporation losses; recycling more water in industry; charging more realistic prices for irrigation water; extending the use of the most efficient irrigation systems; changing from highly water-dependent crops such as rice and alfalfa to those needing less water.

Future options include: developing new groundwater resources; investing in more desalination plants; constructing offshore aqueducts that would run under the ocean from the Columbia river in the northwest of the USA to California.',
ARRAY['Western states: 60% land area, 40% population, 25% precipitation', 'Colorado River: 2333km long, serves 30+ million people', 'Central Arizona Project: $4 billion investment', 'California: 70% runoff in north, 80% demand in south', 'Options: Desalination, offshore aqueducts, groundwater']),

-- Topic 3.7 Environmental Risks
(21, 'Environmental Problems in the Pearl River Delta',
'The Pearl River delta region in south-east China is the focal point of a massive wave of foreign investment into China. The region''s manufacturing industries already employ 30 million people. Major industrial centres include Shunde, Shenzhen and Guangzhou.

The three major environmental problems in the Pearl River delta are air pollution, water pollution and deforestation.

In 2007 eight out of every ten rainfalls in Guangzhou were classified as acid rain. The high concentration of factories and power stations is the source of this problem along with the growing number of cars in the province.

Two-thirds of Guangdong''s 21 cities were affected by acid rain in 2007. Overall, 45 per cent of the province''s rainfall in 2007 was classified as acid rain.

Almost all the urban areas have overexploited their neighbouring uplands, causing a considerable reduction in vegetation cover. This has resulted in serious erosion.

Half of the wastewater in Guangdong''s urban areas is not treated before being dumped into rivers. Guangdong''s government is working to reduce chemical oxygen demand (COD) and also to cut sulfur dioxide emissions.

The Environmental Protection Bureau classifies the environmental situation as "severe".

Among the measures used to tackle the problems are (a) higher sewage treatment charges, (b) stricter pollution regulations on factories and (c) tougher national regulations on vehicle emissions.',
ARRAY['Manufacturing employment: 30 million', 'Acid rain: 80% of rainfalls in Guangzhou (2007)', 'Acid rain affected: 66% of Guangdong cities', '45% of provincial rainfall classified as acid rain', '50% of urban wastewater untreated', 'Environmental status: "Severe"']);

-- ============================================================================
-- PART 8: LEARNING OBJECTIVES (from MD files)
-- ============================================================================

INSERT INTO learning_objectives (topic_id, objective_text) VALUES
-- Topic 1.1
(1, 'Describe and give reasons for the rapid increase in the world''s population'),
(1, 'Show an understanding of over-population and under-population'),
(1, 'Understand the main causes of a change in population size'),
(1, 'Give reasons for contrasting rates of natural population change'),

-- Topic 1.2
(2, 'Explain and give reasons for population migration'),
(2, 'Demonstrate an understanding of the impacts of migration'),

-- Topic 1.3
(3, 'Identify and give reasons for and implications of different types of population structure'),

-- Topic 1.4
(4, 'Describe the factors influencing the density and distribution of population'),

-- Topic 1.5
(5, 'Explain the patterns of settlement'),
(5, 'Describe and explain the factors which may influence the sites, growth and functions of settlements'),
(5, 'Give reasons for the hierarchy of settlements and services'),

-- Topic 1.6
(6, 'Describe and give reasons for the characteristics of, and changes in, land use in urban areas'),
(6, 'Explain the problems of urban areas, their causes and possible solutions'),

-- Topic 1.7
(7, 'Identify and suggest reasons for rapid urban growth'),
(7, 'Describe the impacts of urban growth on both rural and urban areas, along with possible solutions to reduce the negative impacts'),

-- Topic 2.1
(8, 'Describe the main types and features of volcanoes and earthquakes'),
(8, 'Describe and explain the distribution of earthquakes and volcanoes'),
(8, 'Describe the causes of earthquakes and volcanic eruptions and their effects on people and the environment'),
(8, 'Demonstrate an understanding that volcanoes present hazards and offer opportunities for people'),
(8, 'Explain what can be done to reduce the impacts of earthquakes and volcanoes'),

-- Topic 3.3 Industry
(17, 'Demonstrate an understanding of an industrial system: inputs, processes and outputs'),
(17, 'Describe and explain the factors influencing the distribution and location of factories and industrial zones'),

-- Topic 3.4 Tourism
(18, 'Describe and explain the growth of tourism in relation to the main attractions of the physical and human landscape'),
(18, 'Evaluate the benefits and disadvantages of tourism to receiving areas'),
(18, 'Demonstrate an understanding that careful management of tourism is required in order for it to be sustainable'),

-- Topic 3.5 Energy
(19, 'Describe the importance of non-renewable fossil fuels, renewable energy supplies, nuclear power and fuelwood; globally and in different countries at different levels of development'),
(19, 'Evaluate the benefits and disadvantages of nuclear power and renewable energy sources'),

-- Topic 3.6 Water
(20, 'Describe methods of water supply and the proportions of water used for agricultural, domestic and industrial purposes in countries at different levels of economic development'),
(20, 'Explain why there are water shortages in some areas and demonstrate that careful management is required to ensure future supplies'),

-- Topic 3.7 Environmental Risks
(21, 'Describe how economic activities may pose threats to the natural environment, locally and globally'),
(21, 'Demonstrate the need for sustainable development and management'),
(21, 'Understand the importance of resource conservation');

-- ============================================================================
-- END OF MIGRATION v5 FIXED
-- All content sourced directly from Cambridge IGCSE Geography Study Guide MD files
-- ============================================================================
