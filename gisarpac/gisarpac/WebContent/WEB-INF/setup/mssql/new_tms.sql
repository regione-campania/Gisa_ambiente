/**
 *  MSSQL Table Creation
 *
 *@author     mrajkowski
 *@created    March 20, 2002
 *@version    $Id: new_tms.sql 15115 2006-05-31 16:47:51Z matt $
 */
-- REQUIRES: new_product.sql
-- REQUIRES: new_project.sql

CREATE TABLE ticket_level (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL UNIQUE,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);


CREATE TABLE ticket_severity (
  code INT IDENTITY PRIMARY KEY
  ,description VARCHAR(300) NOT NULL UNIQUE
  ,style text NOT NULL DEFAULT ''
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
);


CREATE TABLE lookup_ticketsource (
  code INT IDENTITY PRIMARY KEY
  ,description VARCHAR(300) NOT NULL UNIQUE
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
);


CREATE TABLE lookup_ticket_status (
  code INT IDENTITY PRIMARY KEY
  ,description VARCHAR(300) NOT NULL UNIQUE
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
);


CREATE TABLE ticket_priority (
  code INT IDENTITY PRIMARY KEY
  ,description VARCHAR(300) NOT NULL UNIQUE
  ,style text NOT NULL DEFAULT '' 
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
);


CREATE TABLE lookup_ticket_escalation(
  code INTEGER IDENTITY PRIMARY KEY
  ,description VARCHAR(300) NOT NULL UNIQUE
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
);

CREATE TABLE ticket_category (
  id INT IDENTITY PRIMARY KEY
  ,cat_level int  NOT NULL DEFAULT 0 
  ,parent_cat_code int NOT NULL DEFAULT 0
  ,description VARCHAR(300) NOT NULL 
  ,full_description text NOT NULL DEFAULT ''
  ,default_item BIT DEFAULT 0
  ,level INTEGER DEFAULT 0
  ,enabled BIT DEFAULT 1
  ,site_id INTEGER REFERENCES lookup_site_id(code)
);

CREATE TABLE ticket_category_draft (
  id INT IDENTITY PRIMARY KEY,
  link_id INT DEFAULT -1,
  cat_level int NOT NULL DEFAULT 0,
  parent_cat_code int NOT NULL DEFAULT 0,
  description VARCHAR(300) NOT NULL,
  full_description text NOT NULL DEFAULT '',
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1,
  site_id INTEGER REFERENCES lookup_site_id(code)
);

-- Ticket Category Draft Assignment table
CREATE TABLE ticket_category_draft_assignment (
  map_id INT IDENTITY PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES ticket_category_draft(id),
  department_id INTEGER REFERENCES lookup_department(code),
  assigned_to INTEGER REFERENCES access(user_id),
  group_id INTEGER REFERENCES user_group(group_id)
);

-- Ticket Category Assignment table
CREATE TABLE ticket_category_assignment (
  map_id INT IDENTITY PRIMARY KEY,
  category_id INTEGER NOT NULL REFERENCES ticket_category(id),
  department_id INTEGER REFERENCES lookup_department(code),
  assigned_to INTEGER REFERENCES access(user_id),
  group_id INTEGER REFERENCES user_group(group_id)
);

CREATE TABLE ticket (
  ticketid INT IDENTITY PRIMARY KEY,
  org_id INT REFERENCES organization, 
  contact_id INT REFERENCES contact,
  problem TEXT NOT NULL,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),
  closed DATETIME,
  pri_code INT REFERENCES ticket_priority(code), 
  level_code INT REFERENCES ticket_level(code),
  department_code INT REFERENCES lookup_department,
  source_code INT REFERENCES lookup_ticketsource(code),
  cat_code INT REFERENCES ticket_category(id),
  subcat_code1 INT REFERENCES ticket_category(id),
  subcat_code2 INT REFERENCES ticket_category(id),
  subcat_code3 INT REFERENCES ticket_category(id),
  assigned_to INT REFERENCES access,
  comment TEXT,
  solution TEXT,
  scode INT REFERENCES ticket_severity(code),
  critical DATETIME,
  notified DATETIME,
  custom_data TEXT,
  location VARCHAR(256),
  assigned_date DATETIME,
  est_resolution_date DATETIME,
  resolution_date DATETIME,
  cause TEXT,
  link_contract_id INTEGER REFERENCES service_contract(contract_id),
  link_asset_id INTEGER REFERENCES asset(asset_id),
  product_id INTEGER REFERENCES product_catalog(product_id)
  -- DO NOT PUT ANY MORE FIELDS IN THIS TABLE HERE
  -- THEY MUST BE APPENDED to new_tms_append_fields.sql because of referential
  -- integrity
);

