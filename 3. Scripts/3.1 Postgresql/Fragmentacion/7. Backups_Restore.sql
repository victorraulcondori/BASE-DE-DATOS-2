-- ============================================================================
-- 7. RUTINA DE RESPALDO Y RESTAURACIÓN EN POSTGRESQL 18
-- ============================================================================

-- COMANDO 1: Backup Lógico Integral Comprimido (Formato Custom pg_dump)
-- Ejecutar en línea de comandos (cmd / bash):
-- pg_dump -U postgres -h localhost -p 5432 -F c -b -v -f "4. Backups/facturafacil_pg_20260304.dump" facturafacil_postgres

-- COMANDO 2: Restauración Integral sobre Base Nueva (pg_restore)
-- dropdb -U postgres -h localhost facturafacil_restored --if-exists
-- createdb -U postgres -h localhost facturafacil_restored
-- pg_restore -U postgres -h localhost -p 5432 -d facturafacil_restored -v "4. Backups/facturafacil_pg_20260304.dump"
