-- SQL Script for the Original E/R Diagram (Transactional Database)
-- Database: SistemaReservasER
DROP DATABASE IF EXISTS SistemaReservasER;
CREATE DATABASE SistemaReservasER;
USE SistemaReservasER;

-- Table: TIPO (Client Type)
CREATE TABLE TIPO (
    id_tipo INT PRIMARY KEY AUTO_INCREMENT,
    nombre_tipo VARCHAR(50) UNIQUE NOT NULL
);

-- Table: CLIENTE
CREATE TABLE CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    id_tipo INT NOT NULL, -- (1,1) cardinality with TIPO
    FOREIGN KEY (id_tipo) REFERENCES TIPO(id_tipo)
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
    id_pais INT NOT NULL, -- (1,1) cardinality with PAIS
    FOREIGN KEY (id_pais) REFERENCES PAIS(id_pais)
);

-- Table: VIAJE
CREATE TABLE VIAJE (
    id_viaje INT PRIMARY KEY AUTO_INCREMENT,
    nombre_viaje VARCHAR(255) NOT NULL,
    descripcion TEXT,
    id_destino INT NOT NULL, -- (1,1) cardinality with DESTINO
    FOREIGN KEY (id_destino) REFERENCES DESTINO(id_destino)
);

-- Table: OPERADOR
CREATE TABLE OPERADOR (
    id_operador INT PRIMARY KEY AUTO_INCREMENT,
    nombre_operador VARCHAR(255) UNIQUE NOT NULL
);

-- Table: AGENCIA_DE_VIAJES
CREATE TABLE AGENCIA_DE_VIAJES (
    id_agencia_viajes INT PRIMARY KEY AUTO_INCREMENT,
    nombre_agencia_viajes VARCHAR(255) UNIQUE NOT NULL,
    id_operador INT NOT NULL, -- (1,1) cardinality with OPERADOR
    FOREIGN KEY (id_operador) REFERENCES OPERADOR(id_operador)
);

-- Table: RESERVA
CREATE TABLE RESERVA (
    id_reserva BIGINT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL, -- (1,1) cardinality with CLIENTE
    id_viaje INT NOT NULL, -- (1,1) cardinality with VIAJE
    id_agencia_viajes INT NOT NULL, -- (1,1) cardinality with AGENCIA_DE_VIAJES
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE(id_cliente),
    FOREIGN KEY (id_viaje) REFERENCES VIAJE(id_viaje),
    FOREIGN KEY (id_agencia_viajes) REFERENCES AGENCIA_DE_VIAJES(id_agencia_viajes)
);


-- SQL Script for the Dimensional Model (Data Warehouse)
-- Database: DataWarehouseReservas
DROP DATABASE IF EXISTS DataWarehouseReservas;
CREATE DATABASE DataWarehouseReservas;
USE DataWarehouseReservas;

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
);

-- Dimension: DIM_CLIENTE
CREATE TABLE DIM_CLIENTE (
    id_cliente INT PRIMARY KEY AUTO_INCREMENT,
    nombre_cliente VARCHAR(255) NOT NULL,
    direccion_cliente VARCHAR(255),
    tipo_cliente VARCHAR(50) NOT NULL
);

-- Dimension: DIM_AGENCIA_VIAJES
CREATE TABLE DIM_AGENCIA_VIAJES (
    id_agencia_viajes INT PRIMARY KEY AUTO_INCREMENT,
    nombre_agencia VARCHAR(255) UNIQUE NOT NULL,
    nombre_operador VARCHAR(255) NOT NULL
);

-- Dimension: DIM_VIAJE
CREATE TABLE DIM_VIAJE (
    id_viaje INT PRIMARY KEY AUTO_INCREMENT,
    nombre_viaje VARCHAR(255) NOT NULL,
    descripcion_viaje TEXT,
    destino_viaje VARCHAR(100) NOT NULL,
    pais_destino VARCHAR(100) NOT NULL
);

-- Fact Table: FACT_RESERVA
CREATE TABLE FACT_RESERVA (
    id_reserva BIGINT PRIMARY KEY AUTO_INCREMENT,
    id_tiempo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_agencia_viajes INT NOT NULL,
    id_viaje INT NOT NULL,
    cantidad_reservas INT NOT NULL DEFAULT 1, -- Measure: Each row represents one reservation
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES DIM_CLIENTE(id_cliente),
    FOREIGN KEY (id_agencia_viajes) REFERENCES DIM_AGENCIA_VIAJES(id_agencia_viajes),
    FOREIGN KEY (id_viaje) REFERENCES DIM_VIAJE(id_viaje)
);