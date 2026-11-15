// ============================================================================
// 4. FUNCIONES OPERACIONALES Y PIPELINES DE AGREGACIÓN NATIVOS EN MONGODB 8.2
// Proyecto FacturaFácil - Modernización Arquitectónica
// NOTA ARQUITECTÓNICA: Se reemplaza el almacenamiento obsoleto en db.system.js
// por Pipelines de Agregación Nativos y Funciones Transaccionales Modernas.
// ============================================================================

use facturafacil_db;

// ----------------------------------------------------------------------------
// PIPELINE 1: Conciliación Tributaria y Resumen de Ventas por Tenant
// Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
// Ejecución de agregación de alto rendimiento en memoria RAM con índices
// ----------------------------------------------------------------------------
const pipelineConciliacionFiscal = [
  {
    $match: {
      estado_sunat: "ACEPTADO"
    }
  },
  {
    $group: {
      _id: {
        tenant: "$id_tenant",
        tipo: "$tipo_comprobante",
        mes: { $dateToString: { format: "%Y-%m", date: "$fecha_emision" } }
      },
      total_documentos: { $sum: 1 },
      base_imponible_total: { $sum: "$totales.total_gravado" },
      igv_total_recaudado: { $sum: "$totales.total_igv" },
      monto_facturado_total: { $sum: "$totales.total_venta" }
    }
  },
  {
    $sort: { "_id.mes": -1, monto_facturado_total: -1 }
  }
];

// Ejecución y visualización de la agregación
print("=== PIPELINE 1: CONCILIACIÓN TRIBUTARIA MONGODB ===");
printjson(db.comprobantes_xml_cdr.aggregate(pipelineConciliacionFiscal).toArray());


// ----------------------------------------------------------------------------
// PIPELINE 2: Auditoría y Detección de Comprobantes Rechazados u Observados
// Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
// ----------------------------------------------------------------------------
const pipelineAuditoriaRechazos = [
  {
    $match: {
      estado_sunat: { $in: ["RECHAZADO", "OBSERVADO", "ANULADO"] }
    }
  },
  {
    $project: {
      _id: 0,
      id_comprobante: 1,
      id_tenant: 1,
      tipo_comprobante: 1,
      emisor_ruc: "$emisor.ruc",
      receptor_num: "$receptor.num_doc",
      estado_sunat: 1,
      codigo_respuesta_cdr: "$cdr.codigo_respuesta",
      descripcion_error: "$cdr.descripcion_sunat",
      fecha_emision: 1
    }
  },
  {
    $sort: { fecha_emision: -1 }
  }
];

print("=== PIPELINE 2: AUDITORÍA DE RECHAZOS Y ERRORES CDR ===");
printjson(db.comprobantes_xml_cdr.aggregate(pipelineAuditoriaRechazos).toArray());


// ----------------------------------------------------------------------------
// FUNCIÓN OPERACIONAL 3: Registro Atómico de Auditoría de Red SOAP ante SUNAT
// Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
// Implementación transaccional nativa moderna con insertOne
// ----------------------------------------------------------------------------
function registrarLogAuditoriaSunat(idComprobante, rucEmisor, endpoint, codigoHttp, tiempoMs, respuestaSoap) {
  const resultado = db.logs_auditoria_sunat.insertOne({
    id_comprobante: idComprobante,
    emisor_ruc: rucEmisor,
    endpoint_invocado: endpoint,
    http_status: codigoHttp,
    tiempo_respuesta_ms: tiempoMs,
    respuesta_soap: respuestaSoap,
    timestamp: new Date()
  });

  return {
    ok: resultado.acknowledged,
    insertedId: resultado.insertedId,
    mensaje: "Log de auditoría de red SOAP persistido exitosamente en MongoDB."
  };
}


// ----------------------------------------------------------------------------
// FUNCIÓN OPERACIONAL 4: Anulación Atómica y Reversión Fiscal por Nota de Crédito
// Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
// Ejecuta actualización segura de estado_sunat sin usar db.system.js
// ----------------------------------------------------------------------------
function anularComprobantePago(idComprobante, motivoBaja, notaCreditoAsociada) {
  const res = db.comprobantes_xml_cdr.updateOne(
    { 
      id_comprobante: idComprobante, 
      estado_sunat: { $in: ["ACEPTADO", "OBSERVADO", "PENDIENTE"] } 
    },
    { 
      $set: { 
        estado_sunat: "ANULADO", 
        motivo_baja: motivoBaja,
        nota_credito_asociada: notaCreditoAsociada,
        fecha_anulacion: new Date()
      } 
    }
  );

  return {
    comprobante_afectado: idComprobante,
    nuevo_estado: "ANULADO",
    nota_credito_vinculada: notaCreditoAsociada,
    modificados: res.modifiedCount,
    ok: res.modifiedCount > 0
  };
}


// ----------------------------------------------------------------------------
// PIPELINE 5: Top Clientes Receptores por Volumen de Venta e IGV Acumulado
// Responsable: Condori Ponce, Victor Raul - Cód. U24206253
// ----------------------------------------------------------------------------
const pipelineTopClientes = [
  {
    $group: {
      _id: {
        ruc_receptor: "$receptor.num_doc",
        razon_social: "$receptor.razon_social"
      },
      total_comprobantes: { $sum: 1 },
      total_comprado: { $sum: "$totales.total_venta" },
      total_igv: { $sum: "$totales.total_igv" }
    }
  },
  {
    $sort: { total_comprado: -1 }
  },
  {
    $limit: 5
  }
];

print("=== PIPELINE 5: TOP 5 CLIENTES POR VOLUMEN ===");
printjson(db.comprobantes_xml_cdr.aggregate(pipelineTopClientes).toArray());
