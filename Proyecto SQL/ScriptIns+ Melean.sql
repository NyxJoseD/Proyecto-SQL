USE Simple_Banco4;

SELECT * FROM cliente;
INSERT INTO cliente (NOMBRES,APELLIDOS,EMAIL,DIRECCION,DNI,TELEFONO)
VALUES
    ('Pedro', 'Becerra', 'pbecerra@gmail.com','Santa Marta',12345789,'9899989'),
    ('Paula', 'Betulio', 'pbecerra3@gmail.com','Maracaibo',123456666,'9899989'),
    ('Leon', 'Arch', 'pepearch@gmail.com','Valencia',25689789,'9777888996'),
    ('Ender', 'Chacin', 'echacin@gmail.com','Valencia',15622789,'9667888996'),
    ('Max', 'Smith','maxs@digital.com','Perijan',23698777,'9999846879');
    
INSERT INTO convenios (NOMBRE_EMPRESA, DESCUENTO)
VALUES
	('McDonalds',15),
    ('Papa Jhons',10),
    ('Burger King', 13);
    
SELECT * FROM convenios;
INSERT INTO tipo_cuenta (CANT_TCUENTA,NOMBRE_TCUENTA)
VALUES
	(2,'Corriente'),
    (4,'Ahorro');

SELECT * FROM tipo_cuenta;
    
INSERT INTO cuentas_clientes (ID_CLIENTE,ID_CONVENIOS,MONTO,ID_TCUENTA)
VALUES
	(1,2,20000,1),
    (2,1,1030000,2),
    (3,1,10500,1),
    (4,2,56469,2),
    (5,3, 133334,2);
    
SELECT * FROM cuentas_clientes;

INSERT INTO tarjetas (NOMBRE_PROVEEDOR,TIPO_TARJETA)
VALUES
	('Visa','Corriente'),
    ('Mastercard','Corriente'),
    ('Visa','Ahorro'),
    ('Mastercard','Ahorro');
SELECT * FROM tarjetas;

INSERT INTO num_tarjetas (ID_CCLIENTE,ID_TARJETAS,NRO_TARJETA,CANT_TARJETAS)
VALUES
	(1,2,99998888,1),
    (2,2,66667777,2),
    (3,3,55554444,1),
    (4,4,33335555,1),
    (5,1,20201010,1);
    
    SELECT * FROM num_tarjetas;
    
    INSERT INTO cuentas_destino (ID_CLIENTE)
VALUES
	(1),
    (2),
    (3),
    (4);
     SELECT * FROM cuentas_destino;
     
     INSERT INTO transferencias (ID_CCLIENTE,ID_CUENTASDESTINO)
VALUES
	(1,1),
    (2,2),
    (3,3),
    (4,4);
    SELECT * FROM transferencias;