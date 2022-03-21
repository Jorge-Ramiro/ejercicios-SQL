/*--------------- CONSULTAS SOBRE UNA TABLA ---------------*/

/*1.-Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.*/
SELECT
    codigo_oficina,
    ciudad
FROM oficina;
/*2.-Devuelve un listado con la ciudad y el teléfono de las oficinas de España.*/
SELECT
    ciudad,
    telefono
FROM oficina WHERE pais LIKE '%España%';
/*3.-Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.*/
SELECT
    nombre,
    apellido1,
    apellido2,
    email
FROM empleado WHERE codigo_jefe = 7;
/*4.-Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.*/
SELECT
    puesto,
    nombre,
    apellido1,
    apellido2,
    email
FROM empleado WHERE codigo_jefe IS NULL;
/*5.-Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.*/
SELECT
    nombre,
    apellido1,
    apellido2,
    puesto
FROM empleado WHERE puesto NOT LIKE '%Representante ventas%';
/*6.-Devuelve un listado con el nombre de los todos los clientes españoles.*/
SELECT
    nombre_cliente,
    nombre_contacto,
    apellido_contacto
FROM cliente WHERE pais LIKE '%Spain%';
/*7.-Devuelve un listado con los distintos estados por los que puede pasar un pedido.*/
SELECT DISTINCT
    estado
FROM pedido;
/*8.-Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
Utilizando la función YEAR de MySQL.
Utilizando la función DATE_FORMAT de MySQL.
Sin utilizar ninguna de las funciones anteriores.*/
SELECT
    codigo_cliente
FROM pago WHERE YEAR(fecha_pago) = 2008;
SELECT
    codigo_cliente
FROM pago WHERE DATE_FORMAT(fecha_pago, '%Y') = '2008';
SELECT
    codigo_cliente
FROM pago WHERE fecha_pago BETWEEN '2008-01-01' AND '2008-12-31';
/*9.-Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega 
de los pedidos que no han sido entregados a tiempo.*/
SELECT
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido WHERE fecha_entrega > fecha_esperada;
/*10.-Devuelve un listado con el código de pedido, código de cliente, 
fecha esperada y fecha de entrega de los pedidos cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
Utilizando la función ADDDATE de MySQL.
Utilizando la función DATEDIFF de MySQL.
¿Sería posible resolver esta consulta utilizando el operador de suma + o resta -? R=Si*/
SELECT
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido WHERE fecha_esperada >= adddate(fecha_entrega, 2);

SELECT
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido WHERE DATEDIFF(fecha_esperada,fecha_entrega) >= 2;

SELECT
    codigo_pedido,
    codigo_cliente,
    fecha_esperada,
    fecha_entrega
FROM pedido WHERE (fecha_esperada - fecha_entrega) >= 2;
/*11.-Devuelve un listado de todos los pedidos que fueron rechazados en 2009.*/
SELECT
    *
FROM pedido
WHERE estado LIKE '%Rechazado%' AND YEAR(fecha_pedido) = '2009';
/*12.-Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.*/
SELECT
    *
FROM pedido
WHERE estado LIKE '%Entregado%' AND MONTH(fecha_pedido) = '01';
/*13.-Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.*/
SELECT
    *
FROM pago WHERE forma_pago LIKE '%PayPal%' AND YEAR(fecha_pago) = 2008 
ORDER BY total DESC;
/*14.-Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. 
Tenga en cuenta que no deben aparecer formas de pago repetidas.*/
SELECT DISTINCT
    forma_pago
FROM pago;
/*15.-Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock. 
El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.*/
SELECT
    *
FROM producto WHERE gama LIKE '%Ornamentales%' AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;
/*16.-Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas 
tenga el código de empleado 11 o 30.*/
SELECT
    *
FROM cliente WHERE ciudad LIKE '%Madrid%' AND codigo_empleado_rep_ventas IN (11, 30);

/*--------------- CONSULTAS MULTITABLA (COMPOSICION INTERNA) ---------------*/
/*Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2. 
Las consultas con sintaxis de SQL2 se deben resolver con INNER JOIN y NATURAL JOIN.*/

