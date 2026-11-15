-- ============================================================================
-- 4. FUNCIONES DEFINIDAS POR EL USUARIO (UDF/UDA) Y CONSULTAS ANALÍTICAS EN CASSANDRA 5.0
-- Proyecto FacturaFácil - Asignación Individual por Integrante
-- ============================================================================

USE facturafacil_ks;

-- ----------------------------------------------------------------------------
-- FUNCIÓN UDF 1: Cálculo Determinista de IGV (18%) en Cassandra (Java UDF)
-- Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
-- Justificación: Permite computar en tiempo de consulta CQL el impuesto fiscal
-- Soporta tipos decimal (BigData financiero) y double nativo
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION facturafacil_ks.fn_calcular_igv_cql (subtotal decimal)
CALLED ON NULL INPUT
RETURNS decimal
LANGUAGE java AS '
    if (subtotal == null) return java.math.BigDecimal.ZERO;
    return subtotal.multiply(new java.math.BigDecimal("0.18")).setScale(2, java.math.RoundingMode.HALF_UP);
';

CREATE OR REPLACE FUNCTION facturafacil_ks.fn_calcular_igv_cql (subtotal double)
CALLED ON NULL INPUT
RETURNS double
LANGUAGE java AS '
    if (subtotal == null) return Double.valueOf(0.0);
    return Double.valueOf(Math.round(subtotal * 0.18 * 100.0) / 100.0);
';

-- ----------------------------------------------------------------------------
-- FUNCIÓN UDF 2: Clasificación de Ticket Promedio Fiscal (Java UDF)
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Segmenta el ticket promedio en categorías MICRO, PEQUEÑA o CORPORATIVA
-- Soporta tipos decimal y double
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION facturafacil_ks.fn_clasificar_ticket (monto decimal)
CALLED ON NULL INPUT
RETURNS text
LANGUAGE java AS '
    if (monto == null || monto.compareTo(new java.math.BigDecimal("100.0")) < 0) return "TICKET_MENOR";
    if (monto.compareTo(new java.math.BigDecimal("700.0")) <= 0) return "TICKET_MEDIO";
    return "TICKET_MAYOR_FISCAL";
';

CREATE OR REPLACE FUNCTION facturafacil_ks.fn_clasificar_ticket (monto double)
CALLED ON NULL INPUT
RETURNS text
LANGUAGE java AS '
    if (monto == null || monto < 100.0) return "TICKET_MENOR";
    if (monto <= 700.0) return "TICKET_MEDIO";
    return "TICKET_MAYOR_FISCAL";
';

-- ----------------------------------------------------------------------------
-- CONSULTA ANALÍTICA 1: Resumen de Facturación por Clave de Partición (Murmur3)
-- Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
-- Rendimiento: Latencia sub-3ms mediante acceso directo a nodo réplica sin cluster scan
-- ----------------------------------------------------------------------------
SELECT ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, 
       total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min
FROM metricas_emision_diaria
WHERE ruc_emisor = '20601234567' AND periodo_mes = '2026-03';

-- ----------------------------------------------------------------------------
-- CONSULTA ANALÍTICA 2: Trazabilidad Cronológica de Estados CDR para Auditoría
-- Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
-- Rendimiento: Lectura ordenada descendente por Clustering Key (timestamp_evento DESC)
-- ----------------------------------------------------------------------------
SELECT ruc_emisor, tipo_comprobante, id_comprobante, timestamp_evento, estado_cdr, codigo_error_sunat
FROM historial_cdr_status
WHERE ruc_emisor = '20601234567' AND tipo_comprobante = '01'
ORDER BY timestamp_evento DESC
LIMIT 10;

-- ----------------------------------------------------------------------------
-- CONSULTA ANALÍTICA 3: Detección de Picos de Demanda y Concurrencia de Emisión
-- Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
-- Justificación: Monitorea sobrecargas en puntos de venta durante cierre comercial
-- ----------------------------------------------------------------------------
SELECT fecha_emision, total_comprobantes, pico_concurrencia_min, promedio_ticket
FROM metricas_emision_diaria
WHERE ruc_emisor = '20601234567' AND periodo_mes = '2026-03'
ORDER BY fecha_emision ASC;

-- ----------------------------------------------------------------------------
-- CONSULTA ANALÍTICA 4: Validación y Ejecución de UDFs en Tiempo Real
-- Responsable: Equipo FacturaFácil - Validación Integral UDFs
-- Justificación: Verifica el cálculo dinámico de IGV y clasificación en caliente
-- ----------------------------------------------------------------------------
SELECT fecha_emision, 
       total_monto_pen, 
       fn_calcular_igv_cql(total_monto_pen) AS igv_calculado_udf,
       promedio_ticket,
       fn_clasificar_ticket(promedio_ticket) AS clasificacion_ticket_udf
FROM metricas_emision_diaria
WHERE ruc_emisor = '20601234567' AND periodo_mes = '2026-03';
