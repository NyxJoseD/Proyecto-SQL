-- Creación de BD y Tablas
CREATE SCHEMA Simple_Banco4;
USE Simple_Banco4;

CREATE TABLE CLIENTE(
	ID_CLIENTE INT NOT NULL UNIQUE AUTO_INCREMENT PRIMARY KEY, 
    NOMBRES VARCHAR(100) NOT NULL,
    APELLIDOS VARCHAR(100) NOT NULL,
    EMAIL VARCHAR(100) NOT NULL,
    DIRECCION VARCHAR(100) NOT NULL,
    TELEFONO BIGINT NOT NULL,
    DNI INT NOT NULL UNIQUE
);

CREATE TABLE CONVENIOS(
ID_CONVENIOS INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
NOMBRE_EMPRESA VARCHAR(150) NOT NULL,
DESCUENTO INT NOT NULL DEFAULT 0
);
CREATE TABLE TIPO_CUENTA(
	ID_TCUENTA INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    CANT_TCUENTA INT NOT NULL DEFAULT 0,
    NOMBRE_TCUENTA VARCHAR(50)
);
CREATE TABLE CUENTAS_CLIENTES(
	ID_CCLIENTE INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_CLIENTE INT NOT NULL,
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE),
    ID_CONVENIOS INT NOT NULL,
    FOREIGN KEY (ID_CONVENIOS) REFERENCES CONVENIOS(ID_CONVENIOS),
    ID_TCUENTA INT NOT NULL,
    FOREIGN KEY (ID_TCUENTA) REFERENCES TIPO_CUENTA(ID_TCUENTA),
    MONTO BIGINT NOT NULL DEFAULT 0
);


CREATE TABLE TARJETAS(
	ID_TARJETAS INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    NOMBRE_PROVEEDOR VARCHAR(50),
    TIPO_TARJETA VARCHAR(50)
);
CREATE TABLE NUM_TARJETAS(
	ID_NUMTARJETAS INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_CCLIENTE INT NOT NULL,
    FOREIGN KEY (ID_CCLIENTE) REFERENCES CUENTAS_CLIENTES(ID_CCLIENTE),
    ID_TARJETAS INT NOT NULL,
    FOREIGN KEY (ID_TARJETAS) REFERENCES TARJETAS(ID_TARJETAS),
    NRO_TARJETA INT NOT NULL,
    CANT_TARJETAS INT NOT NULL DEFAULT 0
);

CREATE TABLE CUENTAS_DESTINO(
	ID_CUENTASDESTINO INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	ID_CLIENTE INT NOT NULL,
    FOREIGN KEY (ID_CLIENTE) REFERENCES CLIENTE(ID_CLIENTE)
);
CREATE TABLE TRANSFERENCIAS(
	ID_TRANSFERENCIAS INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    ID_CCLIENTE INT NOT NULL,
    FOREIGN KEY (ID_CCLIENTE) REFERENCES CUENTAS_CLIENTES(ID_CCLIENTE),
    ID_CUENTASDESTINO INT NOT NULL,
    FOREIGN KEY (ID_CUENTASDESTINO) REFERENCES CUENTAS_DESTINO(ID_CUENTASDESTINO)
);



    
    -- Vistas
    -- 1-Vista para ver la cantidad de clientes que hay en la tabla cliente.

CREATE VIEW cantidad_clientes AS
SELECT COUNT(*)
FROM cliente;

SELECT * FROM cantidad_clientes;

-- 2-Mostrar los monto que tienen los clientes superiores a 10000 de la tabla cuentas_clientes
CREATE VIEW monto_clientes_superior10000 AS
SELECT * FROM cuentas_clientes 
WHERE monto>=10000;

SELECT * FROM monto_clientes_superior10000;

-- 3- Mostrar Clientes que tengan convenios con Papa Jhons
CREATE VIEW convenios_papajhons AS
SELECT C1.NOMBRES, C1.APELLIDOS, C3.NOMBRE_EMPRESA, C3.DESCUENTO
FROM cuentas_clientes CC
JOIN cliente C1 ON CC.ID_CLIENTE = C1.ID_CLIENTE
JOIN convenios C3 ON C3.ID_CONVENIOS = CC.ID_CONVENIOS
WHERE CC.ID_CONVENIOS=2 OR C3.NOMBRE_EMPRESA='Papa Jhons';

