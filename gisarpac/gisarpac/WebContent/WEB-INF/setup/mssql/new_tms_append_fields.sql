--
--  MSSQL Table additions to the ticket table that must be done last
--
--@author     mrajkowski
--@created    April 30, 2004
--@version    $Id: new_tms_append_fields.sql 15115 2006-05-31 16:47:51Z matt $

-- ticket table
ALTER TABLE ticket ADD customer_product_id INTEGER REFERENCES customer_product(customer_product_id);
ALTER TABLE ticket ADD expectation INTEGER;
ALTER TABLE ticket ADD key_count INT;
ALTER TABLE ticket ADD est_resolution_date_timezone VARCHAR(255);
ALTER TABLE ticket ADD assigned_date_timezone VARCHAR(255);
ALTER TABLE ticket ADD resolution_date_timezone VARCHAR(255);
ALTER TABLE ticket ADD status_id INTEGER REFERENCES lookup_ticket_status(code);
ALTER TABLE ticket ADD trashed_date DATETIME;
ALTER TABLE ticket ADD user_group_id INTEGER REFERENCES user_group(group_id);
ALTER TABLE ticket ADD cause_id INTEGER REFERENCES lookup_ticket_cause(code);
ALTER TABLE ticket ADD resolution_id INTEGER REFERENCES lookup_ticket_resolution(code);
ALTER TABLE ticket ADD defect_id INTEGER REFERENCES ticket_defect(defect_id);
ALTER TABLE ticket ADD escalation_level INT REFERENCES lookup_ticket_escalation(code);
ALTER TABLE ticket ADD resolvable BIT NOT NULL DEFAULT 1;
ALTER TABLE ticket ADD resolvedby INT REFERENCES access(user_id);
ALTER TABLE ticket ADD resolvedby_department_code INT REFERENCES lookup_department(code);
ALTER TABLE ticket ADD state_id INTEGER REFERENCES lookup_ticket_state(code);
ALTER TABLE ticket ADD site_id INT REFERENCES lookup_site_id(code);

-- ticketlog table
ALTER TABLE ticketlog ADD escalation_code INT REFERENCES lookup_ticket_escalation(code);
ALTER TABLE ticketlog ADD state_id INT REFERENCES lookup_ticket_state(code);
