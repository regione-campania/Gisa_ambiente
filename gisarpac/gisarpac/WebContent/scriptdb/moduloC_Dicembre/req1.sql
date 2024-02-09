INSERT INTO public."permission"
(permission_id, category_id, "permission", permission_view, permission_add, permission_edit, permission_delete, description, "level", enabled, active, viewpoints)
VALUES(102, 29, 'impianti-aia', true, true, true, true, 'Gestione Impianti AIA', 0, true, true, false);
INSERT INTO public."permission"
(permission_id, category_id, "permission", permission_view, permission_add, permission_edit, permission_delete, description, "level", enabled, active, viewpoints)
VALUES(103, 29, 'impianti-aua', true, true, true, true, 'Gestione Impianti AUA', 0, true, true, false);


INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(225, 32, 102, true, true, true, true, NULL);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(226, 32, 103, true, true, true, true, NULL);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(227, 1, 102, true, true, true, true, NULL);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(228, 1, 103, true, true, true, true, NULL);


INSERT INTO public."permission"
(permission_id, category_id, "permission", permission_view, permission_add, permission_edit, permission_delete, description, "level", enabled, active, viewpoints)
VALUES(38, 29, 'gestionepostit_asl', true, true, true, true, 'Gestione Post It', 0, true, true, false);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(229, 32, 38, true, true, true, true, NULL);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(230, 1, 38, true, true, true, true, NULL);
INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(231, 27, 38, true, true, true, true, NULL);


INSERT INTO public.role_permission
(id, role_id, permission_id, role_view, role_add, role_edit, role_delete, note_hd)
VALUES(232, 1, 37, true, true, true, true, NULL);
