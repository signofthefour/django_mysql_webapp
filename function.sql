use transportation;

-- begin implementation --
drop function if exists transportation.LoTrinhTuyenXeTau;
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

-- test the result
select distinct route_id, LoTrinhTuyenXeTau(route_id)
from materialdb_Route;