/*1.-Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.*/
SELECT
    c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas
FROM cliente AS c
INNER JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado; 
/*2.-Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.*/
SELECT DISTINCT
    c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas
FROM pago NATURAL JOIN cliente AS c
INNER JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;
/*3.-Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.*/
SELECT
    c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas
FROM cliente AS c
INNER JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE c.codigo_cliente NOT IN (SELECT DISTINCT p.codigo_cliente FROM pago AS p);
/*4.-Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes 
junto con la ciudad de la oficina a la que pertenece el representante.*/
SELECT DISTINCT
	c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas,
    o.ciudad
FROM pago
NATURAL JOIN cliente AS c
INNER JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina AS o ON e.codigo_oficina = o.codigo_oficina;
/*5.-Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes 
junto con la ciudad de la oficina a la que pertenece el representante.*/
SELECT
	c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas,
    o.ciudad
FROM empleado AS e NATURAL JOIN oficina AS o
INNER JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente NOT IN (SELECT DISTINCT pago.codigo_cliente FROM pago);
/*6.-Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.*/
SELECT
    IFNULL(o.linea_direccion1, o.linea_direccion2) AS direccion
FROM oficina AS o NATURAL JOIN empleado AS e
INNER JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad LIKE '%Fuenlabrada';
/*7.-Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina 
a la que pertenece el representante.*/
SELECT 
	c.nombre_cliente,
    CONCAT(e.nombre, ' ', e.apellido1, ' ', e.apellido2) AS representante_ventas,
	o.ciudad 
FROM oficina AS o NATURAL JOIN empleado AS e
INNER JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas;
/*8.-Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.*/
SELECT
	CONCAT(e.nombre, ' ', e.apellido1) AS empleado_,
	CONCAT(j.nombre, ' ', j.apellido1) AS jefe_
FROM empleado AS e
INNER JOIN empleado AS j ON e.codigo_jefe = j.codigo_empleado;
/*9.-Devuelve un listado que muestre el nombre de cada empleados, el nombre de su jefe y el nombre del jefe de sus jefe.*/
SELECT
	CONCAT(e.nombre, ' ', e.apellido1) AS empleado_,
	CONCAT(j.nombre, ' ', j.apellido1) AS jefe_,
    CONCAT(jj.nombre, ' ', jj.apellido1) AS jefe_de_jefe
FROM empleado AS e
INNER JOIN empleado AS j ON e.codigo_jefe = j.codigo_empleado
INNER JOIN empleado AS jj ON j.codigo_jefe = jj.codigo_empleado;
/*10.-Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.*/
SELECT DISTINCT
    c.nombre_cliente
FROM cliente AS c NATURAL JOIN pedido AS p
WHERE p.fecha_entrega > fecha_esperada;
/*11.-Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.*/
SELECT DISTINCT
	c.codigo_cliente,
    pr.gama
FROM producto AS pr NATURAL JOIN detalle_pedido
Natural JOIN pedido AS pe NATURAL JOIN cliente AS c;

/*--------------- CONSULTAS MULTITABLA (COMPOSICION EXTERNA) ---------------*/
/*Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, NATURAL LEFT JOIN y NATURAL RIGHT JOIN.*/

/*1.-Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT
    c.*
FROM cliente AS c
NATURAL LEFT JOIN pago AS p
WHERE p.forma_pago IS NULL;
/*2.-Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.*/
SELECT
    c.*
FROM cliente AS c
NATURAL LEFT JOIN pedido AS pe
WHERE pe.codigo_pedido IS NULL;
/*3.-Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.*/
SELECT
    c.*
FROM pago AS p
NATURAL RIGHT JOIN cliente AS c
NATURAL LEFT JOIN pedido AS pe
WHERE P.forma_pago is NULL AND pe.codigo_pedido IS NULL;
/*4.-Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.*/
SELECT
    *
FROM empleado AS e
NATURAL LEFT JOIN oficina AS o
WHERE e.codigo_oficina IS NULL;
/*5.-Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.*/
SELECT
    e.*
FROM empleado AS e
LEFT JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_empleado_rep_ventas IS NULL;
/*6.-Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado 
junto con los datos de la oficina donde trabajan.*/
SELECT
    e.nombre,
    e.apellido1,
    o.*
