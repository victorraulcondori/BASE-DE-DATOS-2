-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 3. Indices.sql
-- Índices de Rendimiento y Restricciones Físicas - Asignación Individual
-- ============================================================================

ALTER SESSION SET CURRENT_SCHEMA = facturafacil_owner;

-- ----------------------------------------------------------------------------
-- ÍNDICE 1: Unicidad Fiscal Local (Serie + Correlativo por Empresa y Fecha)
-- Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
-- Justificación: Garantiza correlatividad única legal dentro de cada partición física
-- ----------------------------------------------------------------------------
CREATE UNIQUE INDEX idx_ora_cpe_unicidad 
    ON documentos_tributarios (id_tenant, tipo_cpe, serie, correlativo, fecha_emision) LOCAL;

-- ----------------------------------------------------------------------------
-- ÍNDICE 2: B-Tree de Integridad Referencial y Cruce de Cliente
-- Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
-- Justificación: Acelera las consultas de facturas históricas por cliente receptor
-- ----------------------------------------------------------------------------
CREATE INDEX idx_ora_doc_cliente 
    ON documentos_tributarios (id_cliente);

-- ----------------------------------------------------------------------------
-- ÍNDICE 3: Índice Compuesto Local por Estado Tributario y Fecha
-- Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
-- Justificación: Optimiza el filtrado de comprobantes ACEPTADOS / RECHAZADOS por periodo
-- ----------------------------------------------------------------------------
CREATE INDEX idx_ora_doc_estado 
    ON documentos_tributarios (estado_sunat, fecha_emision) LOCAL;

-- ----------------------------------------------------------------------------
-- ÍNDICE 4: B-Tree Compuesto para Búsqueda Directa de Clientes por RUC/DNI
-- Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
-- Justificación: Elimina Full Table Scans en la verificación previa a la facturación
-- ----------------------------------------------------------------------------
CREATE INDEX idx_ora_cliente_ruc 
    ON cliente_receptor (id_tenant, numero_documento);

-- ----------------------------------------------------------------------------
-- ÍNDICE 5: Índice Local de Rango de Montos de Venta Fiscal
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Facilita auditorías de comprobantes de alto valor (mayores a 700 soles)
-- ----------------------------------------------------------------------------
CREATE INDEX idx_ora_doc_monto 
    ON documentos_tributarios (total_venta, fecha_emision) LOCAL;
