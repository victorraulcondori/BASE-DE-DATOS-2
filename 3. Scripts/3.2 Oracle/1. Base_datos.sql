-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 1. Base_datos.sql
-- ============================================================================

-- 1. Creación del Tablespace Dedicado para Almacenamiento Fiscal
CREATE TABLESPACE ts_facturafacil 
    DATAFILE 'ts_facturafacil.dbf' 
    SIZE 100M 
    AUTOEXTEND ON NEXT 50M 
    MAXSIZE UNLIMITED;

-- 2. Creación del Esquema / Usuario Propietario
CREATE USER facturafacil_owner 
    IDENTIFIED BY "OraclePass2026!"
    DEFAULT TABLESPACE ts_facturafacil
    TEMPORARY TABLESPACE temp
    QUOTA UNLIMITED ON ts_facturafacil;

-- 3. Asignación de Roles y Privilegios del Sistema
GRANT CONNECT, RESOURCE TO facturafacil_owner;
GRANT CREATE VIEW, CREATE PROCEDURE, CREATE SEQUENCE, CREATE TABLE TO facturafacil_owner;

-- 4. Confirmación de Entorno
ALTER SESSION SET CURRENT_SCHEMA = facturafacil_owner;
