-- ============================================================================
-- 6. DATOS SEMILLA ANALÍTICOS Y SERIES TEMPORALES EN APACHE CASSANDRA 5.0
-- Proyecto FacturaFácil - Métricas, Trazabilidad CDR y Telemetría POS
-- ============================================================================

USE facturafacil_ks;

-- ----------------------------------------------------------------------------
-- 1. Inserción de Métricas de Emisión Diaria (metricas_emision_diaria)
-- ----------------------------------------------------------------------------
-- Periodo 2026-01
INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-01', '2026-01-15', 38, 14250.00, 2565.00, 375.00, 10);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-01', '2026-01-28', 52, 22100.50, 3978.09, 425.01, 15);

-- Periodo 2026-02
INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-02', '2026-02-14', 65, 28900.00, 5202.00, 444.62, 20);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-02', '2026-02-28', 70, 31500.20, 5670.04, 450.00, 22);

-- Periodo 2026-03
INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-03', '2026-03-01', 45, 18450.80, 3321.14, 410.02, 12);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-03', '2026-03-02', 78, 34210.50, 6157.89, 438.60, 24);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-03', '2026-03-03', 62, 25180.20, 4532.44, 406.13, 18);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-03', '2026-03-04', 91, 41200.00, 7416.00, 452.75, 31);

-- Periodo 2026-11
INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-11', '2026-11-14', 110, 52300.00, 9414.00, 475.45, 35);

INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20601234567', '2026-11', '2026-11-15', 125, 60800.50, 10944.09, 486.40, 42);

-- Otro Tenant: 20554433221
INSERT INTO metricas_emision_diaria (ruc_emisor, periodo_mes, fecha_emision, total_comprobantes, total_monto_pen, total_igv_pen, promedio_ticket, pico_concurrencia_min)
VALUES ('20554433221', '2026-03', '2026-03-01', 30, 12500.00, 2250.00, 416.66, 8);


-- ----------------------------------------------------------------------------
-- 2. Inserción de Trazabilidad Cronológica de Constancias CDR (historial_cdr_status)
-- ----------------------------------------------------------------------------
INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '01', '2026-03-01 10:30:05+0000', 'F001-0000001', 'ACEPTADO', 0, 312);

INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '01', '2026-03-02 14:15:06+0000', 'F001-0000002', 'ACEPTADO', 0, 285);

INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '01', '2026-03-03 16:45:08+0000', 'F001-0000003', 'RECHAZADO', 2324, 1450);

INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '03', '2026-03-04 11:20:04+0000', 'B001-0000001', 'ACEPTADO', 0, 198);

INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '03', '2026-03-04 17:50:03+0000', 'B001-0000002', 'ACEPTADO', 0, 210);

INSERT INTO historial_cdr_status (ruc_emisor, tipo_comprobante, timestamp_evento, id_comprobante, estado_cdr, codigo_error_sunat, tiempo_respuesta_ms)
VALUES ('20601234567', '01', '2026-11-15 09:10:05+0000', 'F001-0000004', 'ACEPTADO', 0, 240);


-- ----------------------------------------------------------------------------
-- 3. Inserción de Telemetría de Dispositivos POS Móviles (telemetria_pos_movil)
-- ----------------------------------------------------------------------------
INSERT INTO telemetria_pos_movil (id_dispositivo_pos, fecha_operacion, timestamp_ping, id_cajero, ruc_emisor, nivel_bateria, tipo_conexion, latencia_ping_ms, version_app_movil)
VALUES ('POS-SURCO-01', '2026-03-04', '2026-03-04 10:15:00+0000', 101, '20601234567', 95, 'WIFI_5GHZ', 18.5, 'v2.4.1');

INSERT INTO telemetria_pos_movil (id_dispositivo_pos, fecha_operacion, timestamp_ping, id_cajero, ruc_emisor, nivel_bateria, tipo_conexion, latencia_ping_ms, version_app_movil)
VALUES ('POS-SURCO-01', '2026-03-04', '2026-03-04 14:30:00+0000', 101, '20601234567', 72, '4G_LTE', 42.1, 'v2.4.1');

INSERT INTO telemetria_pos_movil (id_dispositivo_pos, fecha_operacion, timestamp_ping, id_cajero, ruc_emisor, nivel_bateria, tipo_conexion, latencia_ping_ms, version_app_movil)
VALUES ('POS-RUTA-LIMA-03', '2026-11-15', '2026-11-15 08:30:00+0000', 105, '20601234567', 98, '5G_NR', 12.4, 'v2.5.0');

INSERT INTO telemetria_pos_movil (id_dispositivo_pos, fecha_operacion, timestamp_ping, id_cajero, ruc_emisor, nivel_bateria, tipo_conexion, latencia_ping_ms, version_app_movil)
VALUES ('POS-RUTA-LIMA-03', '2026-11-15', '2026-11-15 12:45:00+0000', 105, '20601234567', 64, '4G_LTE', 38.2, 'v2.5.0');
