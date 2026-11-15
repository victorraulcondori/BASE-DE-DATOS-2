// ============================================================================
// PROYECTO FACTURAFÁCIL - CONFIGURACIÓN DE BASE DE DATOS MONGODB 8.2
// ============================================================================

const dbName = "facturafacil_db";
const conn = new Mongo();
const db = conn.getDB(dbName);

print(">>> Inicializando base de datos documental: " + db.getName());
