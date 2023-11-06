--  Upgrade script for altering the product catalog 
--  for the following
--  - Product Option Configurator
--  - Product Option
--  - Product Option Values
--  - Product Option Map
--  - Product Option Properties

-- Product Option Configurator
ALTER TABLE product_option_configurator ADD configurator_name VARCHAR(300);
ALTER TABLE product_option_configurator ALTER configurator_name SET NOT NULL;

-- Product Option
ALTER TABLE product_option ADD COLUMN option_name VARCHAR(300);
ALTER TABLE product_option ADD COLUMN has_range BOOLEAN;
ALTER TABLE product_option ADD COLUMN has_multiplier BOOLEAN;

ALTER TABLE product_option ALTER enabled SET DEFAULT false;
ALTER TABLE product_option ALTER option_name SET NOT NULL;
ALTER TABLE product_option ALTER has_range SET DEFAULT false;
ALTER TABLE product_option ALTER has_multiplier SET DEFAULT false;

-- Product Option Values
ALTER TABLE product_option_values ADD enabled boolean;
ALTER TABLE product_option_values ADD value FLOAT;
ALTER TABLE product_option_values ADD multiplier FLOAT;
ALTER TABLE product_option_values ADD range_min INTEGER;
ALTER TABLE product_option_values ADD range_max INTEGER;

ALTER TABLE product_option_values ALTER enabled SET DEFAULT true;
ALTER TABLE product_option_values ALTER value SET DEFAULT 0;
ALTER TABLE product_option_values ALTER multiplier SET DEFAULT 1;
ALTER TABLE product_option_values ALTER range_min SET DEFAULT 1;
ALTER TABLE product_option_values ALTER range_max SET DEFAULT 1;

DROP INDEX "idx_pr_opt_val";
CREATE UNIQUE INDEX idx_pr_opt_val ON product_option_values (value_id, option_id, result_id);

-- Product Option Map
ALTER TABLE product_option_map DROP COLUMN value_id;

ALTER TABLE product_option_boolean ADD COLUMN id INTEGER;

ALTER TABLE product_option_float ADD COLUMN id INTEGER;

ALTER TABLE product_option_timestamp ADD COLUMN id INTEGER;

ALTER TABLE product_option_integer ADD COLUMN id INTEGER;

ALTER TABLE product_option_text ADD COLUMN id INTEGER;

