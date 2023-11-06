
CREATE SEQUENCE lookup_call_types_code_seq;
CREATE TABLE lookup_call_types (
  code INTEGER NOT NULL,
  description NVARCHAR2(50) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

CREATE SEQUENCE lookup_call_priority_code_seq;
CREATE TABLE lookup_call_priority (
  code INTEGER NOT NULL,
  description NVARCHAR2(50) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  weight INTEGER NOT NULL,
  PRIMARY KEY (CODE)
);

CREATE SEQUENCE lookup_call_reminder_code_seq;
CREATE TABLE lookup_call_reminder (
  code INTEGER NOT NULL,
  description NVARCHAR2(50) NOT NULL,
  base_value INTEGER DEFAULT 0 NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

-- Old Name: lookup_call_result_result_id_seq;
CREATE SEQUENCE lookup_call_r_lt_result_id_seq;
CREATE TABLE lookup_call_result (
  result_id INTEGER NOT NULL,
  description NVARCHAR2(100) NOT NULL,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  next_required CHAR(1) DEFAULT 0 NOT NULL ,
  next_days INTEGER DEFAULT 0 NOT NULL ,
  next_call_type_id INTEGER,
  canceled_type CHAR(1) DEFAULT 0 NOT NULL,
  PRIMARY KEY (RESULT_ID)
);


CREATE SEQUENCE lookup_opport_ity_typ_code_seq;
CREATE TABLE lookup_opportunity_types (
  code INTEGER NOT NULL,
  order_id INTEGER,
  description NVARCHAR2(50) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

--Environment - What stuff is the account already using
CREATE SEQUENCE lookup_opport_ity_env_code_seq;
CREATE TABLE lookup_opportunity_environment (
  code INTEGER NOT NULL,
  description NVARCHAR2(300) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

--Competitors - Who else is competing for this business
CREATE SEQUENCE lookup_opport_ity_com_code_seq;
CREATE TABLE lookup_opportunity_competitors (
  code INTEGER NOT NULL,
  description NVARCHAR2(300) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

--Compelling Event - What event is driving the timeline for purchase
CREATE SEQUENCE lookup_opport_event_compelling;

-- Old Name: lookup_opportunity_event_compelling
CREATE TABLE lookup_opt_event_compelling (
  code INTEGER NOT NULL,
  description NVARCHAR2(300) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

--Budget - Where are they getting the money to pay for the purchasse
CREATE SEQUENCE lookup_opport_ity_bud_code_seq;
CREATE TABLE lookup_opportunity_budget (
  code INTEGER NOT NULL,
  description NVARCHAR2(300) NOT NULL,
  default_item CHAR(1) DEFAULT 0,
  "level" INTEGER DEFAULT 0,
  enabled CHAR(1) DEFAULT 1,
  PRIMARY KEY (CODE)
);

CREATE SEQUENCE opportunity_header_opp_id_seq;
CREATE TABLE opportunity_header (
  opp_id INTEGER NOT NULL PRIMARY KEY,
  description NVARCHAR2(80),
  acctlink INTEGER REFERENCES organization(org_id),
  contactlink INTEGER REFERENCES contact(contact_id),
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  trashed_date TIMESTAMP,
  access_type INT NOT NULL REFERENCES lookup_access_types(code),
  manager INT NOT NULL REFERENCES "access"(user_id),
  "lock" CHAR(1) DEFAULT 0,
  contact_org_id INTEGER REFERENCES organization(org_id),
  custom1_integer INTEGER,
  site_id INT REFERENCES lookup_site_id(code)
);

CREATE SEQUENCE opportunity_component_id_seq;
CREATE TABLE opportunity_component (
  id INTEGER NOT NULL PRIMARY KEY,
  opp_id INTEGER REFERENCES opportunity_header(opp_id),
  owner INTEGER  NOT NULL REFERENCES "access"(user_id),
  description NVARCHAR2(80),
  closedate TIMESTAMP NOT NULL,
  closeprob FLOAT,
  terms FLOAT,
  units CHAR(1),
  lowvalue FLOAT,
  guessvalue FLOAT,
  highvalue FLOAT,
  stage INTEGER REFERENCES lookup_stage(code),
  stagedate TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  commission FLOAT,
  "type" CHAR(1),
  alertdate TIMESTAMP,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  closed TIMESTAMP,
  alert NVARCHAR2(100) DEFAULT NULL,
  enabled CHAR(1) DEFAULT 0 NOT NULL ,
  notes CLOB,
  alertdate_timezone NVARCHAR2(255),
  closedate_timezone NVARCHAR2(255),
  trashed_date TIMESTAMP,
  environment INTEGER REFERENCES lookup_opportunity_environment(code),
  competitors INTEGER REFERENCES lookup_opportunity_competitors(code),
  compelling_event INTEGER REFERENCES lookup_opt_event_compelling(code),
  budget INTEGER REFERENCES lookup_opportunity_budget(code),
  status_id INTEGER
);

CREATE INDEX oppcomplist_closedate ON opportunity_component (closedate);
CREATE INDEX oppcomplist_description ON opportunity_component (description);


CREATE TABLE opportunity_component_levels (
  opp_id INTEGER NOT NULL REFERENCES opportunity_component(id),
  type_id INTEGER NOT NULL REFERENCES lookup_opportunity_types(code),
  "level" INTEGER NOT NULL,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE SEQUENCE call_log_call_id_seq;
CREATE TABLE call_log (
  call_id INTEGER  NOT NULL,
  org_id INTEGER REFERENCES organization(org_id),
  contact_id INTEGER REFERENCES contact(contact_id),
  opp_id INTEGER REFERENCES opportunity_header(opp_id),
  call_type_id INTEGER REFERENCES lookup_call_types(code),
  "length" INTEGER,
  subject NVARCHAR2(255),
  notes CLOB,
  followup_date TIMESTAMP,
  alertdate TIMESTAMP,
  followup_notes CLOB,
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  alert NVARCHAR2(255) ,
  alert_call_type_id INTEGER REFERENCES lookup_call_types(code),
  parent_id INTEGER REFERENCES call_log(call_id),
  owner INTEGER  REFERENCES "access"(user_id),
  assignedby INTEGER REFERENCES "access"(user_id),
  assign_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  completedby INTEGER REFERENCES "access"(user_id),
  complete_date TIMESTAMP ,
  result_id INTEGER REFERENCES lookup_call_result(result_id),
  priority_id INTEGER REFERENCES lookup_call_priority(code),
  status_id INTEGER DEFAULT 1 NOT NULL ,
  reminder_value INTEGER ,
  reminder_type_id INTEGER  REFERENCES lookup_call_reminder(code),
  alertdate_timezone NVARCHAR2(255),
  trashed_date TIMESTAMP,
  followup_contact_id INTEGER  REFERENCES contact(contact_id), 
  PRIMARY KEY (CALL_ID)
);

CREATE INDEX call_log_cidx ON call_log ( alertdate, enteredby );
CREATE INDEX call_log_entered_idx ON call_log ( entered );
CREATE INDEX call_contact_id_idx ON call_log ( contact_id );
CREATE INDEX call_org_id_idx ON call_log ( org_id );
CREATE INDEX call_opp_id_idx ON call_log ( opp_id );
CREATE INDEX call_fcontact_id_idx  ON call_log (followup_contact_id);

-- Used at end of script because it references a table that has not been created
-- =============================================================================
ALTER TABLE lookup_call_result ADD CONSTRAINT FK_LOOKUP_CALL_RESULT_CALL_LOG
  FOREIGN KEY(next_call_type_id) REFERENCES call_log(call_id);

CREATE SEQUENCE opportunity_c_onent_log_id_seq;
CREATE TABLE opportunity_component_log (
 id INTEGER NOT NULL PRIMARY KEY,
 component_id INTEGER REFERENCES opportunity_component(id),
 header_id INTEGER REFERENCES opportunity_header(opp_id),
 description NVARCHAR2(80),
 closeprob FLOAT,
 closedate TIMESTAMP NOT NULL,
 terms FLOAT,
 units CHAR(1),
 lowvalue FLOAT,
 guessvalue FLOAT,
 highvalue FLOAT,
 stage INTEGER REFERENCES lookup_stage(code),
 owner INTEGER NOT NULL REFERENCES "access"(user_id),
 entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
 enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
 closedate_timezone NVARCHAR2(255),
 closed TIMESTAMP
);

