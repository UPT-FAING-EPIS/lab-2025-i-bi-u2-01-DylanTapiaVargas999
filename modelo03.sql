--------------------------------------------------------
-- MODELO TRANSACCIONAL: SISTEMA DE GESTIÓN DE PROYECTOS
--------------------------------------------------------
-- Tabla: CLIENTE_3
CREATE TABLE CLIENTE_3 (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre_cliente VARCHAR(255) UNIQUE NOT NULL,
    telefono VARCHAR(20)
);

-- Tabla: PROYECTO_3
CREATE TABLE PROYECTO_3 (
    id_proyecto INT PRIMARY KEY IDENTITY(1,1),
    nombre_proyecto VARCHAR(255) UNIQUE NOT NULL,
    id_cliente INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE_3(id_cliente)
);

-- Tabla: EMPRESA_3
CREATE TABLE EMPRESA_3 (
    id_empresa INT PRIMARY KEY IDENTITY(1,1),
    nombre_empresa VARCHAR(255) UNIQUE NOT NULL
);

-- Tabla: RESPONSABLE_3
CREATE TABLE RESPONSABLE_3 (
    id_responsable INT PRIMARY KEY IDENTITY(1,1),
    nombre_responsable VARCHAR(255) UNIQUE NOT NULL,
    id_empresa INT NOT NULL,
    FOREIGN KEY (id_empresa) REFERENCES EMPRESA_3(id_empresa)
);

-- Tabla: PAIS_3
CREATE TABLE PAIS_3 (
    id_pais INT PRIMARY KEY IDENTITY(1,1),
    nombre_pais VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: LOCALIDAD_3
CREATE TABLE LOCALIDAD_3 (
    id_localidad INT PRIMARY KEY IDENTITY(1,1),
    nombre_localidad VARCHAR(100) UNIQUE NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES PAIS_3(id_pais)
);

-- Tabla: PAQUETE_TRABAJO_3
CREATE TABLE PAQUETE_TRABAJO_3 (
    id_paquete_trabajo BIGINT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    id_proyecto INT NOT NULL,
    id_responsable INT NOT NULL,
    id_localidad INT NOT NULL,
    FOREIGN KEY (id_proyecto) REFERENCES PROYECTO_3(id_proyecto),
    FOREIGN KEY (id_responsable) REFERENCES RESPONSABLE_3(id_responsable),
    FOREIGN KEY (id_localidad) REFERENCES LOCALIDAD_3(id_localidad)
);


--------------------------------------------------------
-- MODELO DIMENSIONAL: DATA WAREHOUSE
--------------------------------------------------------
-- Tabla Dimensión: DIM_TIEMPO_3
CREATE TABLE DIM_TIEMPO_3 (
    id_tiempo INT PRIMARY KEY,
    fecha DATE NOT NULL UNIQUE,
    dia TINYINT NOT NULL,
    mes TINYINT NOT NULL,
    nombre_mes VARCHAR(20) NOT NULL,
    trimestre TINYINT NOT NULL,
    nombre_trimestre VARCHAR(10) NOT NULL,
    año SMALLINT NOT NULL,
    dia_semana TINYINT NOT NULL,
    nombre_dia_semana VARCHAR(15) NOT NULL,
    numero_semana_año TINYINT NOT NULL,
    es_fin_semana BIT NOT NULL
);

-- Tabla Dimensión: DIM_PROYECTO_3
CREATE TABLE DIM_PROYECTO_3 (
    id_proyecto INT PRIMARY KEY IDENTITY(1,1),
    nombre_proyecto VARCHAR(255) UNIQUE NOT NULL,
    nombre_cliente VARCHAR(255) NOT NULL,
    telefono_cliente VARCHAR(20)
);

-- Tabla Dimensión: DIM_RESPONSABLE_3
CREATE TABLE DIM_RESPONSABLE_3 (
    id_responsable INT PRIMARY KEY IDENTITY(1,1),
    nombre_responsable VARCHAR(255) UNIQUE NOT NULL,
    nombre_empresa VARCHAR(255) NOT NULL
);

-- Tabla Dimensión: DIM_LOCALIDAD_3
CREATE TABLE DIM_LOCALIDAD_3 (
    id_localidad INT PRIMARY KEY IDENTITY(1,1),
    nombre_localidad VARCHAR(100) UNIQUE NOT NULL,
    nombre_pais VARCHAR(100) NOT NULL
);

-- Tabla de Hechos: FACT_PAQUETE_TRABAJO_3
CREATE TABLE FACT_PAQUETE_TRABAJO_3 (
    id_paquete_trabajo BIGINT PRIMARY KEY IDENTITY(1,1),
    id_tiempo INT NOT NULL,
    id_proyecto INT NOT NULL,
    id_responsable INT NOT NULL,
    id_localidad INT NOT NULL,
    costos DECIMAL(18, 2) NOT NULL,
    cantidad_paquetes_trabajo INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO_3(id_tiempo),
    FOREIGN KEY (id_proyecto) REFERENCES DIM_PROYECTO_3(id_proyecto),
    FOREIGN KEY (id_responsable) REFERENCES DIM_RESPONSABLE_3(id_responsable),
    FOREIGN KEY (id_localidad) REFERENCES DIM_LOCALIDAD_3(id_localidad)
);
