CREATE TABLE IF NOT EXISTS profile
(
    id                SERIAL PRIMARY KEY,
    email             VARCHAR(100) NOT NULL UNIQUE,
    last_name          VARCHAR(256) ,
    user_id           VARCHAR(100) NOT NULL UNIQUE,
    create_date       TIMESTAMP,
    identifier        VARCHAR(100),
    address           VARCHAR(256),
    first_name        VARCHAR(256),
    telephone         VARCHAR(256),
    mobile            VARCHAR(256),
    nationality       VARCHAR(256),
    gender            VARCHAR(50),
    birth_date        TIMESTAMP,
    status            VARCHAR(100),
    postal_code       VARCHAR(100),
    creator           VARCHAR(100),
    last_update_date  TIMESTAMP DEFAULT CURRENT_DATE,
    kyc_level varchar(100)
 );

CREATE TABLE IF NOT EXISTS profile_history
(
    id                SERIAL PRIMARY KEY,
    email             VARCHAR(100) NOT NULL ,
    last_name            VARCHAR(256) ,
    user_id           VARCHAR(100) NOT NULL ,
    create_date       TIMESTAMP,
    identifier        VARCHAR(100),
    address           VARCHAR(256),
    first_name        VARCHAR(256),
    telephone         VARCHAR(256),
    mobile            VARCHAR(256),
    nationality       VARCHAR(256),
    gender            BOOLEAN,
    birth_date        TIMESTAMP,
    status            VARCHAR(100),
    last_update_date  TIMESTAMP,
    original_data_id  VARCHAR(100) NOT NULL,
    creator           VARCHAR(100),
    issuer            VARCHAR(100) ,
    postal_code            VARCHAR(100),
    change_request_date TIMESTAMP,
    change_request_type VARCHAR(100),
    kyc_level varchar(100)

    );


