-- use testing;
use transportation;
show tables;

-- // Clear all tables
drop procedure if exists ClearAll;
delimiter $$
create procedure ClearAll()
begin
	set sql_safe_updates = 0;
    set foreign_key_checks = 0;
		delete from materialdb_Route;
		delete from materialdb_Distance;
		delete from materialdb_Intersection;
		delete from materialdb_Street;
        delete from materialdb_Stopping_point;
        delete from materialdb_Ticket;
        delete from materialdb_Bus_route;
        delete from materialdb_Train_route;
        delete from materialdb_Trip;
        delete from materialdb_Visit;
        delete from materialdb_Regular_ticket;
        delete from materialdb_Monthly_ticket;
        delete from materialdb_Oneday_ticket;
        delete from materialdb_Monthly_ticket_record;
        delete from materialdb_Oneday_ticket_record;
        
		set foreign_key_checks = 1;
	set sql_safe_updates = 1;

	truncate table seq_street;
	truncate table seq_intersection;
end$$
delimiter ;

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

-- // 8. stopping point
insert into materialdb_stopping_point (id, type, first_int_id, second_int_id, `name`, address)
values
('BT00001', 0, 'GL1', 'GL2', 'stop no 1970', 'at 1970'),
('BT00002', 0, 'GL2', 'GL5', 'stop no 1980s', 'at 1980s'),
('BT00003', 0, 'GL5', 'GL8', 'stop no 1990s', 'at 1990s'),
('BT00004', 0, 'GL8', 'GL11', 'stop no 2000s', 'at 2000s'),
('TT00001', 1, 'GL3', 'GL2', 'stop no 1989', 'at 1989'),
('TT00002', 1, 'GL2', 'GL4', 'stop no 1988', 'at 1988');

-- // 9. visits
insert into materialdb_Visit(trip_route_id, trip_index, stopping_point_id, 
	visit_index, arrival_time, departure_time)
values
('B008', 1, 'BT00001', 1, '060000', '060100'),
('B008', 1, 'BT00002', 1, '061500', '061600'),
('B008', 1, 'BT00003', 1, '063000', '063100'),
('B008', 1, 'BT00004', 1, '064500', '064600'),
('T008', 1, 'TT00001', 1, '060000', '060300'),
('T008', 1, 'TT00002', 1, '063000', '063300');

-- // 10. ticket
insert into materialdb_Ticket(ticket_id, `type`, price, purchase_date, customer_id)
values
('VO3101202100001', '0', 7.0, current_timestamp(), NULL),
('VO3101202100002', '0', 7.0, current_timestamp(), NULL),
('VO3101202100003', '0', NULL, current_timestamp(), NULL),
('VO3101202100004', '0', 7.0, current_timestamp(), NULL),
('VO3101202100005', '0', 7.0, current_timestamp(), NULL),
('VD3101202100001', '2', NULL, current_timestamp(), NULL),
('VD3101202100002', '2', NULL, current_timestamp(), NULL),
('VD3101202100003', '2', NULL, current_timestamp(), NULL),
('VD3101202100004', '2', NULL, current_timestamp(), NULL),
('VD3101202100005', '2', NULL, current_timestamp(), NULL),
('VM3101202100001', '1', NULL, current_timestamp(), NULL),
('VM3101202100002', '1', NULL, current_timestamp(), NULL),
('VM3101202100003', '1', NULL, current_timestamp(), NULL),
('VM3101202100004', '1', NULL, current_timestamp(), NULL),
('VM3101202100005', '1', NULL, current_timestamp(), NULL);
select * from materialdb_Ticket;

-- begin insert into Regular ticket-- 
 
INSERT INTO materialdb_Regular_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE materialdb_Ticket.type = '0' ORDER BY ticket_id LIMIT 0,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-21'),
        enter_time = time('08:00:00'),
        leave_time = time('10:00:00');

INSERT INTO materialdb_Regular_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE materialdb_Ticket.type = '0' ORDER BY ticket_id LIMIT 1,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-21'),
        enter_time = time('09:00:00'),
        leave_time = time('10:00:00');

