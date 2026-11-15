// ============================================================================
// 2. CREACIÓN DE COLECCIONES CON VALIDACIÓN JSON SCHEMA ESTRICTA
// ============================================================================

use facturafacil_db;

// 1. Colección principal de Facturas y Constancias de Recepción CDR
db.createCollection("comprobantes_xml_cdr", {
  validator: {
    $jsonSchema: {
      bsonType: "object",
      required: ["id_comprobante", "id_tenant", "tipo_comprobante", "serie", "correlativo", "fecha_emision", "emisor", "receptor", "totales", "estado_sunat"],
      properties: {
        id_comprobante: { bsonType: "string", pattern: "^[F|B][0-9]{3}-[0-9]{1,8}$" },
        id_tenant: { bsonType: "int" },
        tipo_comprobante: { enum: ["01", "03", "07", "08"] },
        serie: { bsonType: "string" },
        correlativo: { bsonType: "int" },
        fecha_emision: { bsonType: "date" },
        emisor: {
          bsonType: "object",
          required: ["ruc", "razon_social"],
          properties: {
            ruc: { bsonType: "string", pattern: "^(10|20)[0-9]{9}$" },
            razon_social: { bsonType: "string" }
          }
        },
        receptor: {
          bsonType: "object",
          required: ["num_doc", "razon_social"],
          properties: {
            tipo_doc: { enum: ["1", "6", "4", "7", "0"] },
            num_doc: { bsonType: "string" },
            razon_social: { bsonType: "string" }
          }
        },
        totales: {
          bsonType: "object",
          required: ["total_venta", "total_igv"],
          properties: {
            total_gravado: { bsonType: "double" },
            total_igv: { bsonType: "double" },
            total_venta: { bsonType: "double" }
          }
        },
        xml_ubl_base64: { bsonType: "string" },
        hash_cpe_sha256: { bsonType: "string" },
        estado_sunat: { enum: ["PENDIENTE_ENVIO", "ACEPTADO", "RECHAZADO", "OBSERVADO", "ANULADO"] },
        cdr: {
          bsonType: "object",
          properties: {
            codigo_respuesta: { bsonType: "string" },
            descripcion_sunat: { bsonType: "string" },
            fecha_respuesta: { bsonType: "date" }
          }
        }
      }
    }
  }
});

// 2. Colección de Catálogo de Productos y Precios
db.createCollection("catalogo_productos");

// 3. Colección de Trazabilidad y Logs SOAP SUNAT
db.createCollection("logs_auditoria_sunat");
