USE Simple_Banco4;

-- 1- Mostrar la cantidad de clientes que tienen cuentas de ahorro
-- La finalidad de esta vista es que el personal pueda ver cada tanto el aumento de las cuentas de ahorros.
CREATE VIEW cantCA AS
SELECT COUNT(*)
FROM cuentas_clientes CC
JOIN cliente C1 ON CC.ID_CLIENTE = C1.ID_CLIENTE
JOIN tipo_cuenta TC ON TC.ID_TCUENTA = CC.ID_TCUENTA
WHERE TC.NOMBRE_TCUENTA='Ahorro';

SELECT * FROM cantCA;
-- 2- Mostrar los clientes que tengan más de una tarjeta
-- El uso de esta es poder ver que clientes esta teniendo más productos del banco en el ambito de Tarjetas.
CREATE VIEW cantTarjeta AS
SELECT C1.NOMBRES, C1.APELLIDOS, NT.CANT_TARJETAS
FROM num_tarjetas NT
JOIN cuentas_clientes CC ON CC.ID_CCLIENTE = NT.ID_CCLIENTE
JOIN cliente C1 ON C1.ID_CLIENTE = CC.ID_CLIENTE
WHERE NT.CANT_TARJETAS >1;

SELECT * FROM cantTarjeta;