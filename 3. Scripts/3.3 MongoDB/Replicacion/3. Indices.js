// ============================================================================
// 3. CREACIÓN Y VALIDACIÓN DE ÍNDICES COMPUESTOS EN MONGODB
// ============================================================================

use facturafacil_db;

// 1. Índice compuesto de alta selectividad por Emisor y Fecha descendente
db.comprobantes_xml_cdr.createIndex(
  { "emisor.ruc": 1, "fecha_emision": -1 },
  { name: "idx_emisor_fecha_desc" }
);

// 2. Índice único para garantizar unicidad legal del identificador de comprobante
db.comprobantes_xml_cdr.createIndex(
  { "id_tenant": 1, "id_comprobante": 1 },
  { unique: true, name: "idx_tenant_id_cpe_unique" }
);

// 3. Índice para auditoría de rechazos y monitoreo de estado
db.comprobantes_xml_cdr.createIndex(
  { "estado_sunat": 1, "cdr.codigo_respuesta": 1 },
  { name: "idx_estado_rechazos_sunat" }
);
