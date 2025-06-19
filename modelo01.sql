--------------------------------------------------------
-- MODELO TRANSACCIONAL: SISTEMA DE ENVÍOS (SistemaEnviosER)
--------------------------------------------------------

-- Tabla: GRUPO_1
CREATE TABLE GRUPO_1 (
    id_grupo INT PRIMARY KEY IDENTITY(1,1),
    nombre_grupo VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: PAIS_1
CREATE TABLE PAIS_1 (
    id_pais INT PRIMARY KEY IDENTITY(1,1),
    nombre_pais VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: DESTINO_1
CREATE TABLE DESTINO_1 (
    id_destino INT PRIMARY KEY IDENTITY(1,1),
    nombre_destino VARCHAR(100) UNIQUE NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES PAIS_1(id_pais)
);

-- Tabla: LOTE_1
CREATE TABLE LOTE_1 (
    id_lote INT PRIMARY KEY IDENTITY(1,1),
    codigo_lote VARCHAR(100) UNIQUE NOT NULL,
    peso DECIMAL(10, 2),
    tarifa_exportacion DECIMAL(10, 2),
    tarifa_importacion DECIMAL(10, 2),
    id_grupo INT NOT NULL,
    FOREIGN KEY (id_grupo) REFERENCES GRUPO_1(id_grupo)
);

-- Tabla: GRUPO_CENTRO_COSTO_1
CREATE TABLE GRUPO_CENTRO_COSTO_1 (
    id_grupo_centro_costo INT PRIMARY KEY IDENTITY(1,1),
    nombre_grupo_centro_costos VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: CENTRO_DE_COSTO_1
CREATE TABLE CENTRO_DE_COSTO_1 (
    id_centro_costo INT PRIMARY KEY IDENTITY(1,1),
    nombre_centro_costo VARCHAR(100) UNIQUE NOT NULL,
    responsable VARCHAR(100),
    id_grupo_centro_costo INT NOT NULL,
    FOREIGN KEY (id_grupo_centro_costo) REFERENCES GRUPO_CENTRO_COSTO_1(id_grupo_centro_costo)
);

-- Tabla: MODO_TRANSPORTE_1
CREATE TABLE MODO_TRANSPORTE_1 (
    id_modo_transporte INT PRIMARY KEY IDENTITY(1,1),
    nombre_modo_transporte VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla: ENVIO_1
CREATE TABLE ENVIO_1 (
    id_envio BIGINT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    id_lote INT NOT NULL,
    id_destino INT NOT NULL,
    id_centro_costo INT NOT NULL,
    id_modo_transporte INT NOT NULL,
    FOREIGN KEY (id_lote) REFERENCES LOTE_1(id_lote),
    FOREIGN KEY (id_destino) REFERENCES DESTINO_1(id_destino),
    FOREIGN KEY (id_centro_costo) REFERENCES CENTRO_DE_COSTO_1(id_centro_costo),
    FOREIGN KEY (id_modo_transporte) REFERENCES MODO_TRANSPORTE_1(id_modo_transporte)
);



--------------------------------------------------------
-- MODELO DIMENSIONAL: DATA WAREHOUSE (DataWarehouseEnvios)
--------------------------------------------------------
-- Tabla Dimensión: DIM_TIEMPO_1
CREATE TABLE DIM_TIEMPO_1 (
    id_tiempo INT PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    dia TINYINT NOT NULL,
    mes TINYINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre TINYINT NOT NULL,
    año SMALLINT NOT NULL,
    dia_semana TINYINT NOT NULL,
    nombre_dia_semana VARCHAR(15) NOT NULL,
    numero_semana_año TINYINT NOT NULL,
    es_fin_semana BIT NOT NULL
);

-- Tabla Dimensión: DIM_GRUPO_CENTRO_COSTO_1
CREATE TABLE DIM_GRUPO_CENTRO_COSTO_1 (
    id_grupo_centro_costo INT PRIMARY KEY IDENTITY(1,1),
    grupo_centro_costos VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla Dimensión: DIM_MODO_TRANSPORTE_1
CREATE TABLE DIM_MODO_TRANSPORTE_1 (
    id_modo_transporte INT PRIMARY KEY IDENTITY(1,1),
    modo_transporte VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla Dimensión: DIM_DESTINO_1
CREATE TABLE DIM_DESTINO_1 (
    id_destino INT PRIMARY KEY IDENTITY(1,1),
    destino VARCHAR(100) UNIQUE NOT NULL,
    pais VARCHAR(100) NOT NULL
);

-- Tabla Dimensión: DIM_GRUPO_1
CREATE TABLE DIM_GRUPO_1 (
    id_grupo INT PRIMARY KEY IDENTITY(1,1),
    grupo VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla Dimensión: DIM_LOTE_1
CREATE TABLE DIM_LOTE_1 (
    id_lote INT PRIMARY KEY IDENTITY(1,1),
    lote VARCHAR(100) UNIQUE NOT NULL,
    peso DECIMAL(10, 2)
);

-- Tabla Hechos: FACT_ENVIO_1
CREATE TABLE FACT_ENVIO_1 (
    id_envio BIGINT PRIMARY KEY IDENTITY(1,1),
    id_tiempo INT NOT NULL,
    id_grupo_centro_costo INT NOT NULL,
    id_modo_transporte INT NOT NULL,
    id_destino INT NOT NULL,
    id_grupo INT NOT NULL,
    id_lote INT NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO_1(id_tiempo),
    FOREIGN KEY (id_grupo_centro_costo) REFERENCES DIM_GRUPO_CENTRO_COSTO_1(id_grupo_centro_costo),
    FOREIGN KEY (id_modo_transporte) REFERENCES DIM_MODO_TRANSPORTE_1(id_modo_transporte),
    FOREIGN KEY (id_destino) REFERENCES DIM_DESTINO_1(id_destino),
    FOREIGN KEY (id_grupo) REFERENCES DIM_GRUPO_1(id_grupo),
    FOREIGN KEY (id_lote) REFERENCES DIM_LOTE_1(id_lote)
);
