-- =====================================================
-- IGCSE Geography Guru - Full Content Migration v3
-- Cambridge IGCSE and O Level Geography Study Guide
-- =====================================================
-- CORRECTED: Uses INTEGER topic_id referencing topics(id)
-- =====================================================

-- =====================================================
-- STEP 1: SEED TOPICS TABLE
-- =====================================================

-- Clear and reseed topics
TRUNCATE TABLE definitions, test_yourself, questions, mcq_options, case_studies RESTART IDENTITY CASCADE;
DELETE FROM topics;

-- Reset sequence
ALTER SEQUENCE topics_id_seq RESTART WITH 1;

-- Insert all topics (19 topics across 4 themes)
INSERT INTO topics (theme_number, theme_name, topic_number, topic_name, textbook_pages) VALUES
-- Theme 1: Population & Settlement
(1, 'Population and Settlement', '1.1', 'Population Dynamics', 'p.6-14'),
(1, 'Population and Settlement', '1.2', 'Migration', 'p.15-19'),
(1, 'Population and Settlement', '1.3', 'Population Structure', 'p.20-23'),
(1, 'Population and Settlement', '1.4', 'Population Density and Distribution', 'p.24-27'),
(1, 'Population and Settlement', '1.5', 'Settlements and Service Provision', 'p.28-33'),
(1, 'Population and Settlement', '1.6', 'Urban Settlements', 'p.34-39'),
(1, 'Population and Settlement', '1.7', 'Urbanisation', 'p.40-44'),
-- Theme 2: Natural Environment
(2, 'The Natural Environment', '2.1', 'Earthquakes and Volcanoes', 'p.45-52'),
(2, 'The Natural Environment', '2.2', 'Rivers', 'p.53-60'),
(2, 'The Natural Environment', '2.3', 'Coasts', 'p.61-66'),
(2, 'The Natural Environment', '2.4', 'Weather', 'p.67-70'),
(2, 'The Natural Environment', '2.5', 'Climate and Natural Vegetation', 'p.71-76'),
-- Theme 3: Economic Development
(3, 'Economic Development', '3.1', 'Development', 'p.77-80'),
(3, 'Economic Development', '3.2', 'Food Production', 'p.81-84'),
(3, 'Economic Development', '3.3', 'Industry', 'p.85-89'),
(3, 'Economic Development', '3.4', 'Tourism', 'p.90-94'),
(3, 'Economic Development', '3.5', 'Energy', 'p.95-102'),
(3, 'Economic Development', '3.6', 'Water', 'p.103-106'),
(3, 'Economic Development', '3.7', 'Environmental Risks of Economic Development', 'p.107-115'),
-- Theme 4: Geographical Skills
(4, 'Geographical Skills and Investigations', '4.1', 'Geographical Skills', 'p.116-126'),
(4, 'Geographical Skills and Investigations', '4.2', 'Geographical Investigations', 'p.127-128');

-- =====================================================
-- STEP 2: DEFINITIONS (Flashcards)
-- Using subqueries to get topic_id from topic_number
-- =====================================================

-- TOPIC 1.1: Population Dynamics
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Population explosion', 'The rapid population growth of the developing world in the post-1950 period.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Birth rate', 'The number of live births per 1000 population in a year.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Death rate', 'The number of deaths per 1000 population in a year.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Rate of natural change', 'The difference between the birth rate and the death rate. If it is positive it is termed natural increase. If it is negative it is known as natural decrease.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Rate of net migration', 'The difference between the rates of immigration and emigration.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Model of demographic transition', 'A model illustrating the historical shift of birth and death rates from high to low levels in a population.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Total fertility rate', 'The average number of children a woman has during her lifetime.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Infant mortality rate', 'The number of deaths of children under one year of age per 1000 live births per year.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Life expectancy at birth', 'The average number of years a newborn infant can expect to live under current mortality levels.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Depopulation', 'A decline in the number of people in a population.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Optimum population', 'The best balance between a population and the resources available to it. This is usually viewed as the population giving the highest average living standards in a country.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Under-population', 'When there are too few people in an area to use the resources available effectively.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Over-population', 'When there are too many people in an area relative to the resources and the level of technology available.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Underemployment', 'A situation where people are working less than they would like to and need to in order to earn a reasonable living.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Population policy', 'Encompasses all of the measures taken by a government aimed at influencing population size, growth, distribution or composition.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Pro-natalist policies', 'Such policies promote larger families.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 'Anti-natalist policies', 'Such policies aim to reduce population growth.');

