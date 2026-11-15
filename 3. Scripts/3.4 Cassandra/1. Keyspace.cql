-- ============================================================================
-- PROYECTO FACTURAFÁCIL - CONFIGURACIÓN DEL KEYSPACE APACHE CASSANDRA 5.0
-- ============================================================================

CREATE KEYSPACE IF NOT EXISTS facturafacil_ks
WITH replication = {
    'class': 'NetworkTopologyStrategy',
    'datacenter1': 3
} AND durable_writes = true;

USE facturafacil_ks;
