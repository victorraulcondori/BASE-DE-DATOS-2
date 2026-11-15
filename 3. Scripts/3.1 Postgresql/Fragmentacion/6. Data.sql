-- ============================================================================
-- 6. DATOS SEMILLA TRANSACCIONALES PARA AMBIENTE DE PRODUCCIÓN / EVALUACIÓN
-- ============================================================================

\c facturafacil_postgres;

-- Inserción de Empresas Emisoras
INSERT INTO empresa_emisora (id_tenant, ruc, razon_social, nombre_comercial, direccion_fiscal, ubigeo, usuario_sol, clave_sol)
VALUES 
(1, '20601234567', 'FACTURAFACIL PERU S.A.C.', 'FacturaFácil Cloud', 'AV. JAVIER PRADO ESTE 4200, SANTIAGO DE SURCO, LIMA', '150140', 'MODDATOS', 'moddatos'),
(2, '20554433221', 'DISTRIBUIDORA COMERCIAL S.A.C.', 'DisComer Lima', 'CALLE LOS PINOS 124, MIRAFLORES, LIMA', '150122', 'DISCOMER', 'clave2026'),
(3, '10458923418', 'LOA ROJAS JEAN FRANCK', 'Consultoría TI Loa', 'JR. BOLOGNESI 540, HUANCAYO, JUNIN', '120101', 'JEANLOA1', 'solpass26')
ON CONFLICT (id_tenant) DO NOTHING;

-- Inserción de Clientes Receptores
INSERT INTO cliente_receptor (id_tenant, tipo_documento, numero_documento, razon_social_nombres, direccion, email_notificacion)
VALUES 
(1, '6', '20554433221', 'INVERSIONES SANTA ROSA S.A.C.', 'AV. ARGENTINA 1420, CALLAO', 'facturacion@santarosa.pe'),
(1, '6', '20608899112', 'CONSTRUCTORA DEL PACIFICO S.A.', 'AV. LARCO 850, MIRAFLORES', 'cuentas@pacificoconstruc.pe'),
(1, '6', '20498765432', 'LOGISTICA INTEGRAL LIMA S.R.L.', 'AV. FAUSETT 210, CALLAO', 'operaciones@logisticaintegral.pe'),
(1, '1', '45892341', 'LOA ROJAS JEAN FRANCK', 'JR. BOLOGNESI 540, HUANCAYO', 'jean.loa@gmail.com'),
(1, '1', '72194052', 'CAPCHA HUAMAN DIOGO SAID', 'JR. HUANCAVELICA 320, HUANCAYO', 'diogo.capcha@gmail.com'),
(2, '6', '20100070970', 'SUPERMERCADOS PERUANOS S.A.', 'CALLE MORELLI 181, SAN BORJA', 'facturacion@spsa.pe'),
(2, '1', '44332211', 'VILA HUARCO JEREMI DARIO', 'AV. AREQUIPA 1200, LIMA', 'jeremi.vila@gmail.com'),
(3, '1', '46556677', 'QUISPE RODRIGUEZ JEAN PIERRE', 'AV. LA MARINA 1500, SAN MIGUEL', 'jean.quispe@gmail.com'),
(3, '1', '48998877', 'CONDORI PONCE VICTOR RAUL', 'JR. LIMA 300, HUANCAYO', 'victor.condori@gmail.com'),
(1, '1', '47112233', 'LAVADO MISARI ANDRIV ENRIQUE', 'AV. COLONIAL 800, LIMA', 'andriv.lavado@gmail.com')
ON CONFLICT DO NOTHING;

-- Inserción de Comprobantes de Pago (Distribución en particiones 2026-01, 2026-02, 2026-03 y DEFAULT)
INSERT INTO comprobante_pago (id_tenant, id_cliente, tipo_comprobante, serie, correlativo, fecha_emision, total_gravado, total_igv, total_venta, estado_sunat, hash_cpe)
VALUES 
(1, 1, '01', 'F001', 1, '2026-01-15', 1800.00, 324.00, 2124.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010101'),
(1, 2, '01', 'F001', 2, '2026-01-28', 3500.00, 630.00, 4130.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010102'),
(1, 3, '01', 'F001', 3, '2026-02-10', 2900.00, 522.00, 3422.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010103'),
(1, 4, '03', 'B001', 1, '2026-02-18', 420.00, 75.60, 495.60, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010104'),
(1, 5, '03', 'B001', 2, '2026-02-25', 680.00, 122.40, 802.40, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010105'),
(1, 1, '01', 'F001', 4, '2026-03-01', 2500.00, 450.00, 2950.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010106'),
(1, 2, '01', 'F001', 5, '2026-03-02', 4800.00, 864.00, 5664.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010107'),
(1, 3, '01', 'F001', 6, '2026-03-03', 1200.00, 216.00, 1416.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010108'),
(1, 4, '03', 'B001', 3, '2026-03-04', 350.00, 63.00, 413.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010109'),
(1, 5, '03', 'B001', 4, '2026-03-04', 850.00, 153.00, 1003.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010110'),
(2, 6, '01', 'F001', 1, '2026-03-05', 9200.00, 1656.00, 10856.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010111'),
(2, 7, '03', 'B001', 1, '2026-03-06', 150.00, 27.00, 177.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010112'),
(3, 8, '03', 'B001', 1, '2026-03-07', 520.00, 93.60, 613.60, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010113'),
(3, 9, '03', 'B001', 2, '2026-11-15', 740.00, 133.20, 873.20, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010114'),
(1, 10, '01', 'F001', 7, '2026-11-15', 6100.00, 1098.00, 7198.00, 'ACEPTADO', 'a1b2c3d4e5f60101010101010101010101010101010101010101010101010115')
ON CONFLICT DO NOTHING;

-- Inserción de Detalles de Comprobantes (detalle_comprobante)
INSERT INTO detalle_comprobante (id_comprobante, fecha_emision, numero_orden, codigo_sku, descripcion_producto, unidad_medida, cantidad, valor_unitario, precio_unitario, subtotal_gravado, igv_item, total_item)
SELECT c.id_comprobante, c.fecha_emision, 1, 'SERV-CLOUD-01', 'Suscripción SaaS Facturación Electrónica', 'ZZ', 1.000, c.total_gravado, c.total_venta, c.total_gravado, c.total_igv, c.total_venta
FROM comprobante_pago c
WHERE NOT EXISTS (
    SELECT 1 FROM detalle_comprobante d WHERE d.id_comprobante = c.id_comprobante AND d.fecha_emision = c.fecha_emision
);