-- TOPIC 1.2: Migration
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Migration', 'The movement of people across a specified boundary, national or international, to establish a new permanent place of residence.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Push and pull factors', 'Push factors are negative conditions at the point of origin, which encourage or force people to move. In contrast, pull factors are positive conditions at the point of destination, which encourage people to migrate.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Refugees', 'People forced to flee their homes due to human or environmental factors and who cross an international border into another country.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Internally displaced people', 'People forced to flee their homes due to human or environmental factors who remain in the same country.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Rural-to-urban migration', 'The movement of significant numbers of people from the countryside to towns and cities.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 'Remittances', 'Money sent back to their families in their home communities by migrants.');

-- TOPIC 1.3: Population Structure
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.3'), 'Population structure', 'The composition of a population, the most important elements of which are age and sex.'),
((SELECT id FROM topics WHERE topic_number = '1.3'), 'Population pyramid', 'A bar chart arranged vertically, that shows the distribution of a population by age and sex.'),
((SELECT id FROM topics WHERE topic_number = '1.3'), 'Dependency ratio', 'The ratio of the number of people under 15 and over 64 years to those 15–64 years of age.');

-- TOPIC 1.4: Population Density and Distribution
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Population density', 'The average number of people per square kilometre in a country or region.'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Population distribution', 'The way that the population is spread out over a given area, from a small region to the Earth as a whole.'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Densely populated', 'Areas with a high population density.'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 'Sparsely populated', 'Areas with a low population density.');

-- TOPIC 1.5: Settlements and Service Provision
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Dispersed settlement', 'When farms or houses are set among their fields or spread along roads.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Nucleated settlement', 'Houses and buildings are tightly clustered around a central feature.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Linear pattern', 'Settlements are found along a geographical feature such as a river valley or a major transport route.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Site', 'The actual land on which a settlement is built.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Situation', 'The relationship between a settlement and its surrounding area.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Low-order functions', 'Basic functions found in smaller settlements (e.g. hamlets).'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'High-order functions', 'More specialised functions and services found in larger settlements (villages and market towns).'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Range of a good', 'The maximum distance a person is prepared to travel to buy a good.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Threshold population', 'The minimum number of people needed to support a good or service.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 'Sphere of influence', 'The area that a settlement serves.');

-- TOPIC 1.6: Urban Settlements
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Urban land use', 'Activities such as industry, housing and commerce that may be found in towns and cities.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Bid rent', 'When land value and rent decrease as distance from the central business district increases.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Central business district', 'An area of an urban settlement where most of the commercial activity takes place.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Suburbs', 'The outer part of an urban settlement, generally consisting of residential housing and shops of a low order.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Rural-urban fringe', 'The boundary of a town or city, where new building is changing land use from rural to urban.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Urban sprawl', 'Occurs when urban areas continue to grow without any form of planning.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Urban redevelopment', 'Attempts to improve an urban area.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Urban renewal', 'When existing buildings are improved.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 'Gentrification', 'The movement of higher social or economic groups into an area after it has been renovated and restored.');

-- TOPIC 1.7: Urbanisation
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Urbanisation', 'The process by which the proportion of a population living in or around towns and cities increases through migration and natural increase.'),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Millionaire city', 'A city with over 1 million inhabitants.'),
((SELECT id FROM topics WHERE topic_number = '1.7'), 'Megacity', 'A city with over 10 million inhabitants.');

