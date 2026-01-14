-- ============================================
-- IGCSE Geography Guru - Major Upgrade Migration v5
-- Adds: Exam Questions, Case Studies, Tips, Common Errors, Learning Objectives
-- ============================================

-- ============================================
-- PART 0: DROP EXISTING TABLES (clean slate)
-- ============================================
DROP TABLE IF EXISTS sample_answers CASCADE;
DROP TABLE IF EXISTS exam_questions CASCADE;
DROP TABLE IF EXISTS case_studies CASCADE;
DROP TABLE IF EXISTS tips CASCADE;
DROP TABLE IF EXISTS common_errors CASCADE;
DROP TABLE IF EXISTS user_objective_progress CASCADE;
DROP TABLE IF EXISTS learning_objectives CASCADE;

-- ============================================
-- PART 1: CREATE NEW TABLES
-- ============================================

-- Exam Questions with Model Answers
CREATE TABLE IF NOT EXISTS exam_questions (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    question TEXT NOT NULL,
    marks INTEGER NOT NULL,
    model_answer TEXT NOT NULL,
    command_word TEXT,
    question_type TEXT DEFAULT 'exam-style', -- exam-style, sample
    UNIQUE(topic_id, question)
);

-- Sample Answers with Teacher Comments
CREATE TABLE IF NOT EXISTS sample_answers (
    id SERIAL PRIMARY KEY,
    exam_question_id INTEGER REFERENCES exam_questions(id) ON DELETE CASCADE,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    question_context TEXT,
    student_answer TEXT NOT NULL,
    teacher_comments TEXT NOT NULL,
    marks_awarded INTEGER,
    marks_available INTEGER,
    strengths TEXT,
    improvements TEXT
);

-- Case Studies
CREATE TABLE IF NOT EXISTS case_studies (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    location TEXT,
    category TEXT,
    overview TEXT,
    causes TEXT,
    effects TEXT,
    solutions TEXT,
    key_facts JSONB,
    exam_relevance TEXT,
    UNIQUE(topic_id, name)
);

-- Study Tips
CREATE TABLE IF NOT EXISTS tips (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    tip_text TEXT NOT NULL,
    tip_type TEXT DEFAULT 'study'
);

-- Common Errors
CREATE TABLE IF NOT EXISTS common_errors (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    error_statement TEXT NOT NULL,
    explanation TEXT NOT NULL
);

-- Learning Objectives
CREATE TABLE IF NOT EXISTS learning_objectives (
    id SERIAL PRIMARY KEY,
    topic_id INTEGER NOT NULL REFERENCES topics(id) ON DELETE CASCADE,
    objective_text TEXT NOT NULL,
    order_num INTEGER DEFAULT 1
);

-- User Objective Progress (for tracking)
CREATE TABLE IF NOT EXISTS user_objective_progress (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    objective_id INTEGER REFERENCES learning_objectives(id) ON DELETE CASCADE,
    status TEXT DEFAULT 'not_started',
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(user_id, objective_id)
);

-- ============================================
-- PART 2: LEARNING OBJECTIVES DATA
-- ============================================

INSERT INTO learning_objectives (topic_id, objective_text, order_num) VALUES
-- Topic 1.1 Population dynamics
((SELECT id FROM topics WHERE topic_number = '1.1'), 'describe and explain the factors influencing the density and distribution of population', 1),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'describe and give reasons for the rapid increase in the world''s population', 2),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'show an understanding of over-population and under-population', 3),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'understand the main causes of a change in population size', 4),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'give reasons for contrasting rates of natural population change', 5),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'describe and evaluate population policies', 6),

-- Topic 1.2 Migration
((SELECT id FROM topics WHERE topic_number = '1.2'), 'explain and give examples of forced and voluntary migration', 1),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'explain the causes and effects of migration', 2),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'demonstrate an understanding of the impacts of migration', 3),

-- Topic 1.3 Population structure
((SELECT id FROM topics WHERE topic_number = '1.3'), 'identify and give reasons for and implications of different types of population structure', 1),
((SELECT id FROM topics WHERE topic_number = '1.3'), 'describe the characteristics of the demographic transition model', 2),
((SELECT id FROM topics WHERE topic_number = '1.3'), 'interpret and analyse population pyramids', 3),

-- Topic 1.4 Population density and distribution
((SELECT id FROM topics WHERE topic_number = '1.4'), 'describe the factors influencing the density and distribution of population', 1),
((SELECT id FROM topics WHERE topic_number = '1.4'), 'describe the factors which affect population density', 2),

-- Topic 1.5 Settlements and service provision
((SELECT id FROM topics WHERE topic_number = '1.5'), 'explain the patterns of settlement', 1),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'describe and explain the factors which may influence the sites, growth and functions of settlements', 2),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'give reasons for the hierarchy of settlements and services', 3),

-- Topic 1.6 Urban settlements
((SELECT id FROM topics WHERE topic_number = '1.6'), 'describe and give reasons for the characteristics of, and changes in, land use in urban areas', 1),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'explain the problems of urban areas, their causes and possible solutions', 2),

-- Topic 1.7 Urbanisation
((SELECT id FROM topics WHERE topic_number = '1.7'), 'describe and explain the process of urbanisation', 1),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'describe the problems caused by rapid urbanisation', 2),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'explain the formation of squatter settlements', 3),

-- Topic 2.1 Earthquakes and volcanoes
((SELECT id FROM topics WHERE topic_number = '2.1'), 'describe the main types and features of volcanoes and earthquakes', 1),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'describe and explain the distribution of earthquakes and volcanoes', 2),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'describe the causes of earthquakes and volcanic eruptions and their effects on people and the environment', 3),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'demonstrate an understanding that volcanoes present hazards and offer opportunities for people', 4),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'explain what can be done to reduce the impacts of earthquakes and volcanoes', 5),

-- Topic 2.2 Rivers
((SELECT id FROM topics WHERE topic_number = '2.2'), 'explain the main hydrological characteristics and processes which operate within rivers and drainage basins', 1),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'demonstrate an understanding of the work of a river in eroding, transporting and depositing', 2),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'describe and explain the formation of the landforms associated with these processes', 3),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'demonstrate an understanding that rivers present hazards and offer opportunities for people', 4),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'explain what can be done to manage the impacts of river flooding', 5),

-- Topic 2.3 Coasts
((SELECT id FROM topics WHERE topic_number = '2.3'), 'demonstrate an understanding of the work of the sea and wind in eroding, transporting and depositing', 1),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'describe and explain the formation of the landforms associated with these processes', 2),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'describe coral reefs and mangrove swamps and the conditions required for their development', 3),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'demonstrate an understanding that coasts present hazards and offer opportunities for people', 4),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'explain what can be done to manage the impacts of coastal erosion', 5),

-- Topic 2.4 Weather
((SELECT id FROM topics WHERE topic_number = '2.4'), 'describe how weather data are collected', 1),
((SELECT id FROM topics WHERE topic_number = '2.4'), 'make calculations using information from weather instruments', 2),
((SELECT id FROM topics WHERE topic_number = '2.4'), 'use and interpret graphs and other diagrams showing weather and climate data', 3),

-- Topic 2.5 Climate and natural vegetation
((SELECT id FROM topics WHERE topic_number = '2.5'), 'describe and explain the characteristics of two climates: equatorial and hot desert', 1),
((SELECT id FROM topics WHERE topic_number = '2.5'), 'describe and explain the characteristics of tropical rainforest and hot desert ecosystems', 2),
((SELECT id FROM topics WHERE topic_number = '2.5'), 'describe the causes and effects of deforestation of tropical rainforest', 3),

-- Topic 3.1 Development
((SELECT id FROM topics WHERE topic_number = '3.1'), 'use a variety of indicators to assess the level of development of a country', 1),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'identify and explain inequalities between and within countries', 2),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'classify production into different sectors and give illustrations of each', 3),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'describe and explain how the proportions employed in each sector vary according to the level of development', 4),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'describe and explain the process of globalisation, and consider its impacts', 5),

-- Topic 3.2 Food production
((SELECT id FROM topics WHERE topic_number = '3.2'), 'describe and explain the main features of an agricultural system: inputs, processes and outputs', 1),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'recognise the causes and effects of food shortages and describe possible solutions to this problem', 2),

-- Topic 3.3 Industry
((SELECT id FROM topics WHERE topic_number = '3.3'), 'demonstrate an understanding of an industrial system: inputs, processes and outputs', 1),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'describe and explain the factors influencing the distribution and location of factories and industrial zones', 2),