FROM cliente AS c
RIGHT JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN oficina AS o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL;
/*7.-Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.*/
SELECT
    e.nombre,
    e.apellido1,
    o.*
FROM cliente AS c
RIGHT JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
LEFT JOIN oficina AS o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_empleado_rep_ventas IS NULL OR e.codigo_oficina IS NULL;
/*8.-Devuelve un listado de los productos que nunca han aparecido en un pedido.*/
SELECT
    pr.*
FROM producto AS pr
NATURAL LEFT JOIN detalle_pedido AS dp
WHERE dp.codigo_pedido IS NULL;
/*9.-Devuelve un listado de los productos que nunca han aparecido en un pedido. El resultado debe mostrar el nombre, 
la descripción y la imagen del producto.*/
SELECT
    pr.nombre,
    pr.descripcion,
    gp.imagen
FROM gama_producto AS gp
NATURAL RIGHT JOIN producto AS pr
NATURAL LEFT JOIN detalle_pedido AS dp
WHERE dp.codigo_pedido IS NULL;
/*10.-Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente 
que haya realizado la compra de algún producto de la gama Frutales.*/
SELECT DISTINCT
	o.*
FROM producto 
NATURAL RIGHT JOIN detalle_pedido
NATURAL RIGHT JOIN pedido
NATURAL RIGHT JOIN cliente AS c
RIGHT JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
RIGHT JOIN oficina AS o ON e.codigo_oficina = o.codigo_oficina
WHERE producto.gama NOT LIKE '%Frutales%';
/*11.-Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.*/
SELECT DISTINCT
    cliente.*
FROM pedido
NATURAL LEFT JOIN cliente
NATURAL LEFT JOIN pago
WHERE pago.forma_pago is null;
/*12.-Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.*/
SELECT
    e.codigo_empleado,
    CONCAT(e.nombre, ' ', e.apellido1) AS empleado_,
    CONCAT(ej.nombre, ' ', ej.apellido1) AS jefe_
FROM cliente AS c
RIGHT JOIN empleado AS e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN empleado AS ej ON e.codigo_jefe = ej.codigo_empleado
WHERE c.codigo_empleado_rep_ventas IS NULL;

/*--------------- CONSULTAS RESUMEN ---------------*/

/*1.-¿Cuántos empleados hay en la compañía?*/
SELECT
    COUNT(*) AS total_empleados
FROM empleado;
/*2.-¿Cuántos clientes tiene cada país?*/
SELECT
    pais,
    COUNT(*) AS total_clientes
FROM cliente
GROUP BY pais;
/*3.-¿Cuál fue el pago medio en 2009?*/
SELECT
	YEAR(fecha_pago) AS año,
    AVG(total) AS pago_medio
FROM pago
WHERE YEAR(fecha_pago) = 2009;
/*4.-¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.*/
SELECT
    estado,
    COUNT(*) AS n_pedidos
FROM pedido
GROUP BY estado
ORDER BY n_pedidos DESC;
/*5.-Calcula el precio de venta del producto más caro y más barato en una misma consulta.*/
SELECT
    MAX(precio_venta) AS precio_maximo,
    MIN(precio_venta) AS precio_minimo
FROM producto;
/*6.-Calcula el número de clientes que tiene la empresa.*/
SELECT
    COUNT(*) AS clientes_de_la_empresa
FROM empleado AS e
INNER JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas;
/*7.-¿Cuántos clientes existen con domicilio en la ciudad de Madrid?*/
SELECT
    ciudad,
    COUNT(*) AS clientes
FROM cliente
GROUP BY ciudad
HAVING ciudad LIKE '%Madrid%';
/*8.-¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?*/
SELECT
    ciudad,
    COUNT(*) AS clientes
FROM cliente
GROUP BY ciudad
HAVING ciudad LIKE 'M%';
/*9.-Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.*/
SELECT
    e.nombre,
    COUNT(*) AS clientes
