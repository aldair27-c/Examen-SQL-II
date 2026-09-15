-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pizzeria
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pizzeria` DEFAULT CHARACTER SET utf8 ;
USE `pizzeria` ;

-- -----------------------------------------------------
-- Table `pizzeria`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(60) NOT NULL,
  `telefono` VARCHAR(45) NULL,
  `direccion` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pizza` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(80) NOT NULL,
  `tamaño` VARCHAR(45) NOT NULL,
  `precio_base` DOUBLE NOT NULL,
  `tipo` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`ingredientes`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`ingredientes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `stock` INT NOT NULL,
  `stock_minimo` INT NOT NULL,
  `costo_unitario` DOUBLE NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pizza_ingrediente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pizza_ingrediente` (
  `pizza_fk` INT NOT NULL,
  `ingrediente_fk` INT NOT NULL,
  `cantidad` INT NOT NULL,
  PRIMARY KEY (`pizza_fk`, `ingrediente_fk`),
  INDEX `fk_pizza_ingrediente_2_idx` (`ingrediente_fk` ASC) VISIBLE,
  CONSTRAINT `fk_pizza_ingrediente_1`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_pizza_ingrediente_2`
    FOREIGN KEY (`ingrediente_fk`)
    REFERENCES `pizzeria`.`ingredientes` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cliente_fk` INT NOT NULL,
  `fecha_hora` DATETIME NOT NULL,
  `estado` ENUM('pendiente', 'en preparación', 'entregado', 'cancelado') NOT NULL,
  `total` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_pedido_1_idx` (`cliente_fk` ASC) VISIBLE,
  CONSTRAINT `fk_pedido_1`
    FOREIGN KEY (`cliente_fk`)
    REFERENCES `pizzeria`.`cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`detalle_pedido`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`detalle_pedido` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pedido_fk` INT NOT NULL,
  `pizza_fk` INT NOT NULL,
  `cantidad` INT NOT NULL,
  `subtotal` DOUBLE NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_detalle_pedido_1_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `fk_detalle_pedido_2_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `fk_detalle_pedido_1`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_detalle_pedido_2`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`repartidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`repartidor` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NOT NULL,
  `zona` VARCHAR(45) NOT NULL,
  `estado` ENUM('disponible', 'no disponible') NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`domicilio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`domicilio` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pedido_fk` INT NOT NULL,
  `repartidor_fk` INT NOT NULL,
  `hora_salida` DATETIME NULL,
  `hora_entrega` DATETIME NULL,
  `distancia` DOUBLE NULL,
  `costo_envio` DOUBLE NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_domicilio_1_idx` (`pedido_fk` ASC) VISIBLE,
  INDEX `fk_domicilio_2_idx` (`repartidor_fk` ASC) VISIBLE,
  UNIQUE INDEX `pedido_fk_UNIQUE` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `fk_domicilio_1`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_domicilio_2`
    FOREIGN KEY (`repartidor_fk`)
    REFERENCES `pizzeria`.`repartidor` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`pago`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`pago` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pedido_fk` INT NOT NULL,
  `fecha_pago` DATETIME NOT NULL,
  `monto` DOUBLE NOT NULL,
  `metodo` ENUM('efectivo', 'tarjeta', 'app') NOT NULL,
  `estado` ENUM('pendiente', 'pagado', 'rechazado') NULL,
  PRIMARY KEY (`id`),
  INDEX `fek_pago_1_idx` (`pedido_fk` ASC) VISIBLE,
  CONSTRAINT `fek_pago_1`
    FOREIGN KEY (`pedido_fk`)
    REFERENCES `pizzeria`.`pedido` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pizzeria`.`historial_precios`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pizzeria`.`historial_precios` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `pizza_fk` INT NOT NULL,
  `precio_anterior` DOUBLE NOT NULL,
  `precio_nuevo` DOUBLE NOT NULL,
  `fecha_cambio` DATETIME NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_historial_precios_1_idx` (`pizza_fk` ASC) VISIBLE,
  CONSTRAINT `fk_historial_precios_1`
    FOREIGN KEY (`pizza_fk`)
    REFERENCES `pizzeria`.`pizza` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

USE pizzeria;

INSERT INTO cliente (nombre, telefono, direccion, correo)
VALUES
('Juan Perez', '3001234567', 'Calle 10 #20-30', 'juan@gmail.com'),
('Maria Gomez', '3012345678', 'Carrera 15 #25-40', 'maria@gmail.com'),
('Carlos Rodriguez', '3023456789', 'Calle 30 #10-20', 'carlos@gmail.com'),
('Ana Martinez', '3034567890', 'Carrera 20 #15-25', 'ana@gmail.com'),
('Luis Hernandez', '3045678901', 'Calle 45 #12-18', 'luis@gmail.com'),
('Laura Torres', '3056789012', 'Carrera 8 #30-15', 'laura@gmail.com'),
('Diego Ramirez', '3067890123', 'Calle 22 #18-40', 'diego@gmail.com'),
('Sofia Castro', '3078901234', 'Carrera 12 #40-22', 'sofia@gmail.com');

USE pizzeria;

INSERT INTO ingredientes (nombre, stock, stock_minimo, costo_unitario)
VALUES
('Queso mozzarella', 100, 20, 8000),
('Pepperoni', 80, 15, 12000),
('Jamon', 70, 15, 9000),
('Champiñones', 50, 10, 6000),
('Pimenton', 60, 10, 4000),
('Cebolla', 60, 10, 3000),
('Aceitunas', 45, 8, 5000),
('Piña', 50, 10, 4500),
('Tomate', 70, 15, 3500),
('Maiz', 50, 10, 4000),
('Carne molida', 60, 12, 11000),
('Pollo', 65, 12, 10000);

USE pizzeria;

INSERT INTO pizza (nombre, tamaño, precio_base, tipo)
VALUES
('Margarita', 'Mediana', 22000, 'Clásica'),
('Margarita', 'Grande', 30000, 'Clásica'),
('Pepperoni', 'Mediana', 28000, 'Clásica'),
('Pepperoni', 'Grande', 38000, 'Clásica'),
('Hawaiana', 'Mediana', 27000, 'Clásica'),
('Hawaiana', 'Grande', 37000, 'Clásica'),
('Vegetariana', 'Mediana', 26000, 'Vegetariana'),
('Vegetariana', 'Grande', 36000, 'Vegetariana'),
('Carnes', 'Mediana', 32000, 'Especial'),
('Carnes', 'Grande', 44000, 'Especial'),
('Pollo BBQ', 'Mediana', 30000, 'Especial'),
('Pollo BBQ', 'Grande', 42000, 'Especial');

USE pizzeria;

INSERT INTO pizza_ingrediente (pizza_fk, ingrediente_fk, cantidad)
VALUES
-- Margarita Mediana
(1, 1, 1),
(1, 9, 1),
(1, 6, 1),

-- Margarita Grande
(2, 1, 2),
(2, 9, 2),
(2, 6, 1),

-- Pepperoni Mediana
(3, 1, 1),
(3, 2, 1),
(3, 9, 1),

-- Pepperoni Grande
(4, 1, 2),
(4, 2, 2),
(4, 9, 1),

-- Hawaiana Mediana
(5, 1, 1),
(5, 3, 1),
(5, 8, 1),

-- Hawaiana Grande
(6, 1, 2),
(6, 3, 2),
(6, 8, 2),

-- Vegetariana Mediana
(7, 1, 1),
(7, 4, 1),
(7, 5, 1),
(7, 6, 1),
(7, 9, 1),

-- Vegetariana Grande
(8, 1, 2),
(8, 4, 2),
(8, 5, 1),
(8, 6, 1),
(8, 9, 1),

-- Carnes Mediana
(9, 1, 1),
(9, 2, 1),
(9, 3, 1),
(9, 11, 1),

-- Carnes Grande
(10, 1, 2),
(10, 2, 2),
(10, 3, 2),
(10, 11, 2),

-- Pollo BBQ Mediana
(11, 1, 1),
(11, 12, 1),
(11, 6, 1),
(11, 10, 1),

-- Pollo BBQ Grande
(12, 1, 2),
(12, 12, 2),
(12, 6, 1),
(12, 10, 1);

USE pizzeria;

INSERT INTO repartidor (nombre, zona, estado)
VALUES
('Andres Gomez', 'Norte', 'disponible'),
('Miguel Torres', 'Sur', 'disponible'),
('Daniel Rodriguez', 'Centro', 'no disponible'),
('Felipe Martinez', 'Occidente', 'disponible'),
('Santiago Perez', 'Oriente', 'disponible');

USE pizzeria;

INSERT INTO pedido (cliente_fk, fecha_hora, estado, total)
VALUES
(1, '2026-09-01 12:30:00', 'entregado', 0),
(1, '2026-09-03 19:00:00', 'entregado', 0),
(1, '2026-09-05 20:15:00', 'entregado', 0),
(1, '2026-09-10 18:30:00', 'entregado', 0),
(1, '2026-09-12 13:00:00', 'entregado', 0),
(1, '2026-09-14 19:30:00', 'pendiente', 0),

(2, '2026-09-02 13:00:00', 'entregado', 0),
(2, '2026-09-06 19:30:00', 'entregado', 0),
(3, '2026-09-04 20:00:00', 'entregado', 0),
(3, '2026-09-11 19:00:00', 'entregado', 0),
(4, '2026-09-07 12:45:00', 'entregado', 0),
(5, '2026-09-08 18:00:00', 'entregado', 0),
(6, '2026-09-09 19:15:00', 'entregado', 0),
(7, '2026-09-13 13:30:00', 'entregado', 0),
(8, '2026-09-14 12:00:00', 'cancelado', 0);

USE pizzeria;

INSERT INTO detalle_pedido (pedido_fk, pizza_fk, cantidad, subtotal)
VALUES
-- Pedido 1
(1, 3, 2, 56000),

-- Pedido 2
(2, 5, 1, 27000),
(2, 1, 1, 22000),

-- Pedido 3
(3, 4, 1, 38000),
(3, 6, 1, 37000),

-- Pedido 4
(4, 9, 1, 32000),
(4, 11, 1, 30000),

-- Pedido 5
(5, 7, 2, 52000),

-- Pedido 6
(6, 10, 1, 44000),
(6, 3, 1, 28000),

-- Pedido 7
(7, 2, 1, 30000),
(7, 8, 1, 36000),

-- Pedido 8
(8, 12, 1, 42000),

-- Pedido 9
(9, 4, 2, 76000),

-- Pedido 10
(10, 5, 1, 27000),
(10, 9, 1, 32000),

-- Pedido 11
(11, 6, 1, 37000),
(11, 7, 1, 26000),

-- Pedido 12
(12, 10, 1, 44000),

-- Pedido 13
(13, 11, 2, 60000),

-- Pedido 14
(14, 8, 1, 36000),
(14, 3, 1, 28000),

-- Pedido 15
(15, 1, 1, 22000);

USE pizzeria;

INSERT INTO domicilio
(pedido_fk, repartidor_fk, hora_salida, hora_entrega, distancia, costo_envio)
VALUES
(1, 1, '2026-09-01 12:45:00', '2026-09-01 13:15:00', 4.5, 5000),
(2, 2, '2026-09-03 19:15:00', '2026-09-03 19:50:00', 6.0, 6000),
(3, 3, '2026-09-05 20:30:00', '2026-09-05 21:05:00', 5.0, 5000),
(4, 4, '2026-09-10 18:45:00', '2026-09-10 19:20:00', 7.5, 7000),
(5, 5, '2026-09-12 13:15:00', '2026-09-12 13:45:00', 3.5, 4000),

(7, 1, '2026-09-02 13:15:00', '2026-09-02 13:45:00', 4.0, 5000),
(8, 2, '2026-09-06 19:45:00', '2026-09-06 20:30:00', 8.0, 7000),
(9, 3, '2026-09-04 20:15:00', '2026-09-04 20:50:00', 5.5, 5000),
(10, 4, '2026-09-11 19:15:00', '2026-09-11 19:55:00', 6.5, 6000),
(11, 5, '2026-09-07 13:00:00', '2026-09-07 13:30:00', 3.0, 4000),
(12, 1, '2026-09-08 18:15:00', '2026-09-08 18:50:00', 5.0, 5000),
(13, 2, '2026-09-09 19:30:00', '2026-09-09 20:10:00', 7.0, 6000),
(14, 4, '2026-09-13 13:45:00', '2026-09-13 14:20:00', 6.0, 6000);

USE pizzeria;

INSERT INTO pago
(pedido_fk, fecha_pago, monto, metodo, estado)
VALUES
(1,  '2026-09-01 13:20:00', 72240, 'efectivo', 'pagado'),
(2,  '2026-09-03 19:55:00', 64260, 'tarjeta', 'pagado'),
(3,  '2026-09-05 21:10:00', 95230, 'app', 'pagado'),
(4,  '2026-09-10 19:25:00', 73700, 'efectivo', 'pagado'),
(5,  '2026-09-12 13:50:00', 66640, 'tarjeta', 'pagado'),
(6,  '2026-09-14 19:30:00', 0, 'app', 'pendiente'),
(7,  '2026-09-02 13:50:00', 41650, 'efectivo', 'pagado'),
(8,  '2026-09-06 20:35:00', 64260, 'tarjeta', 'pagado'),
(9,  '2026-09-04 20:55:00', 96249, 'app', 'pagado'),
(10, '2026-09-11 20:00:00', 70217, 'efectivo', 'pagado'),
(11, '2026-09-07 13:35:00', 74990, 'tarjeta', 'pagado'),
(12, '2026-09-08 18:55:00', 58310, 'app', 'pagado'),
(13, '2026-09-09 20:15:00', 77252, 'efectivo', 'pagado'),
(14, '2026-09-13 14:25:00', 76128, 'tarjeta', 'pagado'),
(15, '2026-09-14 12:05:00', 0, 'app', 'rechazado');
