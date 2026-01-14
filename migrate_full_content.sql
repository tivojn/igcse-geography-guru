-- =====================================================
-- IGCSE Geography Guru - Full Content Migration
-- Cambridge IGCSE and O Level Geography Study Guide
-- =====================================================
-- This migration adds all definitions and test_yourself Q&A
-- from the complete Study and Revision Guide
-- =====================================================

-- First, let's ensure the topics table has all topics
-- Theme 1: Population & Settlement (Topics 1.1-1.7)
-- Theme 2: Natural Environment (Topics 2.1-2.5)
-- Theme 3: Economic Development (Topics 3.1-3.7)
-- Theme 4: Geographical Skills (Topics 4.1-4.2)

-- =====================================================
-- TOPICS TABLE - Insert/Update all topics
-- =====================================================

INSERT INTO topics (id, theme, topic_number, title, description) VALUES
-- Theme 1: Population & Settlement
('1.1', 1, '1.1', 'Population Dynamics', 'Population growth, demographic transition, over/under-population, population policies'),
('1.2', 1, '1.2', 'Migration', 'Types of migration, push/pull factors, impacts of migration'),
('1.3', 1, '1.3', 'Population Structure', 'Population pyramids, dependency ratios, age-sex structure'),
('1.4', 1, '1.4', 'Population Density and Distribution', 'Factors affecting population density and distribution'),
('1.5', 1, '1.5', 'Settlements and Service Provision', 'Settlement patterns, hierarchy, site and situation'),
('1.6', 1, '1.6', 'Urban Settlements', 'Urban land use, CBD, suburbs, urban change'),
('1.7', 1, '1.7', 'Urbanisation', 'Rapid urban growth, squatter settlements, urbanisation impacts'),
-- Theme 2: Natural Environment
('2.1', 2, '2.1', 'Earthquakes and Volcanoes', 'Plate tectonics, volcanic and earthquake hazards'),
('2.2', 2, '2.2', 'Rivers', 'River processes, landforms, flooding and management'),
('2.3', 2, '2.3', 'Coasts', 'Coastal processes, landforms, hazards and management'),
('2.4', 2, '2.4', 'Weather', 'Weather instruments, recording and interpreting weather data'),
('2.5', 2, '2.5', 'Climate and Natural Vegetation', 'Equatorial and desert climates, ecosystems, deforestation'),
-- Theme 3: Economic Development
('3.1', 3, '3.1', 'Development', 'Development indicators, inequalities, globalisation, TNCs'),
('3.2', 3, '3.2', 'Food Production', 'Agricultural systems, food shortages, Green Revolution'),
('3.3', 3, '3.3', 'Industry', 'Industrial systems, location factors, high-tech industry'),
('3.4', 3, '3.4', 'Tourism', 'Growth of tourism, benefits and disadvantages, sustainable tourism'),
('3.5', 3, '3.5', 'Energy', 'Fossil fuels, renewable energy, nuclear power'),
('3.6', 3, '3.6', 'Water', 'Water supply methods, water shortages, water management'),
('3.7', 3, '3.7', 'Environmental Risks of Economic Development', 'Pollution, global warming, soil erosion, resource conservation'),
-- Theme 4: Geographical Skills
('4.1', 4, '4.1', 'Geographical Skills', 'Map skills, graphical skills, mathematical skills'),
('4.2', 4, '4.2', 'Geographical Investigations', 'Sampling, questionnaires, fieldwork methods')
ON CONFLICT (id) DO UPDATE SET
  theme = EXCLUDED.theme,
  topic_number = EXCLUDED.topic_number,
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- =====================================================
-- DEFINITIONS TABLE - All flashcard definitions
-- =====================================================

-- Clear existing definitions to avoid duplicates
DELETE FROM definitions;

-- TOPIC 1.1: Population Dynamics
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.1', 'Population explosion', 'The rapid population growth of the developing world in the post-1950 period.'),
('1.1', 'Birth rate', 'The number of live births per 1000 population in a year.'),
('1.1', 'Death rate', 'The number of deaths per 1000 population in a year.'),
('1.1', 'Rate of natural change', 'The difference between the birth rate and the death rate. If it is positive it is termed natural increase. If it is negative it is known as natural decrease.'),
('1.1', 'Rate of net migration', 'The difference between the rates of immigration and emigration.'),
('1.1', 'Model of demographic transition', 'A model illustrating the historical shift of birth and death rates from high to low levels in a population.'),
('1.1', 'Total fertility rate', 'The average number of children a woman has during her lifetime.'),
('1.1', 'Infant mortality rate', 'The number of deaths of children under one year of age per 1000 live births per year.'),
('1.1', 'Life expectancy at birth', 'The average number of years a newborn infant can expect to live under current mortality levels.'),
('1.1', 'Depopulation', 'A decline in the number of people in a population.'),
('1.1', 'Optimum population', 'The best balance between a population and the resources available to it. This is usually viewed as the population giving the highest average living standards in a country.'),
('1.1', 'Under-population', 'When there are too few people in an area to use the resources available effectively.'),
('1.1', 'Over-population', 'When there are too many people in an area relative to the resources and the level of technology available.'),
('1.1', 'Underemployment', 'A situation where people are working less than they would like to and need to in order to earn a reasonable living.'),
('1.1', 'Population policy', 'Encompasses all of the measures taken by a government aimed at influencing population size, growth, distribution or composition.'),
('1.1', 'Pro-natalist policies', 'Such policies promote larger families.'),
('1.1', 'Anti-natalist policies', 'Such policies aim to reduce population growth.');

