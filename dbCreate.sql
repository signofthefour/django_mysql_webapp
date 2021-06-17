DROP DATABASE IF EXISTS `TRANSPORTATION`;
CREATE DATABASE `TRANSPORTATION`;
USE `TRANSPORTATION`;

SET NAMES utf8;
SET character_set_client = utf8mb4;


-- // Giao lo (GL+auto_increment)--------------------------------
CREATE TABLE  materialdb_Intersection (
	id		varchar(7),
    -- `id` 	INT NOT NULL AUTO_INCREMENT, -- GL prefix
    `long` 	FLOAT,
    `lat` 	FLOAT,
    PRIMARY KEY (`id`)
);

create table seq_Intersection (
	id		int primary key AUTO_INCREMENT
);

delimiter $$
create trigger before_intersection_insert
before insert on materialdb_intersection
for each row
begin 
	insert into seq_Intersection values (NULL);
	set new.id = concat('GL', last_insert_id());
end$$
delimiter ;

-- // Con duong (CD + auto_increment) --------------------
CREATE TABLE materialdb_Street (
	id		varchar(7),
    -- `id` INT NOT NULL AUTO_INCREMENT, -- CD prefix
    `name` 	VARCHAR(50),
    PRIMARY KEY (`id`)
);

create table seq_Street (
	id		int primary key auto_increment
);

delimiter $$
create trigger before_street_insert
before insert on materialdb_street
for each row
begin 
	insert into seq_Street values (NULL);
	set new.id = concat('CD', last_insert_id());
end$$
delimiter ;