CREATE INDEX "ticket_cidx" ON "ticket" ("assigned_to", "closed");
CREATE INDEX "ticketlist_entered" ON "ticket" (entered);

CREATE TABLE project_ticket_count (
  project_id INT UNIQUE NOT NULL REFERENCES projects(project_id),
  key_count INT NOT NULL DEFAULT 0
);

CREATE TABLE ticketlog (
  id INT IDENTITY PRIMARY KEY
  ,ticketid INT REFERENCES ticket(ticketid)
  ,assigned_to INT REFERENCES access(user_id)
  ,comment TEXT
  ,closed BIT
  ,pri_code INT REFERENCES ticket_priority(code)
  ,level_code INT
  ,department_code INT REFERENCES lookup_department(code)
  ,cat_code INT
  ,scode INT REFERENCES ticket_severity(code)
  ,entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  ,enteredby INT NOT NULL REFERENCES access(user_id)
  ,modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
  ,modifiedby INT NOT NULL REFERENCES access(user_id)
  -- DO NOT PUT ANY MORE FIELDS IN THIS TABLE HERE
  -- THEY MUST BE APPENDED to new_tms_append_fields.sql because of referential
  -- integrity
);

CREATE TABLE ticket_csstm_form(
  form_id INT IDENTITY PRIMARY KEY,
  link_ticket_id INT REFERENCES ticket(ticketid), 
  phone_response_time VARCHAR(10),
  engineer_response_time VARCHAR(10),
  follow_up_required BIT DEFAULT 0,
  follow_up_description VARCHAR(2048),
  alert_date DATETIME,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),
  enabled BIT DEFAULT 1,
  travel_towards_sc BIT DEFAULT 1,
  labor_towards_sc BIT DEFAULT 1,
  alert_date_timezone VARCHAR(255)
);

CREATE TABLE ticket_activity_item(
  item_id INT IDENTITY PRIMARY KEY,
  link_form_id INT REFERENCES ticket_csstm_form(form_id),
  activity_date DATETIME,
  description TEXT,
  travel_hours INT,
  travel_minutes INT,
  labor_hours INT,
  labor_minutes INT,
  activity_date_timezone VARCHAR(255)
);

CREATE TABLE ticket_sun_form(
  form_id INT IDENTITY PRIMARY KEY,
  link_ticket_id INT REFERENCES ticket(ticketid), 
  description_of_service TEXT,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),
  enabled BIT DEFAULT 1
);

CREATE TABLE trouble_asset_replacement(
  replacement_id INT IDENTITY PRIMARY KEY,
  link_form_id INT REFERENCES ticket_sun_form(form_id),
  part_number VARCHAR(256),
  part_description TEXT
);

CREATE TABLE ticketlink_project (
  ticket_id INT NOT NULL REFERENCES ticket(ticketid),
  project_id INT NOT NULL REFERENCES projects(project_id)
);

CREATE INDEX ticketlink_project_idx ON ticketlink_project(ticket_id);

-- Ticket Cause lookup
CREATE TABLE lookup_ticket_cause (
  code INTEGER IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
	enabled BIT DEFAULT 1
);

-- Ticket Resolution lookup
CREATE TABLE lookup_ticket_resolution (
  code INTEGER IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
	enabled BIT DEFAULT 1
);

--Ticket Defect table
CREATE TABLE ticket_defect (
  defect_id INT IDENTITY PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  start_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  end_date DATETIME,
  enabled BIT NOT NULL DEFAULT 1,
  trashed_date DATETIME,
  site_id INT REFERENCES lookup_site_id(code)
);

-- Ticket State lookup
CREATE TABLE lookup_ticket_state (
  code INTEGER IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
	enabled BIT DEFAULT 1
);

