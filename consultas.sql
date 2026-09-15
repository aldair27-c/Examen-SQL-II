USE pizzeria;

-- =====================================================
-- 1. CLIENTES CON PEDIDOS ENTRE DOS FECHAS
-- Usa BETWEEN
-- =====================================================

SELECT
    c.nombre AS cliente,
    p.id AS pedido,
    p.fecha_hora,
    p.estado,
    p.total
FROM cliente c
JOIN pedido p
    ON c.id = p.cliente_fk
WHERE p.fecha_hora BETWEEN '2026-09-01 00:00:00'
                       AND '2026-09-14 23:59:59';


-- =====================================================
-- 2. PIZZAS MÁS VENDIDAS
-- Usa GROUP BY y COUNT
-- =====================================================

SELECT
    p.nombre AS pizza,
    SUM(dp.cantidad) AS cantidad_vendida
FROM pizza p
JOIN detalle_pedido dp
    ON p.id = dp.pizza_fk
GROUP BY p.id, p.nombre
ORDER BY cantidad_vendida DESC;


-- =====================================================
-- 3. PEDIDOS POR REPARTIDOR
-- Usa JOIN
-- =====================================================

SELECT
    r.nombre AS repartidor,
    r.zona,
    d.pedido_fk AS pedido,
    d.hora_salida,
    d.hora_entrega
FROM repartidor r
JOIN domicilio d
    ON r.id = d.repartidor_fk
ORDER BY r.nombre;


-- =====================================================
-- 4. TIEMPO PROMEDIO DE ENTREGA POR ZONA
-- Usa AVG y JOIN
-- =====================================================

SELECT
    r.zona,
    AVG(TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega))
        AS promedio_minutos
FROM repartidor r
JOIN domicilio d
    ON r.id = d.repartidor_fk
WHERE d.hora_entrega IS NOT NULL
GROUP BY r.zona
ORDER BY promedio_minutos;


-- =====================================================
-- 5. CLIENTES QUE HAN GASTADO MÁS DE $100.000
-- Usa HAVING
-- =====================================================

SELECT
    c.nombre AS cliente,
    SUM(p.total) AS total_gastado
FROM cliente c
JOIN pedido p
    ON c.id = p.cliente_fk
GROUP BY c.id, c.nombre
HAVING SUM(p.total) > 100000
ORDER BY total_gastado DESC;


-- =====================================================
-- 6. BUSCAR PIZZAS POR PARTE DEL NOMBRE
-- Usa LIKE
-- =====================================================

SELECT
    id,
    nombre,
    tamaño,
    precio_base,
    tipo
FROM pizza
WHERE nombre LIKE '%pollo%';


-- =====================================================
-- 7. CLIENTES FRECUENTES
-- Más de 5 pedidos en un mes
-- Usa SUBCONSULTA
-- =====================================================

SELECT
    c.nombre AS cliente,
    (
        SELECT COUNT(*)
        FROM pedido p2
        WHERE p2.cliente_fk = c.id
          AND p2.fecha_hora >= '2026-09-01'
          AND p2.fecha_hora < '2026-10-01'
    ) AS numero_pedidos
FROM cliente c
WHERE (
    SELECT COUNT(*)
    FROM pedido p2
    WHERE p2.cliente_fk = c.id
      AND p2.fecha_hora >= '2026-09-01'
      AND p2.fecha_hora < '2026-10-01'
) > 5;