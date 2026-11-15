// ============================================================================
// 6. DATOS SEMILLA DOCUMENTALES PARA MONGODB 8.2 (FACTURAS UBL 2.1 Y CDR)
// Proyecto FacturaFácil - Repositorio de Documentos Semiestructurados
// ============================================================================

use facturafacil_db;

// 1. Colección Principal: comprobantes_xml_cdr
db.comprobantes_xml_cdr.insertMany([
  {
    id_comprobante: "F001-0000001",
    id_tenant: 1,
    tipo_comprobante: "01",
    serie: "F001",
    correlativo: 1,
    fecha_emision: new Date("2026-01-15T10:30:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "6", num_doc: "20554433221", razon_social: "INVERSIONES SANTA ROSA S.A.C." },
    totales: { total_gravado: 1800.00, total_igv: 324.00, total_venta: 2124.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
    estado_sunat: "ACEPTADO",
    cdr: { codigo_respuesta: "0", descripcion_sunat: "El comprobante numero F001-0000001 ha sido aceptado", fecha_respuesta: new Date("2026-01-15T10:30:05Z") }
  },
  {
    id_comprobante: "F001-0000002",
    id_tenant: 1,
    tipo_comprobante: "01",
    serie: "F001",
    correlativo: 2,
    fecha_emision: new Date("2026-02-14T14:15:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "6", num_doc: "20608899112", razon_social: "CONSTRUCTORA DEL PACIFICO S.A." },
    totales: { total_gravado: 4800.00, total_igv: 864.00, total_venta: 5664.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "a4b2c14298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b112",
    estado_sunat: "ACEPTADO",
    cdr: { codigo_respuesta: "0", descripcion_sunat: "El comprobante numero F001-0000002 ha sido aceptado", fecha_respuesta: new Date("2026-02-14T14:15:06Z") }
  },
  {
    id_comprobante: "F001-0000003",
    id_tenant: 1,
    tipo_comprobante: "01",
    serie: "F001",
    correlativo: 3,
    fecha_emision: new Date("2026-03-01T16:45:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "6", num_doc: "20498765432", razon_social: "LOGISTICA INTEGRAL LIMA S.R.L." },
    totales: { total_gravado: 1200.00, total_igv: 216.00, total_venta: 1416.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "c5d3c14298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b334",
    estado_sunat: "RECHAZADO",
    cdr: { codigo_respuesta: "2324", descripcion_sunat: "El RUC del receptor no se encuentra habido en SUNAT", fecha_respuesta: new Date("2026-03-01T16:45:08Z") }
  },
  {
    id_comprobante: "B001-0000001",
    id_tenant: 1,
    tipo_comprobante: "03",
    serie: "B001",
    correlativo: 1,
    fecha_emision: new Date("2026-03-04T11:20:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "1", num_doc: "45892341", razon_social: "LOA ROJAS JEAN FRANCK" },
    totales: { total_gravado: 350.00, total_igv: 63.00, total_venta: 413.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "f7a1e23498fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b556",
    estado_sunat: "ACEPTADO",
    cdr: { codigo_respuesta: "0", descripcion_sunat: "El comprobante numero B001-0000001 ha sido aceptado", fecha_respuesta: new Date("2026-03-04T11:20:04Z") }
  },
  {
    id_comprobante: "B001-0000002",
    id_tenant: 1,
    tipo_comprobante: "03",
    serie: "B001",
    correlativo: 2,
    fecha_emision: new Date("2026-03-04T17:50:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "1", num_doc: "72194052", razon_social: "CAPCHA HUAMAN DIOGO SAID" },
    totales: { total_gravado: 850.00, total_igv: 153.00, total_venta: 1003.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "b8c3d44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b778",
    estado_sunat: "ACEPTADO",
    cdr: { codigo_respuesta: "0", descripcion_sunat: "El comprobante numero B001-0000002 ha sido aceptado", fecha_respuesta: new Date("2026-03-04T17:50:03Z") }
  },
  {
    id_comprobante: "F001-0000004",
    id_tenant: 1,
    tipo_comprobante: "01",
    serie: "F001",
    correlativo: 4,
    fecha_emision: new Date("2026-11-15T09:10:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "6", num_doc: "20100070970", razon_social: "SUPERMERCADOS PERUANOS S.A." },
    totales: { total_gravado: 6100.00, total_igv: 1098.00, total_venta: 7198.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48SW52b2ljZT48L0ludm9pY2U+",
    hash_cpe_sha256: "d9e4f55298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b990",
    estado_sunat: "ACEPTADO",
    cdr: { codigo_respuesta: "0", descripcion_sunat: "El comprobante numero F001-0000004 ha sido aceptado", fecha_respuesta: new Date("2026-11-15T09:10:05Z") }
  },
  {
    id_comprobante: "FC01-0000001",
    id_tenant: 1,
    tipo_comprobante: "07",
    serie: "FC01",
    correlativo: 1,
    fecha_emision: new Date("2026-11-15T12:00:00Z"),
    emisor: { ruc: "20601234567", razon_social: "FACTURAFACIL PERU S.A.C." },
    receptor: { tipo_doc: "6", num_doc: "20498765432", razon_social: "LOGISTICA INTEGRAL LIMA S.R.L." },
    totales: { total_gravado: 1200.00, total_igv: 216.00, total_venta: 1416.00 },
    xml_ubl_base64: "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz48Q3JlZGl0Tm90ZT48L0NyZWRpdE5vdGU+",
    hash_cpe_sha256: "e1f2a33498fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b221",
    estado_sunat: "ACEPTADO",
    documento_modificado: { tipo: "01", serie: "F001", correlativo: 3, motivo: "01 - Anulacion de la operacion" },
    cdr: { codigo_respuesta: "0", descripcion_sunat: "La Nota de Credito FC01-0000001 ha sido aceptada", fecha_respuesta: new Date("2026-11-15T12:00:04Z") }
  }
]);

// 2. Colección de Auditoría: logs_auditoria_sunat
db.logs_auditoria_sunat.insertMany([
  {
    id_comprobante: "F001-0000001",
    emisor_ruc: "20601234567",
    endpoint_invocado: "https://e-factura.sunat.gob.pe/ol-ti-itcpfconsdoc/billService",
    http_status: 200,
    tiempo_respuesta_ms: 312,
    respuesta_soap: "<soap:Envelope><soap:Body><sendBillResponse><applicationResponse>...</applicationResponse></sendBillResponse></soap:Body></soap:Envelope>",
    timestamp: new Date("2026-01-15T10:30:05Z")
  },
  {
    id_comprobante: "F001-0000002",
    emisor_ruc: "20601234567",
    endpoint_invocado: "https://e-factura.sunat.gob.pe/ol-ti-itcpfconsdoc/billService",
    http_status: 200,
    tiempo_respuesta_ms: 285,
    respuesta_soap: "<soap:Envelope><soap:Body><sendBillResponse><applicationResponse>...</applicationResponse></sendBillResponse></soap:Body></soap:Envelope>",
    timestamp: new Date("2026-02-14T14:15:06Z")
  },
  {
    id_comprobante: "F001-0000003",
    emisor_ruc: "20601234567",
    endpoint_invocado: "https://e-factura.sunat.gob.pe/ol-ti-itcpfconsdoc/billService",
    http_status: 500,
    tiempo_respuesta_ms: 1450,
    respuesta_soap: "<soap:Fault><faultcode>SOAP-ENV:Client.2324</faultcode><faultstring>El RUC receptor no habido</faultstring></soap:Fault>",
    timestamp: new Date("2026-03-01T16:45:08Z")
  },
  {
    id_comprobante: "B001-0000001",
    emisor_ruc: "20601234567",
    endpoint_invocado: "https://e-factura.sunat.gob.pe/ol-ti-itcpfconsdoc/billService",
    http_status: 200,
    tiempo_respuesta_ms: 198,
    respuesta_soap: "<soap:Envelope><soap:Body><sendBillResponse><applicationResponse>CDR_OK</applicationResponse></sendBillResponse></soap:Body></soap:Envelope>",
    timestamp: new Date("2026-03-04T11:20:04Z")
  },
  {
    id_comprobante: "F001-0000004",
    emisor_ruc: "20601234567",
    endpoint_invocado: "https://e-factura.sunat.gob.pe/ol-ti-itcpfconsdoc/billService",
    http_status: 200,
    tiempo_respuesta_ms: 240,
    respuesta_soap: "<soap:Envelope><soap:Body><sendBillResponse><applicationResponse>CDR_OK</applicationResponse></sendBillResponse></soap:Body></soap:Envelope>",
    timestamp: new Date("2026-11-15T09:10:05Z")
  }
]);
