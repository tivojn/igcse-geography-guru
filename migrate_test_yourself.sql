-- Migration: Insert Test Yourself questions into Supabase
-- From Cambridge IGCSE Geography Study Guide (p.125-127)

-- Clear existing data
TRUNCATE TABLE test_yourself RESTART IDENTITY;

-- Topic 1.1 - Population dynamics
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.1', 1, 'Define rate of natural change.', 'The difference between the birth rate and the death rate.'),
('1.1', 2, 'Which world region has the highest birth rate?', 'Africa'),
('1.1', 3, 'When is the world''s population projected to reach 8 billion?', '2023'),
('1.1', 4, 'What are the four categories of factors affecting fertility?', 'Demographic, social/cultural, economic, political'),
('1.1', 5, 'Define life expectancy.', 'The average number of years a newborn infant can expect to live under current mortality levels.'),
('1.1', 6, 'Give two negative impacts of overpopulation.', 'Intense competition for land; heavy traffic congestion');

-- Topic 1.2 - Migration
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.2', 1, 'What is a refugee?', 'A person forced to flee their home due to human or environmental factors, and who crosses an international border into another country.'),
('1.2', 2, 'When did developed countries have their period of high rural–urban migration?', 'In the nineteenth century and the early part of the twentieth century.'),
('1.2', 3, 'What is counterurbanisation?', 'The process of population decentralisation as people move from large urban areas to smaller urban settlements and rural areas.');

-- Topic 1.3 - Population structure
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.3', 1, 'Place the following stages of the demographic transition model in order of highest to lowest natural increase: Stage 2, Stage 3, Stage 4, Stage 5.', 'Stage 3, stage 5, stage 2, stage 4'),
('1.3', 2, 'Define the dependency ratio.', 'The ratio of the number of people under 15 and over 64 years to those 15–64 years of age (per 100).'),
('1.3', 3, 'What does a dependency ratio of 80 mean?', 'For every 100 people in the economically active population there are 80 people dependent on them.');

-- Topic 1.4 - Population density and distribution
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.4', 1, 'Define population density.', 'The average number of people per square kilometre in a country or region.'),
('1.4', 2, 'What is the population density of the Canadian Northlands?', 'Less than one person per km²'),
('1.4', 3, 'Name four major cities in the northeast of the USA.', 'For example, Boston, New York, Chicago, Philadelphia');

-- Topic 1.5 - Settlements and service provision
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.5', 1, 'Distinguish between dispersed and nucleated settlements.', 'A dispersed settlement pattern occurs when farms or houses are set among fields or spread along roads. A nucleated settlement is one in which buildings are tightly clustered around a central feature.'),
('1.5', 2, 'Distinguish between the site and situation of a settlement.', 'The site of a settlement is the land on which the settlement is built, whereas the situation or position is the relationship between the settlement and its surrounding area.'),
('1.5', 3, 'State one example of a high-order function and one example of a low-order function.', 'High-order function – department store or bank; low-order function – newsagent'),
('1.5', 4, 'Define the terms threshold population and sphere of influence.', 'The threshold population is the number of people needed to support a good or service. The sphere of influence refers to the area that a settlement serves.');

-- Topic 1.6 - Urban settlements
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.6', 1, 'Distinguish between urban sprawl and urban renewal.', 'Urban sprawl is the unchecked outward spread of built-up areas, caused by their expansion. Urban renewal refers to the improvement of existing buildings.'),
('1.6', 2, 'What is gentrification?', 'Gentrification refers to the movement of higher social or economic groups into an area after it has been renovated and restored.');

-- Topic 1.7 - Urbanisation
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('1.7', 1, 'Define urbanisation.', 'Urbanisation is the process by which the proportion of a population living in urban areas increases through migration and natural increase.'),
('1.7', 2, 'Distinguish between a megacity and a millionaire city.', 'A megacity is a city with over 10 million inhabitants, whereas a millionaire city is a city with over 1 million inhabitants.');

-- Topic 2.1 - Earthquakes and volcanoes
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('2.1', 1, 'State the difference between dormant and extinct volcanoes.', 'A dormant volcano is a volcano that has not erupted for a very long time but could erupt again. In contrast, an extinct volcano is a volcano that has shown no signs of volcanic activity in historical times.'),
('2.1', 2, 'Distinguish between destructive and constructive plate boundaries.', 'A destructive plate boundary is one where oceanic crust moves towards the continental crust and sinks beneath it, due to its higher density. Material is destroyed at a destructive plate boundary. In contrast, at a constructive plate boundary, new oceanic crust is formed as the two plates move apart.'),
('2.1', 3, 'Explain how humans can cause earthquakes.', 'For example, due to the weight of large dams, drilling for oil/fracking and/or nuclear testing.');

