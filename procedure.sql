USE transportation;

-- begin implementation --

DROP PROCEDURE IF EXISTS ThongKeLuotNguoi;
DELIMITER $$
CREATE PROCEDURE ThongKeLuotNguoi(
	myRoute 	CHAR(4),
    fromDate 	DATE,
    toDate		DATE
)
BEGIN
SELECT SUM(total.count) AS total, total.use_date
FROM
((
	-- by regular ticket
	SELECT count(*) AS count, date(use_date) as use_date
	FROM materialdb_Regular_ticket
	WHERE route_id = myRoute
	AND use_date IS NOT NULL
	GROUP BY use_date
)
UNION ALL
(
	-- by month ticket
	SELECT count(*) AS count, date(use_date) as use_date
	FROM materialdb_Monthly_ticket_record
	WHERE ticket_id IN (
		SELECT distinct ticket_id
		FROM materialdb_Monthly_ticket
		WHERE route_id = myRoute
	)
)
UNION ALL
(
	-- by day ticket
	SELECT COUNT(*) AS count, DATE(use_date) AS use_date
	FROM materialdb_Oneday_ticket_record AS _record
	INNER JOIN materialdb_Oneday_ticket AS _ticket
	ON _record.ticket_id = _ticket.ticket_id 
	WHERE route_id = myRoute AND _ticket.use_date IS NOT NULL
	GROUP BY use_date
)) total
GROUP BY total.use_date;
END$$
DELIMITER ;

-- test the result --

set @myRoute 	= 'T150';
set @fromDate 	= date('2021-04-12');
set @toDate 	= date('2021-04-21');
CALL ThongKeLuotNguoi(@myRoute, @fromDate, @toDate)
