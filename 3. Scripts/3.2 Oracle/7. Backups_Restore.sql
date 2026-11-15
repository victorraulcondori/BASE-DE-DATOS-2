-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 7. Backups_Restore.sql
-- ============================================================================

-- COMANDO 1: Configuración de Directorio de Respaldo en Oracle
-- Conectarse como SYSDBA o SYSTEM:
-- CREATE OR REPLACE DIRECTORY dpump_dir AS '/opt/oracle/admin/XE/dpdump';
-- GRANT READ, WRITE ON DIRECTORY dpump_dir TO facturafacil_owner;

-- COMANDO 2: Exportación Lógica Completa con Oracle Data Pump (expdp)
-- Ejecutar en línea de comandos (cmd / bash):
-- expdp facturafacil_owner/OraclePass2026! \
--       SCHEMAS=facturafacil_owner \
--       DIRECTORY=dpump_dir \
--       DUMPFILE=facturafacil_ora_%U.dmp \
--       LOGFILE=facturafacil_expdp.log \
--       COMPRESSION=ALL \
--       PARALLEL=2

-- COMANDO 3: Restauración Lógica Completa con Oracle Data Pump (impdp)
-- impdp facturafacil_owner/OraclePass2026! \
--       SCHEMAS=facturafacil_owner \
--       DIRECTORY=dpump_dir \
--       DUMPFILE=facturafacil_ora_%U.dmp \
--       LOGFILE=facturafacil_impdp.log \
--       TABLE_EXISTS_ACTION=REPLACE