-- TOPIC 2.1: Earthquakes and Volcanoes
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Crater', 'Depression at the top of a volcano following a volcanic eruption. It may contain a lake.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Lava', 'Molten magma that has reached the Earth''s surface. It may be liquid or may have solidified.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Shield volcano', 'Gently sloping volcano produced by very hot, runny lava.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Cone volcano', 'Steeply sloping volcano produced by thick lava.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Ash', 'Very fine-grained volcanic material.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Cinders', 'Small-sized rocks and coarse volcanic materials.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Magma', 'Molten rock within the Earth. When magma reaches the surface it is called lava.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Magma chamber', 'The reservoir of magma located deep inside the volcano.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Pyroclastic flow', 'Superhot (700°C) flows of ash, pumice (volcanic rocks) and steam at speeds of over 500km per hour.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Vent', 'The channel through which volcanic material is ejected.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Dormant', 'Volcanoes which have not erupted for a very long time but could erupt again.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Active', 'A volcano currently showing signs of activity.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Extinct', 'A volcano which has shown no signs of volcanic activity in historic times.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Intensity', 'The power of an earthquake is generally measured using the Richter scale or sometimes the Mercalli scale.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Richter scale', 'An open-ended scale to record magnitude of earthquakes – the higher the number on the scale, the greater the strength of the earthquake.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Mercalli scale', 'Relates ground movement to commonplace observations of, for example, light bulbs, book cases and building damage.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Epicentre', 'The point on the Earth''s surface directly above the focus of an earthquake. The strength of the shock waves generally decrease away from the epicentre.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 'Focus', 'The position within the Earth where an earthquake occurs. Earthquakes may be divided into shallow-focus and deep-focus earthquakes.');

-- TOPIC 2.2: Rivers
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Tributary', 'A stream or river which joins a larger river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Drainage basin', 'The area of land drained by a river system (a river and its tributaries).'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Watershed', 'A ridge or other line of separation between two river systems.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Confluence', 'The point at which two rivers meet.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Interception', 'The precipitation that is collected and stored by vegetation.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Infiltration', 'The movement of water into the soil.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Throughflow', 'The downslope movement of water in the subsoil.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Evaporation', 'The process in which a liquid turns to a vapour.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Overland flow', 'Overland movement of water after a rainfall. It is the fastest way in which water reaches a river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Abrasion (corrasion)', 'The wearing away of the bed and bank by the load carried by a river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Attrition', 'The wearing away of the load carried by a river. It creates smaller, rounder particles.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Hydraulic action', 'The force of air and water on the sides of rivers and in cracks.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Groundwater flow', 'The movement of water from land to river through rock. It is the slowest form of such water movement.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Suspension', 'Small particles are held up by turbulent flow in the river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Saltation', 'Heavier particles are bounced or bumped along the bed of the river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Solution', 'The removal of chemical ions, especially calcium, which cause rocks to dissolve.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 'Traction', 'The heaviest material is dragged or rolled along the bed of the river.');

-- TOPIC 2.3: Coasts
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Abrasion (corrasion)', 'The wearing away of the cliffs by the load carried by the sea.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Hydraulic action', 'The force of air and water when the waves break.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Solution (corrosion)', 'The removal of chemical ions, especially calcium, which cause rocks to dissolve.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Attrition', 'The wearing away of the load carried by the sea.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Fringing reefs', 'Reefs that grow outwards around an island.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Barrier reef', 'A reef that is separated from the coast by a deep channel.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 'Atoll', 'A circular reef enclosing a shallow lagoon.');

-- TOPIC 2.4: Weather
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '2.4'), 'Isohyet', 'A line on a map which joins areas of equal rainfall.');

-- TOPIC 2.5: Climate and Natural Vegetation
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '2.5'), 'Specific heat capacity', 'The amount of heat needed to raise the temperature of a body by 1°C.');

