-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 5. Usuario.sql
-- ============================================================================

-- 1. Rol para Terminales de Venta / Cajas POS
CREATE ROLE rol_pos_oracle;
GRANT CREATE SESSION TO rol_pos_oracle;
GRANT SELECT, INSERT ON facturafacil_owner.documentos_tributarios TO rol_pos_oracle;
GRANT SELECT ON facturafacil_owner.cliente_receptor TO rol_pos_oracle;
GRANT EXECUTE ON facturafacil_owner.sp_emitir_cpe_oracle TO rol_pos_oracle;

-- 2. Rol para Auditores Fiscales y Contabilidad
CREATE ROLE rol_auditor_oracle;
GRANT CREATE SESSION TO rol_auditor_oracle;
GRANT SELECT ON facturafacil_owner.empresa_emisora TO rol_auditor_oracle;
GRANT SELECT ON facturafacil_owner.cliente_receptor TO rol_auditor_oracle;
GRANT SELECT ON facturafacil_owner.documentos_tributarios TO rol_auditor_oracle;

-- 3. Creación de Usuarios de Aplicación y Asignación de Roles
CREATE USER usr_caja_lima IDENTIFIED BY "CajaLima2026!"
    DEFAULT TABLESPACE ts_facturafacil;
GRANT rol_pos_oracle TO usr_caja_lima;

CREATE USER usr_auditor_sunat IDENTIFIED BY "AuditorSunat2026!"
    DEFAULT TABLESPACE ts_facturafacil;
GRANT rol_auditor_oracle TO usr_auditor_sunat;
