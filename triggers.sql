USE pizzeria;

DELIMITER //

CREATE TRIGGER actualizar_stock_ingredientes
AFTER INSERT ON detalle_pedido
FOR EACH ROW
BEGIN

    UPDATE ingredientes i
    JOIN pizza_ingrediente pi
        ON i.id = pi.ingrediente_fk
    SET i.stock = i.stock - (pi.cantidad * NEW.cantidad)
    WHERE pi.pizza_fk = NEW.pizza_fk;

END //

DELIMITER ;

USE pizzeria;

SELECT id, nombre, stock
FROM ingredientes
WHERE id IN (1, 2, 9);

INSERT INTO detalle_pedido
(pedido_fk, pizza_fk, cantidad, subtotal)
VALUES
(6, 3, 1, 28000);

SELECT id, nombre, stock
FROM ingredientes
WHERE id IN (1, 2, 9);

/*===============================================================================================*/

USE pizzeria;

DELIMITER //

CREATE TRIGGER registrar_cambio_precio
AFTER UPDATE ON pizza
FOR EACH ROW
BEGIN

    IF OLD.precio_base <> NEW.precio_base THEN

        INSERT INTO historial_precios
        (pizza_fk, precio_anterior, precio_nuevo, fecha_cambio)
        VALUES
        (NEW.id, OLD.precio_base, NEW.precio_base, NOW());

    END IF;

END //

DELIMITER ;

SELECT id, nombre, precio_base
FROM pizza
WHERE id = 3;

UPDATE pizza
SET precio_base = 30000
WHERE id = 3;

SELECT *
FROM historial_precios;

/*===============================================================================================*/

USE pizzeria;

DELIMITER //

CREATE TRIGGER liberar_repartidor
AFTER UPDATE ON domicilio
FOR EACH ROW
BEGIN

    IF OLD.hora_entrega IS NULL
       AND NEW.hora_entrega IS NOT NULL THEN

        UPDATE repartidor
        SET estado = 'disponible'
        WHERE id = NEW.repartidor_fk;

    END IF;

END //

DELIMITER ;

UPDATE repartidor
SET estado = 'no disponible'
WHERE id = 1;
SELECT * FROM repartidor
WHERE id = 1;

INSERT INTO domicilio
(pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia, costo_envio)
VALUES
(6, 1, '2026-09-14 20:50:00', NULL, 5.0, 5000);

UPDATE domicilio
SET hora_entrega = '2026-09-14 21:20:00'
WHERE pedido_fk = 6;

SELECT * FROM repartidor
WHERE id = 1;