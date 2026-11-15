-- ============================================================================
-- 5. ADMINISTRACIÓN DE ROLES Y CONTROL DE ACCESO EN CASSANDRA
-- ============================================================================

-- Rol 1: Escritor de Telemetría desde dispositivos POS móviles
CREATE ROLE IF NOT EXISTS ff_telemetria_writer
    WITH PASSWORD = 'PosPassword2026!' AND LOGIN = true;

GRANT SELECT, MODIFY ON KEYSPACE facturafacil_ks TO ff_telemetria_writer;

-- Rol 2: Lector de Analítica de Solo Lectura para Reporting
CREATE ROLE IF NOT EXISTS ff_analytics_reader
    WITH PASSWORD = 'AnalystPassword2026!' AND LOGIN = true;

GRANT SELECT ON TABLE facturafacil_ks.metricas_emision_diaria TO ff_analytics_reader;
