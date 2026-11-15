-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 6. Data.sql
-- Datos Semilla Transaccionales para Validación y Pruebas
-- ============================================================================

ALTER SESSION SET CURRENT_SCHEMA = facturafacil_owner;

-- Inserción de Empresas Emisoras (Tenants)
INSERT INTO empresa_emisora (ruc, razon_social, nombre_comercial, direccion_fiscal, ubigeo, usuario_sol, clave_sol)
VALUES ('20601234567', 'FACTURAFACIL PERU S.A.C.', 'FacturaFácil Cloud', 'AV. JAVIER PRADO ESTE 4200, SURCO, LIMA', '150140', 'MODDATOS', 'moddatos2026');

INSERT INTO empresa_emisora (ruc, razon_social, nombre_comercial, direccion_fiscal, ubigeo, usuario_sol, clave_sol)
VALUES ('20498765432', 'DISTRIBUIDORA COMERCIAL LIMA S.A.C.', 'Comercial Lima', 'AV. NICOLAS DE PIEROLA 550, LIMA', '150101', 'LIMAUSER', 'lima2026pass');

INSERT INTO empresa_emisora (ruc, razon_social, nombre_comercial, direccion_fiscal, ubigeo, usuario_sol, clave_sol)
VALUES ('10458923418', 'LOA ROJAS JEAN FRANCK', 'Consultoría TI Loa', 'JR. BOLOGNESI 540, HUANCAYO, JUNIN', '120101', 'JEANLOA1', 'solpass2026');

-- Inserción de Clientes Receptores
INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social, direccion)
VALUES (1, '6', '20100070970', 'SUPERMERCADOS PERUANOS S.A.', 'CALLE MORELLI 181, SAN BORJA, LIMA');

INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social, direccion)
VALUES (1, '1', '45892341', 'GARCIA MENDOZA, CARLOS ALBERTO', 'JR. LAS FLORES 234, LINCE, LIMA');

INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social, direccion)
VALUES (2, '6', '20554433221', 'CORPORACION LOGISTICA ANDINA S.A.', 'AV. ELMER FAUCETT 2100, CALLAO');

INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social, direccion)
VALUES (2, '6', '20608899112', 'CONSTRUCTORA DEL PACIFICO S.A.', 'AV. LARCO 850, MIRAFLORES, LIMA');

INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social, direccion)
VALUES (3, '1', '72194052', 'CAPCHA HUAMAN, DIOGO SAID', 'JR. HUANCAVELICA 320, HUANCAYO');

-- Inserción de Documentos Tributarios (Particiones Q1, Q2, Q3, Q4 y p_max)
-- Q1: 2026-01 a 2026-03
INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 1, '01', 'F001', 1, TO_DATE('2026-01-15', 'YYYY-MM-DD'), '09:15:00', 1800.00, 324.00, 2124.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 2, '03', 'B001', 1, TO_DATE('2026-01-20', 'YYYY-MM-DD'), '11:40:00', 320.00, 57.60, 377.60, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 1, '01', 'F001', 2, TO_DATE('2026-02-15', 'YYYY-MM-DD'), '10:30:00', 2500.00, 450.00, 2950.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 2, '03', 'B001', 2, TO_DATE('2026-02-15', 'YYYY-MM-DD'), '11:15:00', 120.00, 21.60, 141.60, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 1, '01', 'F001', 3, TO_DATE('2026-03-01', 'YYYY-MM-DD'), '09:45:00', 4200.00, 756.00, 4956.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (2, 3, '01', 'F001', 1, TO_DATE('2026-03-02', 'YYYY-MM-DD'), '14:20:00', 8500.00, 1530.00, 10030.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (2, 4, '01', 'F001', 2, TO_DATE('2026-03-10', 'YYYY-MM-DD'), '16:00:00', 3100.00, 558.00, 3658.00, 'ACEPTADO');

-- Q2: 2026-04 a 2026-06
INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 1, '01', 'F001', 4, TO_DATE('2026-04-12', 'YYYY-MM-DD'), '10:00:00', 5600.00, 1008.00, 6608.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 2, '03', 'B001', 3, TO_DATE('2026-05-18', 'YYYY-MM-DD'), '15:30:00', 450.00, 81.00, 531.00, 'ACEPTADO');

-- Q3: 2026-07 a 2026-09
INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (2, 3, '01', 'F001', 3, TO_DATE('2026-07-22', 'YYYY-MM-DD'), '08:50:00', 12400.00, 2232.00, 14632.00, 'ACEPTADO');

-- Q4: 2026-10 a 2026-12 (Incluye fecha actual Noviembre 2026)
INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (3, 5, '03', 'B001', 1, TO_DATE('2026-11-15', 'YYYY-MM-DD'), '11:10:00', 950.00, 171.00, 1121.00, 'ACEPTADO');

INSERT INTO documentos_tributarios (id_tenant, id_cliente, tipo_cpe, serie, correlativo, fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat)
VALUES (1, 1, '01', 'F001', 5, TO_DATE('2026-11-15', 'YYYY-MM-DD'), '16:45:00', 7800.00, 1404.00, 9204.00, 'ACEPTADO');

COMMIT;
