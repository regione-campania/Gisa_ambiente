/* Supporting table for scheduled business processes */

CREATE TABLE business_process_log (
  process_name VARCHAR(255) UNIQUE NOT NULL,
  anchor DATETIME NOT NULL
);
