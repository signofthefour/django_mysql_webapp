USE TRANSPORTATION;


-- trigger for Monthly_ticket_record --
DROP TRIGGER IF EXISTS before_insert_monthly_ticket_record;
DELIMITER $$
CREATE TRIGGER before_insert_monthly_ticket_record
BEFORE INSERT ON materialdb_Monthly_ticket_record 
FOR EACH ROW
BEGIN
	-- ** TODO:
	-- check for valid stopping points (as registration)
	-- check if that a monthly-ticket
	-- check for valid ticket (not yet expired)

	DECLARE EXPECTED_STOP_1 CHAR(7);
	DECLARE EXPECTED_STOP_2 CHAR(7);
	DECLARE ERROR_MESSAGE VARCHAR(128);
	DECLARE firstUseDate DATETIME;
    
	-- check 2
	SET EXPECTED_STOP_1 := (
		SELECT enter_point_id FROM materialdb_Monthly_ticket bought
		WHERE bought.ticket_id = NEW.ticket_id LIMIT 1);
	
	SET EXPECTED_STOP_2 := (
		SELECT leave_point_id FROM materialdb_Monthly_ticket bought
		WHERE bought.ticket_id = NEW.ticket_id LIMIT 1);

	IF	EXPECTED_STOP_1 IS NULL OR EXPECTED_STOP_1 IS NULL THEN
		SET ERROR_MESSAGE = 'Invalid ticket_id';
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = ERROR_MESSAGE;
	END IF;
	-- check 1
	IF (NEW.enter_point_id NOT IN (EXPECTED_STOP_1, EXPECTED_STOP_2) OR
		NEW.leave_point_id NOT IN (EXPECTED_STOP_1, EXPECTED_STOP_2)) THEN
		SET ERROR_MESSAGE = 'Invalid stopping point';
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = ERROR_MESSAGE;
	END IF;
    
	-- check 3
	SET firstUseDate := (
		SELECT MIN(use_date)
		FROM materialdb_Monthly_ticket_record record
		WHERE 	record.ticket_id = NEW.ticket_id
		GROUP BY use_date
	);
	
	IF (firstUseDate IS NOT NULL AND DATEDIFF(NEW.use_date, firstUseDate) > 30) THEN
		SET ERROR_MESSAGE = 'Expired ticket';
		SIGNAL SQLSTATE '45000'
			SET MESSAGE_TEXT = ERROR_MESSAGE;
	END IF;
END$$

DELIMITER ;

-- test the result
-- INSERT