-- TOPIC 1.2: Migration
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.2', 'Migration', 'The movement of people across a specified boundary, national or international, to establish a new permanent place of residence.'),
('1.2', 'Push and pull factors', 'Push factors are negative conditions at the point of origin, which encourage or force people to move. In contrast, pull factors are positive conditions at the point of destination, which encourage people to migrate.'),
('1.2', 'Refugees', 'People forced to flee their homes due to human or environmental factors and who cross an international border into another country.'),
('1.2', 'Internally displaced people', 'People forced to flee their homes due to human or environmental factors who remain in the same country.'),
('1.2', 'Rural-to-urban migration', 'The movement of significant numbers of people from the countryside to towns and cities.'),
('1.2', 'Remittances', 'Money sent back to their families in their home communities by migrants.');

-- TOPIC 1.3: Population Structure
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.3', 'Population structure', 'The composition of a population, the most important elements of which are age and sex.'),
('1.3', 'Population pyramid', 'A bar chart arranged vertically, that shows the distribution of a population by age and sex.'),
('1.3', 'Dependency ratio', 'The ratio of the number of people under 15 and over 64 years to those 15–64 years of age.');

-- TOPIC 1.4: Population Density and Distribution
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.4', 'Population density', 'The average number of people per square kilometre in a country or region.'),
('1.4', 'Population distribution', 'The way that the population is spread out over a given area, from a small region to the Earth as a whole.'),
('1.4', 'Densely populated', 'Areas with a high population density.'),
('1.4', 'Sparsely populated', 'Areas with a low population density.');

-- TOPIC 1.5: Settlements and Service Provision
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.5', 'Dispersed settlement', 'When farms or houses are set among their fields or spread along roads.'),
('1.5', 'Nucleated settlement', 'Houses and buildings are tightly clustered around a central feature.'),
('1.5', 'Linear pattern', 'Settlements are found along a geographical feature such as a river valley or a major transport route.'),
('1.5', 'Site', 'The actual land on which a settlement is built.'),
('1.5', 'Situation', 'The relationship between a settlement and its surrounding area.'),
('1.5', 'Low-order functions', 'Basic functions found in smaller settlements (e.g. hamlets).'),
('1.5', 'High-order functions', 'More specialised functions and services found in larger settlements (villages and market towns).'),
('1.5', 'Range of a good', 'The maximum distance a person is prepared to travel to buy a good.'),
('1.5', 'Threshold population', 'The minimum number of people needed to support a good or service.'),
('1.5', 'Sphere of influence', 'The area that a settlement serves.');

-- TOPIC 1.6: Urban Settlements
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.6', 'Urban land use', 'Activities such as industry, housing and commerce that may be found in towns and cities.'),
('1.6', 'Bid rent', 'When land value and rent decrease as distance from the central business district increases.'),
('1.6', 'Central business district', 'An area of an urban settlement where most of the commercial activity takes place.'),
('1.6', 'Suburbs', 'The outer part of an urban settlement, generally consisting of residential housing and shops of a low order.'),
('1.6', 'Rural–urban fringe', 'The boundary of a town or city, where new building is changing land use from rural to urban.'),
('1.6', 'Urban sprawl', 'Occurs when urban areas continue to grow without any form of planning.'),
('1.6', 'Urban redevelopment', 'Attempts to improve an urban area.'),
('1.6', 'Urban renewal', 'When existing buildings are improved.'),
('1.6', 'Gentrification', 'The movement of higher social or economic groups into an area after it has been renovated and restored.');

-- TOPIC 1.7: Urbanisation
INSERT INTO definitions (topic_id, term, definition) VALUES
('1.7', 'Urbanisation', 'The process by which the proportion of a population living in or around towns and cities increases through migration and natural increase.'),
('1.7', 'Millionaire city', 'A city with over 1 million inhabitants.'),
('1.7', 'Megacity', 'A city with over 10 million inhabitants.');

