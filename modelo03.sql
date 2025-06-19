-- SQL Script for the Original E/R Diagram (Transactional Database)
-- Database: SistemaGestionProyectosER
DROP DATABASE IF EXISTS SistemaGestionProyectosER;
CREATE DATABASE SistemaGestionProyectosER;
USE SistemaGestionProyectosER;

-- Table: CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

-- Table: PROYECTO
CREATE TABLE PROYECTO (
    id_proyecto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proyecto VARCHAR(255) UNIQUE NOT NULL,
    id_cliente INT NOT NULL, -- (1,1) cardinality with CLIENTE
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente)
);

-- Table: EMPRESA
CREATE TABLE EMPRESA (
    id_empresa INT PRIMARY KEY AUTO_INCREMENT,
    nombre_empresa VARCHAR(255) UNIQUE NOT NULL
);

-- Table: RESPONSABLE
CREATE TABLE RESPONSABLE (
    id_responsable INT PRIMARY KEY AUTO_INCREMENT,
    nombre_responsable VARCHAR(255) UNIQUE NOT NULL,
    id_empresa INT NOT NULL, -- (1,1) cardinality with EMPRESA
    FOREIGN KEY (id_empresa) REFERENCES EMPRESA(id_empresa)
);

-- Table: PAIS
CREATE TABLE PAIS (
    id_pais INT PRIMARY KEY AUTO_INCREMENT,
    nombre_pais VARCHAR(100) UNIQUE NOT NULL
);

-- Table: LOCALIDAD
CREATE TABLE LOCALIDAD (
    id_localidad INT PRIMARY KEY AUTO_INCREMENT,
    nombre_localidad VARCHAR(100) UNIQUE NOT NULL,
    id_pais INT NOT NULL, -- (1,1) cardinality with PAIS
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais)
);

-- Table: PAQUETE_TRABAJO
CREATE TABLE PAQUETE_TRABAJO (
    id_paquete_trabajo BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    id_proyecto INT NOT NULL, -- (1,1) cardinality from PAQUETE TRABAJO is part of PROYECTO
    id_responsable INT NOT NULL, -- (1,1) cardinality from PAQUETE TRABAJO is supervised by RESPONSABLE
    id_localidad INT NOT NULL, -- (1,1) cardinality from PAQUETE TRABAJO has place in LOCALIDAD
    FOREIGN KEY (id_proyecto) REFERENCES PROYECTO(id_proyecto),
    FOREIGN KEY (id_responsable) REFERENCES RESPONSABLE(id_responsable),
    FOREIGN KEY (id_localidad) REFERENCES LOCALIDAD(id_localidad)
);


-- SQL Script for the Dimensional Model (Data Warehouse)
-- Database: DataWarehouseGestionProyectos
DROP DATABASE IF EXISTS DataWarehouseGestionProyectos;
CREATE DATABASE DataWarehouseGestionProyectos;
USE DataWarehouseGestionProyectos;

-- Dimension: DIM_TIEMPO
CREATE TABLE DIM_TIEMPO (
    id_tiempo INT PRIMARY KEY, -- Example: YYYYMMDD
    fecha DATE NOT NULL UNIQUE,
    dia TINYINT NOT NULL,
    mes TINYINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre TINYINT NOT NULL,
    nombre_trimestre VARCHAR(10) NOT NULL, -- e.g., 'Q1', 'Q2'
    año SMALLINT NOT NULL,
    dia_semana TINYINT NOT NULL,
    nombre_dia_semana VARCHAR(15) NOT NULL,
    numero_semana_año TINYINT NOT NULL,
    es_fin_semana BOOLEAN NOT NULL
    -- es_feriado BOOLEAN -- Optional, if data is available
);

-- Dimension: DIM_PROYECTO
CREATE TABLE DIM_PROYECTO (
    id_proyecto INT PRIMARY KEY AUTO_INCREMENT,
    nombre_proyecto VARCHAR(255) UNIQUE NOT NULL,
    nombre_cliente VARCHAR(255) NOT NULL,
    telefono_cliente VARCHAR(20)
);

-- Dimension: DIM_RESPONSABLE
CREATE TABLE DIM_RESPONSABLE (
    id_responsable INT PRIMARY KEY AUTO_INCREMENT,
    nombre_responsable VARCHAR(255) UNIQUE NOT NULL,
    nombre_empresa VARCHAR(255) NOT NULL
);

-- Dimension: DIM_LOCALIDAD
CREATE TABLE DIM_LOCALIDAD (
    id_localidad INT PRIMARY KEY AUTO_INCREMENT,
    nombre_localidad VARCHAR(100) UNIQUE NOT NULL,
    nombre_pais VARCHAR(100) NOT NULL
);

-- Fact Table: FACT_PAQUETE_TRABAJO
CREATE TABLE FACT_PAQUETE_TRABAJO (
    id_paquete_trabajo BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_tiempo INT NOT NULL,
    id_proyecto INT NOT NULL,
    id_responsable INT NOT NULL,
    id_localidad INT NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    cantidad_paquetes_trabajo INT NOT NULL DEFAULT 1, -- Additional fact attribute
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO(id_tiempo),
    FOREIGN KEY (id_proyecto) REFERENCES DIM_PROYECTO(id_proyecto),
    FOREIGN KEY (id_responsable) REFERENCES DIM_RESPONSABLE(id_responsable),
    FOREIGN KEY (id_localidad) REFERENCES DIM_LOCALIDAD(id_localidad)
);