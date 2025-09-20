-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema brewery
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Table `suppliers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `suppliers` (
  `supplier_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `email` VARCHAR(100) NULL,
  PRIMARY KEY (`supplier_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `ingredients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ingredients` (
  `ingredient_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `category` VARCHAR(20) NOT NULL,
  `unit` VARCHAR(10) NULL DEFAULT 'OPEN',
  `unit_cost` DECIMAL(10,2) NULL,
  PRIMARY KEY (`ingredient_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `purchase_orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `purchase_orders` (
  `po_id` INT NOT NULL AUTO_INCREMENT,
  `supplier_id` INT NULL,
  `order_date` DATE NOT NULL,
  `status` VARCHAR(45) NULL DEFAULT 'OPEN',
  PRIMARY KEY (`po_id`),
  INDEX `supplier_id_idx` (`supplier_id` ASC) VISIBLE,
  CONSTRAINT `supplier_id`
    FOREIGN KEY (`supplier_id`)
    REFERENCES `suppliers` (`supplier_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `po_lines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `po_lines` (
  `po_id` INT NOT NULL,
  `line_no` INT NOT NULL,
  `ingredient_id` INT NOT NULL,
  `qty` DECIMAL(10,2) NOT NULL,
  `unit_cost` DECIMAL(10,2) NULL,
  `lot_code` VARCHAR(40) NULL,
  `expiry_date` DATE NULL,
  PRIMARY KEY (`po_id`, `line_no`),
  INDEX `ingredient_id_idx` (`ingredient_id` ASC) VISIBLE,
  CONSTRAINT `po_id`
    FOREIGN KEY (`po_id`)
    REFERENCES `purchase_orders` (`po_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ingredient_id`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredients` (`ingredient_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `beers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `beers` (
  `beer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `style` VARCHAR(50) NULL,
  `abv_target` DECIMAL(4,2) NULL,
  `ibu_target` INT NULL,
  PRIMARY KEY (`beer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_versions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `recipe_versions` (
  `recipe_id` INT NOT NULL AUTO_INCREMENT,
  `beer_id` INT NOT NULL,
  `version_no` INT NOT NULL,
  `created_on` DATE NULL,
  `notes` MEDIUMTEXT NULL,
  INDEX `beer_id_idx` (`beer_id` ASC) VISIBLE,
  CONSTRAINT `beer_id`
    FOREIGN KEY (`beer_id`)
    REFERENCES `beers` (`beer_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `recipe_items`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `recipe_items` (
  `recipe_item_id` INT NOT NULL AUTO_INCREMENT,
  `recipe_id` INT NOT NULL,
  `ingredient_id` INT NOT NULL,
  `amount` VARCHAR(45) NULL,
  `unit` VARCHAR(10) NULL,
  `step_no` INT NULL,
  PRIMARY KEY (`recipe_item_id`),
  INDEX `recipe_id_idx` (`recipe_id` ASC) VISIBLE,
  INDEX `ingredient_id_idx` (`ingredient_id` ASC) VISIBLE,
  CONSTRAINT `recipe_id`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe_versions` (`recipe_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ingredient_id`
    FOREIGN KEY (`ingredient_id`)
    REFERENCES `ingredients` (`ingredient_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `batches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `batches` (
  `batch_id` INT NOT NULL AUTO_INCREMENT,
  `recipe_id` INT NOT NULL,
  `start_date` DATE NULL,
  `end_date` DATE NULL,
  `volume_I` DECIMAL(10,2) NULL,
  `og` DECIMAL(5,3) NULL,
  `fg` DECIMAL(5,3) NULL,
  `status` VARCHAR(20) NULL DEFAULT 'PLANNED',
  PRIMARY KEY (`batch_id`),
  INDEX `recipe_id_idx` (`recipe_id` ASC) VISIBLE,
  CONSTRAINT `recipe_id`
    FOREIGN KEY (`recipe_id`)
    REFERENCES `recipe_versions` (`recipe_id`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `finished_lots`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `finished_lots` (
  `lot_id` INT NOT NULL AUTO_INCREMENT,
  `batch_id` INT NOT NULL,
  `package_type` VARCHAR(10) NULL,
  `package_date` DATE NULL,
  `qty_on_hand` INT NULL DEFAULT 0,
  `lot_code` VARCHAR(40) NULL,
  PRIMARY KEY (`lot_id`),
  INDEX `batch_id_idx` (`batch_id` ASC) VISIBLE,
  CONSTRAINT `batch_id`
    FOREIGN KEY (`batch_id`)
    REFERENCES `batches` (`batch_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `customers` (
  `customer_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(120) NOT NULL,
  `type` VARCHAR(12) NULL DEFAULT 'TAPROOM',
  `tax_id` VARCHAR(30) NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`customer_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sales`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sales` (
  `sale_id` INT NOT NULL AUTO_INCREMENT,
  `customer_id` INT NULL,
  `sale_date` DATETIME NOT NULL,
  `channel` VARCHAR(12) NULL DEFAULT 'TAPROOM',
  `subtotal` DECIMAL(10,2) NULL,
  `tax` DECIMAL(10,2) NULL,
  `total` DECIMAL(10,2) NULL,
  PRIMARY KEY (`sale_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `sale_lines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sale_lines` (
  `Sale_id` INT NOT NULL AUTO_INCREMENT,
  `line_no` INT NOT NULL,
  `lot_id` INT NULL,
  `qty` INT NOT NULL,
  `unit_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`Sale_id`, `line_no`))
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
