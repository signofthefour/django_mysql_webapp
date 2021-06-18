--trigger for Monthly_ticket_record
drop trigger if exists enter_leave_point
create trigger enter_leave_point
on materialdb_Monthly_ticket_record
after insert, update
for each row
begin
	declare enter char(7) -- inserted enter point ID
	set enter = (select enter_point_id from inserted)
	declare leave char(7) -- inserted leave point ID
	set leave = (select leave_point_id from inserted)
	declare id char(15) --ticket ID
	set id = (select ticket_id from inserted)
	declare en char(7) -- enter point ID from Monthly_ticket table
	set en = (select enter_point_id from materialdb_Monthly_ticket
				where ticket_id = id)
	declare lea char(7) -- leave point ID from Monthly_ticket table
	set lea = (select leave_point_id from materialdb_Monthly_ticket
				where ticket_id = id)
	if enter != en or leave != lea
	begin
		print ('invalid enter point')
		rollback
	end
end