-- TOPIC 3.1: Development
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Development', 'The use of resources to improve the quality of life in a country.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Gross National Product (GNP)', 'The total value of goods and services produced by a country in a year, plus income earned by the country''s residents from foreign investments.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Gross National Product per capita', 'The total GNP of a country divided by the total population.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Development gap', 'The differences in wealth, and other indicators, between the world''s richest and poorest countries.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Human Development Index (HDI)', 'Combines four indicators: life expectancy at birth; mean years of schooling; expected years of schooling; GNI per capita.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Least developed countries (LDCs)', 'The poorest of the developing countries with major economic, institutional and human resource problems.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Newly industrialised countries (NICs)', 'Nations that have undergone rapid and successful industrialisation since the 1960s.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Gini coefficient', 'Technique used to show the extent of income inequality.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Cumulative causation', 'The process whereby economic growth can lead to even more growth as money circulates.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Formal sector', 'That part of an economy known to government departments responsible for taxation.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Informal sector', 'That part of the economy operating outside official recognition.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Product chain', 'The full sequence of activities needed to turn raw materials into a finished product.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Globalisation', 'The increasing interconnectedness and interdependence of the world economically, culturally and politically.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Transnational corporation (TNC)', 'A firm that owns or controls productive operations in more than one country through foreign direct investment.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Diffusion', 'The spread of a phenomenon over time and space.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'Internet', 'A group of protocols by which computers communicate.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 'New international division of labour (NIDL)', 'Divides production into different skills and tasks that are often spread across countries.');

-- TOPIC 3.2: Food Production
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.2'), 'System', 'A practice in which there are recognisable inputs, processes and outputs.'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Irrigation', 'Supplying dry land with water by systems of ditches and also by more advanced means.'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Economies of scale', 'The reduction in unit cost as the scale of an operation increases.'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Agricultural technology', 'The application of techniques to control the growth and harvesting of animal and vegetable products.'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Land tenure', 'The ways in which land is or can be owned.'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 'Green Revolution', 'The introduction of high-yielding seeds and modern agricultural techniques in developing countries.');

-- TOPIC 3.3: Industry
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.3'), 'By-product', 'Something left over from the main production process, which has some value and can be sold.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Waste product', 'All manufacturing industries produce waste product that has no value and must be disposed of.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Footloose industries', 'Industries that are not tied to certain areas because of energy requirements or other factors.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Industrial agglomeration', 'The clustering together of economic activities in close proximity to one another.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Industrial estate', 'An area zoned and planned for the purpose of industrial development.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 'Greenfield locations', 'An area of agricultural land or undeveloped site earmarked for commercial development.');

-- TOPIC 3.4: Tourism
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Tourism', 'Travel away from the home environment for leisure, recreation, holidays, visiting friends/relatives, or business.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Package tour', 'The most popular form of foreign holiday where travel, accommodation and meals are all included.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Growth pole', 'A location where economic development is focused, setting off wider growth in the region.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Economic leakages', 'The part of tourist money that does not benefit the destination country because it goes elsewhere.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Multiplier effect', 'The idea that spending causes money to circulate in the economy, bringing benefits over time.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Sustainable tourism', 'Tourism that can be sustained without creating irreparable environmental, social and economic damage.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Destination footprint', 'The environmental impact caused by an individual tourist.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Ecotourism', 'Tourism where people experience untouched natural environments while ensuring no further damage.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Preservation', 'Maintaining a location exactly as it is and not allowing development.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Conservation', 'Allowing for developments that do not damage the character of a destination.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Community tourism', 'Tourism which aims to include and benefit local communities, particularly in developing countries.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 'Pro-poor tourism', 'Tourism that results in increased net benefits for poor people.');

-- TOPIC 3.5: Energy
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Fossil fuels', 'Fuels consisting of hydrocarbons (coal, oil and natural gas), formed by decomposition of prehistoric organisms.'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Renewable energy', 'Sources of energy such as solar and wind power that are not depleted as they are used.'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Energy mix', 'The relative contribution of different energy sources to a country''s energy consumption.'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Biofuels', 'Fossil fuel substitutes made from crops including oilseeds, wheat and sugar.'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 'Geothermal energy', 'The natural heat found in the Earth''s crust in the form of steam, hot water and hot rock.');

-- TOPIC 3.6: Water
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Water supply', 'The provision of water by public utilities, commercial organisations or community endeavours.'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Dam', 'A barrier that holds back water.'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Reservoir', 'An artificial lake primarily used for storing water.'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Wells and boreholes', 'A means of tapping into aquifers (water-bearing rocks), gaining access to groundwater.'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Potable water', 'Water that is free from impurities, pollution and bacteria, and is thus safe to drink.'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 'Water stress', 'When water supply is below 1700 cubic metres per person per year.');

