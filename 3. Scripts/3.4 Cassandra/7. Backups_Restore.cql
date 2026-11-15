-- ============================================================================
-- 7. RUTINA DE RESPALDO Y RESTAURACIÓN EN APACHE CASSANDRA 5.0
-- ============================================================================

-- COMANDO 1: Snapshot de SSTables en frío con nodetool (Ejecutar en terminal):
-- nodetool snapshot -t snapshot_facturafacil_s14 facturafacil_ks

-- COMANDO 2: Exportación y Respaldo en Archivo CSV Delimitado
USE facturafacil_ks;
COPY metricas_emision_diaria TO '4. Backups/metricas_backup.csv' WITH HEADER = TRUE;

-- COMANDO 3: Restauración desde CSV sobre nodo recuperado:
-- TRUNCATE metricas_emision_diaria;
-- COPY metricas_emision_diaria FROM '4. Backups/metricas_backup.csv' WITH HEADER = TRUE;
