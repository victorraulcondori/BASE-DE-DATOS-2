/**
 * ============================================================================
 * PROYECTO: FACTURAFÁCIL - SaaS e-Invoicing & Accounting Multi-tenant
 * ARCHIVO: 7. Backups_Restore.js
 * MOTOR: MongoDB 8.2 (Replica Set rs-facturafacil)
 * PROPÓSITO: Procedimientos y comandos oficiales de respaldo y restauración
 *            para colecciones BSON y metadatos de índices.
 * ============================================================================
 */

// 1. Comando Oficial de Generación de Backup (mongodump con compresión gzip)
// Ejecutar desde la consola del sistema operativo o contenedor Docker:
//
// mongodump --host localhost:27017 \
//           --db facturafacil_db \
//           --archive="../../4. Backups/facturafacil_mongo_20260304.archive.gz" \
//           --gzip
//
print(">>> [INFO] Para generar el respaldo comprimido de MongoDB ejecute:");
print("    mongodump --host localhost:27017 --db facturafacil_db --archive=\"../../4. Backups/facturafacil_mongo_20260304.archive.gz\" --gzip");

// 2. Comando Oficial de Restauración (mongorestore con reemplazo atómico)
// Ejecutar para recuperar la base de datos completa desde el archivo comprimido:
//
// mongorestore --host localhost:27017 \
//              --archive="../../4. Backups/facturafacil_mongo_20260304.archive.gz" \
//              --gzip \
//              --drop
//
print(">>> [INFO] Para restaurar la base de datos completa ejecute:");
print("    mongorestore --host localhost:27017 --archive=\"../../4. Backups/facturafacil_mongo_20260304.archive.gz\" --gzip --drop");

// 3. Verificación de Estado del Replica Set tras Restauración
try {
    const status = rs.status();
    print(">>> Estado del Replica Set tras verificación: " + status.set);
    print(">>> Nodo Primario: " + status.members.find(m => m.stateStr === "PRIMARY").name);
} catch (e) {
    print(">>> [AVISO] Ejecutar rs.status() dentro de mongosh conectado al clúster para verificar salud.");
}
