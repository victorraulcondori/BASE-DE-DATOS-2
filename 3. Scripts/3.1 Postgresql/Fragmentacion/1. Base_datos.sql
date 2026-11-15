-- ============================================================================
-- PROYECTO FACTURAFÁCIL - BASE DE DATOS TRANSACCIONAL ACID POSTGRESQL 18
-- Integrantes:
-- 1. Lavado Misari, Andriv Enrique (Líder - U24285101)
-- 2. Capcha Huaman, Diogo Said (U24219405)
-- 3. Vila Huarco, Jeremi Dario (U24233812)
-- 4. Quispe Rodriguez, Jean Pierre (U24271984)
-- 5. Condori Ponce, Victor Raul (U24206253)
-- ============================================================================

-- Creación de la base de datos principal
CREATE DATABASE facturafacil_postgres
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Peru.1252'
    LC_CTYPE = 'Spanish_Peru.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

COMMENT ON DATABASE facturafacil_postgres
    IS 'Base de datos transaccional central de FacturaFácil SaaS para emisión electrónica SUNAT UBL 2.1';