FROM empleado AS e
INNER JOIN cliente AS c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
GROUP BY e.codigo_empleado;
/*10.-Calcula el número de clientes que no tiene asignado representante de ventas.*/
SELECT
    COUNT(*) AS n_clientes_sin_rep
FROM cliente
WHERE codigo_empleado_rep_ventas IS NULL;
/*11.-Calcula la fecha del primer y último pago realizado por cada uno de los clientes.
El listado deberá mostrar el nombre y los apellidos de cada cliente.*/
SELECT
    codigo_cliente,
    MIN(fecha_pago) AS primer_pago,
    Max(fecha_pago) AS ultimo_pago
FROM pago
GROUP BY codigo_cliente;
/*12.-Calcula el número de productos diferentes que hay en cada uno de los pedidos.*/
SELECT DISTINCT
    codigo_pedido,
    COUNT(*) AS n_productos_distintos
FROM detalle_pedido
GROUP BY codigo_pedido;
/*13.-Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.*/
SELECT
    codigo_pedido,
    SUM(cantidad) AS cantidad_total
FROM detalle_pedido
GROUP BY codigo_pedido;
/*14.-Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. 
El listado deberá estar ordenado por el número total de unidades vendidas.*/
SELECT
    codigo_producto,
    SUM(cantidad) AS total_unidades_vendidas
FROM detalle_pedido
GROUP BY codigo_producto
ORDER BY total_unidades_vendidas DESC LIMIT 20;
/*15.-La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado. 
La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido. 
El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.*/
SELECT
    SUM(precio_unidad * cantidad) AS base_imponible,
    ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS iva_21,
    SUM(precio_unidad * cantidad) + ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS total_facturado
FROM detalle_pedido;
/*16.-La misma información que en la pregunta anterior, pero agrupada por código de producto.*/
SELECT
    codigo_producto,
    SUM(precio_unidad * cantidad) AS base_imponible,
    ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS iva_21,
    SUM(precio_unidad * cantidad) + ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS total_facturado
FROM detalle_pedido
GROUP BY codigo_producto;
/*17.-La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.*/
SELECT
    codigo_producto,
    SUM(precio_unidad * cantidad) AS base_imponible,
    ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS iva_21,
    SUM(precio_unidad * cantidad) + ROUND((SUM(precio_unidad * cantidad) * .21), 2) AS total_facturado
FROM detalle_pedido
GROUP BY codigo_producto
HAVING codigo_producto LIKE 'OR%';
/*18.-Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, 
total facturado y total facturado con impuestos (21% IVA).*/
SELECT
    p.nombre,
    COUNT(dp.cantidad) AS unidades_vendidas,
    SUM(dp.precio_unidad * dp.cantidad) AS total_facturado,
    SUM(dp.precio_unidad * dp.cantidad) + ROUND((SUM(dp.precio_unidad * dp.cantidad) * .21), 2) AS total_facturado_con_impuestos
FROM detalle_pedido AS dp
NATURAL JOIN producto AS p
GROUP BY codigo_producto
HAVING total_facturado > 3000;
/*19.-Muestre la suma total de todos los pagos que se realizaron para cada uno de los años que aparecen en la tabla pagos.*/
SELECT
    YEAR(fecha_pago) AS año,
    SUM(total) AS total_pagos
FROM pago
GROUP BY año
ORDER BY año;

/*--------------- SUBCONSULTAS ---------------*/
/*----- CON OPERADORES BASICOS DE COMPARACION -----*/

/*1.-Devuelve el nombre del cliente con mayor límite de crédito.*/
SELECT
    nombre_cliente,
    nombre_contacto
FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);
/*2.-Devuelve el nombre del producto que tenga el precio de venta más caro.*/
SELECT
    nombre
FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);
/*3.-Devuelve el nombre del producto del que se han vendido más unidades. 
(Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir 
de los datos de la tabla detalle_pedido)*/
SELECT
    *
FROM producto
WHERE codigo_producto = (SELECT
                                codigo_producto
                        FROM detalle_pedido 
                        GROUP BY codigo_producto 
                        HAVING SUM(cantidad) = (SELECT
                                                    SUM(cantidad) AS total_vendidos
                                                FROM detalle_pedido 
                                                GROUP BY codigo_producto
                                                ORDER BY total_vendidos DESC LIMIT 1));