-- Topic 3.4 Tourism
((SELECT id FROM topics WHERE topic_number = '3.4'), 'describe and explain the growth of tourism', 1),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'demonstrate an understanding of the importance of tourism to countries at different levels of development', 2),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'evaluate the benefits and disadvantages of tourism', 3),

-- Topic 3.5 Energy
((SELECT id FROM topics WHERE topic_number = '3.5'), 'describe the significance of energy resources', 1),
((SELECT id FROM topics WHERE topic_number = '3.5'), 'evaluate the benefits and disadvantages of different sources of energy', 2),

-- Topic 3.6 Water
((SELECT id FROM topics WHERE topic_number = '3.6'), 'describe the significance of water as a resource', 1),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'explain the factors which affect the availability and supply of water', 2),

-- Topic 3.7 Environmental risks
((SELECT id FROM topics WHERE topic_number = '3.7'), 'describe how economic activities may pose threats to the natural environment', 1),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'demonstrate an understanding of the need for sustainable development and resource management', 2);

-- ============================================
-- PART 3: TIPS DATA
-- ============================================

INSERT INTO tips (topic_id, tip_text, tip_type) VALUES
-- Topic 1.1
((SELECT id FROM topics WHERE topic_number = '1.1'), 'When describing a population pyramid, always identify specific age groups, and try to give data.', 'exam'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Population pyramids are one of the easiest sections of the course to gain marks for, as long as you can describe and explain differences in the pyramids. The description could include the shape of the pyramid, the proportion in each age group, and any anomalies or indentations.', 'exam'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Candidates should be aware that birth rates and fertility rates are not the same thing. Fertility rates can be used to show the average number of children per woman, for example.', 'study'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'When planning their revision, candidates should make sure to: (a) revise each part of the syllabus; (b) plan their revision; and (c) practise case studies.', 'study'),

-- Topic 1.2
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Many migrations are complex – so identifying push and pull factors is not always easy.', 'study'),

-- Topic 1.3
((SELECT id FROM topics WHERE topic_number = '1.3'), 'The dependency ratio does not give a complete picture, as some in the 15-64 age group are not economically active, and some who are outside of this age range are.', 'study'),

-- Topic 1.4
((SELECT id FROM topics WHERE topic_number = '1.4'), 'In any answer about population density, make sure that you distinguish between those factors (human and physical) that attract population and those that deter people from living in an area.', 'exam'),

-- Topic 1.5
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Factors that affect the functions of a settlement also affect its size. The range of functions that a settlement can support depends on the size of its population, and also on its situation (position in relation to other settlements). The larger the settlement, the more people it attracts, and the more functions it can support.', 'study'),

-- Topic 1.6
((SELECT id FROM topics WHERE topic_number = '1.6'), 'The bid rent model is highly simplified and in reality land values can vary greatly over short distances.', 'study'),

-- Topic 1.7
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Urbanisation does not just refer to migration. Natural increase may become more important as the rate of migration slows.', 'study'),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'If a question asks you to describe, explain the causes of, and evaluate a strategy to reduce, problems of urbanisation, make sure that you answer all parts of the question – in this case the describe, causes and evaluate.', 'exam'),

-- Topic 2.1
((SELECT id FROM topics WHERE topic_number = '2.1'), 'The Richter scale is logarithmic so an earthquake measuring 7.0 on the Richter scale is 10 times more powerful than one measuring 6.0, and 100 times more powerful than one measuring 5.0.', 'study'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Although the map of plate boundaries is well known, in reality plate boundaries are often not clear-cut, and there are many areas where the plate boundaries are uncertain. Scientists do not know everything about the restless Earth.', 'study'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Earthquakes may occur anywhere: some of the largest ones in the USA have been at great distances from plate boundaries. This makes them difficult – if not impossible – to predict with accuracy.', 'study'),

-- Topic 2.2
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Remember that the factors affecting erosion interact with each other. In any single case, the impact of one factor may be altered through the impact of others.', 'study'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'When drawing a diagram of oxbow lakes make sure you label where the erosion and deposition are occurring.', 'exam'),

-- Topic 2.3
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Many stretches of coastline have a range of management types – usually they will be a mix of hard and soft engineering, often side by side.', 'study'),

-- Topic 2.4
((SELECT id FROM topics WHERE topic_number = '2.4'), 'When reading climate graphs, always note the scale used for temperature and rainfall - they may differ between graphs.', 'exam'),

-- Topic 2.5
((SELECT id FROM topics WHERE topic_number = '2.5'), 'When writing about ecosystems, give specific details (for example, mean temperature, rainfall total, names of selected plants and animals), rather than a generalised account that could refer to any ecosystem.', 'exam'),

-- Topic 3.1
((SELECT id FROM topics WHERE topic_number = '3.1'), 'It is important to understand the difference between economic growth and development. The former is an increase in GDP while development is a more wide-ranging concept concerning many more aspects of the quality of life.', 'study'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'You should take care with the word ''industry'' as it can be applied to all sectors of the economy (for example, the agricultural industry and the service industry).', 'study'),

-- Topic 3.2
((SELECT id FROM topics WHERE topic_number = '3.2'), 'A simple, but clearly labelled sketch map can considerably enhance the presentation of a case study.', 'exam'),

-- Topic 3.3
((SELECT id FROM topics WHERE topic_number = '3.3'), 'When discussing industrial location, remember that factors can be physical (raw materials, energy) or human (labour, markets, government policy).', 'exam'),

-- Topic 3.4
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Tourism statistics can be misleading – ''arrivals'' may include business travellers and those visiting friends and relatives, not just holidaymakers.', 'study'),

-- Topic 3.5
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Energy consumption varies greatly between countries. Always consider both the amount of energy used and the sources of that energy.', 'study'),

-- Topic 3.6
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Water stress and water scarcity are different terms. Water stress occurs when supply falls below 1700 cubic metres per person per year; water scarcity when it falls below 1000.', 'study'),

-- Topic 3.7
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Sustainable development is about balance – meeting current needs without compromising the ability of future generations to meet their own needs.', 'study'),

-- Topic 4.1
((SELECT id FROM topics WHERE topic_number = '4.1'), 'When giving a grid reference, always give the easting (vertical line) before the northing (horizontal line). Remember: along the corridor, then up the stairs.', 'exam'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 'When drawing cross-sections, use a consistent vertical scale and mark key features clearly.', 'exam');

-- ============================================
-- PART 4: COMMON ERRORS DATA
-- ============================================

