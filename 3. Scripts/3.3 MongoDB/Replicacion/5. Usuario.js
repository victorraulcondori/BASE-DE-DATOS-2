// ============================================================================
// 5. ADMINISTRACIÓN DE USUARIOS Y ROLES EN MONGODB
// ============================================================================

use facturafacil_db;

// Usuario Auditor Tributario con rol de solo lectura (read)
db.createUser({
  user: "usr_contador_auditor",
  pwd: "AuditorPassword2026!",
  roles: [
    { role: "read", db: "facturafacil_db" }
  ]
});

// Verificación de autenticación:
// db.auth("usr_contador_auditor", "AuditorPassword2026!");
