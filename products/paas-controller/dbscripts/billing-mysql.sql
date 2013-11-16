/*
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements. See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership. The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License. You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied. See the License for the
* specific language governing permissions and limitations
* under the License.
*/ 

CREATE TABLE IF NOT EXISTS BC_CUSTOMER (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_NAME VARCHAR (64),
             BC_STARTED_DATE TIMESTAMP,
             BC_EMAIL VARCHAR (64),
             BC_ADDRESS VARCHAR (256),
             CONSTRAINT PK_BC_CUSTOMER PRIMARY KEY (BC_ID)
)ENGINE INNODB;

CREATE INDEX BC_CUSTOMER_IND_BY_BC_NAME USING HASH ON BC_CUSTOMER(BC_NAME);
CREATE INDEX BC_CUSTOMER_IND_BY_BC_EMAIL USING HASH ON BC_CUSTOMER(BC_EMAIL);

CREATE TABLE IF NOT EXISTS BC_ITEM (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_NAME VARCHAR (64),
             BC_COST VARCHAR (64),
             BC_DESCRIPTION VARCHAR(128),
             BC_PARENT_ITEM_ID INTEGER,
             CONSTRAINT PK_BC_ITEM PRIMARY KEY (BC_ID)
)ENGINE INNODB;
INSERT INTO BC_ITEM (BC_NAME,BC_COST,BC_DESCRIPTION,BC_PARENT_ITEM_ID) values ("Demo",NULL,NULL,NULL);
INSERT INTO BC_ITEM (BC_NAME,BC_COST,BC_DESCRIPTION,BC_PARENT_ITEM_ID) values ("SMB",NULL,NULL,NULL);
INSERT INTO BC_ITEM (BC_NAME,BC_COST,BC_DESCRIPTION,BC_PARENT_ITEM_ID) values ("Professional",NULL,NULL,NULL);
INSERT INTO BC_ITEM (BC_NAME,BC_COST,BC_DESCRIPTION,BC_PARENT_ITEM_ID) values ("Enterprise",NULL,NULL,NULL);

ALTER TABLE BC_ITEM ADD CONSTRAINT BC_ITEM_FK_BY_PARENT_ITEM_ID FOREIGN KEY (BC_PARENT_ITEM_ID) REFERENCES BC_ITEM (BC_ID);


CREATE TABLE IF NOT EXISTS BC_SUBSCRIPTION (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_FILTER VARCHAR (32),
             BC_IS_ACTIVE INTEGER,
             BC_ACTIVE_SINCE TIMESTAMP,
             BC_ACTIVE_UNTIL TIMESTAMP,
             BC_ITEM_ID INTEGER,
             BC_TENANT_ID INTEGER,
             CONSTRAINT PK_BC_SUBSCRIPTION PRIMARY KEY (BC_ID)
)ENGINE INNODB;

ALTER TABLE BC_SUBSCRIPTION ADD CONSTRAINT BC_SUBSCRIPTION_FK_BY_ITEM_ID FOREIGN KEY (BC_ITEM_ID) REFERENCES BC_ITEM (BC_ID);

CREATE TABLE IF NOT EXISTS BC_INVOICE (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_TENANT_ID INTEGER,
             BC_DATE TIMESTAMP,
             BC_START_DATE TIMESTAMP,
             BC_END_DATE TIMESTAMP,
             BC_BOUGHT_FORWARD VARCHAR (64),
             BC_CARRIED_FORWARD VARCHAR (64),
             BC_TOTAL_PAYMENTS VARCHAR (64),
             BC_TOTAL_COST VARCHAR (64),
             CONSTRAINT PK_BC_INVOICE PRIMARY KEY (BC_ID)
)ENGINE INNODB;


CREATE TABLE IF NOT EXISTS BC_PAYMENT (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_DATE TIMESTAMP,
             BC_AMOUNT VARCHAR (64),
             BC_DESCRIPTION VARCHAR (128),
             BC_INVOICE_ID INTEGER,
	     BC_TENANT_ID INTEGER,	
             CONSTRAINT PK_BC_SUBSCRIPTION_ORDER PRIMARY KEY (BC_ID)
)ENGINE INNODB;

ALTER TABLE BC_PAYMENT ADD CONSTRAINT BC_PAYMENT_FK_BY_INVOICE_ID FOREIGN KEY (BC_INVOICE_ID) REFERENCES BC_INVOICE (BC_ID);

