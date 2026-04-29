-- Script para corrigir permissões no PostgreSQL
-- Execute como superuser (postgres)

-- Conectar à database iot_db
\c iot_db

-- Conceder privilégios ao schema public para o usuário usado no app
-- Substitua bloguser pelo usuário do DATABASE_URL, se for outro.
GRANT USAGE ON SCHEMA public TO bloguser;
GRANT CREATE ON SCHEMA public TO bloguser;

-- Conceder privilégios às tabelas futuras
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO bloguser;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO bloguser;

-- Se a tabela já existir, conceder permissões também
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO bloguser;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO bloguser;

-- Reiniciar a conexão após essas mudanças
