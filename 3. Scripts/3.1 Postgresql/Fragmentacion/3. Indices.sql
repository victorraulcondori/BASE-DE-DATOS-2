-- ============================================================================
-- 3. ÍNDICES DE RENDIMIENTO Y RESTRICCIONES DE UNICIDAD FISCAL EN POSTGRESQL 18
-- Proyecto FacturaFácil - Asignación Individual por Integrante de Equipo
-- ============================================================================

\c facturafacil_postgres;

-- ----------------------------------------------------------------------------
-- ÍNDICE 1: Unicidad Tributaria Legal (Serie + Correlativo por Empresa)
-- Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
-- Justificación: Impide duplicidad fiscal de comprobantes bajo normativa SUNAT
-- ----------------------------------------------------------------------------
CREATE UNIQUE INDEX IF NOT EXISTS idx_cpe_unicidad_fiscal
    ON comprobante_pago (id_tenant, tipo_comprobante, serie, correlativo, fecha_emision);

-- ----------------------------------------------------------------------------
-- ÍNDICE 2: Búsqueda Compuesta de Clientes por Documento de Identidad
-- Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
-- Justificación: Acelera la validación de RUC/DNI en emisión de comprobantes en caja
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cliente_doc_busqueda
    ON cliente_receptor (id_tenant, numero_documento);

-- ----------------------------------------------------------------------------
-- ÍNDICE 3: Reportes Mensuales y Auditoría de Estados Tributarios
-- Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
-- Justificación: Optimiza las consultas de liquidación fiscal mensual y estados SUNAT
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cpe_fecha_estado
    ON comprobante_pago (id_tenant, fecha_emision DESC, estado_sunat);

-- ----------------------------------------------------------------------------
-- ÍNDICE 4: Clave Foránea de Cliente para JOINs de Reportes Contables
-- Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
-- Justificación: Elimina Sequential Scans en cruces entre cliente_receptor y comprobantes
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cpe_cliente_fk
    ON comprobante_pago (id_cliente);

-- ----------------------------------------------------------------------------
-- ÍNDICE 5: Verificación Criptográfica y Antifraude de Hash CPE
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Permite verificación inmediata del código hash SHA-256 ante SUNAT
-- ----------------------------------------------------------------------------
CREATE INDEX IF NOT EXISTS idx_cpe_hash_sha256
    ON comprobante_pago (hash_cpe);
