/**
 *  MSSQL Table Creation
 *
 *@author     mrajkowski
 *@created    March 27, 2002
 *@version    $Id: new_opportunity.sql 15848 2006-09-18 13:22:19Z matt $
 */

CREATE TABLE lookup_call_types (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(50) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE lookup_call_priority (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(50) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1,
  weight INTEGER NOT NULL
);

CREATE TABLE lookup_call_reminder (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(50) NOT NULL,
  base_value INTEGER DEFAULT 0 NOT NULL,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE lookup_call_result (
  result_id INT IDENTITY PRIMARY KEY,
  description VARCHAR(100) NOT NULL,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1,
  next_required BIT NOT NULL DEFAULT 0,
  next_days INT NOT NULL DEFAULT 0,
  next_call_type_id INTEGER,
  canceled_type BIT NOT NULL DEFAULT 0
);

CREATE TABLE lookup_opportunity_types (
  code INT IDENTITY PRIMARY KEY,
  order_id INT,
  description VARCHAR(50) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

--Environment - What stuff is the account already using
CREATE TABLE lookup_opportunity_environment (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);

--Competitors - Who else is competing for this business
CREATE TABLE lookup_opportunity_competitors (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);

--Compelling Event - What event is driving the timeline for purchase
CREATE TABLE lookup_opportunity_event_compelling (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);

--Budget - Where are they getting the money to pay for the purchasse
CREATE TABLE lookup_opportunity_budget (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BIT DEFAULT 0,
  level INT DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE opportunity_header (
  opp_id INT IDENTITY PRIMARY KEY,
  description VARCHAR(80),
  acctlink INT REFERENCES organization(org_id),
  contactlink INT REFERENCES contact(contact_id),
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),
  trashed_date DATETIME,
  access_type INT NOT NULL REFERENCES lookup_access_types(code),
  manager INT NOT NULL REFERENCES access(user_id),
  lock BIT DEFAULT 0,
  contact_org_id INTEGER REFERENCES organization(org_id),
  custom1_integer INTEGER,
  site_id INT REFERENCES lookup_site_id(code)
);

CREATE INDEX "opp_contactlink_idx" ON "opportunity_header" (contactlink);
CREATE INDEX "opp_header_contact_org_id_idx" ON "opportunity_header" (contact_org_id);
CREATE INDEX "oppheader_description_idx" ON "opportunity_header" (description);

CREATE TABLE opportunity_component (
  id INT IDENTITY PRIMARY KEY,
  opp_id INT REFERENCES opportunity_header(opp_id),
  owner INT NOT NULL REFERENCES access(user_id),
  description VARCHAR(80),
  closedate DATETIME NOT NULL,
  closeprob FLOAT,
  terms FLOAT,
  units CHAR(1),
  lowvalue FLOAT,
  guessvalue FLOAT,
  highvalue FLOAT,
  stage INT REFERENCES lookup_stage(code),
  stagedate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  commission FLOAT,
  type CHAR(1),
  alertdate DATETIME,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),  
  closed DATETIME,
  alert VARCHAR(100) DEFAULT NULL,
  enabled BIT NOT NULL DEFAULT 1,
  notes TEXT,
  alertdate_timezone VARCHAR(255),
  closedate_timezone VARCHAR(255),
  trashed_date DATETIME,
  environment INT REFERENCES lookup_opportunity_environment(code),
  competitors INT REFERENCES lookup_opportunity_competitors(code),
  compelling_event INT REFERENCES lookup_opportunity_event_compelling(code),
  budget INT REFERENCES lookup_opportunity_budget(code),
  status_id INT
);

CREATE INDEX "oppcomplist_header_idx" ON "opportunity_component" (opp_id);
CREATE INDEX "oppcomplist_closedate" ON "opportunity_component" (closedate);
CREATE INDEX "oppcomplist_description" ON "opportunity_component" (description);


CREATE TABLE opportunity_component_levels (
  opp_id INT NOT NULL REFERENCES opportunity_component(id),
  type_id INT NOT NULL REFERENCES lookup_opportunity_types(code),
  level INTEGER NOT NULL,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE call_log (
  call_id INT IDENTITY PRIMARY KEY,
  org_id INT REFERENCES organization(org_id),
  contact_id INT REFERENCES contact(contact_id),
  opp_id INT REFERENCES opportunity_header(opp_id),
  call_type_id INT REFERENCES lookup_call_types(code),
  length INTEGER,
  subject VARCHAR(255),
  notes TEXT,
  followup_date DATETIME,
  alertdate DATETIME,
  followup_notes TEXT,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id),
  alert VARCHAR(255) DEFAULT NULL,
  alert_call_type_id INT REFERENCES lookup_call_types(code),
  parent_id INT NULL REFERENCES call_log(call_id),
  owner INT NULL REFERENCES access(user_id),
  assignedby INT REFERENCES access(user_id),
  assign_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  completedby INT REFERENCES access(user_id),
  complete_date DATETIME NULL,
  result_id INT REFERENCES lookup_call_result(result_id),
  priority_id INT REFERENCES lookup_call_priority(code),
  status_id INT NOT NULL DEFAULT 1,
  reminder_value INT NULL,
  reminder_type_id INT NULL REFERENCES lookup_call_reminder(code),
  alertdate_timezone VARCHAR(255),
  trashed_date DATETIME,
  followup_contact_id INT  REFERENCES contact(contact_id)
);

CREATE INDEX "call_log_cidx" ON "call_log" ("alertdate", "enteredby");
CREATE INDEX "call_log_entered_idx" ON "call_log" (entered);
CREATE INDEX "call_contact_id_idx" ON "call_log" (contact_id);
CREATE INDEX "call_org_id_idx" ON "call_log" (org_id);
CREATE INDEX "call_opp_id_idx" ON "call_log" (opp_id);
CREATE INDEX call_fcontact_id_idx  ON call_log (followup_contact_id);

ALTER TABLE lookup_call_result ADD FOREIGN KEY(next_call_type_id) REFERENCES call_log(call_id); 

CREATE TABLE opportunity_component_log(
  id INT IDENTITY PRIMARY KEY,
  component_id INT REFERENCES opportunity_component(id),
  header_id INT REFERENCES opportunity_header(opp_id),
  description VARCHAR(80),
  closeprob FLOAT,
  closedate DATETIME NOT NULL,
  terms FLOAT,
  units CHAR(1),
  lowvalue FLOAT,
  guessvalue FLOAT,
  highvalue FLOAT,
  stage INT REFERENCES lookup_stage(code),
  owner INT NOT NULL REFERENCES access(user_id),
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  closedate_timezone VARCHAR(255),
  closed DATETIME
);

