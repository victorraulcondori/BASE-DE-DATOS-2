-- ============================================================================
-- PROYECTO: FACTURAFÁCIL - CAPA RELACIONAL EN ORACLE DATABASE 19c / 23c
-- ARCHIVO: 4. Procedure_Functions.sql
-- Procedimientos y Funciones PL/SQL - Asignación Individual por Integrante
-- ============================================================================

ALTER SESSION SET CURRENT_SCHEMA = facturafacil_owner;

-- ----------------------------------------------------------------------------
-- FUNCIÓN 1: Validación Algorítmica de RUC ante SUNAT (Módulo 11)
-- Responsable: Vila Huarco, Jeremi Dario - Cód. U24233812
-- Justificación: Implementación determinista en PL/SQL del algoritmo fiscal SUNAT
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_validar_ruc_oracle (
    p_ruc IN VARCHAR2
) RETURN NUMBER DETERMINISTIC IS
    TYPE t_factores IS VARRAY(10) OF NUMBER;
    v_factores t_factores := t_factores(5, 4, 3, 2, 7, 6, 5, 4, 3, 2);
    v_suma NUMBER := 0;
    v_residuo NUMBER;
    v_digito_calc NUMBER;
    v_digito_esperado NUMBER;
    v_digito_real NUMBER;
BEGIN
    IF LENGTH(p_ruc) <> 11 OR NOT REGEXP_LIKE(p_ruc, '^[0-9]+$') THEN
        RETURN 0;
    END IF;
    IF SUBSTR(p_ruc, 1, 2) NOT IN ('10', '15', '17', '20') THEN
        RETURN 0;
    END IF;
    FOR i IN 1..10 LOOP
        v_suma := v_suma + (TO_NUMBER(SUBSTR(p_ruc, i, 1)) * v_factores(i));
    END LOOP;
    v_residuo := MOD(v_suma, 11);
    v_digito_calc := 11 - v_residuo;
    IF v_digito_calc = 10 THEN
        v_digito_esperado := 0;
    ELSIF v_digito_calc = 11 THEN
        v_digito_esperado := 1;
    ELSE
        v_digito_esperado := v_digito_calc;
    END IF;
    v_digito_real := TO_NUMBER(SUBSTR(p_ruc, 11, 1));
    IF v_digito_esperado = v_digito_real THEN
        RETURN 1; -- RUC Válido
    ELSE
        RETURN 0; -- RUC Inválido
    END IF;
END fn_validar_ruc_oracle;
/

-- ----------------------------------------------------------------------------
-- FUNCIÓN AUXILIAR: Cálculo de Impuesto General a las Ventas (IGV 18%)
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Estandariza el cálculo con redondeo a dos decimales
-- ----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION fn_calcular_igv_oracle (
    p_monto IN NUMBER
) RETURN NUMBER DETERMINISTIC IS
BEGIN
    RETURN ROUND(p_monto * 0.18, 2);
END fn_calcular_igv_oracle;
/

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 2: Emisión Atómica de Comprobante con Correlativo Transaccional
-- Responsable: Lavado Misari, Andriv Enrique (Líder) - Cód. U24285101
-- Justificación: Administra la secuencia legal de numeración y almacena en la partición
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_emitir_cpe_oracle (
    p_id_tenant IN NUMBER,
    p_id_cliente IN NUMBER,
    p_tipo_cpe IN VARCHAR2,
    p_serie IN VARCHAR2,
    p_subtotal IN NUMBER,
    p_id_cpe_generado OUT NUMBER
) IS
    v_igv NUMBER;
    v_total NUMBER;
    v_correlativo NUMBER;
