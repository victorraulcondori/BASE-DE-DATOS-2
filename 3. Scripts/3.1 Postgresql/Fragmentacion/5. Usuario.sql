-- ============================================================================
-- 5. SEGURIDAD Y CONTROL DE ACCESO BASADO EN ROLES (RBAC) EN POSTGRESQL
-- ============================================================================

\c facturafacil_postgres;

-- 1. Rol POS Facturador (Emisión en cajas registradoras y terminales móviles)
CREATE ROLE rol_pos_emisor WITH LOGIN PASSWORD 'PosSeguro2026!';
GRANT CONNECT ON DATABASE facturafacil_postgres TO rol_pos_emisor;
GRANT USAGE ON SCHEMA public TO rol_pos_emisor;
GRANT SELECT, INSERT ON TABLE comprobante_pago, detalle_comprobante TO rol_pos_emisor;
GRANT SELECT ON TABLE cliente_receptor, empresa_emisora TO rol_pos_emisor;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO rol_pos_emisor;

-- 2. Rol Auditor Tributario SUNAT (Solo lectura y reportes contables)
CREATE ROLE rol_auditor_fiscal WITH LOGIN PASSWORD 'AuditorSeguro2026!';
GRANT CONNECT ON DATABASE facturafacil_postgres TO rol_auditor_fiscal;
GRANT USAGE ON SCHEMA public TO rol_auditor_fiscal;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO rol_auditor_fiscal;
REVOKE INSERT, UPDATE, DELETE, TRUNCATE ON ALL TABLES IN SCHEMA public FROM rol_auditor_fiscal;
