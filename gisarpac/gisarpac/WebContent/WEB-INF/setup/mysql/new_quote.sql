-- ----------------------------------------------------------------------------
--  MySQL Table Creation
--
--  @author     Andrei I. Holub
--  @created    August 2, 2006
--  @version    $Id:$
-- ----------------------------------------------------------------------------

-- This schema represents an Quote Entry System.
-- REQUIRES: new_product.sql
-- REQUIRES: new_project.sql

-- Each quote can have a status, which changes as the quote is completed
-- Example: Pending, In Progress, Cancelled, Rejected, Completed
CREATE TABLE lookup_quote_status (
  code INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT true,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL
);

CREATE TRIGGER lookup_quote_status_entries BEFORE INSERT ON lookup_quote_status FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

-- Each quote has a type
-- Example: New, Change, Upgrade/Downgrade, Disconnect, Move, Refund, Suspend, Unsuspend
CREATE TABLE lookup_quote_type (
  code INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT true,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL
);

CREATE TRIGGER lookup_quote_type_entries BEFORE INSERT ON lookup_quote_type FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

-- Each quote has terms in which the quote was placed
CREATE TABLE lookup_quote_terms (
  code INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT true,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL
);

CREATE TRIGGER lookup_quote_terms_entries BEFORE INSERT ON lookup_quote_terms FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

-- Each quote has a type of origination
-- Example: Online, Email, Incoming Phone Call, Outgoing Phone Call, Mail
CREATE TABLE lookup_quote_source (
  code INT AUTO_INCREMENT PRIMARY KEY,
  description VARCHAR(300) NOT NULL,
  default_item BOOLEAN DEFAULT false,
  level INTEGER DEFAULT 0,
  enabled BOOLEAN DEFAULT true,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL
);

CREATE TRIGGER lookup_quote_source_entries BEFORE INSERT ON lookup_quote_source FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

-- The details of a quote are listed
-- A quote can be requested by an organization, or a specific contact in an organization.
CREATE TABLE quote_entry (
  quote_id INT AUTO_INCREMENT PRIMARY KEY,
  parent_id INT REFERENCES quote_entry(quote_id),
  org_id INTEGER REFERENCES organization(org_id),
  contact_id INT REFERENCES contact(contact_id),
  source_id INTEGER REFERENCES lookup_quote_source(code),
  grand_total FLOAT,
  status_id INTEGER REFERENCES lookup_quote_status(code),
  status_date TIMESTAMP NULL,
  expiration_date TIMESTAMP NULL,
  quote_terms_id INTEGER REFERENCES lookup_quote_terms(code),
  quote_type_id INTEGER REFERENCES lookup_quote_type(code),
  issued TIMESTAMP NULL,
  short_description TEXT,
  notes TEXT NULL,
  ticketid INTEGER REFERENCES ticket(ticketid),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES `access`(user_id),
  modified TIMESTAMP NULL,
  modifiedby INT NOT NULL REFERENCES `access`(user_id)
);

CREATE TRIGGER quote_entry_entries BEFORE INSERT ON quote_entry FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

-- Each quote can contain multiple products(line items)
CREATE TABLE quote_product (
  item_id INT AUTO_INCREMENT PRIMARY KEY,
  quote_id INTEGER NOT NULL REFERENCES quote_entry(quote_id),
  product_id INTEGER NOT NULL REFERENCES product_catalog(product_id),
  quantity INTEGER NOT NULL DEFAULT 0,
  price_currency INTEGER REFERENCES lookup_currency(code),
  price_amount FLOAT NOT NULL DEFAULT 0,
  recurring_currency INTEGER REFERENCES lookup_currency(code),
  recurring_amount FLOAT NOT NULL DEFAULT 0,
  recurring_type INTEGER REFERENCES lookup_recurring_type(code),
  extended_price FLOAT NOT NULL DEFAULT 0,
  total_price FLOAT NOT NULL DEFAULT 0,
  estimated_delivery_date TIMESTAMP NULL,
  status_id INTEGER REFERENCES lookup_quote_status(code),
  status_date TIMESTAMP NULL,
  estimated_delivery TEXT,
  comment VARCHAR(300)
);

-- Each quote_product can have configurable options
CREATE TABLE quote_product_options (
  quote_product_option_id INT AUTO_INCREMENT PRIMARY KEY,
  item_id INTEGER NOT NULL REFERENCES quote_product(item_id),
  product_option_id INTEGER NOT NULL REFERENCES product_option_map(product_option_id),
  quantity INTEGER NOT NULL DEFAULT 0,
  price_currency INTEGER REFERENCES lookup_currency(code),
  price_amount FLOAT NOT NULL DEFAULT 0,
  recurring_currency INTEGER REFERENCES lookup_currency(code),
  recurring_amount FLOAT NOT NULL DEFAULT 0,
  recurring_type INTEGER REFERENCES lookup_recurring_type(code),
  extended_price FLOAT NOT NULL DEFAULT 0,
  total_price FLOAT NOT NULL DEFAULT 0,
  status_id INTEGER REFERENCES lookup_quote_status(code)
);

CREATE TABLE quote_product_option_boolean (
  quote_product_option_id INTEGER REFERENCES quote_product_options(quote_product_option_id),
  value BOOLEAN NOT NULL,
  id INTEGER
);

CREATE TABLE quote_product_option_float (
  quote_product_option_id INTEGER REFERENCES quote_product_options(quote_product_option_id),
  value FLOAT NOT NULL,
  id INTEGER
);

CREATE TABLE quote_product_option_timestamp (
  quote_product_option_id INTEGER REFERENCES quote_product_options(quote_product_option_id),
  value TIMESTAMP NULL,
  id INTEGER
);

CREATE TABLE quote_product_option_integer (
  quote_product_option_id INTEGER REFERENCES quote_product_options(quote_product_option_id),
  value INTEGER NOT NULL,
  id INTEGER
);

CREATE TABLE quote_product_option_text (
  quote_product_option_id INTEGER REFERENCES quote_product_options(quote_product_option_id),
  value TEXT NOT NULL,
  id INTEGER
);
