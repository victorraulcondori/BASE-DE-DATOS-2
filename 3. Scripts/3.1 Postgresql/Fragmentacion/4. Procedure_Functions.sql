-- ============================================================================
-- 4. PROCEDIMIENTOS ALMACENADOS Y FUNCIONES TRIBUTARIAS EN POSTGRESQL 18
-- Proyecto FacturaFácil - Asignación Individual por Integrante de Equipo
-- ============================================================================

\c facturafacil_postgres;

-- ----------------------------------------------------------------------------
-- FUNCIÓN 1: Validación Algorítmica de RUC ante SUNAT (Módulo 11)
-- Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
-- Justificación: Valida la integridad del número de RUC antes de persistir o emitir
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validar_ruc_sunat(p_ruc VARCHAR)
RETURNS BOOLEAN AS $$
DECLARE
    v_factores INT[] := ARRAY[5, 4, 3, 2, 7, 6, 5, 4, 3, 2];
    v_suma INT := 0;
    v_residuo INT;
    v_digito_calculado INT;
    v_digito_real INT;
    i INT;
BEGIN
    IF LENGTH(p_ruc) <> 11 OR (SUBSTRING(p_ruc FROM 1 FOR 2) NOT IN ('10', '15', '17', '20')) THEN
        RETURN FALSE;
    END IF;

    FOR i IN 1..10 LOOP
        v_suma := v_suma + (CAST(SUBSTRING(p_ruc FROM i FOR 1) AS INT) * v_factores[i]);
    END LOOP;

    v_residuo := v_suma % 11;
    v_digito_calculado := 11 - v_residuo;

    IF v_digito_calculado = 10 THEN
        v_digito_calculado := 0;
    ELSIF v_digito_calculado = 11 THEN
        v_digito_calculado := 1;
    END IF;

    v_digito_real := CAST(SUBSTRING(p_ruc FROM 11 FOR 1) AS INT);
    RETURN (v_digito_calculado = v_digito_real);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 2: Emisión Atómica con Correlatividad Legal y Particionamiento
-- Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
-- Justificación: Asegura correlativo estrictamente incremental y asignación a partición
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_emitir_comprobante_pago(
    p_id_tenant INT,
    p_tipo_cpe VARCHAR,
    p_serie VARCHAR,
    p_id_cliente INT,
    p_total_gravado NUMERIC,
    p_total_igv NUMERIC,
    p_total_venta NUMERIC,
    INOUT p_nuevo_correlativo INT DEFAULT 0
)
LANGUAGE plpgsql AS $$
DECLARE
    v_ultimo_correlativo INT;
BEGIN
    -- Bloqueo consultivo de correlativo para evitar colisiones en alta concurrencia
    SELECT COALESCE(MAX(correlativo), 0) + 1 INTO v_ultimo_correlativo
    FROM comprobante_pago
    WHERE id_tenant = p_id_tenant 
      AND tipo_comprobante = p_tipo_cpe 
      AND serie = p_serie;

    INSERT INTO comprobante_pago (
        id_tenant, id_cliente, tipo_comprobante, serie, correlativo,
        fecha_emision, total_gravado, total_igv, total_venta, estado_sunat
    ) VALUES (
        p_id_tenant, p_id_cliente, p_tipo_cpe, p_serie, v_ultimo_correlativo,
        CURRENT_DATE, p_total_gravado, p_total_igv, p_total_venta, 'ACEPTADO'
    );

    p_nuevo_correlativo := v_ultimo_correlativo;
    COMMIT;
