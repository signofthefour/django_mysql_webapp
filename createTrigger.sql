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
        IF (SELECT * FROM Passenger WHERE passenger_id = NEW.customer_id AND job = 'student')  THEN
			SET MONTHLYPRICE = ROUND(MONTHLYPRICE / 2);
		ELSE
-- 			SELECT * 
--             FROM (SELECT route_id, enter_point_id, leave_point_id
-- 					FROM ((SELECT ticket_id FROM materialdb_Ticket WHERE customer_id = NEW.customer_id) AS T_id
-- 					INNER JOIN materialdb_Monthly_ticket ON T_id.ticket_id = materialdb_Monthly_ticket.ticket_id))
-- 			WHERE route_id = NEW.route_id and enter_point_id = NEW.enter_point....
            
			IF (SELECT ticket_id 
				FROM materialdb_Ticket 
				WHERE customer_id = NEW.customer_id AND DATEDIFF(curdate(), purchase_date) < 30) THEN
				
				SET MONTHLYPRICE = MONTHLYPRICE -  ROUND(MONTHLYPRICE / 10);
			END IF;
        END IF;
        
		UPDATE materialdb_Ticket
        SET price = MONTHLYPRICE;
    END IF;
    
END //

DELIMITER ;