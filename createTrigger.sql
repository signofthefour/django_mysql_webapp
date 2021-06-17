USE TRANSPORTATION;
DELIMITER //

CREATE TRIGGER update_ticket_price
AFTER INSERT
ON materialdb_Ticket 
FOR EACH ROW
BEGIN
    DECLARE UNIT INT;
    DECLARE DAYPRICE INT;
    DECLARE MONTHLYPRICE INT;
    -- Regular ticket
	IF NEW.type LIKE '0' AND NEW.price IS NULL THEN
		SET UNIT := (SELECT bus_unit_price FROM materialdb_Price_list LIMIT 1);
		UPDATE materialdb_Ticket
        SET price = UNIT * ROUND((SELECT COUNT(*) FROM materialdb_Stopping_point) / 2);
    END IF;
    
    -- ONEDAY ticket
    IF NEW.type LIKE '2' AND NEW.price IS NULL THEN
		-- GET price of day if it is weekend or not
		IF DAYOFWEEK(recordTime) = 7 OR DAYOFWEEK(recordTime) = 1 THEN
			SET DAYPRICE = (SELECT weekend_price FROM materialdb_Price_list LIMIT 1);
		ELSE
			SET DAYPRICE = (SELECT week_day_price FROM materialdb_Price_list LIMIT 1);
		END IF;
		UPDATE materialdb_Ticket
        SET price = DAYPRICE;
	END IF;
    -- MONTHLY ticket
	IF NEW.type LIKE '1' AND NEW.price IS NULL THEN
		SET UNIT := (SELECT bus_unit_price FROM materialdb_Price_list LIMIT 1);
        SET MONTHLYPRICE = UNIT * ROUND((SELECT COUNT(*) FROM materialdb_Stopping_point) / 2 ) * 20 * 2;
        IF NEW.job = 'student' THEN
			SET MONTHLYPRICE = ROUND(MONTHLYPRICE / 2);
		ELSE
			IF 
        END IF;
		UPDATE materialdb_Ticket
        SET price = UNIT * ((SELECT COUNT(*) FROM materialdb_Stopping_point) / 2);
    END IF;
    
END //

DELIMITER ;