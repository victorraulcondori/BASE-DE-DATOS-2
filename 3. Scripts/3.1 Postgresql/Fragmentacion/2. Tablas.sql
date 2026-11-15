-- ============================================================================
-- 2. TABLAS DEL MODELO RELACIONAL TRANSACCIONAL CON PARTICIONAMIENTO
-- ============================================================================

\c facturafacil_postgres;

-- Tabla 1: Empresa Emisora (Multi-tenant SaaS)
CREATE TABLE IF NOT EXISTS empresa_emisora (
    id_tenant SERIAL PRIMARY KEY,
    ruc VARCHAR(11) NOT NULL UNIQUE CHECK (ruc ~ '^(10|20)[0-9]{9}$'),
    razon_social VARCHAR(150) NOT NULL,
    nombre_comercial VARCHAR(150),
    direccion_fiscal TEXT NOT NULL,
    ubigeo VARCHAR(6) NOT NULL,
    usuario_sol VARCHAR(20) NOT NULL,
    clave_sol VARCHAR(50) NOT NULL,
    certificado_digital_path VARCHAR(255),
    estado_contribuyente VARCHAR(20) DEFAULT 'ACTIVO',
    condicion_domicilio VARCHAR(20) DEFAULT 'HABIDO',
    fecha_afiliacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla 2: Cliente Receptor
CREATE TABLE IF NOT EXISTS cliente_receptor (
    id_cliente SERIAL PRIMARY KEY,
    id_tenant INT NOT NULL REFERENCES empresa_emisora(id_tenant) ON DELETE RESTRICT,
    tipo_documento VARCHAR(1) NOT NULL CHECK (tipo_documento IN ('1', '6', '4', '7')), -- 1=DNI, 6=RUC
    numero_documento VARCHAR(15) NOT NULL,
    razon_social_nombres VARCHAR(150) NOT NULL,
    direccion VARCHAR(255),
    email_notificacion VARCHAR(100),
    telefono VARCHAR(20),
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_tenant_cliente UNIQUE (id_tenant, tipo_documento, numero_documento)
);

-- Tabla 3: Tabla Madre Particionada de Comprobantes de Pago
CREATE TABLE IF NOT EXISTS comprobante_pago (
    id_comprobante BIGSERIAL,
    id_tenant INT NOT NULL REFERENCES empresa_emisora(id_tenant) ON DELETE RESTRICT,
    id_cliente INT NOT NULL REFERENCES cliente_receptor(id_cliente) ON DELETE RESTRICT,
    tipo_comprobante VARCHAR(2) NOT NULL CHECK (tipo_comprobante IN ('01', '03', '07', '08')), -- 01: Factura, 03: Boleta
    serie VARCHAR(4) NOT NULL,
    correlativo INT NOT NULL CHECK (correlativo > 0),
    fecha_emision DATE NOT NULL,
    hora_emision TIME NOT NULL DEFAULT CURRENT_TIME,
    moneda VARCHAR(3) DEFAULT 'PEN',
    total_gravado NUMERIC(12,2) DEFAULT 0.00 CHECK (total_gravado >= 0),
    total_inafecto NUMERIC(12,2) DEFAULT 0.00 CHECK (total_inafecto >= 0),
    total_exonerado NUMERIC(12,2) DEFAULT 0.00 CHECK (total_exonerado >= 0),
    total_igv NUMERIC(12,2) DEFAULT 0.00 CHECK (total_igv >= 0),
    total_icbper NUMERIC(8,2) DEFAULT 0.00 CHECK (total_icbper >= 0),
    total_venta NUMERIC(12,2) NOT NULL CHECK (total_venta >= 0),
    estado_sunat VARCHAR(20) DEFAULT 'PENDIENTE' CHECK (estado_sunat IN ('PENDIENTE', 'ACEPTADO', 'RECHAZADO', 'ANULADO')),
    hash_cpe VARCHAR(64),
    PRIMARY KEY (id_comprobante, fecha_emision)
) PARTITION BY RANGE (fecha_emision);

-- Particiones por Rango Mensual (Fragmentación Horizontal)
CREATE TABLE IF NOT EXISTS comprobante_pago_2026_01 PARTITION OF comprobante_pago
    FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');

CREATE TABLE IF NOT EXISTS comprobante_pago_2026_02 PARTITION OF comprobante_pago
    FOR VALUES FROM ('2026-02-01') TO ('2026-03-01');

CREATE TABLE IF NOT EXISTS comprobante_pago_2026_03 PARTITION OF comprobante_pago
    FOR VALUES FROM ('2026-03-01') TO ('2026-04-01');

CREATE TABLE IF NOT EXISTS comprobante_pago_2026_11 PARTITION OF comprobante_pago
    FOR VALUES FROM ('2026-11-01') TO ('2026-12-01');

-- Partición por Defecto (Garantiza inserción continua sin error por fechas fuera de rango)
CREATE TABLE IF NOT EXISTS comprobante_pago_default PARTITION OF comprobante_pago DEFAULT;

-- Tabla 4: Detalle de Comprobante
CREATE TABLE IF NOT EXISTS detalle_comprobante (
    id_detalle BIGSERIAL PRIMARY KEY,
    id_comprobante BIGINT NOT NULL,
    fecha_emision DATE NOT NULL,
    numero_orden INT NOT NULL,
    codigo_sku VARCHAR(30) NOT NULL,
    descripcion_producto VARCHAR(255) NOT NULL,
    unidad_medida VARCHAR(3) DEFAULT 'NIU',
    cantidad NUMERIC(10,3) NOT NULL CHECK (cantidad > 0),
    valor_unitario NUMERIC(12,4) NOT NULL CHECK (valor_unitario >= 0),
    precio_unitario NUMERIC(12,4) NOT NULL CHECK (precio_unitario >= 0),
    subtotal_gravado NUMERIC(12,2) NOT NULL,
    igv_item NUMERIC(12,2) NOT NULL,
    total_item NUMERIC(12,2) NOT NULL
);