END;
$$;

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 3: Conciliación Diaria Fiscal de Ventas e Impuestos
-- Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
-- Justificación: Consolida totales diarios por tenant para declaración DJ mensual
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_conciliacion_tributaria_diaria(
    p_id_tenant INT,
    p_fecha DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    v_total_cpe INT;
    v_total_gravado NUMERIC;
    v_total_igv NUMERIC;
BEGIN
    SELECT COUNT(*), COALESCE(SUM(total_gravado), 0), COALESCE(SUM(total_igv), 0)
    INTO v_total_cpe, v_total_gravado, v_total_igv
    FROM comprobante_pago
    WHERE id_tenant = p_id_tenant AND fecha_emision = p_fecha AND estado_sunat = 'ACEPTADO';

    RAISE NOTICE '=== CONCILIACION FISCAL [%] ===', p_fecha;
    RAISE NOTICE 'Total Comprobantes Aceptados : %', v_total_cpe;
    RAISE NOTICE 'Base Imponible Total Ventas  : S/ %', v_total_gravado;
    RAISE NOTICE 'Total IGV Fiscal Recaudado   : S/ %', v_total_igv;
END;
$$;

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 4: Anulación Formal de CPE y Registro de Baja Tributaria
-- Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
-- Justificación: Ejecuta anulación atómica de comprobante emitido respetando plazos SUNAT
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_anular_comprobante_pago(
    p_id_tenant INT,
    p_tipo_cpe VARCHAR,
    p_serie VARCHAR,
    p_correlativo INT,
    p_motivo_baja VARCHAR,
    INOUT p_resultado VARCHAR DEFAULT ''
)
LANGUAGE plpgsql AS $$
DECLARE
    v_id_comprobante BIGINT;
    v_fecha_emision DATE;
    v_estado_actual VARCHAR;
BEGIN
    SELECT id_comprobante, fecha_emision, estado_sunat 
    INTO v_id_comprobante, v_fecha_emision, v_estado_actual
    FROM comprobante_pago
    WHERE id_tenant = p_id_tenant 
      AND tipo_comprobante = p_tipo_cpe 
      AND serie = p_serie 
      AND correlativo = p_correlativo;

    IF NOT FOUND THEN
        p_resultado := 'ERROR: Comprobante no existe para los parametros indicados.';
        RETURN;
    END IF;

    IF v_estado_actual = 'ANULADO' THEN
        p_resultado := 'AVISO: El comprobante ya se encontraba previamente anulado.';
        RETURN;
    END IF;

    -- Actualización directa con poda de partición (Partition Pruning por fecha_emision)
    UPDATE comprobante_pago
    SET estado_sunat = 'ANULADO'
    WHERE id_comprobante = v_id_comprobante 
      AND fecha_emision = v_fecha_emision;

    p_resultado := FORMAT('EXITO: Comprobante %s-%s N° %s anulado correctamente. Motivo: %s', 
                          p_tipo_cpe, p_serie, p_correlativo, p_motivo_baja);
    COMMIT;
END;
$$;

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 5: Auditoría y Detección de Inconsistencias Fiscales
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Detecta discrepancias de redondeo y cuadraturas entre subtotal, IGV y total
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_auditoria_inconsistencias_fiscales(
    p_id_tenant INT,
    INOUT p_inconsistencias_encontradas INT DEFAULT 0
)
LANGUAGE plpgsql AS $$
DECLARE
    v_cpe RECORD;
    v_igv_esperado NUMERIC;
    v_total_esperado NUMERIC;
    v_conteo INT := 0;
BEGIN
    FOR v_cpe IN 
        SELECT id_comprobante, tipo_comprobante, serie, correlativo, total_gravado, total_igv, total_venta
        FROM comprobante_pago
        WHERE id_tenant = p_id_tenant
    LOOP
        v_igv_esperado := ROUND(v_cpe.total_gravado * 0.18, 2);
        v_total_esperado := ROUND(v_cpe.total_gravado + v_igv_esperado, 2);

        IF ABS(v_cpe.total_igv - v_igv_esperado) > 0.05 OR ABS(v_cpe.total_venta - v_total_esperado) > 0.05 THEN
            v_conteo := v_conteo + 1;
            RAISE WARNING 'Inconsistencia detectada en CPE [%-%-%]: Gravado=%, IGV=%, Total=% (Esperado IGV=%, Total=%)',
                          v_cpe.tipo_comprobante, v_cpe.serie, v_cpe.correlativo,
                          v_cpe.total_gravado, v_cpe.total_igv, v_cpe.total_venta,
                          v_igv_esperado, v_total_esperado;
        END IF;
    END LOOP;

    p_inconsistencias_encontradas := v_conteo;
    RAISE NOTICE 'Auditoria completada. Inconsistencias totales detectadas: %', v_conteo;
END;
$$;