-- Topic 2.2 - Rivers
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('2.2', 1, 'Distinguish between hydraulic action and abrasion.', 'Hydraulic action is the force of air and water on the sides of rivers and in cracks, whereas abrasion is the wearing away of the bed and bank by the load carried by a river.'),
('2.2', 2, 'Distinguish between saltation and traction.', 'Saltation is the process whereby heavier particles are bounced or bumped along the bed of the river, whereas traction is the process whereby the heaviest material is dragged or rolled along the bed of the river.'),
('2.2', 3, 'What are the main causes of floods?', 'The main causes of floods are heavy rain, prolonged rain, snow melt, high tides, storm surges, earthquakes and landslides causing temporary lakes. Human activities can increase the flood risk by removing vegetation, making the surface impermeable and living in areas at risk of flooding.'),
('2.2', 4, 'Briefly explain how flood risk can be managed.', 'The risk of flooding can be reduced by: building dams or reservoirs to hold back excess water; raising the banks of rivers; dredging the river channel so that it can hold more water; diverting streams and creating new flood relief channels; using sand bags to prevent water getting into houses; building houses on stilts so that water can pass underneath; land-use planning; afforestation to increase interception and reduce overland flow; having insurance cover for vulnerable areas and communities; improving forecasting and warning systems.');

-- Topic 2.3 - Coasts
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('2.3', 1, 'Distinguish between destructive and constructive waves.', 'Destructive waves are erosional waves with a short wavelength and high height. They have a high frequency (10–12 per minute), and their backwash is greater than their swash. In contrast, constructive waves have a long wavelength and low height. They have a low frequency (6–8 per minute) and their swash is greater than backwash.'),
('2.3', 2, 'How is a wave-cut platform formed?', 'Steep cliffs are eroded between the low-water mark and the high-water mark. As they retreat they are replaced by a lengthening platform and lower-angle cliffs, subject to weathering and mass movements rather than marine forces.'),
('2.3', 3, 'Distinguish between fringing reefs and atolls.', 'Fringing reefs are those that grow outwards around an island, and are located on the edge of a land mass, whilst atolls are circular reefs enclosing a shallow lagoon.'),
('2.3', 4, 'Distinguish between gabions and sea walls.', 'Gabions are rocks held in wire cages and absorb wave energy, whereas sea walls are large-scale concrete structures designed to deflect wave energy.');

-- Topic 2.4 - Weather
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('2.4', 1, 'Describe a Stevenson screen and explain why it is used.', 'A Stevenson screen is a wooden box standing on four legs of height about 120cm. The screen is raised so that air temperature can be measured. The sides of the box are slatted to allow air to enter freely. The roof is usually made of double boarding to prevent the Sun''s heat from reaching the inside of the screen. Insulation is further improved by painting the outside of the screen white to reflect much of the Sun''s energy. The screen is usually placed on a grass-covered surface, thereby reducing the radiation of heat from the ground.'),
('2.4', 2, 'Name the instruments used to measure: (a) humidity (b) wind speed.', '(a) Wet- and dry-bulb thermometer (b) Anemometer'),
('2.4', 3, 'Distinguish between cirrus and cumulonimbus clouds.', 'Cirrus clouds are thin, wispy, high-altitude clouds, formed of ice crystals. Cumulonimbus are thick clouds extending from low altitude to high altitude, and are associated with heavy downpours and sometimes thunder and lightning.');

-- Topic 2.5 - Climate and natural vegetation
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('2.5', 1, 'Describe the characteristics of (a) equatorial climate and (b) hot desert climate.', '(a) Equatorial areas have: high annual temperatures year round (26–27°C); low seasonal ranges (1–2°C), but greater diurnal (daily) ranges (10–15°C); high rainfall throughout the year (more than 2000mm). (b) Hot deserts have: high daytime temperatures (30–40°C) throughout the year; a large temperature difference, often as much as 50°C between day and night; unreliable and low rainfall (about 250mm/year).'),
('2.5', 2, '(a) Why do equatorial areas receive more heat than polar areas? (b) How does temperature change with altitude?', '(a) Areas that are close to the Equator receive more heat than areas that are close to the Poles because incoming solar radiation is concentrated near the Equator, but dispersed near the Poles. In addition, insolation near the Poles has to pass through a greater amount of atmosphere and there is more chance of it being reflected back out to space. (b) Temperature decreases with altitude. On average, it drops about 1°C for every 100 metres.'),
('2.5', 3, 'Describe the characteristics of tropical rainforest vegetation.', 'Vegetation in the rainforest is evergreen. Photosynthesis and growing can happen all year. The vegetation is layered, and the shape of the crowns varies with the layer, in order to receive maximum light. It is very diverse — there are up to 200 species of tree per hectare. Trees at the top of the canopy are adapted to being in the light; those near the ground are adapted to being in the shade. The trees have buttress roots to help stabilise them.'),
('2.5', 4, 'How do plants adapt to desert conditions?', 'Plants adapt to deserts by: growing deep roots or wide roots; producing only a few leaves, to reduce transpiration (moisture loss); storing water; and producing seeds that wait for rainfall before growing and completing a very quick life cycle.');

