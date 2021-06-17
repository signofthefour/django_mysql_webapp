use transportation;

drop function if exists transportation.LoTrinhTuyenXeTau;

-- // -------------------------

DELIMITER $$
create function transportation.LoTrinhTuyenXeTau(
	routeIdToSearch char(4)
)
returns varchar(1024)
deterministic
BEGIN
	declare resultString varchar(1024);
	
    drop temporary table if exists temp;
	create temporary table temp
	select distinct visit_index, stopping_point_id, routeIdToSearch
	from materialdb_Visit
	where trip_route_id = routeIdToSearch
	group by visit_index
    order by stopping_point_id;
    
    set resultString = (
		select group_concat(`name` separator ', ')
		from temp
        inner join materialdb_Stopping_point as sp
		on temp.stopping_point_id = sp.id
		group by routeIdToSearch
    );
    
    return if (resultString is null, 'not found', resultString);
END$$
delimiter ;

-- testing
set @routeIdToSearch := 'B050';
set @routeIdToSearch := 'B008';
set @routeIdToSearch := 'T050';
set @routeIdToSearch := 'T008';
set @routeIdToSearch := 'C008';

select LoTrinhTuyenXeTau(@routeIdToSearch);


-- -- // count regular turns -------------------------

-- select use_date, count(*)
-- from materialdb_Regular_ticket
-- where use_date is not null
-- and route_id = @myRouteID
-- group by date(use_date);

-- -- // count day turns
-- select *
-- from materialdb_Monthly_ticket_record;
-- where route_id = @myRouteID;
