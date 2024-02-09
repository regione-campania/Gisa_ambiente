insert into role_permission(role_id, permission_id, role_view)
select role_id, (select permission_id from permission where permission = 'opu'), true
from role where role_id not in (select role_id from role_permission where role_view and permission_id in (select permission_id from permission where permission = 'opu')) 

insert into role_permission(role_id, permission_id, role_view, role_add)
select role_id, (select permission_id from permission where permission = 'gestionenuovacu'), true, true
from role where role_id not in (select role_id from role_permission where role_view and permission_id in (select permission_id from permission where permission = 'gestionenuovacu'))

insert into role_permission(role_id, permission_id, role_view, role_add)
select role_id, (select permission_id from permission where permission = 'opu-vigilanza'), true, true
from role where role_id not in (select role_id from role_permission where role_view and permission_id in (select permission_id from permission where permission = 'opu-vigilanza'));

insert into role_permission(role_id, permission_id, role_view)
select role_id, (select permission_id from permission where permission = 'system-access'), true
from role where role_id not in (select role_id from role_permission where role_view and permission_id in (select permission_id from permission where permission = 'system-access'));