-- TOPIC 2.1: Earthquakes and Volcanoes
INSERT INTO definitions (topic_id, term, definition) VALUES
('2.1', 'Crater', 'Depression at the top of a volcano following a volcanic eruption. It may contain a lake.'),
('2.1', 'Lava', 'Molten magma that has reached the Earth''s surface. It may be liquid or may have solidified.'),
('2.1', 'Shield volcano', 'Gently sloping volcano produced by very hot, runny lava.'),
('2.1', 'Cone volcano', 'Steeply sloping volcano produced by thick lava.'),
('2.1', 'Ash', 'Very fine-grained volcanic material.'),
('2.1', 'Cinders', 'Small-sized rocks and coarse volcanic materials.'),
('2.1', 'Magma', 'Molten rock within the Earth. When magma reaches the surface it is called lava.'),
('2.1', 'Magma chamber', 'The reservoir of magma located deep inside the volcano.'),
('2.1', 'Pyroclastic flow', 'Superhot (700°C) flows of ash, pumice (volcanic rocks) and steam at speeds of over 500km per hour.'),
('2.1', 'Vent', 'The channel through which volcanic material is ejected.'),
('2.1', 'Dormant', 'Volcanoes which have not erupted for a very long time but could erupt again.'),
('2.1', 'Active', 'A volcano currently showing signs of activity.'),
('2.1', 'Extinct', 'A volcano which has shown no signs of volcanic activity in historic times.'),
('2.1', 'Intensity', 'The power of an earthquake is generally measured using the Richter scale or sometimes the Mercalli scale.'),
('2.1', 'Richter scale', 'An open-ended scale to record magnitude of earthquakes – the higher the number on the scale, the greater the strength of the earthquake. There are more small earthquakes than large earthquakes.'),
('2.1', 'Mercalli scale', 'Relates ground movement to commonplace observations of, for example, light bulbs, book cases and building damage.'),
('2.1', 'Epicentre', 'The point on the Earth''s surface directly above the focus of an earthquake. The strength of the shock waves generally decrease away from the epicentre.'),
('2.1', 'Focus', 'The position within the Earth where an earthquake occurs. Earthquakes may be divided into shallow-focus and deep-focus earthquakes depending on how far below the Earth''s surface they occur.');

-- TOPIC 2.2: Rivers
INSERT INTO definitions (topic_id, term, definition) VALUES
('2.2', 'Tributary', 'A stream or river which joins a larger river.'),
('2.2', 'Drainage basin', 'The area of land drained by a river system (a river and its tributaries).'),
('2.2', 'Watershed', 'A ridge or other line of separation between two river systems.'),
('2.2', 'Confluence', 'The point at which two rivers meet.'),
('2.2', 'Interception', 'The precipitation that is collected and stored by vegetation.'),
('2.2', 'Infiltration', 'The movement of water into the soil. The rate at which water enters the soil (the infiltration rate) depends on the intensity of rainfall, the permeability of the soil, and the extent to which it is already saturated with water.'),
('2.2', 'Throughflow', 'The downslope movement of water in the subsoil.'),
('2.2', 'Evaporation', 'The process in which a liquid turns to a vapour.'),
('2.2', 'Overland flow', 'Overland movement of water after a rainfall. It is the fastest way in which water reaches a river. The amount of overland runoff increases with heavy and prolonged rainfall, steep gradients, lack of vegetation cover, and saturated or frozen soil.'),
('2.2', 'Abrasion (or corrasion)', 'The wearing away of the bed and bank by the load carried by a river.'),
('2.2', 'Attrition', 'The wearing away of the load carried by a river. It creates smaller, rounder particles.'),
('2.2', 'Hydraulic action', 'The force of air and water on the sides of rivers and in cracks.'),
('2.2', 'Groundwater flow', 'The movement of water from land to river through rock. It is the slowest form of such water movement, and accounts for the constant flow of water in rivers during times of low rainfall.'),
('2.2', 'Suspension', 'Small particles are held up by turbulent flow in the river.'),
('2.2', 'Saltation', 'Heavier particles are bounced or bumped along the bed of the river.'),
('2.2', 'Solution', 'The removal of chemical ions, especially calcium, which cause rocks to dissolve. The chemical load is carried dissolved in the water.'),
('2.2', 'Traction', 'The heaviest material is dragged or rolled along the bed of the river.');

-- TOPIC 2.3: Coasts
INSERT INTO definitions (topic_id, term, definition) VALUES
('2.3', 'Abrasion (or corrasion)', 'The wearing away of the cliffs by the load carried by the sea.'),
('2.3', 'Hydraulic action', 'The force of air and water when the waves break.'),
('2.3', 'Solution (or corrosion)', 'The removal of chemical ions, especially calcium, which cause rocks to dissolve.'),
('2.3', 'Attrition', 'The wearing away of the load carried by the sea.'),
('2.3', 'Fringing reefs', 'Reefs that grow outwards around an island.'),
('2.3', 'Barrier reef', 'A reef that is separated from the coast by a deep channel.'),
('2.3', 'Atoll', 'A circular reef enclosing a shallow lagoon.');

-- TOPIC 2.4: Weather
INSERT INTO definitions (topic_id, term, definition) VALUES
('2.4', 'Isohyet', 'A line on a map which joins areas of equal rainfall.');

-- TOPIC 2.5: Climate and Natural Vegetation
INSERT INTO definitions (topic_id, term, definition) VALUES
('2.5', 'Specific heat capacity', 'The amount of heat needed to raise the temperature of a body by 1°C.');

