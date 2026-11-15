-- ============================================================================
-- 2. TABLAS DE SERIES TEMPORALES Y TELEMETRÍA EN CASSANDRA
-- ============================================================================

USE facturafacil_ks;

-- Tabla 1: Métricas de Emisión Diaria por Emisor (Clave compuesta de partición)
CREATE TABLE IF NOT EXISTS metricas_emision_diaria (
    ruc_emisor text,
    periodo_mes text,
    fecha_emision date,
    total_comprobantes int,
    total_monto_pen decimal,
    total_igv_pen decimal,
    promedio_ticket decimal,
    pico_concurrencia_min int,
    PRIMARY KEY ((ruc_emisor, periodo_mes), fecha_emision)
) WITH CLUSTERING ORDER BY (fecha_emision DESC);

-- Tabla 2: Trazabilidad Cronológica de Constancias CDR
CREATE TABLE IF NOT EXISTS historial_cdr_status (
    ruc_emisor text,
    tipo_comprobante text,
    timestamp_evento timestamp,
    id_comprobante text,
    estado_cdr text,
    codigo_error_sunat int,
    tiempo_respuesta_ms int,
    PRIMARY KEY ((ruc_emisor, tipo_comprobante), timestamp_evento, id_comprobante)
) WITH CLUSTERING ORDER BY (timestamp_evento DESC, id_comprobante ASC);

-- Tabla 3: Telemetría de Dispositivos POS Móviles en Ruta
CREATE TABLE IF NOT EXISTS telemetria_pos_movil (
    id_dispositivo_pos text,
    fecha_operacion date,
    timestamp_ping timestamp,
    id_cajero int,
    ruc_emisor text,
    nivel_bateria int,
    tipo_conexion text,
    latencia_ping_ms double,
    version_app_movil text,
    PRIMARY KEY ((id_dispositivo_pos, fecha_operacion), timestamp_ping)
) WITH CLUSTERING ORDER BY (timestamp_ping DESC);
