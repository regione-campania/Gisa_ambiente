-- ----------------------------------------------------------------------------
--  MySQL Table Creation
--
--  @author     Andrei I. Holub
--  @created    August 2, 2006
--  @version    $Id:$
-- ----------------------------------------------------------------------------
 
CREATE TABLE sync_client (
  client_id INT AUTO_INCREMENT PRIMARY KEY,
  type VARCHAR(100),
  version VARCHAR(50),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL,
  modified TIMESTAMP NULL,
  modifiedby INT NOT NULL,
  anchor TIMESTAMP NULL,
  enabled BOOLEAN DEFAULT false,
  code VARCHAR(255),
  user_id INT REFERENCES access(user_id),
  package_file_id INT REFERENCES project_files(item_id)
);

CREATE TRIGGER sync_client_entries BEFORE INSERT ON sync_client FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

CREATE TABLE sync_system (
  system_id INT AUTO_INCREMENT PRIMARY KEY,
  application_name VARCHAR(255),
  enabled BOOLEAN DEFAULT true
);

CREATE TABLE sync_table (
  table_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT NOT NULL REFERENCES sync_system(system_id),
  element_name VARCHAR(255),
  mapped_class_name VARCHAR(255),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified TIMESTAMP NULL,
  create_statement TEXT,
  order_id INT DEFAULT -1,
  sync_item BOOLEAN DEFAULT false,
  object_key VARCHAR(50)
);

CREATE TRIGGER sync_table_entries BEFORE INSERT ON sync_table FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered),
NEW.modified = IF (NEW.modified IS NULL OR NEW.modified = '0000-00-00 00:00:00', NEW.entered, NEW.modified);

CREATE TABLE sync_map (
  client_id INT NOT NULL REFERENCES sync_client(client_id),
  table_id INT NOT NULL REFERENCES sync_table(table_id),
  record_id INT NOT NULL,
  cuid INT NOT NULL,
  complete BOOLEAN DEFAULT false,
  status_date TIMESTAMP NULL
);

CREATE UNIQUE INDEX idx_sync_map ON sync_map (client_id, table_id, record_id);

CREATE TABLE sync_conflict_log (
  client_id INT NOT NULL REFERENCES sync_client(client_id),
  table_id INT NOT NULL REFERENCES sync_table(table_id),
  record_id INT NOT NULL,
  status_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sync_log (
  log_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT NOT NULL REFERENCES sync_system(system_id),
  client_id INT NOT NULL REFERENCES sync_client(client_id),
  ip VARCHAR(30),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER sync_log_entries BEFORE INSERT ON sync_log FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered);

CREATE TABLE sync_transaction_log (
  transaction_id INTEGER AUTO_INCREMENT NOT NULL PRIMARY KEY,
  log_id INT NOT NULL REFERENCES sync_log(log_id),
  reference_id VARCHAR(50),
  element_name VARCHAR(255),
  action VARCHAR(20),
  link_item_id INT,
  status_code INT,
  record_count INT,
  message TEXT
);

CREATE TABLE process_log (
  process_id INT AUTO_INCREMENT PRIMARY KEY,
  system_id INT NOT NULL REFERENCES sync_system(system_id),
  client_id INT NOT NULL REFERENCES sync_client(client_id),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  process_name VARCHAR(255),
  process_version VARCHAR(20),
  status INT,
  message TEXT
);

CREATE TRIGGER process_log_entries BEFORE INSERT ON process_log FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered);

CREATE TABLE sync_package (
  package_id INT AUTO_INCREMENT PRIMARY KEY,
  client_id INT NOT NULL REFERENCES sync_client(client_id),
  type INT NOT NULL,
  size INT DEFAULT 0,
  status_id INT NOT NULL,
  recipient INT NOT NULL,
  status_date TIMESTAMP NULL,
  last_anchor TIMESTAMP NULL,
  next_anchor TIMESTAMP NULL,
  package_file_id INT REFERENCES project_files(item_id),
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER sync_package_entries BEFORE INSERT ON sync_package FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered);

CREATE TABLE sync_package_data (
  data_id INT AUTO_INCREMENT PRIMARY KEY,
  package_id INT NOT NULL REFERENCES sync_package(package_id),
  table_id INT NOT NULL REFERENCES sync_table(table_id),
  action INT NOT NULL,
  identity_start INT NOT NULL,
  `offset` INT,
  items INT,
  last_anchor TIMESTAMP NULL,
  next_anchor TIMESTAMP NULL,
  entered TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TRIGGER sync_package_data_entries BEFORE INSERT ON sync_package_data FOR EACH ROW SET
NEW.entered = IF(NEW.entered IS NULL OR NEW.entered = '0000-00-00 00:00:00', NOW(), NEW.entered);