/*4.-Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).*/
SELECT
    codigo_cliente,
    nombre_cliente,
    limite_credito
FROM cliente
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago)
AND limite_credito >=all (SELECT total FROM pago);
/*5.-Devuelve el producto que más unidades tiene en stock.*/
SELECT
    *
FROM producto
WHERE cantidad_en_stock = (SELECT MAX(cantidad_en_stock) FROM producto);
/*6.-Devuelve el producto que menos unidades tiene en stock.*/
SELECT
    *
FROM producto
WHERE cantidad_en_stock = (SELECT MIN(cantidad_en_stock) FROM producto);
/*7.-Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.*/
SELECT
    nombre,
    apellido1,
    apellido2,
    email
FROM empleado
WHERE codigo_jefe = (SELECT codigo_empleado FROM empleado WHERE CONCAT(nombre, ' ', apellido1) LIKE '%Alberto Soria%');

/*--------------- SUBCONSULTAS CON ALL Y ANY ---------------*/

/*8.-Devuelve el nombre del cliente con mayor límite de crédito.*/
SELECT
    *
FROM cliente
WHERE limite_credito =ANY (SELECT MAX(limite_credito) FROM cliente); 
/*9.-Devuelve el nombre del producto que tenga el precio de venta más caro.*/
SELECT
    nombre,
    precio_venta
FROM producto
WHERE precio_venta =ANY (SELECT MAX(precio_venta) FROM producto);
/*10.-Devuelve el producto que menos unidades tiene en stock.*/
SELECT
    *
FROM producto
WHERE cantidad_en_stock <=ALL (SELECT cantidad_en_stock FROM producto);

/*--------------- SUBCONSULTAS CON IN Y NOT IN ---------------*/

/*11.-Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.*/
SELECT
    nombre,
    apellido1,
    puesto
FROM empleado
WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);
/*12.-Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT
    *
FROM cliente
WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);
/*13.-Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.*/
SELECT
    *
FROM cliente
WHERE codigo_cliente IN (SELECT codigo_cliente FROM pago);
/*14.-Devuelve un listado de los productos que nunca han aparecido en un pedido.*/
SELECT
    *
FROM producto
WHERE codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido);
/*15.-Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante 
de ventas de ningún cliente.*/
SELECT DISTINCT
    empleado.nombre,
    empleado.apellido1,
    empleado.puesto,
    oficina.telefono
FROM empleado
NATURAL JOIN oficina
WHERE codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente)
ORDER BY empleado.nombre;
/*16.-Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas 
de algún cliente que haya realizado la compra de algún producto de la gama Frutales.*/
SELECT
    *
FROM oficina 
WHERE codigo_oficina NOT IN (SELECT 
                                    codigo_oficina 
                            FROM empleado 
                            WHERE codigo_empleado IN (SELECT 
                                                            codigo_empleado_rep_ventas 
                                                    FROM cliente 
                                                    WHERE codigo_cliente IN (SELECT 
                                                                                    codigo_cliente 
                                                                            FROM pedido 
                                                                            WHERE codigo_pedido IN (SELECT 
                                                                                                            codigo_pedido 
                                                                                                    FROM detalle_pedido 
                                                                                                    WHERE codigo_producto IN (SELECT 
                                                                                                                                    codigo_producto 
                                                                                                                            FROM producto 
                                                                                                                            WHERE gama LIKE '%Frutales%')))));

/*17.-Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.*/
SELECT
    *
FROM cliente
WHERE codigo_cliente NOT IN (SELECT codigo_cliente FROM pago) 
AND codigo_cliente IN (SELECT codigo_cliente FROM pedido);

/*--------------- SUBCONSULTAS CON EXISTS Y NOT EXISTS ---------------*/

/*18.-Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.*/
SELECT
    *
FROM cliente
WHERE NOT EXISTS (SELECT codigo_cliente FROM pago WHERE cliente.codigo_cliente = pago.codigo_cliente);
/*19.-Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.*/
SELECT
    *