-- TOPIC 3.1: Development
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.1', 'Development', 'The use of resources to improve the quality of life in a country.'),
('3.1', 'Gross National Product (GNP)', 'The total value of goods and services produced by a country in a year, plus income earned by the country''s residents from foreign investments and minus income earned within the domestic economy by overseas residents.'),
('3.1', 'Gross National Product per capita', 'The total GNP of a country divided by the total population.'),
('3.1', 'Development gap', 'The differences in wealth, and other indicators, between the world''s richest and poorest countries.'),
('3.1', 'Human Development Index (HDI)', 'Combines four indicators of development: life expectancy at birth; mean years of schooling for adults aged 25 years; expected years of schooling for children of school entering age; GNI per capita (PPP$).'),
('3.1', 'Least developed countries (LDCs)', 'The poorest of the developing countries. They have major economic, institutional and human resource problems.'),
('3.1', 'Newly industrialised countries (NICs)', 'Nations that have undergone rapid and successful industrialisation since the 1960s.'),
('3.1', 'Gini coefficient', 'Technique used to show the extent of income inequality.'),
('3.1', 'Cumulative causation', 'The process whereby a significant increase in economic growth can lead to even more growth as more money circulates in the economy.'),
('3.1', 'Formal sector', 'That part of an economy known to the government department responsible for taxation and to other government offices.'),
('3.1', 'Informal sector', 'That part of the economy operating outside official recognition.'),
('3.1', 'Product chain', 'The full sequence of activities needed to turn raw materials into a finished product.'),
('3.1', 'Globalisation', 'The increasing interconnectedness and interdependence of the world economically, culturally and politically.'),
('3.1', 'Transnational corporation (TNC)', 'A firm that owns or controls productive operations in more than one country through foreign direct investment (FDI).'),
('3.1', 'Diffusion', 'The spread of a phenomenon over time and space.'),
('3.1', 'Internet', 'A group of protocols by which computers communicate.'),
('3.1', 'New international division of labour (NIDL)', 'Divides production into different skills and tasks that are often spread across a number of countries.');

-- TOPIC 3.2: Food Production
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.2', 'System', 'A practice in which there are recognisable inputs, processes and outputs.'),
('3.2', 'Irrigation', 'Supplying dry land with water by systems of ditches and also by more advanced means.'),
('3.2', 'Economies of scale', 'The reduction in unit cost as the scale of an operation increases.'),
('3.2', 'Agricultural technology', 'The application of techniques to control the growth and harvesting of animal and vegetable products.'),
('3.2', 'Land tenure', 'The ways in which land is or can be owned.'),
('3.2', 'Green Revolution', 'The introduction of high-yielding seeds and modern agricultural techniques in developing countries.');

-- TOPIC 3.3: Industry
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.3', 'By-product', 'Something that is left over from the main production process, which has some value and therefore can be sold.'),
('3.3', 'Waste product', 'All manufacturing industries produce waste product that has no value and must be disposed of. Costs will be incurred in the disposal of waste product.'),
('3.3', 'Footloose industries', 'Industries that are not tied to certain areas because of energy requirements or other factors.'),
('3.3', 'Industrial agglomeration', 'The clustering together of economic activities in close proximity to one another.'),
('3.3', 'Industrial estate', 'An area zoned and planned for the purpose of industrial development.'),
('3.3', 'Greenfield locations', 'An area of agricultural land or some other undeveloped site earmarked for commercial development or industrial projects.');

-- TOPIC 3.4: Tourism
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.4', 'Tourism', 'Travel away from the home environment: (a) for leisure, recreation and holidays; (b) to visit friends and relations (VFR); (c) for business and professional reasons.'),
('3.4', 'Package tour', 'The most popular form of foreign holiday where travel, accommodation and meals may all be included in the price and booked in advance.'),
('3.4', 'Growth pole', 'A particular location where economic development, in this case tourism, is focused, setting off wider growth in the region as a whole.'),
('3.4', 'Economic leakages', 'The part of the money a tourist pays for a foreign holiday that does not benefit the destination country because it goes elsewhere.'),
('3.4', 'Multiplier effect', 'The idea that an initial amount of spending or investment causes money to circulate in the economy, bringing a series of economic benefits over time.'),
('3.4', 'Sustainable tourism', 'Tourism organised in such a way that its level can be sustained in the future without creating irreparable environmental, social and economic damage to the receiving area.'),
('3.4', 'Destination footprint', 'The environmental impact caused by an individual tourist.'),
('3.4', 'Ecotourism', 'A specialised form of tourism where people experience relatively untouched natural environments, such as coral reefs, tropical forests and remote mountain areas, and ensures that their presence does no further damage to these environments.'),
('3.4', 'Preservation', 'Maintaining a location exactly as it is and not allowing development.'),
('3.4', 'Conservation', 'Allowing for developments that do not damage the character of a destination.'),
('3.4', 'Community tourism', 'A form of tourism which aims to include and benefit local communities, particularly in developing countries.'),
('3.4', 'Pro-poor tourism', 'Tourism that results in increased net benefits for poor people.');