-- TOPIC 3.7: Environmental Risks
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Pollution', 'Contamination of the environment. It can take many forms – air, water, soil, noise, visual and others.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Prevailing winds', 'The major direction of winds in a region.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Externalities', 'The side effects, positive and negative, of an economic activity that are experienced beyond its site.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Enhanced greenhouse effect', 'Large-scale pollution of the atmosphere by economic activities creating additional warming.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Deforestation', 'The loss of forested lands for agricultural use, timber, mining, and other activities.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Overgrazing', 'The grazing of natural pastures at stocking intensities above the livestock carrying capacity.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Desertification', 'The gradual transformation of habitable land into desert.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Dust storm', 'A severe windstorm that sweeps clouds of dust across an extensive area.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Resource management', 'The control of the exploitation and use of resources in relation to environmental and economic costs.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Sustainable development', 'Resource management ensuring current exploitation does not compromise future generations.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Environmental impact statement', 'A document required by law detailing all environmental impacts of a project.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Conservation of resources', 'Managing natural resources to provide maximum benefit while maintaining future capacity.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Recycling', 'The reprocessing of used materials and their subsequent use in place of new materials.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Reuse', 'Extending the life of a product beyond the norm, or putting it to a new use.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Quotas', 'Agreement between countries to take only a predetermined amount of a resource.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Rationing', 'A last resort management strategy when demand is massively out of proportion to supply.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Subsidies', 'Financial aid supplied by the government to an industry for reasons of public welfare.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Carbon credit', 'A permit that allows an organisation to emit a specified amount of greenhouse gases.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Carbon trading', 'A company can sell unused emission entitlements to another company.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Community energy', 'Energy produced close to the point of consumption.'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 'Microgeneration', 'Generators producing electricity with an output of less than 50KW.');

-- TOPIC 4.1: Geographical Skills
INSERT INTO definitions (topic_id, term, definition) VALUES
((SELECT id FROM topics WHERE topic_number = '4.1'), 'Northings', 'The regular horizontal lines you can see on an Ordnance Survey map.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 'Eastings', 'The regular vertical lines you can see on an Ordnance Survey map.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 'Contour line', 'A line that joins places of equal height.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 'Cross-section', 'A view of the landscape as it would appear if sliced open.');

-- =====================================================
-- STEP 3: TEST YOURSELF Q&A
-- =====================================================

-- TOPIC 1.1: Population Dynamics
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.1'), 1, 'Define rate of natural change.', 'The difference between the birth rate and the death rate.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 2, 'Which world region has the highest birth rate?', 'Africa'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 3, 'When is the world''s population projected to reach 8 billion?', '2023'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 4, 'List the four general factors affecting fertility.', 'Demographic, social/cultural, economic, political'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 5, 'Define life expectancy.', 'The average number of years a newborn infant can expect to live under current mortality levels.'),
((SELECT id FROM topics WHERE topic_number = '1.1'), 6, 'Give two examples of population pressure.', 'Intense competition for land; heavy traffic congestion');

-- TOPIC 1.2: Migration
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.2'), 1, 'What is a refugee?', 'A person forced to flee their home due to human or environmental factors, and who crosses an international border into another country.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 2, 'When did developed countries have their period of high rural-urban migration?', 'In the nineteenth century and the early part of the twentieth century.'),
((SELECT id FROM topics WHERE topic_number = '1.2'), 3, 'What is counterurbanisation?', 'The process of population decentralisation as people move from large urban areas to smaller urban settlements and rural areas.');

-- TOPIC 1.3: Population Structure
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.3'), 1, 'At what stages of demographic transition are Bangladesh, Japan, Niger and the UK?', 'Stage 3, stage 5, stage 2, stage 4'),
((SELECT id FROM topics WHERE topic_number = '1.3'), 2, 'Define dependency ratio.', 'The ratio of the number of people under 15 and over 64 years to those 15-64 years of age (per 100).'),
((SELECT id FROM topics WHERE topic_number = '1.3'), 3, 'What does a dependency ratio of 80 mean?', 'For every 100 people in the economically active population there are 80 people dependent on them.');

