-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 2. Tablas.sql
-- ============================================================================

ALTER SESSION SET CURRENT_SCHEMA = facturafacil_owner;

-- 1. Tabla de Empresas Emisoras (Multi-tenant SaaS)
CREATE TABLE empresa_emisora (
    id_tenant NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ruc VARCHAR2(11) NOT NULL UNIQUE,
    razon_social VARCHAR2(150) NOT NULL,
    nombre_comercial VARCHAR2(150),
    direccion_fiscal VARCHAR2(250) NOT NULL,
    ubigeo VARCHAR2(6) NOT NULL,
    usuario_sol VARCHAR2(20) NOT NULL,
    clave_sol VARCHAR2(50) NOT NULL,
    estado_contribuyente VARCHAR2(20) DEFAULT 'ACTIVO' NOT NULL,
    CONSTRAINT chk_ruc_format CHECK (REGEXP_LIKE(ruc, '^(10|20)[0-9]{9}$'))
);

-- 2. Tabla de Clientes Receptores
CREATE TABLE cliente_receptor (
    id_cliente NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_tenant NUMBER NOT NULL,
    tipo_documento VARCHAR2(2) NOT NULL,
    numero_documento VARCHAR2(15) NOT NULL,
    razon_social VARCHAR2(150) NOT NULL,
    direccion VARCHAR2(250),
    CONSTRAINT fk_cliente_tenant FOREIGN KEY (id_tenant) REFERENCES empresa_emisora(id_tenant)
);

-- 3. Tabla Particionada por Rango de Fecha: Documentos Tributarios (CPEs)
CREATE TABLE documentos_tributarios (
    id_comprobante NUMBER GENERATED ALWAYS AS IDENTITY,
    id_tenant NUMBER NOT NULL,
    id_cliente NUMBER NOT NULL,
    tipo_cpe VARCHAR2(2) NOT NULL,
    serie VARCHAR2(4) NOT NULL,
    correlativo NUMBER NOT NULL,
    fecha_emision DATE NOT NULL,
    hora_emision VARCHAR2(8) DEFAULT '00:00:00' NOT NULL,
    moneda VARCHAR2(3) DEFAULT 'PEN' NOT NULL,
    monto_gravado NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    monto_igv NUMBER(12,2) DEFAULT 0.00 NOT NULL,
    total_venta NUMBER(12,2) NOT NULL,
    estado_sunat VARCHAR2(20) DEFAULT 'EMITIDO' NOT NULL,
    CONSTRAINT pk_doc_tributario PRIMARY KEY (id_comprobante, fecha_emision),
    CONSTRAINT fk_doc_tenant FOREIGN KEY (id_tenant) REFERENCES empresa_emisora(id_tenant),
    CONSTRAINT fk_doc_cliente FOREIGN KEY (id_cliente) REFERENCES cliente_receptor(id_cliente),
    CONSTRAINT chk_tipo_cpe CHECK (tipo_cpe IN ('01', '03', '07', '08'))
)
PARTITION BY RANGE (fecha_emision) (
    PARTITION p_2026_q1 VALUES LESS THAN (TO_DATE('2026-04-01', 'YYYY-MM-DD')),
    PARTITION p_2026_q2 VALUES LESS THAN (TO_DATE('2026-07-01', 'YYYY-MM-DD')),
    PARTITION p_2026_q3 VALUES LESS THAN (TO_DATE('2026-10-01', 'YYYY-MM-DD')),
    PARTITION p_2026_q4 VALUES LESS THAN (TO_DATE('2027-01-01', 'YYYY-MM-DD')),
    PARTITION p_max VALUES LESS THAN (MAXVALUE)
);