-- TOPIC 3.5: Energy
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.5', 'Fossil fuels', 'Fuels consisting of hydrocarbons (coal, oil and natural gas), formed by the decomposition of prehistoric organisms in past geological periods.'),
('3.5', 'Renewable energy', 'Sources of energy such as solar and wind power that are not depleted as they are used.'),
('3.5', 'Energy mix', 'The relative contribution of different energy sources to a country''s energy consumption.'),
('3.5', 'Biofuels', 'Fossil fuel substitutes that can be made from a range of crops including oilseeds, wheat and sugar. They can be blended with petrol and diesel.'),
('3.5', 'Geothermal energy', 'The natural heat found in the Earth''s crust in the form of steam, hot water and hot rock.');

-- TOPIC 3.6: Water
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.6', 'Water supply', 'The provision of water by public utilities, commercial organisations or by community endeavours.'),
('3.6', 'Dam', 'A barrier that holds back water.'),
('3.6', 'Reservoir', 'An artificial lake primarily used for storing water.'),
('3.6', 'Wells and boreholes', 'A means of tapping into various types of aquifers (water-bearing rocks), gaining access to groundwater.'),
('3.6', 'Potable water', 'Water that is free from impurities, pollution and bacteria, and is thus safe to drink.'),
('3.6', 'Water stress', 'When water supply is below 1700 cubic metres per person per year.');

-- TOPIC 3.7: Environmental Risks of Economic Development
INSERT INTO definitions (topic_id, term, definition) VALUES
('3.7', 'Pollution', 'Contamination of the environment. It can take many forms – air, water, soil, noise, visual and others.'),
('3.7', 'Prevailing winds', 'The major direction of winds in a region.'),
('3.7', 'Externalities', 'The side effects, positive and negative, of an economic activity that are experienced beyond its site.'),
('3.7', 'Enhanced greenhouse effect', 'Large-scale pollution of the atmosphere by economic activities has created an enhanced greenhouse effect.'),
('3.7', 'Deforestation', 'The loss of forested lands for a number of reasons including the clearing of land for agricultural use, for timber, and for other activities such as mining.'),
('3.7', 'Overgrazing', 'The grazing of natural pastures at stocking intensities above the livestock carrying capacity.'),
('3.7', 'Desertification', 'The gradual transformation of habitable land into desert.'),
('3.7', 'Dust storm', 'A severe windstorm that sweeps clouds of dust across an extensive area, especially in an arid region.'),
('3.7', 'Resource management', 'The control of the exploitation and use of resources in relation to environmental and economic costs.'),
('3.7', 'Sustainable development', 'A carefully calculated system of resource management which ensures that the current level of exploitation does not compromise the ability of future generations to meet their own needs.'),
('3.7', 'Environmental impact statement', 'A document required by law detailing all the impacts on the environment of an energy or other project above a certain size.'),
('3.7', 'Conservation of resources', 'The management of the human use of natural resources to provide the maximum benefit to current generations while maintaining capacity to meet the needs of future generations.'),
('3.7', 'Recycling', 'The concentration of used or waste materials, their reprocessing, and their subsequent use in place of new materials.'),
('3.7', 'Reuse', 'Extending the life of a product beyond what was the norm in the past, or putting a product to a new use and extending its life in this way.'),
('3.7', 'Quotas', 'Involving agreement between countries to take only a predetermined amount of a resource.'),
('3.7', 'Rationing', 'A last resort management strategy when demand is massively out of proportion to supply. For example, individuals might only be allowed a very small amount of fuel and food per week.'),
('3.7', 'Subsidies', 'Financial aid supplied by the government to an industry for reasons of public welfare.'),
('3.7', 'Carbon credit', 'A permit that allows an organisation to emit a specified amount of greenhouse gases.'),
('3.7', 'Carbon trading', 'A company that does not use up the level of emissions it is entitled to can sell the remainder of its entitlement to another company.'),
('3.7', 'Community energy', 'Energy produced close to the point of consumption.'),
('3.7', 'Microgeneration', 'Generators producing electricity with an output of less than 50KW.');

-- TOPIC 4.1: Geographical Skills
INSERT INTO definitions (topic_id, term, definition) VALUES
('4.1', 'Northings', 'The regular horizontal lines you can see on an Ordnance Survey map.'),
('4.1', 'Eastings', 'The regular vertical lines you can see on an Ordnance Survey map.'),
('4.1', 'Contour line', 'A line that joins places of equal height.'),
('4.1', 'Cross-section', 'A view of the landscape as it would appear if sliced open, or if you were to walk along it.');

-- =====================================================
-- TEST_YOURSELF TABLE - All Q&A from the Study Guide
-- =====================================================

-- Clear existing test_yourself entries to avoid duplicates
DELETE FROM test_yourself;