CREATE TABLE IF NOT EXISTS BC_REGISTRATION_PAYMENT (
             BC_ID INTEGER AUTO_INCREMENT,
             BC_DATE TIMESTAMP,
             BC_AMOUNT VARCHAR (64),
             BC_DESCRIPTION VARCHAR (128),
			 BC_USAGE_PLAN VARCHAR (64),
	     	 BC_TENANT_ID INTEGER,	
             CONSTRAINT PK_BC_REGISTRATION_PAYMENT PRIMARY KEY (BC_ID)
)ENGINE INNODB;

-- this is n-n relationship
CREATE TABLE IF NOT EXISTS BC_PAYMENT_SUBSCRIPTION (
             BC_PAYMENT_ID INTEGER,
             BC_SUBSCRIPTION_ID INTEGER,
             CONSTRAINT PK_BC_SUBSCRIPTION_ORDER PRIMARY KEY (BC_PAYMENT_ID, BC_SUBSCRIPTION_ID)
)ENGINE INNODB;

ALTER TABLE BC_PAYMENT_SUBSCRIPTION ADD CONSTRAINT BC_PAYMENT_SUBSCRIPTION_FK_BY_PAYMENT_ID FOREIGN KEY (BC_PAYMENT_ID) REFERENCES BC_PAYMENT (BC_ID);
ALTER TABLE BC_PAYMENT_SUBSCRIPTION ADD CONSTRAINT BC_PAYMENT_SUBSCRIPTION_FK_BY_SUBSCRIPTION_ID FOREIGN KEY (BC_SUBSCRIPTION_ID) REFERENCES BC_SUBSCRIPTION (BC_ID);

CREATE TABLE IF NOT EXISTS BC_INVOICE_SUBSCRIPTION (
             BC_ID INTEGER  AUTO_INCREMENT,
             BC_INVOICE_ID INTEGER,
             BC_SUBSCRIPTION_ID INTEGER,
             CONSTRAINT PK_BC_INVOICE_ITEM PRIMARY KEY (BC_ID)
)ENGINE INNODB;

ALTER TABLE BC_INVOICE_SUBSCRIPTION ADD CONSTRAINT BC_INVOICE_SUBSCRIPTION_FK_BY_INVOICE_ID FOREIGN KEY (BC_INVOICE_ID) REFERENCES BC_INVOICE (BC_ID);
ALTER TABLE BC_INVOICE_SUBSCRIPTION ADD CONSTRAINT BC_INVOICE_SUBSCRIPTION_FK_BY_SUBSCRIPTION_ID FOREIGN KEY (BC_SUBSCRIPTION_ID) REFERENCES BC_SUBSCRIPTION (BC_ID);


CREATE TABLE IF NOT EXISTS BC_INVOICE_SUBSCRIPTION_ITEM (
             BC_INVOICE_SUBSCRIPTION_ID INTEGER,
             BC_ITEM_ID INTEGER,
             BC_COST VARCHAR (64),
	     BC_DESCRIPTION varchar (64),	
             CONSTRAINT PK_BC_INVOICE_SUBSCRIPTION_ITEM PRIMARY KEY (BC_INVOICE_SUBSCRIPTION_ID, BC_ITEM_ID)
)ENGINE INNODB;

ALTER TABLE BC_INVOICE_SUBSCRIPTION_ITEM ADD CONSTRAINT BC_INVOICE_SUBSCRIPTION_ITEM_FK_BY_INVOICE_SUBSCRIPTION_ID FOREIGN KEY (BC_INVOICE_SUBSCRIPTION_ID) REFERENCES BC_INVOICE_SUBSCRIPTION (BC_ID);
ALTER TABLE BC_INVOICE_SUBSCRIPTION_ITEM ADD CONSTRAINT BC_INVOICE_SUBSCRIPTION_ITEM_FK_BY_ITEM_ID FOREIGN KEY (BC_ITEM_ID) REFERENCES BC_ITEM(BC_ID);

CREATE TABLE IF NOT EXISTS BC_DISCOUNT (
        BC_ID INTEGER AUTO_INCREMENT,
        BC_TENANT_ID INTEGER,
        BC_PERCENTAGE FLOAT,
        BC_AMOUNT FLOAT,
        BC_START_DATE TIMESTAMP,
        BC_END_DATE TIMESTAMP,
        BC_PERCENTAGE_TYPE INTEGER,
        CONSTRAINT PK_BC_DISCOUNT PRIMARY KEY (BC_ID)
)ENGINE INNODB;

