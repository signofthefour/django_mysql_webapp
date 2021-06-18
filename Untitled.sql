use TRANSPORTATION;

insert into materialdb_Visit(trip_route_id, trip_index, stopping_point_id, 
	visit_index, arrival_time, departure_time)
values
('B008', 1, 'BT00001', 1, '060000', '060100'),
('B008', 1, 'BT00002', 2, '061500', '061600'),
('B008', 1, 'BT00003', 3, '063000', '063100'),
('B008', 1, 'BT00004', 4, '064500', '064600'),
('T008', 1, 'TT00001', 1, '060000', '060300'),
('T008', 1, 'TT00002', 2, '063000', '063300');