-- TOPIC 1.1: Population Dynamics - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.1', 'Define rate of natural change.', 'The difference between the birth rate and the death rate.', 'p.125'),
('1.1', 'Which world region has the highest birth rate?', 'Africa', 'p.125'),
('1.1', 'When is the world''s population projected to reach 8 billion?', '2023', 'p.125'),
('1.1', 'List the four general factors affecting fertility.', 'Demographic, social/cultural, economic, political', 'p.125'),
('1.1', 'Define life expectancy.', 'The average number of years a newborn infant can expect to live under current mortality levels.', 'p.125'),
('1.1', 'Give two examples of population pressure.', 'Intense competition for land; heavy traffic congestion', 'p.125');

-- TOPIC 1.2: Migration - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.2', 'What is a refugee?', 'A person forced to flee their home due to human or environmental factors, and who crosses an international border into another country.', 'p.125'),
('1.2', 'When did developed countries have their period of high rural–urban migration?', 'In the nineteenth century and the early part of the twentieth century.', 'p.125'),
('1.2', 'What is counterurbanisation?', 'The process of population decentralisation as people move from large urban areas to smaller urban settlements and rural areas.', 'p.125');

-- TOPIC 1.3: Population Structure - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.3', 'At what stages of demographic transition are Bangladesh, Japan, Niger and the UK?', 'Stage 3, stage 5, stage 2, stage 4', 'p.125'),
('1.3', 'Define dependency ratio.', 'The ratio of the number of people under 15 and over 64 years to those 15–64 years of age (per 100).', 'p.125'),
('1.3', 'What does a dependency ratio of 80 mean?', 'For every 100 people in the economically active population there are 80 people dependent on them.', 'p.125');

-- TOPIC 1.4: Population Density and Distribution - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.4', 'Define population density.', 'The average number of people per square kilometre in a country or region.', 'p.125'),
('1.4', 'What is the population density of the Canadian Northlands?', 'Less than one person per km²', 'p.125'),
('1.4', 'Name four major cities in the northeast of the USA.', 'For example, Boston, New York, Chicago, Philadelphia', 'p.125');

-- TOPIC 1.5: Settlements and Service Provision - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.5', 'Distinguish between dispersed and nucleated settlements.', 'A dispersed settlement pattern occurs when farms or houses are set among fields or spread along roads. A nucleated settlement is one in which buildings are tightly clustered around a central feature.', 'p.125'),
('1.5', 'Distinguish between the site and situation of a settlement.', 'The site of a settlement is the land on which the settlement is built, whereas the situation or position is the relationship between the settlement and its surrounding area.', 'p.125'),
('1.5', 'State one example of a high-order function and one example of a low-order function.', 'High-order function – department store or bank; low-order function – newsagent', 'p.125'),
('1.5', 'Define the terms threshold population and sphere of influence.', 'The threshold population is the number of people needed to support a good or service. The sphere of influence refers to the area that a settlement serves.', 'p.125');

-- TOPIC 1.6: Urban Settlements - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.6', 'Distinguish between urban sprawl and urban renewal.', 'Urban sprawl is the unchecked outward spread of built-up areas, caused by their expansion. Urban renewal refers to the improvement of existing buildings.', 'p.125'),
('1.6', 'Explain the meaning of the term gentrification.', 'Gentrification refers to the movement of higher social or economic groups into an area after it has been renovated and restored.', 'p.125');

-- TOPIC 1.7: Urbanisation - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('1.7', 'Define the term urbanisation.', 'Urbanisation is the process by which the proportion of a population living in urban areas increases through migration and natural increase.', 'p.125'),
('1.7', 'Distinguish between megacities and millionaire cities.', 'A megacity is a city with over of 10 million inhabitants, whereas a millionaire city is a city with over 1 million inhabitants.', 'p.125');

-- TOPIC 2.1: Earthquakes and Volcanoes - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('2.1', 'State the difference between dormant and extinct volcanoes.', 'A dormant volcano is a volcano that has not erupted for a very long time but could erupt again. In contrast, an extinct volcano is a volcano that has shown no signs of volcanic activity in historical times.', 'p.125'),
('2.1', 'Distinguish between destructive and constructive plate boundaries.', 'A destructive plate boundary is one where oceanic crust moves towards the continental crust and sinks beneath it, due to its higher density. Material is destroyed at a destructive plate boundary. In contrast, at a constructive plate boundary, new oceanic crust is formed as the two plates move apart.', 'p.125'),
('2.1', 'Explain how humans can cause earthquakes.', 'For example, due to the weight of large dams, drilling for oil/fracking and/or nuclear testing.', 'p.125');

