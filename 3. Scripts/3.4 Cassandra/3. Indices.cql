-- ============================================================================
-- 3. ÍNDICES SECUNDARIOS EN CASSANDRA
-- ============================================================================

USE facturafacil_ks;

-- Índice secundario para filtrar directamente facturas con rechazos tributarios
CREATE INDEX IF NOT EXISTS idx_historial_estado_cdr
    ON historial_cdr_status (estado_cdr);