-- TOPIC 1.4: Population Density and Distribution
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.4'), 1, 'Define population density.', 'The average number of people per square kilometre in a country or region.'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 2, 'What is the population density of the Canadian Northlands?', 'Less than one person per km²'),
((SELECT id FROM topics WHERE topic_number = '1.4'), 3, 'Name four major cities in the northeast of the USA.', 'For example, Boston, New York, Chicago, Philadelphia');

-- TOPIC 1.5: Settlements and Service Provision
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.5'), 1, 'Distinguish between dispersed and nucleated settlements.', 'A dispersed settlement pattern occurs when farms or houses are set among fields or spread along roads. A nucleated settlement is one in which buildings are tightly clustered around a central feature.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 2, 'Distinguish between the site and situation of a settlement.', 'The site of a settlement is the land on which the settlement is built, whereas the situation or position is the relationship between the settlement and its surrounding area.'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 3, 'State one example of a high-order function and one example of a low-order function.', 'High-order function: department store or bank; low-order function: newsagent'),
((SELECT id FROM topics WHERE topic_number = '1.5'), 4, 'Define the terms threshold population and sphere of influence.', 'The threshold population is the number of people needed to support a good or service. The sphere of influence refers to the area that a settlement serves.');

-- TOPIC 1.6: Urban Settlements
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.6'), 1, 'Distinguish between urban sprawl and urban renewal.', 'Urban sprawl is the unchecked outward spread of built-up areas. Urban renewal refers to the improvement of existing buildings.'),
((SELECT id FROM topics WHERE topic_number = '1.6'), 2, 'Explain the meaning of the term gentrification.', 'The movement of higher social or economic groups into an area after it has been renovated and restored.');

-- TOPIC 1.7: Urbanisation
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '1.7'), 1, 'Define the term urbanisation.', 'The process by which the proportion of a population living in urban areas increases through migration and natural increase.'),
((SELECT id FROM topics WHERE topic_number = '1.7'), 2, 'Distinguish between megacities and millionaire cities.', 'A megacity is a city with over 10 million inhabitants, whereas a millionaire city is a city with over 1 million inhabitants.');

-- TOPIC 2.1: Earthquakes and Volcanoes
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '2.1'), 1, 'State the difference between dormant and extinct volcanoes.', 'A dormant volcano has not erupted for a very long time but could erupt again. An extinct volcano has shown no signs of volcanic activity in historical times.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 2, 'Distinguish between destructive and constructive plate boundaries.', 'At a destructive plate boundary, oceanic crust sinks beneath continental crust and material is destroyed. At a constructive plate boundary, new oceanic crust is formed as plates move apart.'),
((SELECT id FROM topics WHERE topic_number = '2.1'), 3, 'Explain how humans can cause earthquakes.', 'For example, due to the weight of large dams, drilling for oil/fracking and/or nuclear testing.');

-- TOPIC 2.2: Rivers
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '2.2'), 1, 'Compare hydraulic action with abrasion.', 'Hydraulic action is the force of air and water on the sides of rivers and in cracks, whereas abrasion is the wearing away of the bed and bank by the load carried by a river.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 2, 'Outline the difference between saltation and traction.', 'Saltation is the process whereby heavier particles are bounced along the bed, whereas traction is the process whereby the heaviest material is dragged or rolled along the bed.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 3, 'Briefly explain the main causes of floods.', 'Heavy rain, prolonged rain, snow melt, high tides, storm surges, earthquakes and landslides. Human activities can increase flood risk by removing vegetation and making surfaces impermeable.'),
((SELECT id FROM topics WHERE topic_number = '2.2'), 4, 'Briefly explain how flood risk can be managed.', 'Building dams or reservoirs; raising river banks; dredging channels; diverting streams; using sand bags; building houses on stilts; land-use planning; afforestation; insurance; improving forecasting.');

