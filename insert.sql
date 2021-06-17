use TRANSPORTATION;

-- begin insert into Regular ticket-- 
 
INSERT INTO matrialdb_Regular_ticket
	SET fk_rtiket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_rroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_renter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_rleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-21'),
        enter_time = time('08:00:00'),
        leave_time = time('10:00:00');

INSERT INTO matrialdb_Regular_ticket
	SET fk_rtiket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_rroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_renter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_rleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-21'),
        enter_time = time('09:00:00'),
        leave_time = time('10:00:00');

INSERT INTO matrialdb_Regular_ticket
	SET fk_rtiket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_rroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_renter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_rleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-21'),
        enter_time = time('07:00:00'),
        leave_time = time('10:00:00');

INSERT INTO matrialdb_Regular_ticket
	SET fk_rtiket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_rroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_renter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_rleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-6-1'),
        enter_time = time('08:00:00'),
        leave_time = time('15:00:00');

INSERT INTO matrialdb_Regular_ticket
	SET fk_rtiket_id = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_rroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_renter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_rleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('07:00:00'),
        leave_time = time('12:00:00');
        
-- END insert into Regular ticket

-- BEGIN insert into Oneday ticket
INSERT INTO matrialdb_Oneday_ticket
	SET fk_otiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
        use_date = date('2021-3-12');

INSERT INTO matrialdb_Oneday_ticket
	SET fk_otiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
        use_date = date('2021-3-12');
        
INSERT INTO matrialdb_Oneday_ticket
	SET fk_otiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-13');
        
INSERT INTO matrialdb_Oneday_ticket
	SET fk_otiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		use_date = date('2021-4-15');

INSERT INTO matrialdb_Oneday_ticket
	SET fk_otiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-12');

-- END insert into oneday ticket

-- BEGIN insert into Monthly_ticket
INSERT INTO matrialdb_Monthly_ticket
	SET fk_mtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_menter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO matrialdb_Monthly_ticket
	SET fk_mtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_menter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO matrialdb_Monthly_ticket
	SET fk_mtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_menter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);


INSERT INTO matrialdb_Monthly_ticket
	SET fk_mtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_menter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

INSERT INTO matrialdb_Monthly_ticket
	SET fk_mtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_menter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1);

-- END insert into monthly ticket

-- BEGIN insert into monthly ticket record
INSERT INTO matrialdb_Monthly_ticket_record
	SET fk_mrtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mrroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_mrenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mrleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-12'),
        enter_time = time('07:00:00'),
        leave_time = time('08:00:00');

INSERT INTO matrialdb_Monthly_ticket_record
	SET fk_mrtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mrroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_mrenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mrleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('07:00:00'),
        leave_time = time('14:00:00');

INSERT INTO matrialdb_Monthly_ticket_record
	SET fk_mrtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mrroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_mrenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mrleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-4-12'),
        enter_time = time('01:00:00'),
        leave_time = time('02:00:00');

INSERT INTO matrialdb_Monthly_ticket_record
	SET fk_mrtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mrroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_mrenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mrleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-3-12'),
        enter_time = time('12:00:00'),
        leave_time = time('18:00:00');

INSERT INTO matrialdb_Monthly_ticket_record
	SET fk_mrtiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_mrroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_mrenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_mrleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        use_date = date('2021-5-12'),
        enter_time = time('18:00:00'),
        leave_time = time('19:00:00');
        
-- END insert into monthly ticket record

-- BEGIN insert into oneday ticket record
INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('18:00:00'),
        leave_time = time('19:00:00');
        
INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('18:00:00'),
        leave_time = time('21:00:00');

INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('05:00:00'),
        leave_time = time('12:00:00');

INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('13:00:00'),
        leave_time = time('17:00:00');
        
INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('06:00:00'),
        leave_time = time('09:00:00');
        
INSERT INTO matrialdb_Oneday_ticket_record
	SET fk_ortiket = ( SELECT ticket_id FROM materialdb_Ticket WHERE type = 0 ORDER BY RAND() LIMIT 1),
		fk_orroute = ( SELECT route_id FROM materialdb_Route ORDER BY RAND() LIMIT 1),
        fk_orenter_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        fk_orleave_id = ( SELECT id FROM materialdb_Stopping_point ORDER BY RAND() LIMIT 1),
        enter_time = time('12:00:00'),
        leave_time = time('13:00:00');
