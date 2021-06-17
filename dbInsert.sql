-- use testing;
use transportation;
show tables;

call ClearAll();

-- // 1.intersection ---------------------- 
insert into materialdb_intersection(`long`, lat)
values
(19, 60),
(19, 80),
(19, 89),
(19, 88),
(19, 90),
(19, 90.9),
(19, 93),
(20, 00),
(20, 10),
(20, 11),
(20, 07);
select * from materialdb_intersection;

-- // 3.street ---------------------- 
insert into materialdb_Street (name)
values
('1 to 11 | Email to anti-phishing'),
('4 to 3| Released for Mac to NSFNET'),
('6 to 7 | HTML email to AOL and Delphi'),
('8 to 10 | 2000s to Facebook Messaging system');
select * from materialdb_Street;

-- // 2. distance
insert into materialdb_distance (first_int_id, second_int_id, street_id, dist_index, length) 
values
('GL1', 'GL2', 'CD1', 1, 20.0),
('GL2', 'GL5', 'CD1', 2, 10.0),
('GL5', 'GL8', 'CD1', 3, 10.0),
('GL8', 'GL11', 'CD1', 4, 7.0),
('GL3', 'GL2', 'CD2', 1, 9.0),
('GL2', 'GL4', 'CD2', 2, 8.0),
('GL6', 'GL5', 'CD3', 1, 0.9),
('GL5', 'GL7', 'CD3', 2, 3),
('GL8', 'GL9', 'CD4', 1, 1.0),
('GL9', 'GL10', 'CD4', 2, 1.0);
select * from materialdb_Distance;

-- // 4. route
insert into materialdb_Route (route_id)
values 
('B008'), ('B050'), ('T008'), ('T050'),
('B108'), ('B150'), ('T108'), ('T150'); 
select * from materialdb_Route;

-- // 5. bus route
insert into materialdb_Bus_route(route_id)
values ('B008'), ('B108'), ('B050'), ('B150');
select * from materialdb_bus_route;

-- // 6. train_route
insert into materialdb_Train_route(route_id, train_route_id, unit_price, `name`)
values 
('T008', 'A', 7000, 'Petro A008'),
('T108', 'B', 7000, 'Petro B108'), 
('T050', 'X', 7000, 'Petro X005'), 
('T150', 'Z', 7000, 'Petro Z105');
select * from materialdb_train_route;

-- // 7. trip
insert into materialdb_Trip (route_id, trip_index)
values 
('B008', 1), ('B008', 2),
('B050', 1), ('B050', 2), ('B050', 3),
('T008', 1),
('T050', 1), ('T050', 2);
select * from materialdb_Trip;