SELECT * FROM convenios;
SELECT * FROM convenios_papajhons;

-- 4- Mostrar Clientes que tengan cuenta ahorro
CREATE VIEW clientes_cuentAhorro AS
SELECT C1.NOMBRES, C1.APELLIDOS, TC.NOMBRE_TCUENTA
FROM cuentas_clientes CC
JOIN cliente C1 ON CC.ID_CLIENTE = C1.ID_CLIENTE
JOIN tipo_cuenta TC ON TC.ID_TCUENTA = CC.ID_TCUENTA
WHERE TC.NOMBRE_TCUENTA='Ahorro';

SELECT * FROM clientes_cuentAhorro;

-- 5- Mostrar Clientes que tengan tarjeta de credito ( Cuenta Corriente )
CREATE VIEW clientes_tarjetacredito AS
SELECT C1.NOMBRES, C1.APELLIDOS, T.TIPO_TARJETA
FROM cuentas_clientes CC
JOIN cliente C1 ON CC.ID_CLIENTE = C1.ID_CLIENTE
JOIN num_tarjetas NC ON NC.ID_CCLIENTE = CC.ID_CCLIENTE
JOIN tarjetas T ON T.ID_TARJETAS = NC.ID_TARJETAS
WHERE T.TIPO_TARJETA = 'Corriente';

SELECT * FROM clientes_tarjetacredito;

-- Funciones

-- 1 Función CONCAT para unir el nombre y el apellido

DELIMITER //
CREATE FUNCTION nombreCompleto(nombre VARCHAR(100), apellido VARCHAR(100)) RETURNS VARCHAR(200)
DETERMINISTIC
  BEGIN
    DECLARE nombre_completo VARCHAR(200);
    SET nombre_completo = CONCAT(nombre, ' ', apellido);
    RETURN nombre_completo;
  END//
  
  SELECT NOMBRES,APELLIDOS, nombreCompleto(NOMBRES,APELLIDOS) as Nombre_Completo FROM cliente;

-- 2 Función que trae información de usuario como nombre completo,monto y tipo de cuenta.
DELIMITER //
CREATE FUNCTION TablaClientes(CLIENTE_ID INT) RETURNS VARCHAR(500)
DETERMINISTIC
BEGIN
DECLARE InfoCuenta VARCHAR(500);
SELECT CONCAT(C1.NOMBRES, '  ',C1.APELLIDOS,' - ',CC.MONTO,' - ',TC.NOMBRE_TCUENTA) 
FROM cuentas_clientes CC
JOIN cliente C1 ON CC.ID_CLIENTE = C1.ID_CLIENTE
JOIN tipo_cuenta TC ON TC.ID_TCUENTA = CC.ID_TCUENTA 
WHERE CC.ID_CLIENTE= CLIENTE_ID INTO InfoCuenta;
RETURN InfoCuenta;
  END//
  SELECT TablaClientes(4) AS NC_TC_MONTO;

-- Trigger

-- 1 Validar que el numero de telefono ingresado no sea negativo ni supere los 100 millones
DELIMITER $$
CREATE TRIGGER `validar_TELEFONO_cliente`
BEFORE INSERT ON `cliente`
FOR EACH ROW
BEGIN
  IF NEW.TELEFONO < 0 THEN
    set NEW.TELEFONO = 0;
  ELSEIF NEW.TELEFONO > 100000000 THEN
    set NEW.TELEFONO = 0;
  END IF;
END$$
-- Se hace una insercción con Telefono negativo
DROP TRIGGER validar_TELEFONO_cliente;
INSERT INTO cliente (NOMBRES,APELLIDOS,EMAIL,DIRECCION,DNI,TELEFONO)
VALUES
    ('Julio2', 'Iglesia2', 'jiglesia2@gmail.com', 'Cucuta2', 1234,'-1');

SELECT * FROM cliente;

-- 2 Actualizar el numero de telefono ingresado no sea negativo ni supere los 100 millones
DELIMITER $$
CREATE TRIGGER `actualizar_TELEFONO_cliente`
BEFORE UPDATE ON `cliente`
FOR EACH ROW
BEGIN
  IF NEW.TELEFONO < 0 THEN
    set NEW.TELEFONO =0;
  ELSEIF NEW.TELEFONO > 100000000 THEN
    set NEW.TELEFONO = 0;
  END IF;