-- TOPIC 2.3: Coasts
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '2.3'), 1, 'Distinguish between destructive and constructive waves.', 'Destructive waves have short wavelength, high height, high frequency (10-12/min), and backwash greater than swash. Constructive waves have long wavelength, low height, low frequency (6-8/min), and swash greater than backwash.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 2, 'Briefly explain how a wave-cut platform is formed.', 'Steep cliffs are eroded between low-water and high-water marks. As they retreat they are replaced by a lengthening platform and lower-angle cliffs.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 3, 'Outline the differences between fringing reefs and atolls.', 'Fringing reefs grow outwards around an island on the edge of a land mass. Atolls are circular reefs enclosing a shallow lagoon.'),
((SELECT id FROM topics WHERE topic_number = '2.3'), 4, 'Distinguish between gabions and sea walls.', 'Gabions are rocks held in wire cages that absorb wave energy. Sea walls are large-scale concrete structures designed to deflect wave energy.');

-- TOPIC 2.4: Weather
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '2.4'), 1, 'Outline the main features of a Stevenson screen.', 'A wooden box on four legs about 120cm high. Slatted sides allow air to enter. Double-boarded roof prevents sun heat entering. Painted white to reflect energy. Placed on grass.'),
((SELECT id FROM topics WHERE topic_number = '2.4'), 2, 'Identify the instrument used to record relative humidity.', 'Wet- and dry-bulb thermometer'),
((SELECT id FROM topics WHERE topic_number = '2.4'), 3, 'Identify the instrument used to record wind speed.', 'Anemometer'),
((SELECT id FROM topics WHERE topic_number = '2.4'), 4, 'Outline the difference between cirrus and cumulonimbus clouds.', 'Cirrus clouds are thin, wispy, high-altitude clouds formed of ice crystals. Cumulonimbus are thick clouds extending from low to high altitude, associated with heavy downpours and thunder.');

-- TOPIC 2.5: Climate and Natural Vegetation
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '2.5'), 1, 'Compare the main climate characteristics of equatorial climates.', 'High annual temperatures (26-27°C); low seasonal ranges (1-2°C); greater diurnal ranges (10-15°C); high rainfall throughout the year (more than 2000mm).'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 2, 'Compare the main climate characteristics of hot desert climates.', 'High daytime temperatures (30-40°C); large temperature difference between day and night (up to 50°C); unreliable and low rainfall (about 250mm/year).'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 3, 'Briefly explain how climate is affected by latitude.', 'Areas near the Equator receive more heat because solar radiation is concentrated. Near the Poles, radiation is dispersed and passes through more atmosphere.'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 4, 'Briefly explain how climate is affected by altitude.', 'Temperature decreases with altitude. On average, it drops about 1°C for every 100 metres.'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 5, 'Briefly describe the vegetation characteristics of tropical rainforests.', 'Evergreen vegetation; layered with varying crown shapes; very diverse (up to 200 species per hectare); buttress roots; trees adapted to light conditions at different levels.'),
((SELECT id FROM topics WHERE topic_number = '2.5'), 6, 'Explain how plants are adapted to hot desert environments.', 'Deep or wide roots; few leaves to reduce transpiration; storing water; seeds that wait for rainfall before growing quickly.');

-- TOPIC 3.1: Development
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.1'), 1, 'List the indicators used in the human development index (HDI).', 'Life expectancy at birth, mean years of schooling for adults aged 25 years, expected years of schooling for children, GNI per capita (PPP$)'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 2, 'How many countries are identified as LDCs?', '48'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 3, 'What is the Gini coefficient?', 'A technique used to show the extent of income inequality.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 4, 'Define the product chain.', 'The full sequence of activities needed to turn raw materials into a finished product.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 5, 'What is a TNC?', 'A firm that owns or controls productive operations in more than one country through foreign direct investment.'),
((SELECT id FROM topics WHERE topic_number = '3.1'), 6, 'State the increase in global internet users between 2000 and 2016.', 'From 361 million in 2000 to 3.4 billion in 2016');

-- TOPIC 3.2: Food Production
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.2'), 1, 'List the three subsections of a system.', 'Inputs, processes, outputs'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 2, 'Define pastoral farming.', 'Livestock farming such as dairy cattle, beef cattle, sheep and pigs'),
((SELECT id FROM topics WHERE topic_number = '3.2'), 3, 'What is land tenure?', 'The way in which land is, or can be, owned.');