CREATE TABLE IF NOT EXISTS limitation
(
    id                SERIAL PRIMARY KEY,
    user_id           VARCHAR(100) NOT NULL,
    action_type       VARCHAR(100),
    create_date       TIMESTAMP,
    exp_time          VARCHAR(100),
    detail            VARCHAR(100),
    limitation_on     VARCHAR(100) UNIQUE NOT NULL,
    description       VARCHAR(100),
    reason             VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS limitation_history
(
    id                SERIAL PRIMARY KEY,
    user_id           VARCHAR(100) NOT NULL,
    action_type       VARCHAR(100),
    create_date       TIMESTAMP,
    exp_time          VARCHAR(100),
    detail            VARCHAR(100),
    issuer            VARCHAR(100) ,
    change_request_date TIMESTAMP,
    change_request_type VARCHAR(100),
    limitation_on     VARCHAR(100),
    description       VARCHAR(100),
    reason             VARCHAR(100)
    );

CREATE TABLE IF NOT EXISTS linked_bank_account
(
    id                SERIAL PRIMARY KEY,
    user_id           VARCHAR(100) NOT NULL,
    bank_account_type       VARCHAR(100),
    register_date       TIMESTAMP,
    verified_date     TIMESTAMP,
    enable          BOOLEAN,
    verify           BOOLEAN,
    verifier            VARCHAR(100),
    number            VARCHAR(100) ,
    account_id          VARCHAR(100) UNIQUE,
    description         VARCHAR(100)
    );


ALTER TABLE linked_bank_account ADD CONSTRAINT unique_account UNIQUE(user_id,number);

CREATE TABLE IF NOT EXISTS linked_bank_account_history
(
    id                SERIAL PRIMARY KEY,
    user_id           VARCHAR(100) NOT NULL,
    bank_account_type       VARCHAR(100),
    register_date       TIMESTAMP,
    verified_date     TIMESTAMP,
    enable          BOOLEAN,
    verify           BOOLEAN,
    verifier            VARCHAR(100),
    number            VARCHAR(100) ,
    account_id          VARCHAR(100),
    description         VARCHAR(100),
    change_request_date TIMESTAMP,
    change_request_type VARCHAR(100)
    );

-- Alter table limitation_history add column reason Varchar(100);



DROP TRIGGER IF EXISTS profile_log_update on public.profile;
DROP TRIGGER IF EXISTS profile_log_delete on public.profile;

DROP TRIGGER IF EXISTS limitation_log_update on public.limitation;
DROP TRIGGER IF EXISTS limitation_log_delete on public.limitation;

DROP TRIGGER IF EXISTS linked_account_log_update on public.linked_bank_account;
DROP TRIGGER IF EXISTS linked_account_log_delete on public.linked_bank_account;


CREATE OR REPLACE FUNCTION triger_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.profile_history (original_data_id,change_request_date,change_request_type,email,user_id,create_date,identifier,address,first_name,last_name,mobile,telephone,nationality,gender,birth_date,status,postal_code,creator,kyc_level)
VALUES(OLD.id,now(),'UPDATE',OLD.email,OLD.user_id,OLD.create_date,OLD.identifier,OLD.address,OLD.first_name,OLD.last_name,OLD.mobile,OLD.telephone,OLD.nationality,OLD.gender,OLD.birth_date,OLD.status,OLD.postal_code,OLD.creator,OLD.kyc_level);
RETURN NULL;
END;
$BODY$
language plpgsql;




CREATE OR REPLACE FUNCTION triger_delete_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.profile_history (original_data_id,change_request_date,change_request_type,email,user_id,create_date,identifier,address,first_name,last_name,mobile,telephone,nationality,gender,birth_date,status,postal_code,creator,kyc_level)
VALUES(OLD.id,now(),'DELETE',OLD.email,OLD.user_id,OLD.create_date,OLD.identifier,OLD.address,OLD.first_name,OLD.last_name,OLD.mobile,OLD.telephone,OLD.nationality,OLD.gender,OLD.birth_date,OLD.status,OLD.postal_code,OLD.creator,OLD.kyc_level);
RETURN NULL;
END;
$BODY$
language plpgsql;



CREATE OR REPLACE FUNCTION triger_limitation_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.limitation_history (change_request_date,change_request_type,user_id,create_date,action_type,exp_time,detail,limitation_on,description,reason)
VALUES(now(),'UPDATE',OLD.user_id,OLD.create_date,OLD.action_type,OLD.exp_time,OLD.detail,OLD.limitation_on,OLD.description,OLD.reason);
RETURN NULL;
END;
$BODY$
language plpgsql;




CREATE OR REPLACE FUNCTION triger_delete_limitation_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.limitation_history (change_request_date,change_request_type,user_id,create_date,action_type,exp_time,detail,limitation_on,description,reason)
VALUES(now(),'DELETE',OLD.user_id,OLD.create_date,OLD.action_type,OLD.exp_time,OLD.detail,OLD.limitation_on,OLD.description,OLD.reason);
RETURN NULL;
END;
$BODY$
language plpgsql;



CREATE OR REPLACE FUNCTION triger_linked_account_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.linked_bank_account_history (change_request_date,change_request_type,user_id,verified_date,enable,verify,verifier,number,description,account_id)
VALUES(now(),'UPDATE',OLD.user_id,OLD.verified_date,OLD.enable,OLD.verify,OLD.verifier,OLD.number,OLD.description,OLD.account_id);
RETURN NULL;
END;
$BODY$
language plpgsql;


CREATE OR REPLACE FUNCTION triger_delete_linked_account_function() RETURNS TRIGGER AS
$BODY$
BEGIN
INSERT INTO public.linked_bank_account_history (change_request_date,change_request_type,user_id,verified_date,enable,verify,verifier,number,description,account_id)
VALUES(now(),'DELETE',OLD.user_id,OLD.verified_date,OLD.enable,OLD.verify,OLD.verifier,OLD.number,OLD.description,OLD.account_id);
RETURN NULL;
END;
$BODY$
language plpgsql;



CREATE TRIGGER  profile_log_update  AFTER UPDATE ON profile FOR EACH ROW   EXECUTE PROCEDURE triger_function();
CREATE TRIGGER  profile_log_delete  AFTER DELETE ON profile  FOR EACH ROW  EXECUTE PROCEDURE triger_delete_function() ;


CREATE TRIGGER  limitation_log_update  AFTER UPDATE ON limitation FOR EACH ROW   EXECUTE PROCEDURE triger_limitation_function();
CREATE TRIGGER  limitation_log_delete  AFTER DELETE ON limitation  FOR EACH ROW  EXECUTE PROCEDURE triger_delete_limitation_function() ;



CREATE TRIGGER  linked_account_log_update  AFTER UPDATE ON linked_bank_account FOR EACH ROW   EXECUTE PROCEDURE triger_linked_account_function();
CREATE TRIGGER  linked_account_log_delete  AFTER DELETE ON linked_bank_account  FOR EACH ROW  EXECUTE PROCEDURE triger_delete_linked_account_function() ;