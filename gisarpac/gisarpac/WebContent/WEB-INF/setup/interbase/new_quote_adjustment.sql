
CREATE GENERATOR lookup_quote_delivery_code_seq;
CREATE TABLE lookup_quote_delivery (
  code INTEGER NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Each quote can have several conditions. They can be entered over the lifetime of a quote.
-- Example: Condition 1, Condition 2 etc
CREATE GENERATOR lookup_quote_condition_code_seq;
CREATE TABLE lookup_quote_condition (
  code INTEGER NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Create a new table to group quote versions
CREATE GENERATOR quote_group_group_id_seq;
SET GENERATOR quote_group_group_id_seq TO 1000;
CREATE TABLE quote_group (
  group_id INTEGER NOT NULL,
  unused CHAR(1),
  PRIMARY KEY (GROUP_ID)
);

-- Adjustments to the quote_entry table
ALTER TABLE quote_entry ADD product_id INTEGER REFERENCES product_catalog(product_id);
ALTER TABLE quote_entry ADD customer_product_id INTEGER REFERENCES customer_product(customer_product_id);
ALTER TABLE quote_entry ADD opp_id INTEGER REFERENCES opportunity_header(opp_id);
ALTER TABLE quote_entry ADD "version" VARCHAR(255) DEFAULT '0' NOT NULL;
ALTER TABLE quote_entry ADD group_id INTEGER REFERENCES quote_group(group_id);
ALTER TABLE quote_entry ADD CONSTRAINT CHK_NOTNULL CHECK(group_id IS NOT NULL);
ALTER TABLE quote_entry ADD delivery_id INTEGER REFERENCES lookup_quote_delivery(code);
ALTER TABLE quote_entry ADD email_address BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD phone_number BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD address BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD fax_number BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD submit_action INTEGER;
ALTER TABLE quote_entry ADD closed TIMESTAMP;
ALTER TABLE quote_entry ADD show_total BOOLEAN DEFAULT TRUE;
ALTER TABLE quote_entry ADD show_subtotal BOOLEAN DEFAULT TRUE;
ALTER TABLE quote_entry ADD logo_file_id INTEGER REFERENCES project_files(item_id);
ALTER TABLE quote_entry ADD trashed_date TIMESTAMP;

-- Create a new table to map quote conditions to a quote
CREATE GENERATOR quote_condition_map_id_seq;
CREATE TABLE quote_condition (
  map_id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  condition_id INTEGER NOT NULL REFERENCES lookup_quote_condition(code),
  PRIMARY KEY (MAP_ID)
);

-- Create a new table to log the quote history
CREATE GENERATOR quotelog_id_seq;
CREATE TABLE quotelog (
  id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  source_id INTEGER REFERENCES lookup_quote_source(code),
  status_id INTEGER REFERENCES lookup_quote_status(code),
  terms_id INTEGER REFERENCES lookup_quote_terms(code),
  type_id INTEGER REFERENCES lookup_quote_type(code),
  delivery_id INTEGER REFERENCES lookup_quote_delivery(code),
  notes BLOB SUB_TYPE 1 SEGMENT SIZE 100 ,
  grand_total FLOAT,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  issued_date TIMESTAMP,
  submit_action INTEGER,
  closed TIMESTAMP,
  PRIMARY KEY (ID)
);


-- Create a new table to lookup quote remarks
CREATE GENERATOR lookup_quote_remarks_code_seq;
CREATE TABLE lookup_quote_remarks (
  code INTEGER   NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Create a new table to map remarks to a quote
CREATE GENERATOR quote_remark_map_id_seq;
CREATE TABLE quote_remark (
  map_id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  remark_id INTEGER NOT NULL REFERENCES lookup_quote_remarks(code),
  PRIMARY KEY (MAP_ID)
);

-- Each quote has notes
-- Example: Notes entered by Advertiser, Notes entered by Designer
CREATE GENERATOR quote_notes_notes_id_seq;
CREATE TABLE quote_notes (
  notes_id INTEGER  NOT NULL,
  quote_id INTEGER REFERENCES quote_entry(quote_id),
  notes BLOB SUB_TYPE 1 SEGMENT SIZE 100,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  entered TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (NOTES_ID)
);

CREATE GENERATOR lookup_quote_delivery_code_seq;
CREATE TABLE lookup_quote_delivery (
  code INTEGER NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Each quote can have several conditions. They can be entered over the lifetime of a quote.
-- Example: Condition 1, Condition 2 etc
CREATE GENERATOR lookup_quote_condition_code_seq;
CREATE TABLE lookup_quote_condition (
  code INTEGER NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Create a new table to group quote versions
CREATE GENERATOR quote_group_group_id_seq;
SET GENERATOR quote_group_group_id_seq TO 1000;
CREATE TABLE quote_group (
  group_id INTEGER NOT NULL,
  unused CHAR(1),
  PRIMARY KEY (GROUP_ID)
);

-- Adjustments to the quote_entry table
ALTER TABLE quote_entry ADD product_id INTEGER REFERENCES product_catalog(product_id);
ALTER TABLE quote_entry ADD customer_product_id INTEGER REFERENCES customer_product(customer_product_id);
ALTER TABLE quote_entry ADD opp_id INTEGER REFERENCES opportunity_header(opp_id);
ALTER TABLE quote_entry ADD "version" VARCHAR(255) DEFAULT '0' NOT NULL;
ALTER TABLE quote_entry ADD group_id INTEGER REFERENCES quote_group(group_id);
ALTER TABLE quote_entry ADD CONSTRAINT CHK_NOTNULL CHECK(group_id IS NOT NULL);
ALTER TABLE quote_entry ADD delivery_id INTEGER REFERENCES lookup_quote_delivery(code);
ALTER TABLE quote_entry ADD email_address BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD phone_number BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD address BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD fax_number BLOB SUB_TYPE 1 SEGMENT SIZE 100;
ALTER TABLE quote_entry ADD submit_action INTEGER;
ALTER TABLE quote_entry ADD closed TIMESTAMP;
ALTER TABLE quote_entry ADD show_total BOOLEAN DEFAULT TRUE;
ALTER TABLE quote_entry ADD show_subtotal BOOLEAN DEFAULT TRUE;
ALTER TABLE quote_entry ADD logo_file_id INTEGER REFERENCES project_files(item_id);
ALTER TABLE quote_entry ADD trashed_date TIMESTAMP;

-- Create a new table to map quote conditions to a quote
CREATE GENERATOR quote_condition_map_id_seq;
CREATE TABLE quote_condition (
  map_id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  condition_id INTEGER NOT NULL REFERENCES lookup_quote_condition(code),
  PRIMARY KEY (MAP_ID)
);

-- Create a new table to log the quote history
CREATE GENERATOR quotelog_id_seq;
CREATE TABLE quotelog (
  id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  source_id INTEGER REFERENCES lookup_quote_source(code),
  status_id INTEGER REFERENCES lookup_quote_status(code),
  terms_id INTEGER REFERENCES lookup_quote_terms(code),
  type_id INTEGER REFERENCES lookup_quote_type(code),
  delivery_id INTEGER REFERENCES lookup_quote_delivery(code),
  notes BLOB SUB_TYPE 1 SEGMENT SIZE 100 ,
  grand_total FLOAT,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  entered TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL ,
  issued_date TIMESTAMP,
  submit_action INTEGER,
  closed TIMESTAMP,
  PRIMARY KEY (ID)
);


-- Create a new table to lookup quote remarks
CREATE GENERATOR lookup_quote_remarks_code_seq;
CREATE TABLE lookup_quote_remarks (
  code INTEGER   NOT NULL,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT FALSE,
  "level" INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT TRUE,
  PRIMARY KEY (CODE)
);

-- Create a new table to map remarks to a quote
CREATE GENERATOR quote_remark_map_id_seq;
CREATE TABLE quote_remark (
  map_id INTEGER  NOT NULL,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  remark_id INTEGER NOT NULL REFERENCES lookup_quote_remarks(code),
  PRIMARY KEY (MAP_ID)
);

-- Each quote has notes
-- Example: Notes entered by Advertiser, Notes entered by Designer
CREATE GENERATOR quote_notes_notes_id_seq;
CREATE TABLE quote_notes (
  notes_id INTEGER  NOT NULL,
  quote_id INTEGER REFERENCES quote_entry(quote_id),
  notes BLOB SUB_TYPE 1 SEGMENT SIZE 100,
  enteredby INTEGER NOT NULL REFERENCES "access"(user_id),
  entered TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL,
  modifiedby INTEGER NOT NULL REFERENCES "access"(user_id),
  modified TIMESTAMP  DEFAULT CURRENT_TIMESTAMP NOT NULL,
  PRIMARY KEY (NOTES_ID)
);