-- TOPIC 3.3: Industry
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.3'), 1, 'What are footloose industries?', 'Industries that are not tied to certain areas because of energy requirements or other factors.'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 2, 'Give an example of a science park.', 'For example, Cambridge Science Park in the UK'),
((SELECT id FROM topics WHERE topic_number = '3.3'), 3, 'State three human factors affecting the location of industry.', 'For example, capital, labour, markets');

-- TOPIC 3.4: Tourism
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.4'), 1, 'When did international tourist arrivals first exceed 1 billion?', '2012'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 2, 'What is a growth pole?', 'A particular location where economic development is focused, setting off wider growth in the surrounding region.'),
((SELECT id FROM topics WHERE topic_number = '3.4'), 3, 'Define economic leakages.', 'The part of the money a tourist pays for a foreign holiday that does not benefit the destination country because it goes elsewhere.');

-- TOPIC 3.5: Energy
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.5'), 1, 'What is renewable energy?', 'Sources of energy that are not depleted as they are used.'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 2, 'How many people in developing countries rely on fuelwood as their main source of energy?', 'About 2.5 billion people'),
((SELECT id FROM topics WHERE topic_number = '3.5'), 3, 'Name the leading countries in global wind energy production.', 'China, the USA, Germany, India and Spain');

-- TOPIC 3.6: Water
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.6'), 1, 'How many people do not have access to an improved water source?', 'Over 660 million'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 2, 'What is the process that can change salt water into potable water?', 'Desalination'),
((SELECT id FROM topics WHERE topic_number = '3.6'), 3, 'Define water scarcity.', 'When water supply falls below 1000 cubic metres per person a year, a country faces water scarcity for all or part of the year.');

-- TOPIC 3.7: Environmental Risks
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '3.7'), 1, 'How much wastewater is discharged into water bodies each year?', '450km³ globally'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 2, 'What are the two strategies used to manage acid deposition?', 'Preventing its occurrence; repairing the damage'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 3, 'List three consequences of enhanced global warming.', 'For example, greater global temperature variations, rising sea levels, melting of ice caps and glaciers'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 4, 'What are the two major causes of land degradation?', 'Deforestation and overgrazing'),
((SELECT id FROM topics WHERE topic_number = '3.7'), 5, 'Define resource management.', 'The control of the exploitation and use of resources in relation to environmental and economic costs.');

-- TOPIC 4.1: Geographical Skills
INSERT INTO test_yourself (topic_id, question_number, question, answer) VALUES
((SELECT id FROM topics WHERE topic_number = '4.1'), 1, 'State the difference between northings and eastings.', 'Northings are horizontal lines showing how far north/south. Eastings are vertical lines showing how far east/west.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 2, 'State the difference between a square reference and a grid reference.', 'Square references are four-figure references, whereas grid references are six-figure references.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 3, 'When would you use a square reference rather than a grid reference?', 'Square references are used to show areas, whereas grid references are used to show precise points.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 4, 'Explain what a contour line is.', 'A contour line is a line that joins places of equal height.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 5, 'Distinguish between a convex slope and a concave slope.', 'Concave slope: contours close at top, further apart at bottom. Convex slope: contours close at bottom, flatter near top.'),
((SELECT id FROM topics WHERE topic_number = '4.1'), 6, 'Define the term cross-section.', 'A view of the landscape as it would appear if sliced open. It shows variations in gradient and altitude.');

-- =====================================================
-- VERIFY COUNTS
-- =====================================================
SELECT 'Topics count:' as info, COUNT(*) as count FROM topics;
SELECT 'Definitions count:' as info, COUNT(*) as count FROM definitions;
SELECT 'Test Yourself count:' as info, COUNT(*) as count FROM test_yourself;

-- Show topics with their IDs
SELECT id, topic_number, topic_name FROM topics ORDER BY id;

-- Show counts per topic
SELECT t.topic_number, t.topic_name,
       (SELECT COUNT(*) FROM definitions d WHERE d.topic_id = t.id) as definitions,
       (SELECT COUNT(*) FROM test_yourself ty WHERE ty.topic_id = t.id) as test_yourself
FROM topics t ORDER BY t.id;