END$$

UPDATE cliente SET TELEFONO = '-4' WHERE ID_CLIENTE = 6;

SELECT * FROM cliente;

# Auditar convenios
CREATE TABLE audits_convenios (
	id_log INT PRIMARY KEY auto_increment,
    entity varchar(100),
    entity_id int,
    insert_dt datetime,
    created_by varchar(100),
    last_update_dt datetime,
    last_updated_by varchar(100)
);
-- Trigger para la auditoria de convenios
CREATE TRIGGER `insert_convenio_auditoria`
AFTER INSERT ON `convenios`
FOR EACH ROW
INSERT INTO `audits_convenios`(entity, entity_id, insert_dt, created_by, last_update_dt, last_updated_by) 
VALUES ('convenios', NEW.ID_CONVENIOS, CURRENT_TIMESTAMP(), USER(), CURRENT_TIMESTAMP(), USER());

CREATE TRIGGER `update_convenio_auditoria`
AFTER UPDATE ON `convenios`
FOR EACH ROW
UPDATE `audits_convenios` SET last_update_dt = CURRENT_TIMESTAMP(), last_updated_by = USER() 
WHERE entity_id = OLD.ID_CONVENIOS;


-- 3 Validar que el descuento asignado por convenios no supere el 50% ni sea negativo
DELIMITER $$
CREATE TRIGGER `validar_descuento_cuenta_cliente`
BEFORE INSERT ON `convenios`
FOR EACH ROW
BEGIN
  IF NEW.DESCUENTO <= 0 OR NEW.DESCUENTO <=10 THEN
    set NEW.DESCUENTO = 10;
  ELSEIF NEW.DESCUENTO >= 50 THEN
    set NEW.DESCUENTO = 50;
  END IF;
END$$
-- Se hace una insercción con Telefono negativo

INSERT INTO convenios (NOMBRE_EMPRESA, DESCUENTO)
VALUES
	('Melt Pizza',150),
    ('Latam air',-10);

SELECT * FROM convenios;

--  4 Actualizar el descuento no sea negativo ni supere el 50%

DELIMITER $$
CREATE TRIGGER `actualizar_convenios_cuenta_cliente`
BEFORE UPDATE ON `convenios`
FOR EACH ROW
BEGIN
  IF NEW.DESCUENTO <= 0 OR NEW.DESCUENTO <=10 THEN
    set NEW.DESCUENTO = 10;
  ELSEIF NEW.DESCUENTO >= 50 THEN
    set NEW.DESCUENTO = 50;
  END IF;
END$$

UPDATE convenios SET DESCUENTO = 150 WHERE ID_CONVENIOS = 2;
SELECT * FROM convenios;
SELECT * FROM audits_convenios;

 -- Store Procedure
 
 -- 1 Ordenar de forma ascendente nombre y apellido de la tabla cliente
DELIMITER $$
CREATE PROCEDURE `OrdenarClientes_PorNombre`(IN nombres CHAR(20))
BEGIN
	IF nombres <> '' THEN -- Verifico si nombres es diferente a ''
		SET @name_order = concat('ORDER BY ', nombres);
	ELSE
		SET @name_order = '';
	END IF;
    
    SET @ordenamiento = concat('SELECT * FROM cliente ', @name_order);
	PREPARE runSQL FROM @ordenamiento;
	EXECUTE runSQL;
	DEALLOCATE PREPARE runSQL;
END
$$

CALL OrdenarClientes_PorNombre('NOMBRES');

-- 2 Insertar un nuevo convenio en una tabla

DELIMITER $$
CREATE PROCEDURE `InsertarConvenio`(IN NOMBRE_EMP CHAR(150),IN DSCTO INT,OUT mensaje VARCHAR(50))
BEGIN
	IF NOMBRE_EMP <> '' AND DSCTO <> '' THEN
		INSERT INTO convenios (NOMBRE_EMPRESA, DESCUENTO)
VALUES (NOMBRE_EMP, DSCTO);
        SET mensaje = 'Se ha insertado el convenio exitosamente';
	ELSE
	SET mensaje = 'ERROR: no se pudo crear el convenio';
	END IF;

END
$$

CALL InsertarConvenio('Wendy',20, @msj);
SELECT * FROM convenios;