INSERT INTO common_errors (topic_id, error_statement, explanation) VALUES
-- Topic 1.1
((SELECT id FROM topics WHERE topic_number = '1.1'), '''The world''s population is not increasing.''', 'Total global population is still rising, although rates of increase have slowed down in many regions.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), '''Population growth is the same everywhere.''', 'Population growth rates vary hugely between countries and regions. Africa has the highest growth rates while some European countries have declining populations.'),

-- Topic 1.2
((SELECT id FROM topics WHERE topic_number = '1.2'), '''Migration only occurs from LICs to HICs.''', 'Much migration is actually internal (within a country) or between countries of similar economic development. South-South migration (between developing countries) is very significant.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), '''All migrants are refugees.''', 'Refugees are a specific category of forced migrants who cross international borders due to persecution, conflict or disaster. Many migrants move voluntarily for economic or family reasons.'),

-- Topic 1.4
((SELECT id FROM topics WHERE topic_number = '1.4'), '''High population density always means overpopulation.''', 'Population density and overpopulation are different concepts. A densely populated area with good resources and technology may not be overpopulated, while a sparsely populated area with few resources might be.'),

-- Topic 1.6
((SELECT id FROM topics WHERE topic_number = '1.6'), '''All cities have the same land use pattern.''', 'Urban land use patterns vary greatly depending on history, culture, planning policies and economic factors. The concentric ring model is simplified and does not apply to all cities.'),

-- Topic 1.7
((SELECT id FROM topics WHERE topic_number = '1.7'), '''Urbanisation is the same as urban growth.''', 'Urbanisation refers to the proportion of population living in urban areas, while urban growth is the increase in the total urban population. A country can have urban growth without urbanisation if rural areas grow at the same rate.'),
((SELECT id FROM topics WHERE topic_number = '1.7'), '''Squatter settlements have no positive features.''', 'While squatter settlements have many problems, they also demonstrate community organisation, self-help housing improvements, and provide affordable housing close to employment.'),

-- Topic 2.1
((SELECT id FROM topics WHERE topic_number = '2.1'), '''Earthquakes only occur at plate boundaries.''', 'While most earthquakes occur at plate boundaries, some occur within plates due to ancient fault lines or human activities such as fracking or reservoir construction.'),

-- Topic 2.2
((SELECT id FROM topics WHERE topic_number = '2.2'), '''Erosion only occurs in the upper course and deposition in the lower course.''', 'Both erosion and deposition occur throughout a river''s course. The balance between them changes, but both processes happen in all sections of a river.'),

-- Topic 2.3
((SELECT id FROM topics WHERE topic_number = '2.3'), '''Management schemes guarantee safety.''', 'The 10m sea walls along the Japanese coastline were not high enough to protect against the 11m waves generated by the 2011 tsunami. No management scheme can provide complete protection.'),

-- Topic 3.2
((SELECT id FROM topics WHERE topic_number = '3.2'), '''Food aid should not be criticised.''', 'Food aid is quite rightly viewed as a good thing, but the way it is done is sometimes criticised. Heavily subsidised food can undermine local farmers and create dependency.'),

-- Topic 3.3
((SELECT id FROM topics WHERE topic_number = '3.3'), '''Industries always locate near raw materials.''', 'Modern footloose industries are not tied to raw material locations. Factors like skilled labour, market access, and government incentives are often more important.'),

-- Topic 3.4
((SELECT id FROM topics WHERE topic_number = '3.4'), '''Tourism always benefits local people.''', 'Economic leakage means much tourist spending goes to foreign-owned hotels and tour operators. Local people may face increased living costs, cultural disruption and environmental damage.'),

-- Topic 3.5
((SELECT id FROM topics WHERE topic_number = '3.5'), '''Renewable energy has no environmental impact.''', 'While renewable energy is cleaner than fossil fuels, it still has environmental impacts. Wind farms affect birds and landscapes, hydroelectric dams flood valleys, and solar farms use large areas of land.'),

-- Topic 3.7
((SELECT id FROM topics WHERE topic_number = '3.7'), '''Climate change is only about temperature rise.''', 'Enhanced global warming causes many changes including sea level rise, more extreme weather events, changes in precipitation patterns, and ecosystem disruption.'),

-- Topic 4.1
((SELECT id FROM topics WHERE topic_number = '4.1'), '''Grid references and area references are the same.''', 'A four-figure reference identifies a grid square (area), while a six-figure reference identifies a specific point within that square. Use the appropriate type for what you are describing.');

-- ============================================
-- PART 5: EXAM QUESTIONS WITH MODEL ANSWERS
-- ============================================

INSERT INTO exam_questions (topic_id, question, marks, model_answer, command_word, question_type) VALUES
-- Topic 1.1 Population dynamics
((SELECT id FROM topics WHERE topic_number = '1.1'), 'State the meaning of the term rate of natural change.', 2, 'The rate of natural change is the difference between the birth rate and the death rate. If it is positive it is called natural increase. If it is negative it is known as natural decrease.', 'state', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Suggest reasons for the difference in the population pyramids of Ethiopia and Japan.', 6, 'Ethiopia has a wide base indicating high birth rates due to lack of family planning, need for children to work on farms, and high infant mortality meaning more children are needed. The narrow top shows low life expectancy due to poor healthcare, poverty, and disease. Japan has a narrow base showing low birth rates due to high cost of raising children, women''s education and careers, and good family planning. The wide middle and top sections show high life expectancy due to excellent healthcare, diet, and standard of living. Japan is in Stage 5 of the DTM while Ethiopia is in Stage 2.', 'suggest', 'exam-style'),

-- Topic 1.2 Migration
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Describe the differences between voluntary and forced migration.', 4, 'Voluntary migration occurs when people choose to move, usually for economic reasons such as better jobs or education opportunities. Examples include rural-urban migration for employment. Forced migration occurs when people have no choice but to move, due to persecution, conflict, natural disasters or environmental degradation. Examples include refugees fleeing war zones. Voluntary migrants can usually return home, while forced migrants often cannot.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'For a named country, explain the causes of internal migration.', 6, 'In Brazil, rural-urban migration is caused by push factors from rural areas including: poverty and lack of employment; mechanisation of agriculture reducing jobs; lack of services like schools and hospitals; and drought in the northeast. Pull factors to cities include: perceived better job opportunities in industry and services; better access to education and healthcare; and the attraction of urban lifestyle and entertainment. São Paulo and Rio de Janeiro have grown rapidly as a result. However, many migrants end up in favelas due to high housing costs.', 'explain', 'exam-style'),

-- Topic 1.3 Population structure
((SELECT id FROM topics WHERE topic_number = '1.3'), 'Describe the characteristics of a population pyramid for a country in Stage 2 of the demographic transition model.', 4, 'A Stage 2 country has a wide base showing high birth rates, rapidly narrowing sides showing high death rates especially in childhood, a concave shape indicating falling population with age, and a very narrow top showing few elderly due to low life expectancy. Examples include some Sub-Saharan African countries. The pyramid shape reflects high fertility but improving mortality.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.3'), 'Explain why the dependency ratio is a useful measure of population structure.', 4, 'The dependency ratio shows the number of dependents (under 15 and over 64) per 100 working-age people (15-64). It is useful because it indicates the economic burden on the working population, helps governments plan for education and pension provision, and allows comparison between countries at different development stages. A high ratio suggests strain on services and working population, while a low ratio indicates a larger workforce to support dependents.', 'explain', 'exam-style'),

-- Topic 1.4 Population density
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Describe the distribution of population in a named country.', 4, 'In Australia, population is very unevenly distributed. The southeast coastal area is densely populated, containing cities like Sydney and Melbourne, due to favourable climate, fertile soils, and historical settlement patterns. The interior (Outback) is very sparsely populated with less than 1 person per km² due to extreme aridity, high temperatures, and lack of water resources. The north is also sparse due to tropical climate and remoteness. Over 85% of Australians live within 50km of the coast.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Explain why some areas are sparsely populated.', 4, 'Areas are sparsely populated due to physical factors including: extreme climates (too hot, cold, wet or dry); mountainous terrain making farming and building difficult; poor soils unsuitable for agriculture; dense vegetation like rainforest; and lack of natural resources. Human factors include: remoteness from markets and services; poor transport links; political instability or conflict; and lack of economic opportunities. The Canadian Northlands are sparse due to extreme cold and permafrost.', 'explain', 'exam-style'),

-- Topic 1.5 Settlements
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Explain the factors that influence the site of a settlement.', 4, 'Settlement sites are influenced by: water supply - rivers provide drinking water, transport and trade; defence - hilltops and river meanders offer protection; building materials - availability of stone or wood; food supply - fertile soils for agriculture; fuel - wood or coal for energy; shelter - valleys protect from wind; and dry point - raised areas safe from flooding. In the past, defensive sites and water supply were most important. Today, accessibility and flat land for building are more significant.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Distinguish between low-order and high-order services.', 4, 'Low-order services are basic, everyday needs found in small settlements. They have low threshold populations (few customers needed), small range (people won''t travel far), and include newsagents, post offices, and convenience stores. High-order services are specialized, used less frequently, found only in larger settlements. They have high threshold populations, large range (people travel further), and include department stores, hospitals, and universities. A village might have low-order services while a city has both.', 'distinguish', 'exam-style'),

-- Topic 1.6 Urban settlements
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Describe the characteristics of the Central Business District (CBD).', 4, 'The CBD is the commercial heart of a city, characterised by: highest land values and building density; tall buildings (vertical land use) to maximise expensive space; concentration of shops, offices, banks and entertainment; excellent accessibility by public transport; pedestrianised areas in many cities; limited residential population; and traffic congestion during working hours. Land use is mainly commercial and retail. The CBD is typically located at the historical core of the city where transport routes converge.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Explain the problems caused by urban sprawl and suggest solutions.', 6, 'Urban sprawl causes problems including: loss of farmland and green spaces; increased car dependency and traffic congestion; air pollution and carbon emissions; strain on infrastructure like water and electricity; social segregation between suburbs and inner city; and loss of community in low-density developments. Solutions include: green belt policies to prevent outward growth; urban renewal to make inner cities attractive; mixed-use developments reducing travel needs; improved public transport; planning controls on out-of-town developments; and brownfield site development prioritised over greenfield.', 'explain', 'exam-style'),

-- Topic 1.7 Urbanisation
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Describe and explain the growth of squatter settlements in cities in developing countries.', 6, 'Squatter settlements grow due to rapid rural-urban migration exceeding housing supply. Migrants cannot afford formal housing so build temporary shelters on unused land. They locate on marginal land like steep slopes, flood plains, or near waste dumps because this land is unclaimed. Settlements grow through self-help as residents gradually improve homes with better materials. Causes include urban pull factors (jobs, services), rural push factors (poverty, lack of land), natural population increase in cities, and government inability to provide affordable housing. Examples include favelas in Rio de Janeiro and bustees in Kolkata.', 'describe and explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Evaluate strategies used to improve squatter settlements.', 6, 'Self-help schemes provide materials for residents to improve their own homes - this is cheap, builds community pride, but progress is slow. Site and service schemes provide plots with basic infrastructure (water, electricity, roads) for people to build on - this is organised but may not meet demand. Urban renewal demolishes settlements and builds new housing - this is modern but displaces communities and is expensive. In-situ upgrading improves existing settlements with paved roads, sanitation and electricity while keeping communities together - this is popular but doesn''t address overcrowding. Most successful approaches combine several strategies and involve community participation.', 'evaluate', 'exam-style'),

-- Topic 2.1 Earthquakes and volcanoes
((SELECT id FROM topics WHERE topic_number = '2.1'), 'State the main differences between cone volcanoes and shield volcanoes.', 4, 'Cone volcanoes are steep sided and formed of acidic ash and cinders, and are formed at destructive plate boundaries. Examples include Mt St Helens. In contrast, shield volcanoes are low-angled volcanoes – they may still be very high – formed of runny, basaltic lava at constructive plate margins and hot spots. Examples include Mauna Loa in Hawaii.', 'state', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'State the meaning of the terms epicentre and focus.', 2, 'The focus is the exact position within the Earth where an earthquake takes place. The epicentre is the point on the Earth''s surface immediately above the focus.', 'state', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Describe the advantages of volcanoes.', 3, 'The advantages of volcanoes include: the creation of new land; the production of fertile soil; rich minerals; and they are important tourist destinations.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Compare the primary and secondary effects of earthquakes.', 4, 'The primary hazards are the direct hazards associated with earthquakes such as land shaking and surface faulting (subsidence). In contrast, secondary hazards are the indirect hazards such as landslides, tsunamis and rock falls.', 'compare', 'exam-style'),

-- Topic 2.2 Rivers
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Compare infiltration and throughflow.', 2, 'Infiltration is the movement of water into the soil, whereas throughflow is the downward movement of water under the soil (subsoil).', 'compare', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Compare the cross-section of a river in its upper course with that of a river in its lower course.', 4, 'An upper course river has a narrow, deep/steep-sided cross-section, whereas a lower course river has a wider, flatter cross-section.', 'compare', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Compare the long profile of an upper-course river with that of a lower-course river.', 2, 'The upper course generally has a steeper long profile, whereas the lower course has a much gentler long profile.', 'compare', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Briefly explain how waterfalls and gorges are formed.', 4, 'Waterfalls frequently occur on horizontally bedded rocks. The soft rock is undercut by hydraulic action and abrasion, to form a plunge pool. The softer rock is eroded by fragments of the harder rock that break off. The weight of the water and the lack of support cause the waterfall to collapse and retreat. Over thousands of years the waterfall may retreat enough to form a gorge of recession.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Draw an annotated diagram to show the formation of an oxbow lake.', 4, 'Diagram should show three stages: 1) Erosion and deposition around a meander with E marked on outer bank and D on inner bank. 2) Increased erosion during flood conditions causing meanders to become exaggerated and neck to narrow. 3) The river breaks through during a flood, and further deposition causes the old meander to become cut off as an oxbow lake.', 'draw', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Outline the hazards and opportunities of living in a named river valley.', 7, 'The Nile Delta is one of the oldest intensively cultivated areas in the world with population density of about 16,000 per km². Only 2.5% of Egypt is suitable for agriculture and 95% of production comes from the Nile valley and delta. Opportunities include: freshwater supply, fertile silt for farming, navigation for trade, flat land for building, and fishing. Hazards include: flooding risk (1m sea level rise would flood 20% of the delta), waterlogging from excessive irrigation, pollution from fertilisers and pesticides, and saltwater intrusion causing groundwater salinisation. The delta provides 60% of the nation''s food supply but most is very low-lying and vulnerable to sea level rise.', 'outline', 'exam-style'),

-- Topic 2.3 Coasts
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Describe the process of longshore drift.', 3, 'Longshore drift occurs when the waves break at an angle to the shoreline. The swash moves up the beach at an angle whereas the backwash moves sediment down the beach at right angles to the shoreline. The net movement is along the beach, i.e. longshore drift.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Explain how a stack is formed.', 4, 'On a rocky headland, hydraulic action erodes a line of weakness (such as a fault line) or wave refraction concentrates wave energy on the flanks of the headland, causing a cave to be formed. Continual erosion may, in time, form an arch in the headland. Over time the arch is weathered and eroded, until eventually it collapses, leaving a stack.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Explain the formation of spits.', 4, 'A spit is formed by longshore drift. It carries material and deposits it where there is an indent in the coastline or a river mouth causes an obstruction to longshore drift. A spit is attached at one end and unattached at the other end.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Identify the hazards associated with tropical storms (hurricanes).', 2, 'Hazards include a combination of high wind speeds, storm surges (high tides), heavy rainfall leading to flooding and wind damage.', 'identify', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Suggest why the Nile Delta is vulnerable to sea level change.', 3, 'The Nile Delta is low lying and a great many people live there. These factors, as well as it being an important agricultural and industrial region, make it vulnerable to sea level rising.', 'suggest', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Identify the advantages of the Nile Delta for people.', 4, 'It is low lying, therefore easy to build on; it is fertile, so good for farming; it has a good supply of fresh water; it has good potential for trade because the river is navigable and has access to the coast; and it has good potential for tourism.', 'identify', 'exam-style'),

-- Topic 2.5 Climate and natural vegetation
((SELECT id FROM topics WHERE topic_number = '2.5'), 'Briefly explain why tropical rainforests are hot and wet.', 4, 'Tropical rainforests are hot because they are located close to the Equator (low latitude), and therefore receive high levels of insolation throughout the year. They are wet because the high temperatures lead to convectional rainfall throughout the year. As you move away from the Equator, the climate becomes more seasonal.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 'Explain why soils in the tropical rainforest are usually infertile.', 3, 'Most of the nutrients are locked in the vegetation due to the year-round growing season. As leaves fall from the trees (there is no season), they are rapidly decomposed in the hot, wet conditions (over 27°C and over 2000mm per year). Due to the continuous growth of the vegetation, plants take up the nutrients, thereby leaving the soil relatively infertile.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 'Describe the main difficulties in developing hot, arid areas.', 3, 'The lack of water is the main limiting factor. Annual rainfall is less than 250mm of rain, and aquifers in desert areas are non-renewable resources. Desalination offers a potential solution for the storage of water, but is expensive.', 'describe', 'exam-style'),

-- Topic 3.1 Development
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Define the primary sector of an economy.', 2, 'The primary sector exploits raw materials from land, water and air. Farming, fishing, forestry, mining and quarrying make up most of the jobs in this sector.', 'define', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Why does the primary sector dominate employment in the poorest countries of the world?', 3, 'The poorest countries of the world have more than 70 per cent of their employment in the primary sector. Lack of investment in general means that agriculture and other parts of the primary sector are very labour intensive, and jobs in the secondary and tertiary sectors are limited in number.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Explain the changes in employment structure that have occurred in NICs.', 4, 'In NICs employment in manufacturing has increased rapidly in recent decades. NICs have reached the stage of development whereby they attract foreign direct investment from TNCs in many sectors of the economy. As NICs expand their economies they develop their own domestic companies. Both processes create employment in manufacturing and services. The increasing wealth of NICs allows for greater investment in agriculture. This includes mechanisation which results in falling demand for labour on the land. So, as employment in the secondary and tertiary sectors rises, employment in the primary sector falls. NICs may become so advanced that the quaternary sector begins to develop.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Define a transnational corporation.', 2, 'A transnational corporation is a firm that owns or controls productive operations in more than one country through foreign direct investment.', 'define', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Describe and explain the role of transnational corporations in the global economy.', 6, 'TNCs and nation states are the two main elements of the global economy. The governments of countries individually and collectively set the rules for the global economy, but the bulk of investment is through TNCs. Manufacturing industry and services have relocated from developed to developing countries as TNCs take advantage of lower labour costs. This has resulted in the emergence of NICs since the 1960s and deindustrialisation in developed countries. Twenty years ago most TNCs had headquarters in North America, Western Europe and Japan. However, NICs like South Korea, China and India now account for an increasing share of the global economy through expansion of their own companies. TNCs have a huge impact through their decisions on what and where to buy and sell, and are major employers influencing countries where they locate.', 'describe and explain', 'exam-style'),

-- Topic 3.2 Food production
((SELECT id FROM topics WHERE topic_number = '3.2'), 'How can farming be seen to operate as a system?', 2, 'Individual farms can be seen to operate as a system with inputs, processes and outputs. A farm requires a range of inputs such as labour so that the processes that take place on the farm, such as harvesting, can be carried out. The aim is to produce the best possible outputs such as milk, eggs and crops.', 'explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Explain the difference between (i) intensive and extensive farming and (ii) subsistence farming and commercial farming.', 4, '(i) Intensive farming is characterised by high inputs per unit of land to achieve high yields per hectare. Extensive farming is where a relatively small amount of agricultural produce is obtained per hectare of land, so such farms tend to cover large areas of land. Inputs per unit of land are low. (ii) Subsistence farming is the most basic form of agriculture where the produce is consumed entirely or mainly by the family who work the land or tend the livestock. If a small surplus is produced it may be sold or traded. The objective of commercial farming is to sell everything the farm produces. The aim is to maximise yields to achieve the greatest profit.', 'explain', 'exam-style'),

-- Topic 3.3 Industry
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Describe and explain the factors that influence the location of a high-technology industry.', 6, 'High-technology industries like those in science parks locate near universities for research links and graduate labour supply. They need pleasant environments (green spaces, low pollution) to attract skilled workers. Good transport links including airports are essential for global connections. Government incentives like tax breaks and grants attract investment. Modern telecommunications infrastructure is vital for data transfer. Examples include Cambridge Science Park near Cambridge University and Silicon Valley near Stanford. These industries are footloose as they don''t need heavy raw materials, so quality of life factors become more important than traditional factors.', 'describe and explain', 'exam-style'),

-- Topic 3.4 Tourism
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Describe and explain the growth of international tourism.', 6, 'International tourism has grown from 25 million arrivals in 1950 to over 1 billion in 2012. Growth factors include: rising incomes giving more disposable income for holidays; increased leisure time with longer paid holidays; cheaper air travel through budget airlines and package holidays; improved transport infrastructure; marketing and media raising awareness of destinations; political changes opening new destinations (e.g., Eastern Europe after 1990); and aging populations in developed countries with time and money to travel. The internet has made booking easier. Growth has been fastest in Asia-Pacific due to rising middle classes in China and India.', 'describe and explain', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Evaluate the benefits and disadvantages of tourism for a named country.', 7, 'Jamaica depends heavily on tourism which provides foreign exchange earnings, employment (directly in hotels, indirectly in transport and crafts), tax revenue for government, and infrastructure development benefiting locals. However, economic leakage is high as foreign-owned hotels repatriate profits. Jobs are often seasonal, low-paid and low-skilled. Tourism creates environmental damage including beach erosion, reef damage, and pollution. Social and cultural impacts include crime, prostitution, and erosion of local traditions. Overdependence on tourism makes the economy vulnerable to external shocks like hurricanes or global recessions. Sustainable tourism initiatives aim to spread benefits more widely but have had limited success.', 'evaluate', 'exam-style'),

-- Topic 3.5 Energy
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Evaluate the benefits and disadvantages of nuclear power as an energy source.', 6, 'Benefits of nuclear power include: high energy output from small amounts of fuel; no direct carbon emissions during operation; reliable baseload power not dependent on weather; long operating life of power stations; and energy security reducing dependence on imported fossil fuels. Disadvantages include: very high construction and decommissioning costs; risk of catastrophic accidents (Chernobyl, Fukushima); unsolved problem of nuclear waste storage; potential security risks from nuclear materials; long construction times; and public opposition. Nuclear may help address climate change but waste remains radioactive for thousands of years. Some countries like Germany are phasing out nuclear while others like France rely on it heavily.', 'evaluate', 'exam-style'),

-- Topic 3.6 Water
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Explain the factors that affect the availability and supply of water.', 6, 'Physical factors affecting water availability include: climate (rainfall amount and distribution, evaporation rates); geology (aquifer presence and recharge rates); relief (catchment areas, river systems); and seasonal variations. Human factors include: population size and growth increasing demand; economic development raising per capita consumption; agriculture (70% of global water use is for irrigation); industry requiring water for processes and cooling; pollution reducing usable water; and infrastructure for storage and distribution. Climate change is altering precipitation patterns. Over 660 million people lack access to improved water sources, mainly in developing countries where infrastructure investment is insufficient.', 'explain', 'exam-style'),

-- Topic 3.7 Environmental risks
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Describe the causes and effects of acid deposition.', 6, 'Acid deposition is caused by emissions of sulfur dioxide and nitrogen oxides from burning fossil fuels in power stations, factories and vehicles. These gases combine with water vapour to form sulfuric and nitric acids which fall as acid rain, snow or dry deposition. Effects include: damage to forests as acid leaches nutrients from soil and damages leaves; acidification of lakes and rivers killing fish and other aquatic life; damage to buildings and monuments, especially limestone; and health effects from air pollution. Effects can occur far from emission sources as pollution is carried by prevailing winds - Scandinavian lakes were damaged by British and German emissions. Solutions include reducing emissions through cleaner technology and adding lime to affected lakes and soils.', 'describe', 'exam-style'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Explain the causes of desertification and evaluate strategies to combat it.', 7, 'Desertification is caused by: overgrazing removing vegetation cover; deforestation for fuel and farmland; overcultivation exhausting soil nutrients; and climate change reducing rainfall. These expose soil to wind and water erosion, leading to loss of productive land. The Sahel region of Africa is severely affected. Strategies include: planting trees as windbreaks and to stabilise soil; improving farming techniques like terracing and mulching; controlled grazing to allow vegetation recovery; water harvesting techniques; and alternative fuel sources to reduce deforestation. However, strategies are difficult to implement due to poverty, population pressure, and weak governance. International aid and long-term commitment are needed. Success requires combining technical solutions with addressing underlying social and economic causes.', 'explain and evaluate', 'exam-style');

-- ============================================
-- PART 6: CASE STUDIES DATA
-- ============================================

INSERT INTO case_studies (topic_id, name, location, category, overview, causes, effects, solutions, key_facts, exam_relevance) VALUES
-- Topic 1.1 Case Studies
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Kenya - Rapid Population Growth', 'Kenya, East Africa', 'population growth',
'Kenya exemplifies the challenges facing many African countries with rapid population growth putting pressure on resources and services.',
'High birth rates due to: cultural preference for large families; lack of education especially for women; limited access to contraception; children needed for farm labour and family security; high infant mortality meaning more children needed to ensure survivors.',
'Pressure on land leading to soil degradation and deforestation; strain on education and healthcare services; high youth unemployment; rapid urbanisation and growth of slums in Nairobi; food insecurity in drought years.',
'Government family planning programmes; improving girls'' education; healthcare improvements reducing infant mortality; economic development providing alternatives to subsistence farming.',
'["Population: ~54 million (2022)", "Growth rate: ~2.2% per year", "Fertility rate: ~3.4 children per woman", "50% of population under 18 years old", "Nairobi population: ~4.5 million"]',
'Use as example of high population growth in LIC, demographic challenges, population policies.'),

((SELECT id FROM topics WHERE topic_number = '1.1'), 'China - One-Child Policy', 'China', 'population policy',
'China''s one-child policy (1979-2015) was the world''s most ambitious population control programme, dramatically reducing birth rates but causing social problems.',
'Rapid population growth in 1960s-70s threatening economic development; Mao''s earlier pro-natalist policies had encouraged large families; government concerned about food security and resources.',
'Birth rate fell from 33 per 1000 (1970) to 12 per 1000 (2015); prevented estimated 400 million births; ageing population now creating dependency issues; gender imbalance (120 boys per 100 girls) due to son preference; ''little emperor'' syndrome; future labour shortage.',
'Policy relaxed to two children (2015) then three children (2021); incentives now offered for having children; improved pension systems needed for ageing population.',
'["Policy duration: 1979-2015", "Fertility rate fell from 5.9 (1970) to 1.7 (2015)", "400 million births prevented", "Gender ratio: 120 males per 100 females at birth", "Population: 1.4 billion"]',
'Key case study for anti-natalist policy, population structure changes, social consequences.'),

((SELECT id FROM topics WHERE topic_number = '1.1'), 'France - Pro-natalist Policy', 'France, Western Europe', 'population policy',
'France has long-standing pro-natalist policies encouraging larger families, resulting in one of Europe''s highest birth rates.',
'Low birth rates in 20th century threatening population decline; concerns about workforce shrinkage and pension funding; desire to maintain population compared to neighbours.',
'Higher birth rate than most European countries (around 1.9 children per woman); relatively young population structure; continued population growth unlike Germany or Italy.',
'Generous maternity/paternity leave; subsidised childcare; family allowances increasing with number of children; tax benefits for families; reduced working hours for parents.',
'["Fertility rate: ~1.9 (one of highest in Europe)", "Maternity leave: 16 weeks full pay", "Family allowances from second child", "Subsidised childcare widely available", "Population: ~67 million"]',
'Use as example of pro-natalist policy in HIC, contrast with ageing European populations.'),

((SELECT id FROM topics WHERE topic_number = '1.1'), 'Russia - Population Decline', 'Russia', 'population decline',
'Russia experienced rapid population decline after the Soviet Union collapsed, with death rates exceeding birth rates.',
'Economic collapse in 1990s causing stress, poverty and poor healthcare; high rates of alcoholism especially among men; emigration of young, educated people; low birth rate due to economic uncertainty; poor healthcare system.',
'Population fell from 148 million (1991) to 143 million (2010); life expectancy for men fell to 58 years; ageing workforce; labour shortages in some regions; military recruitment difficulties.',
'Pro-natalist payments for second and third children (''maternity capital''); improved healthcare funding; restrictions on alcohol; encouraging return migration of ethnic Russians.',
'["Population decline: 148 million (1991) to 144 million (2020)", "Male life expectancy fell to 58 years (1990s)", "Maternity capital: ~$7000 for second child", "Recent slight population recovery before 2020"]',
'Example of population decline in former communist country, demographic crisis, pro-natalist responses.'),

-- Topic 1.2 Case Studies
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Syria Refugee Crisis', 'Syria/Middle East/Europe', 'forced migration',
'The Syrian civil war (from 2011) created the largest refugee crisis since World War II, with millions fleeing to neighbouring countries and Europe.',
'Civil war beginning 2011; government attacks on civilian areas; rise of ISIS; destruction of homes, infrastructure and livelihoods; collapse of economy and services.',
'Over 6 million refugees fled Syria; Turkey hosts 3.6 million, Lebanon 1 million; dangerous Mediterranean crossings; strain on host country resources; integration challenges in Europe; family separation; psychological trauma.',
'UN refugee camps in Jordan and Turkey; EU relocation schemes (limited); integration programmes in Germany and Sweden; some voluntary returns as conflict reduced in some areas.',
'["6+ million refugees fled Syria", "6 million internally displaced", "Turkey hosts 3.6 million Syrian refugees", "Lebanon: Syrians = 25% of population", "Germany accepted 800,000+ in 2015"]',
'Key example of forced migration/refugee crisis, push-pull factors, international migration impacts.'),

((SELECT id FROM topics WHERE topic_number = '1.2'), 'Mexico-USA Migration', 'Mexico to USA', 'international migration',
'Mexico-USA migration is one of the world''s largest migration corridors, driven by economic factors and geographical proximity.',
'Economic push factors: lower wages, unemployment, poverty in rural Mexico. Pull factors: higher wages, job opportunities, established Mexican communities in USA. Geographical proximity makes migration easier.',
'11+ million Mexican-born people in USA; remittances vital to Mexican economy ($40+ billion/year); family separation; exploitation of undocumented workers; cultural influence in border states; political tensions over immigration policy.',
'Border wall construction; increased enforcement; guest worker programmes; DACA programme for young migrants; development programmes in Mexico to reduce emigration pressure.',
'["11 million Mexican-born in USA", "Remittances: $40+ billion/year to Mexico", "Border length: 3,145 km", "2 million deportations 2009-2016"]',
'Classic example of economic migration between neighbouring countries, remittances, border issues.'),

-- Topic 1.7 Case Studies
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Shanghai Urbanisation', 'Shanghai, China', 'urbanisation',
'Shanghai''s transformation from a city of 13 million (1990) to over 24 million illustrates rapid urbanisation in emerging economies.',
'Economic reforms opened China to foreign investment; Shanghai designated Special Economic Zone; rural-urban migration driven by urban job opportunities; natural increase in urban population.',
'Population growth from 13 million to 24+ million (1990-2020); massive infrastructure development (metro, airports, bridges); redevelopment of historic areas; traffic congestion; air pollution; housing affordability crisis.',
'New towns developed around Shanghai to relieve pressure; hukou system limits rural migrant access to services; green space requirements in planning; metro system now world''s largest.',
'["Population: 24+ million", "Metro system: 800+ km (world''s largest)", "Pudong transformed from farmland to financial centre", "GDP per capita: ~$25,000"]',
'Example of rapid urbanisation in NIC/emerging economy, megacity growth, urban planning responses.'),

-- Topic 2.1 Case Studies
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Nepal Earthquake 2015', 'Nepal, South Asia', 'earthquake',
'The 2015 Nepal earthquake demonstrates the devastating impact of earthquakes on less developed countries.',
'Indian plate colliding with Eurasian plate; shallow focus (15km); occurred near densely populated Kathmandu valley; many poorly constructed buildings.',
'Over 9,000 deaths; 22,000+ injuries; 600,000+ homes destroyed; historic temples in Kathmandu destroyed; triggered avalanche on Everest killing 19; landslides blocked roads; aftershocks continued for months.',
'International aid response; temporary shelters; reconstruction programmes with earthquake-resistant designs; improved building codes; early warning systems for future events.',
'["Magnitude: 7.8", "Deaths: 9,000+", "Focus depth: 15km (shallow)", "Epicentre: 80km north of Kathmandu", "Economic cost: $7 billion (35% of GDP)"]',
'Key case study for earthquake in LIC, plate tectonics, impacts and responses.'),

((SELECT id FROM topics WHERE topic_number = '2.1'), 'Soufrière Hills Volcano, Montserrat', 'Montserrat, Caribbean', 'volcano',
'The Soufrière Hills eruption (1995-present) destroyed much of Montserrat, showing volcanic hazards on small island states.',
'Atlantic plate subducting under Caribbean plate; volcano dormant for 400 years before 1995 eruption; continuing dome growth creates ongoing hazard.',
'Plymouth (capital) buried and abandoned; 19 deaths in 1997 pyroclastic flow; two-thirds of island evacuated; population fell from 11,000 to 5,000; airport destroyed; farmland buried.',
'Evacuation of southern exclusion zone; Montserrat Volcano Observatory monitors activity; new airport and town built in north; British government aid for reconstruction.',
'["First eruption: July 1995 after 400 years dormant", "Deaths: 19 (1997)", "Population fell from 11,000 to 5,000", "Southern 2/3 of island in exclusion zone", "Plymouth: only abandoned capital city in modern times"]',
'Excellent case study for volcanic eruption, impacts on small island, long-term volcanic hazard.'),

-- Topic 2.2 Case Studies
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Nile Delta', 'Egypt', 'river opportunities and hazards',
'The Nile Delta demonstrates both the opportunities and hazards of living in a river valley.',
'Annual Nile floods deposited fertile silt for thousands of years; Aswan Dam (1970) now controls flooding but reduces silt deposition; delta formed where river meets Mediterranean.',
'Opportunities: fertile soil supports 95% of Egypt''s agriculture; freshwater supply; navigation and trade; flat land for building. Hazards: sea level rise threatens low-lying areas; reduced silt causes coastal erosion; waterlogging from irrigation; saltwater intrusion.',
'Aswan Dam provides flood control and irrigation; drainage schemes address waterlogging; coastal defences against erosion; water treatment for pollution.',
'["Population density: 16,000/km²", "Provides 60% of Egypt''s food", "Only 2.5% of Egypt suitable for farming", "1m sea level rise would flood 20% of delta", "Nile length: 6,650km (world''s longest river)"]',
'Key case study for river hazards and opportunities, delta environment, water management.'),

-- Topic 2.3 Case Studies
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Dubai Coastal Development', 'Dubai, UAE', 'coastal management',
'Dubai''s artificial islands demonstrate extreme coastal modification and associated environmental concerns.',
'Oil wealth funded massive coastal development; tourism and property development goals; desire to expand limited natural coastline.',
'Palm Jumeirah and World Islands created using 94 million m³ of dredged sand; increased tourism and property development; water circulation problems; damage to natural coral reefs (70% lost since 2001); introduction of invasive species.',
'Dubai Coastal Zone Monitoring Programme; breakwaters to reduce erosion; beach nourishment; sand barriers to preserve coastline.',
'["Palm Jumeirah: 94 million m³ of sand", "70% of coral reefs lost since 2001", "Palm Deira planned to be 8x larger than Palm Jumeirah", "Water circulation issues around artificial islands"]',
'Example of hard engineering, coastal development impacts, management of artificial coastlines.'),

-- Topic 2.5 Case Studies
((SELECT id FROM topics WHERE topic_number = '2.5'), 'Danum Valley Conservation Area', 'Sabah, Borneo, Malaysia', 'tropical rainforest',
'Danum Valley is one of the largest remaining areas of pristine lowland rainforest in Southeast Asia.',
'Lowland dipterocarp forest (valuable hardwood); surrounded by logged forest; 43,800 hectares protected since 1990s.',
'Biodiversity: 120+ mammal species including orangutans, elephants, clouded leopards; 340+ bird species; endangered Sumatran rhinoceros. Research station enables scientific study; ecotourism provides sustainable income.',
'Protected status since 1990s; Royal Society research programme; INFAPRO rehabilitation project replanting 30,000 hectares of logged forest; management committee includes government, NGOs and commercial interests; ecotourism at Borneo Rainforest Lodge.',
'["Area: 43,800 hectares", "120+ mammal species", "340+ bird species", "Contains endangered Sumatran rhinoceros and orangutans", "INFAPRO replanting 30,000 hectares"]',
'Case study for tropical rainforest conservation, biodiversity, sustainable management.'),

((SELECT id FROM topics WHERE topic_number = '2.5'), 'Sonoran Desert', 'Arizona/California USA, Mexico', 'hot desert',
'The Sonoran Desert shows desert ecosystem characteristics and human impacts on arid environments.',
'Subtropical high pressure creates aridity; located 20-30° north latitude; some areas receive less than 75mm annual rainfall.',
'Adapted vegetation: saguaro cactus (up to 15m tall, lives 175 years), palo verde trees, creosote bushes. Low vegetation density; thin, infertile, alkaline soils; flash flooding compacts soil surface.',
'Phoenix urban expansion threatens desert habitat; road construction and fencing blocks wildlife movement; groundwater abstraction lowers water tables; introduced species displace native plants.',
'["Saguaro cactus: up to 15m tall, lives 175 years", "Annual rainfall: <250mm", "Temperature range: can exceed 50°C variation day-night", "Phoenix metro area: 4.5+ million people"]',
'Case study for hot desert ecosystem, adaptations, human impact on desert environment.'),

-- Topic 3.1 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Tata Group - TNC', 'India (HQ Mumbai), global operations', 'transnational corporation',
'Tata Group exemplifies the rise of TNCs from emerging economies and their global expansion.',
'Founded 1868; diversified into multiple sectors; accelerated global expansion from 2000s; strategy of acquiring established Western brands.',
'Over 100 companies in 7 business sectors; operations in 100+ countries; 660,000+ employees worldwide; 60%+ revenue from outside India. Key acquisitions: Corus Steel ($13 billion), Jaguar Land Rover ($2.5 billion). Moved up value chain to sophisticated products.',
'Reputation for social responsibility; Carnegie Medal for Philanthropy 2007; some UK operations faced difficulties (steel plant closures).',
'["Founded: 1868", "Operations: 100+ countries", "Employees: 660,000+", "Revenue: 60%+ from outside India", "Corus acquisition: $13 billion (2007)", "Jaguar Land Rover: $2.5 billion (2008)"]',
'Key case study for TNC from emerging economy, globalisation, acquisition strategy, impacts.'),

-- Topic 3.2 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Lower Ganges Valley - Rice Farming', 'India/Bangladesh', 'agricultural system',
'Intensive rice cultivation in the Ganges valley demonstrates a labour-intensive subsistence agricultural system.',
'Monsoon climate with 2000mm+ rainfall; rich alluvial soils from annual flooding; temperatures over 21°C year-round allow two crops annually; dense population provides labour.',
'Paddy field system with irrigation channels and embankments. Processes: nursery cultivation, transplanting, flooding fields, weeding, harvesting. High labour input throughout. Water buffalo used for ploughing. Two rice crops per year possible.',
'Green Revolution introduced high-yielding varieties but requires fertiliser and pesticide inputs; mechanisation limited due to small plot sizes and labour availability.',
'["Growing season: 100 days per crop", "Temperature: 21°C+ year-round", "Rainfall: 2000mm+ monsoon", "Labour-intensive: requires planting, transplanting, weeding, harvesting", "Two crops per year possible"]',
'Case study for intensive subsistence farming, agricultural systems, rice cultivation.'),

((SELECT id FROM topics WHERE topic_number = '3.2'), 'Sudan and South Sudan - Food Shortage', 'Sudan/South Sudan, East Africa', 'food shortage',
'Long-term food insecurity in Sudan/South Sudan demonstrates multiple causes and challenges of food shortage.',
'Civil war (decades of conflict); drought and climate variability; high population growth (3%); lack of infrastructure; political instability; declining rainfall trend.',
'UN estimated 2 million displaced by conflict; 70,000+ deaths from hunger and disease; food production disrupted; 4-5 million people at risk of severe food shortage; dependency on food aid.',
'UN World Food Programme deliveries (sometimes suspended due to danger); international aid; attempts at peace agreements; agricultural development projects (limited success due to ongoing conflict).',
'["Civil war: decades of conflict", "Population growth: 3% per year", "4-5 million facing food shortage", "Female illiteracy: 65%", "70% of labour force in farming", "WFP operations frequently disrupted"]',
'Case study for food shortage, conflict impacts on agriculture, food aid challenges.'),

-- Topic 3.3 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Bangalore - High-Tech Industry', 'Bangalore (Bengaluru), India', 'high-tech industry',
'Bangalore''s emergence as India''s ''Silicon Valley'' demonstrates factors affecting high-technology industrial location.',
'Large pool of English-speaking, technically educated graduates; lower wage costs than Western countries; time zone allows 24-hour service with US/UK; government support and tax incentives; pleasant climate.',
'Over 400 IT companies; major TNC presence (Microsoft, IBM, Google); IT parks with modern infrastructure; 35%+ of India''s IT exports; created large middle class; traffic congestion and housing pressure from growth.',
'Continued investment in education; new IT parks in surrounding areas; infrastructure improvements (metro, roads); some companies moving to cheaper locations as Bangalore costs rise.',
'["400+ IT companies", "35%+ of India''s IT exports", "Major employers: Infosys, Wipro, TCS", "Population growth from tech boom", "Known as ''Silicon Valley of India''"]',
'Case study for high-tech industry location, globalisation of services, NIC development.'),

-- Topic 3.4 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Jamaica - Tourism', 'Jamaica, Caribbean', 'tourism',
'Jamaica illustrates both the benefits and problems of tourism-dependent economies in developing countries.',
'Natural attractions: beaches, climate, Blue Mountains; cultural attractions: reggae music, Rastafarian culture; proximity to North American market; English-speaking; established tourism infrastructure.',
'Tourism provides 25%+ of GDP and major employment; foreign exchange earnings; infrastructure development. Problems: economic leakage (foreign-owned hotels); seasonal employment; low wages; social impacts (crime, prostitution); environmental damage; overdependence on single industry.',
'Sustainable tourism initiatives; community tourism projects; diversification efforts; all-inclusive resorts (but increase leakage); heritage tourism development.',
'["Tourism: 25%+ of GDP", "4+ million visitors per year", "Major source markets: USA, Canada, UK", "All-inclusive resorts dominant", "Vulnerability to hurricanes and global economic downturns"]',
'Case study for tourism benefits and costs, economic leakage, sustainable tourism attempts.'),

-- Topic 3.5 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Global Energy - Fossil Fuels to Renewables', 'Global', 'energy transition',
'The global shift from fossil fuels to renewable energy illustrates energy challenges and opportunities.',
'Climate change concerns; finite fossil fuel reserves; energy security concerns; improving renewable technology; falling costs of solar and wind power.',
'Coal use declining in developed countries but growing in some developing countries; oil remains dominant for transport; natural gas as ''transition fuel''; solar and wind fastest growing energy sources; 2.5 billion people still rely on traditional fuels.',
'Paris Agreement commitments; carbon pricing; renewable energy subsidies; phasing out coal power; electric vehicle promotion; energy efficiency improvements.',
'["2.5 billion rely on traditional fuels (wood, dung)", "Wind power leaders: China, USA, Germany, India, Spain", "Solar costs fell 90% in decade 2010-2020", "Transport still 95%+ dependent on oil"]',
'Case study for energy mix, renewable transition, energy access inequalities.'),

-- Topic 3.6 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Water Scarcity - Global Challenge', 'Global (focus on water-stressed regions)', 'water supply',
'Global water scarcity affects over 2 billion people and is worsening due to population growth and climate change.',
'Uneven distribution of water resources; population growth increasing demand; agriculture uses 70% of freshwater; climate change affecting rainfall patterns; pollution reducing available clean water.',
'Over 660 million lack access to improved water sources; 2.4 billion lack basic sanitation; water-borne diseases kill millions; conflict over water resources; women and girls spend hours collecting water.',
'Improved wells and boreholes; rainwater harvesting; desalination (expensive); water recycling; drip irrigation efficiency; international aid for water projects; watershed protection.',
'["660+ million lack safe water access", "2.4 billion lack basic sanitation", "70% of water use is agriculture", "Water stress: below 1700 m³/person/year", "Water scarcity: below 1000 m³/person/year"]',
'Case study for water supply challenges, inequality of access, management strategies.'),

-- Topic 3.7 Case Studies
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Climate Change and Global Warming', 'Global', 'environmental risk',
'Enhanced global warming from greenhouse gas emissions represents the greatest environmental challenge facing humanity.',
'Burning fossil fuels releases CO2; deforestation reduces carbon absorption; agriculture releases methane; industrial processes release various greenhouse gases; natural carbon sinks overwhelmed.',
'Global temperature rise (~1.1°C since pre-industrial); sea level rise; more extreme weather events; melting ice caps and glaciers; changing precipitation patterns; ecosystem disruption; species extinction; threats to food production.',
'Paris Agreement (limit to 1.5-2°C); renewable energy transition; carbon pricing; reforestation; energy efficiency; international cooperation; adaptation measures for unavoidable impacts.',
'["Temperature rise: ~1.1°C since 1850", "CO2: 420+ ppm (highest in 800,000 years)", "Sea level rise: 3.7mm per year", "Arctic ice: declining 13% per decade", "Paris Agreement: limit warming to 1.5-2°C"]',
'Essential case study for environmental risks, global cooperation, sustainable development.');

-- ============================================
-- PART 7: SAMPLE ANSWERS WITH TEACHER COMMENTS
-- ============================================

INSERT INTO sample_answers (topic_id, question_context, student_answer, teacher_comments, marks_awarded, marks_available, strengths, improvements) VALUES

((SELECT id FROM topics WHERE topic_number = '1.1'),
'Suggest reasons for the difference in the population pyramids of Ethiopia and Japan. [6]',
'Ethiopia has a wide base showing high birth rates. The young population structure shows limited family planning and a need for children to work on farms. Japan has a narrow base showing low fertility rates. Women pursue careers rather than having children. Japan has good healthcare leading to a top-heavy structure with many elderly. The narrow middle section shows emigration of working-age people.',
'The student has correctly identified key differences. The answer explains Ethiopia''s wide base well. The Japan analysis is good but the comment about emigration causing a narrow middle section is incorrect - Japan has low emigration. The student should focus on low birth rates and ageing population rather than migration.',
4, 6,
'Correct identification of pyramid shapes; good understanding of birth rate factors; appropriate comparison structure',
'Incorrect statement about emigration from Japan; could include specific data; should mention healthcare and life expectancy for Japan'),

((SELECT id FROM topics WHERE topic_number = '2.2'),
'Briefly explain how waterfalls and gorges are formed. [4]',
'Waterfalls frequently occur on horizontally bedded rocks. The soft rock is undercut by hydraulic action and abrasion, to form a plunge pool. The softer rock is eroded by fragments of the harder rock that break off. The weight of the water and the lack of support cause the waterfall to collapse and retreat. Over thousands of years the waterfall may retreat enough to form a gorge of recession.',
'The question did not ask for an annotated diagram, although one could have been provided. Some aspects of physical geography are easier to revise and explain using diagrams. Nevertheless, the student has identified: differences in rock strength; the horizontal layering of rocks; the types of erosion; an implied reason for the effectiveness of erosion; progression over time, leading to the formation of a gorge. Full marks awarded.',
4, 4,
'Identified rock differences; named erosion types (hydraulic action, abrasion); explained retreat mechanism; linked to gorge formation over time',
'Could include diagram; could name example (e.g., Niagara Falls)'),

((SELECT id FROM topics WHERE topic_number = '2.2'),
'Outline the hazards and opportunities of living in a named river valley. [7]',
'The Nile Delta is one of the oldest intensively cultivated areas in the world. It is heavily populated and has a population density of about 16,000 people per km². Only 2.5 per cent of Egypt''s land area is suitable for intensive agriculture – up to 95 per cent of Egypt''s agricultural production comes from the Nile valley and delta. The delta has long been a source of freshwater and fertile silt, as well as an excellent location for the import and export of goods. The flat land makes building easy. However, it is increasingly under stress. The delta covers around 25,000km², is home to around 66 per cent of the country''s rapidly growing population and provides over 60 per cent of the nation''s food supply. However, most of the delta is very low lying, and an increase in sea level of just 1m would flood 20 per cent of the area. Flooding by the river Nile is a potential problem. Excessive irrigation has led to waterlogging, whilst significant amounts of fertilisers and pesticides are leached into water courses along the delta. Seawater intrusion has led to the salinisation of groundwater.',
'The student has offered a range of benefits, two of which are supported with quantification. The student has made some general points about the risk of flooding – a recent example would be useful, or mention of the 2016 floods that killed 98 people in the upper Nile valley. A reason for the increased flood risk is given – numbers of people at risk, or names of cities at risk, or dates of the floods would have made this answer complete.',
6, 7,
'Good range of opportunities with data; identified multiple hazards; excellent use of statistics; named location clearly',
'Add specific flood event example; mention cities at risk; could discuss Aswan Dam role'),

((SELECT id FROM topics WHERE topic_number = '3.1'),
'Explain the changes in employment structure that have occurred in NICs. [4]',
'In NICs such as China and Brazil employment in manufacturing has risen rapidly in recent decades. NICs have attracted high levels of foreign direct investment from transnational corporations. This has not just been in manufacturing, but in the service sector in some countries such as India. The increasing wealth of NICs allows for greater investment in agriculture. This includes mechanisation, which results in falling demand for labour on the land. So, as employment in the secondary and tertiary sectors rises, employment in the primary sector falls.',
'This answer shows clear knowledge and understanding of employment changes in the different sectors in NICs. Relevant use of examples adds to the quality of the answer. The student gains all four marks available.',
4, 4,
'Clear understanding of sector changes; good examples (China, Brazil, India); explained mechanisation impact; linked investment to employment shifts',
'Could mention quaternary sector development; could add specific percentages'),

((SELECT id FROM topics WHERE topic_number = '3.2'),
'Discuss three physical factors that affect agricultural land use. [6]',
'Temperature is a major factor influencing farming as each type of crop requires a minimum growing temperature and a minimum growing season. Latitude, altitude and distance from the sea are the main influences on temperature. Precipitation is another very important factor influencing the type of farming possible in a region. It is not just the annual amount of precipitation that is important, but the way it is distributed throughout the year. Long, steady periods of rainwater to infiltrate into the soil are best, making water available for crop growth throughout the year. In contrast, short, heavy downpours can result in surface runoff, leaving less water available for crop growth and also contributing to soil erosion. A third physical factor affecting farming is soil fertility.',
'The student has gained five marks out of the six available. This answer shows good understanding of the influences of temperature and precipitation on agriculture. However, when it comes to the consideration of a third physical factor, the student is only able to name soil fertility, with no attempt to elaborate and gain the final mark available.',
5, 6,
'Excellent detail on temperature; thorough precipitation analysis; understood seasonal distribution importance',
'Soil fertility needs elaboration (nutrients, drainage, pH); could mention relief/slope as factor');

-- ============================================
-- VERIFICATION QUERIES
-- ============================================

-- Count all new content
SELECT 'Learning Objectives' as content_type, COUNT(*) as count FROM learning_objectives
UNION ALL SELECT 'Tips', COUNT(*) FROM tips
UNION ALL SELECT 'Common Errors', COUNT(*) FROM common_errors
UNION ALL SELECT 'Exam Questions', COUNT(*) FROM exam_questions
UNION ALL SELECT 'Case Studies', COUNT(*) FROM case_studies
UNION ALL SELECT 'Sample Answers', COUNT(*) FROM sample_answers;