-- TOPIC 2.2: Rivers - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('2.2', 'Compare hydraulic action with abrasion.', 'Hydraulic action is the force of air and water on the sides of rivers and in cracks, whereas abrasion is the wearing away of the bed and bank by the load carried by a river.', 'p.125-126'),
('2.2', 'Outline the difference between saltation and traction.', 'Saltation is the process whereby heavier particles are bounced or bumped along the bed of the river, whereas traction is the process whereby the heaviest material is dragged or rolled along the bed of the river.', 'p.125-126'),
('2.2', 'Briefly explain the main causes of floods.', 'The main causes of floods are heavy rain, prolonged rain, snow melt, high tides, storm surges, earthquakes and landslides causing temporary lakes. Human activities can increase the flood risk by removing vegetation, making the surface impermeable and living in areas at risk of flooding.', 'p.125-126'),
('2.2', 'Briefly explain how flood risk can be managed.', 'The risk of flooding can be reduced by: building dams or reservoirs to hold back excess water; raising the banks of rivers; dredging the river channel so that it can hold more water; diverting streams and creating new flood relief channels; using sand bags to prevent water getting into houses; building houses on stilts so that water can pass underneath; land-use planning, i.e. build only on land that is free from flooding; afforestation (planting forests) to increase interception and reduce overland flow; having insurance cover for vulnerable areas and communities; improving forecasting and warning systems.', 'p.125-126');

-- TOPIC 2.3: Coasts - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('2.3', 'Distinguish between destructive and constructive waves.', 'Destructive waves are erosional waves with a short wavelength and high height. They have a high frequency (10–12 per minute), and their backwash is greater than their swash. In contrast, constructive waves have a long wavelength and low height. They have a low frequency (6–8 per minute) and their swash is greater than backwash.', 'p.126'),
('2.3', 'Briefly explain how a wave-cut platform is formed.', 'Steep cliffs are eroded between the low-water mark and the high-water mark. As they retreat they are replaced by a lengthening platform and lower-angle cliffs, subject to weathering and mass movements rather than marine forces.', 'p.126'),
('2.3', 'Outline the differences between fringing reefs and atolls.', 'Fringing reefs are those that grow outwards around an island, and are located on the edge of a land mass, whilst atolls are circular reefs enclosing a shallow lagoon.', 'p.126'),
('2.3', 'Distinguish between gabions and sea walls.', 'Gabions are rocks held in wire cages and absorb wave energy, whereas sea walls are large-scale concrete structures designed to deflect wave energy.', 'p.126');

-- TOPIC 2.4: Weather - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('2.4', 'Outline the main features of a Stevenson screen.', 'A Stevenson screen is a wooden box standing on four legs of height about 120cm. The screen is raised so that air temperature can be measured. The sides of the box are slatted to allow air to enter freely. The roof is usually made of double boarding to prevent the Sun''s heat from reaching the inside of the screen. Insulation is further improved by painting the outside of the screen white to reflect much of the Sun''s energy. The screen is usually placed on a grass-covered surface, thereby reducing the radiation of heat from the ground.', 'p.126'),
('2.4', 'Identify the instrument used to record relative humidity.', 'Wet- and dry-bulb thermometer', 'p.126'),
('2.4', 'Identify the instrument used to record wind speed.', 'Anemometer', 'p.126'),
('2.4', 'Outline the difference between a cirrus cloud and a cumulonimbus cloud.', 'Cirrus clouds are thin, wispy, high-altitude clouds, formed of ice crystals. Cumulonimbus are thick clouds extending from low altitude to high altitude, and are associated with heavy downpours and sometimes thunder and lightning.', 'p.126');

-- TOPIC 2.5: Climate and Natural Vegetation - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('2.5', 'Compare the main climate characteristics of equatorial climates.', 'Equatorial areas have: high annual temperatures year round (26–27°C); low seasonal ranges (1–2°C), but greater diurnal (daily) ranges (10–15°C); high rainfall throughout the year (more than 2000mm).', 'p.126'),
('2.5', 'Compare the main climate characteristics of hot desert climates.', 'Hot deserts have: high daytime temperatures (30–40°C) throughout the year; a large temperature difference, often as much as 50°C between day and night; unreliable and low rainfall (about 250mm year).', 'p.126'),
('2.5', 'Briefly explain how climate is affected by latitude.', 'Areas that are close to the Equator receive more heat than areas that are close to the Poles because incoming solar radiation is concentrated near the Equator, but dispersed near the Poles. In addition, insolation near the Poles has to pass through a greater amount of atmosphere and there is more chance of it being reflected back out to space.', 'p.126'),
('2.5', 'Briefly explain how climate is affected by altitude.', 'Temperature decreases with altitude. On average, it drops about 1°C for every 100 metres.', 'p.126'),
('2.5', 'Briefly describe the vegetation characteristics of tropical rainforests.', 'Vegetation in the rainforest is evergreen. Photosynthesis and growing can happen all year. The vegetation is layered, and the shape of the crowns varies with the layer, in order to receive maximum light. It is very diverse — there are up to 200 species of tree per hectare. Trees at the top of the canopy are adapted to being in the light; those near the ground are adapted to being in the shade. The trees have buttress roots to help stabilise them.', 'p.126'),
('2.5', 'Explain how plants are adapted to hot desert environments.', 'Plants adapt to deserts by: growing deep roots or wide roots; producing only a few leaves, to reduce transpiration (moisture loss); storing water; and producing seeds that wait for rainfall before growing and completing a very quick life cycle.', 'p.126');