FROM cliente
WHERE EXISTS (SELECT codigo_cliente FROM pago WHERE cliente.codigo_cliente = pago.codigo_cliente);
/*20.-Devuelve un listado de los productos que nunca han aparecido en un pedido.*/
SELECT
    *
FROM producto
WHERE NOT EXISTS (SELECT * FROM detalle_pedido WHERE producto.codigo_producto = detalle_pedido.codigo_producto);
/*21.-Devuelve un listado de los productos que han aparecido en un pedido alguna vez.*/
SELECT
    *
FROM producto
WHERE EXISTS (SELECT * FROM detalle_pedido WHERE producto.codigo_producto = detalle_pedido.codigo_producto);

/*--------------- SUBCONSULTAS CORRELACIONADAS ---------------*/
/*----- CONSULTAS VARIADAS -----*/

/*1.-Devuelve el listado de clientes indicando el nombre del cliente y cuántos pedidos ha realizado. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pedido.*/
SELECT
    c.nombre_cliente,
    (SELECT COUNT(*) FROM pedido AS p WHERE c.codigo_cliente = p.codigo_cliente) AS n_pedidos
FROM cliente AS c;
/*2.-Devuelve un listado con los nombres de los clientes y el total pagado por cada uno de ellos. 
Tenga en cuenta que pueden existir clientes que no han realizado ningún pago.*/
SELECT
    c.nombre_cliente,
    IFNULL((SELECT SUM(total) FROM pago AS p WHERE c.codigo_cliente = p.codigo_cliente), 'No tiene pagos realizados') AS total_pagado
FROM cliente AS c;
/*3.-Devuelve el nombre de los clientes que hayan hecho pedidos en 2008 ordenados alfabéticamente de menor a mayor.*/
SELECT DISTINCT
    (SELECT nombre_cliente FROM cliente WHERE cliente.codigo_cliente = pedido.codigo_cliente) AS nombre_c
FROM pedido
WHERE year(fecha_pedido) = 2008
ORDER BY nombre_c;
/*4.-Devuelve el nombre del cliente, el nombre y primer apellido de su representante de ventas y el número de 
teléfono de la oficina del representante de ventas, de aquellos clientes que no hayan realizado ningún pago.*/
SELECT
    nombre_cliente,
    (SELECT CONCAT(nombre, ' ', apellido1) FROM empleado WHERE cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado) AS nombre_rep,
    (SELECT (SELECT telefono FROM oficina WHERE oficina.codigo_oficina = empleado.codigo_oficina) FROM empleado WHERE empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas) AS numero_tel
FROM cliente
WHERE (SELECT DISTINCT codigo_cliente 
        FROM pago 
        WHERE pago.codigo_cliente = cliente.codigo_cliente ) IS NULL;
/*5.-Devuelve el listado de clientes donde aparezca el nombre del cliente, el nombre y primer apellido de su representante 
de ventas y la ciudad donde está su oficina.*/
SELECT
    nombre_cliente,
    (SELECT CONCAT(nombre, ' ', apellido1) FROM empleado WHERE cliente.codigo_empleado_rep_ventas = empleado.codigo_empleado) AS nombre_rep,
    (SELECT (SELECT ciudad FROM oficina WHERE oficina.codigo_oficina = empleado.codigo_oficina) FROM empleado WHERE empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas) AS ciudad_oficina
FROM cliente;
/*6.-Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante 
de ventas de ningún cliente.*/
SELECT
    nombre,
    apellido1,
    apellido2,
    puesto,
    (SELECT telefono FROM oficina WHERE oficina.codigo_oficina = empleado.codigo_oficina) AS numero_tel
FROM empleado
WHERE (SELECT DISTINCT codigo_empleado_rep_ventas FROM cliente WHERE empleado.codigo_empleado = cliente.codigo_empleado_rep_ventas) IS NULL;
/*7.-Devuelve un listado indicando todas las ciudades donde hay oficinas y el número de empleados que tiene.*/
SELECT
    ciudad,
    (SELECT COUNT(*) FROM empleado AS e WHERE o.codigo_oficina = e.codigo_oficina) AS total_empleados
FROM oficina AS o;