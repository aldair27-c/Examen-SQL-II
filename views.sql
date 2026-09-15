USE pizzeria;

-- ================================
-- VIEW 1: Resumen por cliente
-- ================================

DROP VIEW IF EXISTS resumen_pedidos_cliente;

CREATE VIEW resumen_pedidos_cliente AS
SELECT
    c.nombre AS cliente,
    COUNT(p.id) AS numero_pedidos,
    SUM(p.total) AS total_gastado
FROM cliente c
JOIN pedido p
    ON c.id = p.cliente_fk
GROUP BY c.id, c.nombre;


-- ================================
-- VIEW 2: Rendimiento repartidores
-- ================================

DROP VIEW IF EXISTS rendimiento_repartidores;

CREATE VIEW rendimiento_repartidores AS
SELECT
    r.nombre AS repartidor,
    r.zona,
    COUNT(d.id) AS numero_entregas,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega)) AS promedio_minutos
FROM repartidor r
JOIN domicilio d
    ON r.id = d.repartidor_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.id, r.nombre, r.zona;


-- ================================
-- VIEW 3: Ingredientes con stock bajo
-- ================================

DROP VIEW IF EXISTS ingredientes_stock_bajo;

CREATE VIEW ingredientes_stock_bajo AS
SELECT
    id,
    nombre,
    stock,
    stock_minimo
FROM ingredientes
WHERE stock <= stock_minimo;

SELECT * FROM resumen_pedidos_cliente;

SELECT * FROM rendimiento_repartidores;

SELECT * FROM ingredientes_stock_bajo;