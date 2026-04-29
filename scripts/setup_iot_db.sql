-- Script para criar o banco de dados iot_db, o usuário bloguser e conceder todas as permissões necessárias.
-- Execute este script no Query Tool do pgAdmin conectado ao banco de manutenção (por exemplo, postgres).

-- 1) Cria o usuário (role) bloguser com senha
CREATE ROLE bloguser WITH LOGIN PASSWORD '123456';

-- 2) Cria o database iot_db com owner bloguser
CREATE DATABASE iot_db
    OWNER bloguser
    ENCODING 'UTF8'
    LC_COLLATE = 'C'
    LC_CTYPE = 'C'
    TEMPLATE template0;

-- 3) Concede permissões globais no database
GRANT ALL PRIVILEGES ON DATABASE iot_db TO bloguser;

-- 4) Concede permissões no schema public dentro de iot_db
\c iot_db

GRANT USAGE ON SCHEMA public TO bloguser;
GRANT CREATE ON SCHEMA public TO bloguser;

ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bloguser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bloguser;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bloguser;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bloguser;