-- Topic 3.1 - Development
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.1', 1, 'List the indicators used in the Human Development Index (HDI).', 'Life expectancy at birth, mean years of schooling for adults aged 25 years, expected years of schooling for children of school entering age, GNI per capita (PPP$)'),
('3.1', 2, 'How many countries are identified as LDCs (Least Developed Countries)?', '48'),
('3.1', 3, 'What is the Gini coefficient?', 'A technique used to show the extent of income inequality.'),
('3.1', 4, 'What is a product chain?', 'The full sequence of activities needed to turn raw materials into a finished product.'),
('3.1', 5, 'What is a transnational corporation (TNC)?', 'A firm that owns or controls productive operations in more than one country through foreign direct investment.'),
('3.1', 6, 'How has the number of internet users changed since 2000?', 'From 361 million in 2000 to 3.4 billion in 2016');

-- Topic 3.2 - Food production
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.2', 1, 'What are the three components of an agricultural system?', 'Inputs, processes, outputs'),
('3.2', 2, 'Give examples of pastoral farming.', 'Livestock farming such as dairy cattle, beef cattle, sheep and pigs'),
('3.2', 3, 'What is land tenure?', 'The way in which land is, or can be, owned.');

-- Topic 3.3 - Industry
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.3', 1, 'What are footloose industries?', 'Industries that are not tied to certain areas because of energy requirements or other factors.'),
('3.3', 2, 'Give an example of a science park.', 'For example, Cambridge Science Park in the UK'),
('3.3', 3, 'Give three examples of factors affecting industrial location.', 'For example, capital, labour, markets');

-- Topic 3.4 - Tourism
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.4', 1, 'When did international tourism reach 1 billion arrivals?', '2012'),
('3.4', 2, 'What is a growth pole in tourism?', 'A particular location where economic development, such as tourism, is focused, setting off wider growth in the surrounding region.'),
('3.4', 3, 'What is economic leakage in tourism?', 'The part of the money a tourist pays for a foreign holiday that does not benefit the destination country because it goes elsewhere.');

-- Topic 3.5 - Energy
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.5', 1, 'What are renewable energy sources?', 'Sources of energy that are not depleted as they are used.'),
('3.5', 2, 'How many people worldwide lack access to electricity?', 'About 2.5 billion people'),
('3.5', 3, 'Name the top five countries for wind power capacity.', 'China, the USA, Germany, India and Spain');

-- Topic 3.6 - Water
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.6', 1, 'How many people lack access to safe drinking water?', 'Over 660 million'),
('3.6', 2, 'What is the process of removing salt from seawater called?', 'Desalination'),
('3.6', 3, 'Define water scarcity.', 'When water supply falls below 1000 cubic metres per person a year, a country faces water scarcity for all or part of the year.');

-- Topic 3.7 - Environmental risks of economic development
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
('3.7', 1, 'What are the main sources of water pollution?', 'Agricultural runoff (fertilisers, pesticides), industrial discharge, sewage and wastewater, oil spills, and thermal pollution from power plants.'),
('3.7', 2, 'What is the global volume of acid deposition?', '450km³ globally'),
('3.7', 3, 'What are the two main approaches to managing pollution?', 'Preventing its occurrence; repairing the damage'),
('3.7', 4, 'Give examples of evidence of global warming.', 'For example, greater global temperature variations, rising sea levels, melting of ice caps and glaciers'),
('3.7', 5, 'What are the main causes of desertification?', 'Deforestation and overgrazing'),
('3.7', 6, 'Define sustainable development.', 'The control of the exploitation and use of resources in relation to environmental and economic costs.');

-- Verify count
SELECT topic_id, COUNT(*) as question_count FROM test_yourself GROUP BY topic_id ORDER BY topic_id;
