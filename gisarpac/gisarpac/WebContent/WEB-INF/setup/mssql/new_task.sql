/**
 *  MSSQL Table Creation
 *
 *@author     matt rajkowski
 *@created    October 2, 2002
 *@version    $Id: new_task.sql 15115 2006-05-31 16:47:51Z matt $
 */

CREATE TABLE lookup_task_priority (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(50) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE lookup_task_loe (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(50) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE lookup_task_category (
  code INT IDENTITY PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE lookup_ticket_task_category (
  code INTEGER IDENTITY PRIMARY KEY,
  description VARCHAR(255) NOT NULL,
  default_item BIT DEFAULT 0,
  level INTEGER DEFAULT 0,
  enabled BIT DEFAULT 1
);

CREATE TABLE task (
  task_id INT IDENTITY PRIMARY KEY,
  entered DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  enteredby INT NOT NULL REFERENCES access(user_id),
  priority INTEGER NOT NULL REFERENCES lookup_task_priority,
  description VARCHAR(255),
  duedate DATETIME,
  reminderid INT,
  notes TEXT,
  sharing INT NOT NULL,
  complete BIT DEFAULT 0 NOT NULL,
  enabled BIT DEFAULT 0 NOT NULL,
  modified DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modifiedby INT REFERENCES access(user_id),
  estimatedloe FLOAT,
  estimatedloetype INTEGER REFERENCES lookup_task_loe,
  type INTEGER DEFAULT 1,
  owner INTEGER REFERENCES access(user_id),
  completedate DATETIME,
  category_id INTEGER REFERENCES lookup_task_category,
  duedate_timezone VARCHAR(255),
  trashed_date DATETIME,
  ticket_task_category_id INTEGER REFERENCES lookup_ticket_task_category(code)
);

CREATE TABLE tasklink_contact (
  task_id INT NOT NULL REFERENCES task,
  contact_id INT NOT NULL REFERENCES contact(contact_id),
  notes TEXT
);

CREATE TABLE tasklink_ticket (
  task_id INT NOT NULL REFERENCES task,
  ticket_id INT NOT NULL REFERENCES ticket(ticketid),
  category_id INT REFERENCES lookup_ticket_task_category(code)
);

CREATE TABLE tasklink_project (
  task_id INT NOT NULL REFERENCES task,
  project_id INT NOT NULL REFERENCES projects(project_id)
);

CREATE TABLE taskcategory_project (
  category_id INTEGER NOT NULL REFERENCES lookup_task_category,
  project_id INTEGER NOT NULL REFERENCES projects(project_id)
);

CREATE TABLE taskcategorylink_news (
  news_id INTEGER NOT NULL REFERENCES project_news(news_id),
  category_id INTEGER NOT NULL REFERENCES lookup_task_category
);