-- // Doan duong -------------------------
CREATE TABLE materialdb_Distance (
    `first_int_id` 	varchar(7) not null,
    `second_int_id` varchar(7) not null,
	`street_id` 	varchar(7),
    -- `first_int_id` INT NOT NULL,
    -- `second_int_id` INT NOT NULL,
	-- `street_id` INT,
	`length` FLOAT,
    `dist_index` INT,
    PRIMARY KEY (`first_int_id` , `second_int_id`),
    
    CONSTRAINT fk_distance_first_int FOREIGN KEY (`first_int_id`)
    REFERENCES materialdb_Intersection(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    CONSTRAINT fk_distance_second_int FOREIGN KEY (`second_int_id`)
    REFERENCES materialdb_Intersection(id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
    
    CONSTRAINT fk_distance_street FOREIGN KEY (`street_id`)
    REFERENCES materialdb_Street(id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- // Tuyen tau/xe
CREATE TABLE materialdb_Route (
    `route_id` CHAR(4) primary key,
    check (route_id regexp '^[TB][0-9]{3}$')
);

-- // Tuyen xe buyt
CREATE TABLE materialdb_Bus_route (
    `bus_route_id`	INT PRIMARY KEY AUTO_INCREMENT,
	`route_id`		CHAR(4) NOT NULL,
    
    CONSTRAINT fk_bus_route FOREIGN KEY (`route_id`)
    REFERENCES materialdb_Route(`route_id`)
    ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER $$
create trigger before_bus_route_insert 
before insert on materialdb_Bus_route
for each row
begin
	if (new.route_id not REGEXP '^B') then
		signal sqlstate '45000'
        set message_text = 'Invalid bus route id, B[0-9][0-9][0-9] expected';
	end if;
end $$
DELIMITER ;

-- // Tuyen tau
CREATE TABLE materialdb_Train_route (
    train_route_id 	CHAR(1) PRIMARY KEY,
    `name` 			VARCHAR(30) UNIQUE NOT NULL,
    unit_price 		FLOAT,
    route_id 		CHAR(4) NOT NULL,
	
    CONSTRAINT fk_train_route FOREIGN KEY (route_id)
    REFERENCES materialdb_Route(route_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

DELIMITER $$
create trigger before_train_route_insert 
before insert on materialdb_Train_route
for each row
begin
	if (new.route_id not REGEXP '^T') then
		signal sqlstate '45000'
        set message_text = 'Invalid train route id, T[0-9][0-9][0-9] expected';
	end if;
end $$
DELIMITER ;

-- // trip
CREATE TABLE materialdb_Trip (
    `route_id` CHAR(4) NOT NULL,
    `trip_index` INTEGER NOT NULL,
    PRIMARY KEY (`route_id` , `trip_index`),
    CONSTRAINT fk_trip_route FOREIGN KEY (`route_id`)
    REFERENCES materialdb_Route(route_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE materialdb_Stopping_point (
    `id` CHAR(7) UNIQUE NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    `address` VARCHAR(50) NOT NULL,
    `type` BOOL, -- 0 for bus, 1 for train
    `first_int_id` CHAR(7),
    `second_int_id` CHAR(7),
    PRIMARY KEY (`id`),

    CONSTRAINT fk_sp_distance FOREIGN KEY(`first_int_id` , `second_int_id`)
    REFERENCES materialdb_Distance(`first_int_id` , `second_int_id`)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE materialdb_Visit (
    `trip_route_id` CHAR(4) NOT NULL,
    `trip_index` INTEGER NOT NULL,
    `stopping_point_id` CHAR(7) UNIQUE NOT NULL,
    `visit_index` INTEGER,
    `arrival_time` TIME,
    `departure_time` TIME,
    PRIMARY KEY (`trip_route_id` , `trip_index` , `stopping_point_id`),

    CONSTRAINT fk_visit_trip FOREIGN KEY(`trip_route_id` , `trip_index`)
    REFERENCES materialdb_Trip(`route_id` , `trip_index`)
    ON UPDATE CASCADE ON DELETE CASCADE,

    CONSTRAINT fk_visit_sp FOREIGN KEY (stopping_point_id)
    REFERENCES materialdb_Stopping_point(id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE materialdb_Ticket (
    `ticket_id` CHAR(15),
    `type` ENUM('0', '1', '2'),
    `price` FLOAT,
    `purchase_date` DATETIME,
    `customer_id` VARCHAR(8),
    PRIMARY KEY (`ticket_id`)
);

create table materialdb_Regular_ticket (
	`ticket_id` char(15),
    `route_id` char(4),
	`use_date` datetime,
    `enter_point_id` char(7),
    `leave_point_id` char(7),
    `enter_time` time,
    `leave_time` time,
    primary key (ticket_id),
    constraint fk_rticket foreign key(ticket_id)  references materialdb_Ticket(ticket_id),
    constraint fk_rroute foreign key(route_id) references materialdb_Route(route_id),
    constraint fk_renter_id foreign key(enter_point_id) references materialdb_Stopping_point(id),
    constraint fk_rleave_id foreign key(leave_point_id) references materialdb_Stopping_point(id),
    check (enter_time < leave_time)
);

create table materialdb_Monthly_ticket (
	`ticket_id` char(15),
    `route_id` char(4),
	`enter_point_id` char(7),
    `leave_point_id` char(7),
    `use_date` datetime,
	primary key (ticket_id),
    constraint fk_mticket foreign key(ticket_id)  references materialdb_Ticket(ticket_id),
    constraint fk_mroute foreign key(route_id) references materialdb_Route(route_id),
    constraint fk_menter_id foreign key(enter_point_id) references materialdb_Stopping_point(id),
    constraint fk_mleave_id foreign key(leave_point_id) references materialdb_Stopping_point(id)
);

create table materialdb_Monthly_ticket_record (
	`ticket_id` char(15),
    `route_id` char(4),
    `use_date` datetime,
    `enter_point_id` char(7),
    `leave_point_id` char(7),
    `enter_time` time,
    `leave_time` time,
	primary key (ticket_id),
    constraint fk_mrticket foreign key(ticket_id)  references materialdb_Ticket(ticket_id),
    constraint fk_mrroute foreign key(route_id) references materialdb_Route(route_id),
    constraint fk_mrenter_id foreign key(enter_point_id) references materialdb_Stopping_point(id),
    constraint fk_mrleave_id foreign key(leave_point_id) references materialdb_Stopping_point(id),
    check (enter_time < leave_time)
);

create table materialdb_Oneday_ticket (
	`ticket_id` char(15),
    `use_date` datetime,
    primary key (ticket_id),
    constraint fk_oticket foreign key(ticket_id)  references materialdb_Ticket(ticket_id)
);

create table materialdb_Oneday_ticket_record (
	`ticket_id` char(15),
    `route_id` char(4),
    `enter_point_id` char(7),
    `leave_point_id` char(7),
    `enter_time` time,
    `leave_time` time,
    primary key (ticket_id),
	constraint fk_orticket foreign key(ticket_id)  references materialdb_Ticket(ticket_id),
    constraint fk_orroute foreign key(route_id) references materialdb_Route(route_id),
    constraint fk_orenter_id foreign key(enter_point_id) references materialdb_Stopping_point(id),
    constraint fk_orleave_id foreign key(leave_point_id) references materialdb_Stopping_point(id),
    check (enter_time < leave_time)
);

create	table	materialdb_Passenger
(
passenger_id	char(8)	primary key not null,
ssn	char(9)	not null unique,
job	varchar(20),
phone	char(10) unique,
sex	char,
email	varchar(50),
dob	date
);

create table materialdb_Magnetic_card
(
magnatic_card_id	char(8) primary key,
purchase_date	datetime,
passenger_id	char(8),
constraint	fk_magnetic_card_passenger	foreign key	(passenger_id)
			references	materialdb_Passenger(passenger_id)
);

create	table	materialdb_Staff
(
staff_id	char(6)	primary key,
job_category	varchar(20),
dob	date,
email	varchar(50),
sex	char,
mobile_phone	char(10),
internal_phone	char
);

create	table	materialdb_Workplace
(
uid int not null ,
staff_id	char(6)	primary key,
station_id	char(7),
constraint	fk_workplace_staff	foreign key	(staff_id)
			references	materialdb_Staff(staff_id)
);

create table	materialdb_Price_list
(
bus_unit_price	decimal(4),
week_day_price	decimal(5),
weekend_price	decimal(5)
);

create table materialdb_User (
	`user_name` char(30) unique,
	`password` char(30)
);

INSERT INTO `TRANSPORTATION`.`materialdb_User` (`user_name`, `password`) VALUES ('sManager', '123456789');

-- // Clear all tables
delimiter $$
create procedure ClearAll()
begin
	set sql_safe_updates = 0;
	delete from materialdb_Route;
		set foreign_key_checks = 0;

		delete from materialdb_Distance;
		delete from materialdb_Intersection;
		delete from materialdb_Street;
        
		set foreign_key_checks = 1;
	set sql_safe_updates = 1;

	truncate table seq_street;
	truncate table seq_intersection;
end$$
delimiter ;
