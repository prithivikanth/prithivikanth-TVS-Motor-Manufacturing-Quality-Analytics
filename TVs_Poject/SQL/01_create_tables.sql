-- =====================================================================
-- TVS Motor Company – Manufacturing Quality, Defect & Production Analytics
-- Step 1: create the database and tables (MySQL 8.x)
-- Column names match the CSV headers, so the same names are used in
-- Excel, SQL and Power BI.
-- =====================================================================

DROP DATABASE IF EXISTS tvs_manufacturing;
CREATE DATABASE tvs_manufacturing CHARACTER SET utf8mb4;
USE tvs_manufacturing;

-- ---------- Dimension (master) tables: load these FIRST ----------
CREATE TABLE plants (
    Plant_ID    VARCHAR(10) NOT NULL,
    Plant_Name  VARCHAR(50) NOT NULL,
    State       VARCHAR(50) NOT NULL,
    PRIMARY KEY (Plant_ID)
) ENGINE=InnoDB;

CREATE TABLE machines (
    Machine_ID    VARCHAR(10) NOT NULL,   -- includes an 'Unknown' row for blank machines
    Machine_Name  VARCHAR(50) NOT NULL,
    Machine_Type  VARCHAR(30) NOT NULL,
    PRIMARY KEY (Machine_ID)
) ENGINE=InnoDB;

CREATE TABLE products (
    Product_ID    VARCHAR(10) NOT NULL,
    Product_Name  VARCHAR(50) NOT NULL,
    Category      VARCHAR(30) NOT NULL,
    PRIMARY KEY (Product_ID)
) ENGINE=InnoDB;

-- ---------- Fact tables ----------
CREATE TABLE production (
    Production_ID      VARCHAR(10) NOT NULL,
    `Date`             DATE        NOT NULL,
    Plant_ID           VARCHAR(10) NOT NULL,
    Machine_ID         VARCHAR(10) NOT NULL,
    Product_ID         VARCHAR(10) NOT NULL,
    Shift              VARCHAR(10) NOT NULL,   -- A, B, C or Unknown
    Production_Qty     INT         NOT NULL,
    Defect_Qty         INT         NOT NULL,
    Downtime_Minutes   INT         NOT NULL,
    Data_Quality_Flag  VARCHAR(25) NOT NULL,   -- 'OK' = use for analysis
    PRIMARY KEY (Production_ID),
    CONSTRAINT fk_prod_plant   FOREIGN KEY (Plant_ID)   REFERENCES plants(Plant_ID),
    CONSTRAINT fk_prod_machine FOREIGN KEY (Machine_ID) REFERENCES machines(Machine_ID),
    CONSTRAINT fk_prod_product FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
    INDEX idx_prod_date (`Date`)
) ENGINE=InnoDB;

CREATE TABLE defects (
    Defect_ID          VARCHAR(10) NOT NULL,
    `Date`             DATE        NOT NULL,
    Plant_ID           VARCHAR(10) NOT NULL,
    Machine_ID         VARCHAR(10) NOT NULL,
    Product_ID         VARCHAR(10) NOT NULL,
    Defect_Type        VARCHAR(30) NOT NULL,
    Root_Cause         VARCHAR(30) NOT NULL,
    Defect_Qty         INT         NOT NULL,
    Rework_Required    VARCHAR(3)  NOT NULL,   -- Yes / No
    Data_Quality_Flag  VARCHAR(25) NOT NULL,   -- 'OK' or 'Zero_Defect_Qty'
    PRIMARY KEY (Defect_ID),
    CONSTRAINT fk_def_plant   FOREIGN KEY (Plant_ID)   REFERENCES plants(Plant_ID),
    CONSTRAINT fk_def_machine FOREIGN KEY (Machine_ID) REFERENCES machines(Machine_ID),
    CONSTRAINT fk_def_product FOREIGN KEY (Product_ID) REFERENCES products(Product_ID),
    INDEX idx_def_date (`Date`)
) ENGINE=InnoDB;

SHOW TABLES;
