select
'insert into role_permission (role_id, permission_id, role_view, role_add, role_edit, role_delete) values ('||
role_id||', '||(select permission_id from permission where permission ilike '%documentale_bacheca%')||', true, true, true, false);'
from role
where enabled

and role_id not in (
select role_id from role_permission where permission_id in (
select permission_id from permission where permission ilike '%documentale_bacheca%'
))