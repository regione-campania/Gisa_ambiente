CREATE SEQUENCE message_file__ttachment_id_seq AS DECIMAL(27,0);
CREATE TABLE message_file_attachment (
  attachment_id INTEGER NOT NULL PRIMARY KEY,
  link_module_id INT NOT NULL,
  link_item_id INT NOT NULL,
  file_item_id INT REFERENCES project_files(item_id),
  filename VARGRAPHIC(255) NOT NULL,
  "size" INT DEFAULT 0,
  "version" FLOAT DEFAULT 0
);

CREATE INDEX message_f_link_mo1 ON message_file_attachment(link_module_id);
CREATE INDEX message_f_link_it1 ON message_file_attachment(link_item_id);
