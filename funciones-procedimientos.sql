USE pizzeria;

DROP FUNCTION IF EXISTS calcular_total_pedido;

DELIMITER //

CREATE FUNCTION calcular_total_pedido(p_id_pedido INT)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE v_total_pizzas DOUBLE DEFAULT 0;
    DECLARE v_costo_envio DOUBLE DEFAULT 0;

    SELECT COALESCE(SUM(subtotal), 0)
    INTO v_total_pizzas
    FROM detalle_pedido
    WHERE pedido_fk = p_id_pedido;

    SELECT COALESCE(MAX(costo_envio), 0)
    INTO v_costo_envio
    FROM domicilio
    WHERE pedido_fk = p_id_pedido;

    RETURN (v_total_pizzas + v_costo_envio) * 1.19;
END //

DELIMITER ;

SET SQL_SAFE_UPDATES = 0;

UPDATE pedido
SET total = calcular_total_pedido(id);

SET SQL_SAFE_UPDATES = 1;

SELECT id, total
FROM pedido;
/*===============================================================================================*/
USE pizzeria;

DELIMITER //

CREATE FUNCTION ganancia_neta_diaria(p_fecha DATE)
RETURNS DOUBLE
DETERMINISTIC
BEGIN
    DECLARE v_ventas DOUBLE;
    DECLARE v_costos DOUBLE;

    SELECT COALESCE(SUM(dp.subtotal), 0)
    INTO v_ventas
    FROM pedido p
    JOIN detalle_pedido dp ON p.id = dp.pedido_fk
    WHERE DATE(p.fecha_hora) = p_fecha
      AND p.estado = 'entregado';

    SELECT COALESCE(SUM(dp.cantidad * pi.cantidad * i.costo_unitario), 0)
    INTO v_costos
    FROM pedido p
    JOIN detalle_pedido dp ON p.id = dp.pedido_fk
    JOIN pizza_ingrediente pi ON dp.pizza_fk = pi.pizza_fk
    JOIN ingredientes i ON pi.ingrediente_fk = i.id
    WHERE DATE(p.fecha_hora) = p_fecha
      AND p.estado = 'entregado';

    RETURN v_ventas - v_costos;
END //

DELIMITER ;
SELECT ganancia_neta_diaria('2026-09-01');

/*===============================================================================================*/

USE pizzeria;

DELIMITER //

CREATE PROCEDURE marcar_pedido_entregado(IN p_id_pedido INT)
BEGIN

    UPDATE pedido
    SET estado = 'entregado'
    WHERE id = p_id_pedido;

END //

DELIMITER ;
CALL marcar_pedido_entregado(6);
SELECT id, estado
FROM pedido
WHERE id = 6;

/*===============================================================================================*/