BEGIN
    v_igv := fn_calcular_igv_oracle(p_subtotal);
    v_total := p_subtotal + v_igv;
    
    SELECT NVL(MAX(correlativo), 0) + 1
    INTO v_correlativo
    FROM documentos_tributarios
    WHERE id_tenant = p_id_tenant
      AND tipo_cpe = p_tipo_cpe
      AND serie = p_serie;

    INSERT INTO documentos_tributarios (
        id_tenant, id_cliente, tipo_cpe, serie, correlativo,
        fecha_emision, hora_emision, monto_gravado, monto_igv, total_venta, estado_sunat
    ) VALUES (
        p_id_tenant, p_id_cliente, p_tipo_cpe, p_serie, v_correlativo,
        TRUNC(SYSDATE), TO_CHAR(SYSDATE, 'HH24:MI:SS'), p_subtotal, v_igv, v_total, 'EMITIDO'
    ) RETURNING id_comprobante INTO p_id_cpe_generado;
    
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_emitir_cpe_oracle;
/

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 3: Conciliación Diaria Fiscal de Ventas e Impuestos
-- Responsable: Capcha Huaman, Diogo Said - Cód. U24219405
-- Justificación: Agrupa el volumen transaccional diario para el libro electrónico PLE
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_conciliar_ventas_oracle (
    p_id_tenant IN NUMBER,
    p_fecha IN DATE,
    p_total_cpe OUT NUMBER,
    p_total_gravado OUT NUMBER,
    p_total_igv OUT NUMBER,
    p_total_venta OUT NUMBER
) IS
BEGIN
    SELECT COUNT(*),
           NVL(SUM(monto_gravado), 0),
           NVL(SUM(monto_igv), 0),
           NVL(SUM(total_venta), 0)
    INTO p_total_cpe, p_total_gravado, p_total_igv, p_total_venta
    FROM documentos_tributarios
    WHERE id_tenant = p_id_tenant
      AND fecha_emision = TRUNC(p_fecha)
      AND estado_sunat = 'ACEPTADO';
      
    DBMS_OUTPUT.PUT_LINE('=== CONCILIACION FISCAL ORACLE [' || TO_CHAR(p_fecha, 'YYYY-MM-DD') || '] ===');
    DBMS_OUTPUT.PUT_LINE('Comprobantes Aceptados: ' || p_total_cpe);
    DBMS_OUTPUT.PUT_LINE('Base Imponible Total  : S/ ' || p_total_gravado);
    DBMS_OUTPUT.PUT_LINE('IGV Fiscal Liquidado  : S/ ' || p_total_igv);
    DBMS_OUTPUT.PUT_LINE('Venta Total Facturada : S/ ' || p_total_venta);
END sp_conciliar_ventas_oracle;
/

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 4: Anulación Formal de CPE y Registro de Motivo de Baja
-- Responsable: Quispe Rodriguez, Jean Pierre - Cód. U24271984
-- Justificación: Actualiza el estado de emisión a ANULADO con consistencia transaccional
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_anular_cpe_oracle (
    p_id_tenant IN NUMBER,
    p_tipo_cpe IN VARCHAR2,
    p_serie IN VARCHAR2,
    p_correlativo IN NUMBER,
    p_mensaje OUT VARCHAR2
) IS
    v_id_comprobante NUMBER;
    v_estado_actual VARCHAR2(20);
BEGIN
    SELECT id_comprobante, estado_sunat
    INTO v_id_comprobante, v_estado_actual
    FROM documentos_tributarios
    WHERE id_tenant = p_id_tenant
      AND tipo_cpe = p_tipo_cpe
      AND serie = p_serie
      AND correlativo = p_correlativo;

    IF v_estado_actual = 'ANULADO' THEN
        p_mensaje := 'AVISO: El comprobante ya se encontraba en estado ANULADO.';
        RETURN;
    END IF;

    UPDATE documentos_tributarios
    SET estado_sunat = 'ANULADO'
    WHERE id_comprobante = v_id_comprobante;

    COMMIT;
    p_mensaje := 'EXITO: Comprobante ' || p_tipo_cpe || '-' || p_serie || '-' || p_correlativo || ' anulado.';
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_mensaje := 'ERROR: No se encontro comprobante para los datos especificados.';
    WHEN OTHERS THEN
        ROLLBACK;
        p_mensaje := 'ERROR PL/SQL: ' || SQLERRM;
END sp_anular_cpe_oracle;
/

-- ----------------------------------------------------------------------------
-- PROCEDIMIENTO 5: Auditoría de Consistencia Fiscal de Cálculo de Impuestos
-- Responsable: Condori Ponce, Victor Raul - Cód. U24206253
-- Justificación: Verifica discrepancias de redondeo entre gravado, IGV y total venta
-- ----------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE sp_auditoria_cpe_oracle (
    p_id_tenant IN NUMBER,
    p_inconsistencias OUT NUMBER
) IS
    v_conteo NUMBER := 0;
    v_igv_calc NUMBER;
    v_total_calc NUMBER;
    
    CURSOR c_docs IS
        SELECT id_comprobante, tipo_cpe, serie, correlativo, monto_gravado, monto_igv, total_venta
        FROM documentos_tributarios
        WHERE id_tenant = p_id_tenant;
BEGIN
    FOR r IN c_docs LOOP
        v_igv_calc := fn_calcular_igv_oracle(r.monto_gravado);
        v_total_calc := ROUND(r.monto_gravado + v_igv_calc, 2);
        
        IF ABS(r.monto_igv - v_igv_calc) > 0.05 OR ABS(r.total_venta - v_total_calc) > 0.05 THEN
            v_conteo := v_conteo + 1;
            DBMS_OUTPUT.PUT_LINE('Inconsistencia en CPE ' || r.tipo_cpe || '-' || r.serie || '-' || r.correlativo);
        END IF;
    END LOOP;
    
    p_inconsistencias := v_conteo;
    DBMS_OUTPUT.PUT_LINE('Auditoria terminada. Inconsistencias: ' || v_conteo);
END sp_auditoria_cpe_oracle;
/
