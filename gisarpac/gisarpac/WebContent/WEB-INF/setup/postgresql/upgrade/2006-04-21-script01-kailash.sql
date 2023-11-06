CREATE TABLE web_layout (
  layout_id SERIAL PRIMARY KEY,
  layout_constant INT UNIQUE,
  layout_name VARCHAR(300) NOT NULL,
  jsp VARCHAR(300),
  thumbnail VARCHAR(300),
  custom BOOLEAN NOT NULL DEFAULT false
);

CREATE TABLE web_style (
  style_id SERIAL PRIMARY KEY,
  style_constant INT UNIQUE,
  style_name VARCHAR(300) NOT NULL,
  css VARCHAR(300),
  thumbnail VARCHAR(300),
  custom BOOLEAN NOT NULL DEFAULT false,
  layout_id INT REFERENCES web_layout(layout_id)
);

CREATE TABLE web_site (
  site_id SERIAL PRIMARY KEY,
  site_name VARCHAR(300) NOT NULL,
  internal_description TEXT,
  hit_count INT,
  notes TEXT,
  enabled BOOLEAN NOT NULL DEFAULT true,
  layout_id INT REFERENCES web_layout(layout_id),
  style_id INT REFERENCES web_style(style_id),
	logo_image_id INT REFERENCES project_files(item_id),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_site_log (
  site_log_id SERIAL PRIMARY KEY,
  site_id INT references web_site(site_id),
  user_id INT references access(user_id),
  username VARCHAR(80) NOT NULL,
  ip VARCHAR(80),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  browser VARCHAR(255)
);

CREATE TABLE web_tab (
  tab_id SERIAL PRIMARY KEY,
  display_text VARCHAR(300) NOT NULL,
  internal_description TEXT,
  site_id INT references web_site(site_id),
  tab_position INT NOT NULL,
  enabled BOOLEAN NOT NULL DEFAULT true,
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_page_version (
  page_version_id SERIAL PRIMARY KEY,
  version_number INT NOT NULL,
  internal_description TEXT,
  notes TEXT,
  parent_page_version_id INT REFERENCES web_page_version(page_version_id),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_page_group (
  page_group_id SERIAL PRIMARY KEY,
  group_name VARCHAR(300),
  internal_description TEXT,
  group_position INT NOT NULL,
  tab_id INT REFERENCES web_tab(tab_id),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_tab_banner (
  tab_banner_id SERIAL PRIMARY KEY,
  tab_id INT REFERENCES web_tab(tab_id),
  image_id INT REFERENCES project_files(item_id),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_page (
  page_id SERIAL PRIMARY KEY,
  page_name VARCHAR(300),
  page_position INT NOT NULL,
  active_page_version_id INT REFERENCES web_page_version(page_version_id),
  construction_page_version_id INT REFERENCES web_page_version(page_version_id),
  page_group_id INT REFERENCES web_page_group(page_group_id),
  tab_banner_id INT REFERENCES web_tab_banner(tab_banner_id),
  notes TEXT,
  enabled BOOLEAN NOT NULL DEFAULT true,
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

ALTER TABLE web_page_version ADD COLUMN page_id INT REFERENCES web_page(page_id);

CREATE TABLE web_page_row (
  page_row_id SERIAL PRIMARY KEY,
  row_position INT NOT NULL,
  page_version_id INT REFERENCES web_page_version(page_version_id),
  enabled BOOLEAN NOT NULL DEFAULT true,
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

CREATE TABLE web_icelet (
  icelet_id SERIAL PRIMARY KEY,
  icelet_name VARCHAR(300) NOT NULL,
  icelet_description TEXT,
  icelet_configurator_class VARCHAR(300) NOT NULL UNIQUE,
  icelet_version INT,
  enabled BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE web_row_column (
  row_column_id SERIAL PRIMARY KEY,
  column_position INT NOT NULL,
  width INT,
  page_row_id INT REFERENCES web_page_row(page_row_id),
  icelet_id INT REFERENCES web_icelet(icelet_id),
  enabled BOOLEAN NOT NULL DEFAULT true,
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);

ALTER TABLE web_page_row ADD COLUMN row_column_id INT REFERENCES web_row_column(row_column_id);

CREATE TABLE web_icelet_property (
  property_id SERIAL  PRIMARY KEY,
  property_type_constant INT,
  property_value TEXT,
  row_column_id INT NOT NULL REFERENCES web_row_column(row_column_id),
  entered TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  modified TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT NOT NULL REFERENCES access(user_id)
);