INSERT INTO materialdb_Regular_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE materialdb_Ticket.type = '0' ORDER BY ticket_id LIMIT 2,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-21'),
        enter_time = time('07:00:00'),
        leave_time = time('10:00:00');

INSERT INTO materialdb_Regular_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE materialdb_Ticket.type = '0' ORDER BY ticket_id LIMIT 3,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-6-1'),
        enter_time = time('08:00:00'),
        leave_time = time('15:00:00');

INSERT INTO materialdb_Regular_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE materialdb_Ticket.type = '0' ORDER BY ticket_id LIMIT 4,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('07:00:00'),
        leave_time = time('12:00:00');
        
-- END insert into Regular ticket

-- BEGIN insert into Oneday ticket
INSERT INTO materialdb_Oneday_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '2' ORDER BY ticket_id LIMIT 0,1),
        use_date = date('2021-3-12');

INSERT INTO materialdb_Oneday_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '2' ORDER BY ticket_id LIMIT 1,1),
        use_date = date('2021-3-12');
        
INSERT INTO materialdb_Oneday_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '2' ORDER BY ticket_id LIMIT 2,1),
        use_date = date('2021-4-13');
        
INSERT INTO materialdb_Oneday_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '2' ORDER BY ticket_id LIMIT 3,1),
		use_date = date('2021-4-15');

INSERT INTO materialdb_Oneday_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '2' ORDER BY ticket_id LIMIT 4,1),
        use_date = date('2021-5-12');

-- END insert into oneday ticket

-- BEGIN insert into Monthly_ticket
INSERT INTO materialdb_Monthly_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '1' ORDER BY ticket_id LIMIT 0,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO materialdb_Monthly_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '1' ORDER BY ticket_id LIMIT 1,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO materialdb_Monthly_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '1' ORDER BY ticket_id LIMIT 2,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);


INSERT INTO materialdb_Monthly_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '1' ORDER BY ticket_id LIMIT 3,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO materialdb_Monthly_ticket
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = '1' ORDER BY ticket_id LIMIT 4,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

-- END insert into monthly ticket

-- BEGIN insert into monthly ticket record
INSERT INTO materialdb_Monthly_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Monthly_ticket ORDER BY ticket_id LIMIT 0,1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-12'),
        enter_time = time('07:00:00'),
        leave_time = time('08:00:00');

INSERT INTO materialdb_Monthly_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Monthly_ticket ORDER BY ticket_id LIMIT 1,1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('07:00:00'),
        leave_time = time('14:00:00');

INSERT INTO materialdb_Monthly_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Monthly_ticket ORDER BY ticket_id LIMIT 1,1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('01:00:00'),
        leave_time = time('02:00:00');

INSERT INTO materialdb_Monthly_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Monthly_ticket ORDER BY ticket_id LIMIT 2,1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-3-12'),
        enter_time = time('12:00:00'),
        leave_time = time('18:00:00');

INSERT INTO materialdb_Monthly_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Monthly_ticket ORDER BY ticket_id LIMIT 2,1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-12'),
        enter_time = time('18:00:00'),
        leave_time = time('19:00:00');
        
-- END insert into monthly ticket record

-- BEGIN insert into oneday ticket record
INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 0,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('18:00:00'),
        leave_time = time('19:00:00');
        
INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 0,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('18:00:00'),
        leave_time = time('21:00:00');

INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 3,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('05:00:00'),
        leave_time = time('12:00:00');

INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 3,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('13:00:00'),
        leave_time = time('17:00:00');
        
INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 4,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('06:00:00'),
        leave_time = time('09:00:00');
        
INSERT INTO materialdb_Oneday_ticket_record
	SET ticket_id = ( SELECT ticket_id FROM materialdb_Oneday_ticket ORDER BY ticket_id LIMIT 4,1),
		route_id = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        enter_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        leave_point_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('12:00:00'),
        leave_time = time('13:00:00');