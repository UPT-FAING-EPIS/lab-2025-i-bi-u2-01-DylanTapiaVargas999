-- SQL Script for the Original E/R Diagram (Transactional Database)
-- Database: SistemaEnviosER
DROP DATABASE IF EXISTS SistemaEnviosER;
CREATE DATABASE SistemaEnviosER;
USE SistemaEnviosER;

-- Table: GRUPO
CREATE TABLE GRUPO (
    id_grupo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_grupo VARCHAR(100) UNIQUE NOT NULL
);

-- Table: PAIS
CREATE TABLE PAIS (
    id_pais INT PRIMARY KEY AUTO_INCREMENT,
    nombre_pais VARCHAR(100) UNIQUE NOT NULL
);

-- Table: DESTINO
CREATE TABLE DESTINO (
    id_destino INT PRIMARY KEY AUTO_INCREMENT,
    nombre_destino VARCHAR(100) UNIQUE NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais)
);

-- Table: LOTE
CREATE TABLE LOTE (
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    codigo_lote VARCHAR(100) UNIQUE NOT NULL,
    peso DECIMAL(10, 2),
    tarifa_exportacion DECIMAL(10, 2),
    tarifa_importacion DECIMAL(10, 2),
    id_grupo INT NOT NULL, -- (1,1) cardinality with GRUPO
    FOREIGN KEY (id_grupo) REFERENCES GRUPO(id_grupo)
);

-- Table: GRUPO_CENTRO_COSTO
CREATE TABLE GRUPO_CENTRO_COSTO (
    id_grupo_centro_costo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_grupo_centro_costos VARCHAR(100) UNIQUE NOT NULL
);

-- Table: CENTRO_DE_COSTO
CREATE TABLE CENTRO_DE_COSTO (
    id_centro_costo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_centro_costo VARCHAR(100) UNIQUE NOT NULL,
    responsable VARCHAR(100),
    id_grupo_centro_costo INT NOT NULL, -- (1,1) cardinality with GRUPO_CENTRO_COSTO
    FOREIGN KEY (id_grupo_centro_costo) REFERENCES GRUPO_CENTRO_COSTO(id_grupo_centro_costo)
);

-- Table: MODO_TRANSPORTE
CREATE TABLE MODO_TRANSPORTE (
    id_modo_transporte INT PRIMARY KEY AUTO_INCREMENT,
    nombre_modo_transporte VARCHAR(50) UNIQUE NOT NULL
);

-- Table: ENVIO
CREATE TABLE ENVIO (
    id_envio BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    id_lote INT NOT NULL, -- (1,1) cardinality with LOTE
    id_destino INT NOT NULL, -- (1,1) cardinality with DESTINO
    id_centro_costo INT NOT NULL, -- (1,1) cardinality with CENTRO_DE_COSTO
    id_modo_transporte INT NOT NULL, -- (1,1) cardinality with MODO_TRANSPORTE
    FOREIGN KEY (id_lote) REFERENCES LOTE(id_lote),
    FOREIGN KEY (id_destino) REFERENCES DESTINO(id_destino),
    FOREIGN KEY (id_centro_costo) REFERENCES CENTRO_DE_COSTO(id_centro_costo),
    FOREIGN KEY (id_modo_transporte) REFERENCES MODO_TRANSPORTE(id_modo_transporte)
);


-- SQL Script for the Dimensional Model (Data Warehouse)
-- Database: DataWarehouseEnvios
DROP DATABASE IF EXISTS DataWarehouseEnvios;
CREATE DATABASE DataWarehouseEnvios;
USE DataWarehouseEnvios;

-- Dimension: DIM_TIEMPO
CREATE TABLE DIM_TIEMPO (
    id_tiempo INT PRIMARY KEY, -- Often an integer representation of date (e.g., YYYYMMDD)
    fecha DATE NOT NULL UNIQUE,
    dia TINYINT NOT NULL,
    mes TINYINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre TINYINT NOT NULL,
    año SMALLINT NOT NULL,
    dia_semana TINYINT NOT NULL,
    nombre_dia_semana VARCHAR(15) NOT NULL,
    numero_semana_año TINYINT NOT NULL,
    es_fin_semana BOOLEAN NOT NULL
);

-- Dimension: DIM_GRUPO_CENTRO_COSTO
CREATE TABLE DIM_GRUPO_CENTRO_COSTO (
    id_grupo_centro_costo INT PRIMARY KEY AUTO_INCREMENT,
    grupo_centro_costos VARCHAR(100) UNIQUE NOT NULL
);

-- Dimension: DIM_MODO_TRANSPORTE
CREATE TABLE DIM_MODO_TRANSPORTE (
    id_modo_transporte INT PRIMARY KEY AUTO_INCREMENT,
    modo_transporte VARCHAR(50) UNIQUE NOT NULL
);

-- Dimension: DIM_DESTINO
CREATE TABLE DIM_DESTINO (
    id_destino INT PRIMARY KEY AUTO_INCREMENT,
    destino VARCHAR(100) UNIQUE NOT NULL,
    pais VARCHAR(100) NOT NULL
);

-- Dimension: DIM_GRUPO
CREATE TABLE DIM_GRUPO (
    id_grupo INT PRIMARY KEY AUTO_INCREMENT,
    grupo VARCHAR(100) UNIQUE NOT NULL
);

-- Dimension: DIM_LOTE
CREATE TABLE DIM_LOTE (
    id_lote INT PRIMARY KEY AUTO_INCREMENT,
    lote VARCHAR(100) UNIQUE NOT NULL,
    peso DECIMAL(10, 2)
);

-- Fact Table: FACT_ENVIO
CREATE TABLE FACT_ENVIO (
    id_envio BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_tiempo INT NOT NULL,
    id_grupo_centro_costo INT NOT NULL,
    id_modo_transporte INT NOT NULL,
    id_destino INT NOT NULL,
    id_grupo INT NOT NULL,
    id_lote INT NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO(id_tiempo),
    FOREIGN KEY (id_grupo_centro_costo) REFERENCES DIM_GRUPO_CENTRO_COSTO(id_grupo_centro_costo),
    FOREIGN KEY (id_modo_transporte) REFERENCES DIM_MODO_TRANSPORTE(id_modo_transporte),
    FOREIGN KEY (id_destino) REFERENCES DIM_DESTINO(id_destino),
    FOREIGN KEY (id_grupo) REFERENCES DIM_GRUPO(id_grupo),
    FOREIGN KEY (id_lote) REFERENCES DIM_LOTE(id_lote)
);