-- TOPIC 3.1: Development - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.1', 'List the indicators used in the human development index (HDI).', 'Life expectancy at birth, mean years of schooling for adults aged 25 years, expected years of schooling for children of school entering age, GNI per capita (PPP$)', 'p.126'),
('3.1', 'How many countries are identified as LDCs?', '48', 'p.126'),
('3.1', 'What is the Gini coefficient?', 'A technique used to show the extent of income inequality.', 'p.126'),
('3.1', 'Define the product chain.', 'The full sequence of activities needed to turn raw materials into a finished product.', 'p.126'),
('3.1', 'What is a TNC?', 'A firm that owns or controls productive operations in more than one country through foreign direct investment.', 'p.126'),
('3.1', 'State the increase in the number of global internet users between 2000 and 2016.', 'From 361 million in 2000 to 3.4 billion in 2016', 'p.126');

-- TOPIC 3.2: Food Production - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.2', 'List the three subsections of a system.', 'Inputs, processes, outputs', 'p.126'),
('3.2', 'Define pastoral farming.', 'Livestock farming such as dairy cattle, beef cattle, sheep and pigs', 'p.126'),
('3.2', 'What is land tenure?', 'The way in which land is, or can be, owned.', 'p.126');

-- TOPIC 3.3: Industry - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.3', 'What are footloose industries?', 'Industries that are not tied to certain areas because of energy requirements or other factors.', 'p.126'),
('3.3', 'Give an example of a science park.', 'For example, Cambridge Science Park in the UK', 'p.126'),
('3.3', 'State three human factors affecting the location of industry.', 'For example, capital, labour, markets', 'p.126');

-- TOPIC 3.4: Tourism - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.4', 'When did the number of international tourist arrivals first exceed 1 billion?', '2012', 'p.126'),
('3.4', 'What is a growth pole?', 'A particular location where economic development, such as tourism, is focused, setting off wider growth in the surrounding region.', 'p.126'),
('3.4', 'Define economic leakages.', 'The part of the money a tourist pays for a foreign holiday that does not benefit the destination country because it goes elsewhere.', 'p.126');

-- TOPIC 3.5: Energy - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.5', 'What is renewable energy?', 'Sources of energy that are not depleted as they are used.', 'p.127'),
('3.5', 'How many people in developing countries rely on fuelwood as their main source of energy?', 'About 2.5 billion people', 'p.127'),
('3.5', 'Name the leading countries in global wind energy production.', 'China, the USA, Germany, India and Spain', 'p.127');

-- TOPIC 3.6: Water - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.6', 'How many people do not have access to an improved water source?', 'Over 660 million', 'p.127'),
('3.6', 'What is the process that can change salt water into potable water?', 'Desalination', 'p.127'),
('3.6', 'Define water scarcity.', 'When water supply falls below 1000 cubic metres per person a year, a country faces water scarcity for all or part of the year.', 'p.127');

-- TOPIC 3.7: Environmental Risks - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('3.7', 'How much wastewater is discharged into water bodies each year?', '450km³ globally', 'p.127'),
('3.7', 'What are the two strategies used to manage acid deposition?', 'Preventing its occurrence; repairing the damage', 'p.127'),
('3.7', 'List three consequences of enhanced global warming.', 'For example, greater global temperature variations, rising sea levels, melting of ice caps and glaciers', 'p.127'),
('3.7', 'What are the two major causes of land degradation?', 'Deforestation and overgrazing', 'p.127'),
('3.7', 'Define resource management.', 'The control of the exploitation and use of resources in relation to environmental and economic costs.', 'p.127');

-- TOPIC 4.1: Geographical Skills - Test Yourself
INSERT INTO test_yourself (topic_id, question, answer, page_reference) VALUES
('4.1', 'State the difference between northings and eastings.', 'Northings are the horizontal lines on a map. They show how far north (or south) a place is. Eastings are the vertical lines on a map. They show how far east (or west) a place is.', 'p.127'),
('4.1', 'State the difference between a square reference and a grid reference.', 'Square references are four-figure references, whereas grid references are six-figure references.', 'p.127'),
('4.1', 'When would you use a square reference rather than a grid reference?', 'Square references are used to show areas, whereas grid references are used to show precise points.', 'p.127'),
('4.1', 'Explain what a contour line is.', 'A contour line is a line that joins places of equal height.', 'p.127'),
('4.1', 'Distinguish between a convex slope and a concave slope.', 'When contour lines are close together at the top, and then get further apart nearer the bottom, it is a concave slope. In contrast, when contour lines are close at the bottom and flatter near the top, it is a convex slope.', 'p.127'),
('4.1', 'Define the term cross-section.', 'A view of the landscape as it would appear if sliced open, or a side-on view of the path followed if you were to walk along it. It shows variations in gradient and altitude.', 'p.127');

-- =====================================================
-- COMPLETION MESSAGE
-- =====================================================
-- Migration complete!
-- Total definitions: ~120 terms across 19 topics
-- Total test_yourself Q&A: ~60 questions across 19 topics
-- =====================================================
