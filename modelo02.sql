--------------------------------------------------------
-- MODELO TRANSACCIONAL: SISTEMA DE RESERVAS (SistemaReservasER)
--------------------------------------------------------
-- Tabla: TIPO_2 (Tipo de Cliente)
CREATE TABLE TIPO_2 (
    id_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre_tipo VARCHAR(50) UNIQUE NOT NULL
);

-- Tabla: CLIENTE_2
CREATE TABLE CLIENTE_2 (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre_cliente VARCHAR(255) NOT NULL,
    direccion VARCHAR(255),
    id_tipo INT NOT NULL,
    FOREIGN KEY (id_tipo) REFERENCES TIPO_2(id_tipo)
);

-- Tabla: PAIS_2
CREATE TABLE PAIS_2 (
    id_pais INT PRIMARY KEY IDENTITY(1,1),
    nombre_pais VARCHAR(100) UNIQUE NOT NULL
);

-- Tabla: DESTINO_2
CREATE TABLE DESTINO_2 (
    id_destino INT PRIMARY KEY IDENTITY(1,1),
    nombre_destino VARCHAR(100) UNIQUE NOT NULL,
    id_pais INT NOT NULL,
    FOREIGN KEY (id_pais) REFERENCES PAIS_2(id_pais)
);

-- Tabla: VIAJE_2
CREATE TABLE VIAJE_2 (
    id_viaje INT PRIMARY KEY IDENTITY(1,1),
    nombre_viaje VARCHAR(255) NOT NULL,
    descripcion TEXT,
    id_destino INT NOT NULL,
    FOREIGN KEY (id_destino) REFERENCES DESTINO_2(id_destino)
);

-- Tabla: OPERADOR_2
CREATE TABLE OPERADOR_2 (
    id_operador INT PRIMARY KEY IDENTITY(1,1),
    nombre_operador VARCHAR(255) UNIQUE NOT NULL
);

-- Tabla: AGENCIA_DE_VIAJES_2
CREATE TABLE AGENCIA_DE_VIAJES_2 (
    id_agencia_viajes INT PRIMARY KEY IDENTITY(1,1),
    nombre_agencia_viajes VARCHAR(255) UNIQUE NOT NULL,
    id_operador INT NOT NULL,
    FOREIGN KEY (id_operador) REFERENCES OPERADOR_2(id_operador)
);

-- Tabla: RESERVA_2
CREATE TABLE RESERVA_2 (
    id_reserva BIGINT PRIMARY KEY IDENTITY(1,1),
    fecha DATE NOT NULL,
    id_cliente INT NOT NULL,
    id_viaje INT NOT NULL,
    id_agencia_viajes INT NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTE_2(id_cliente),
    FOREIGN KEY (id_viaje) REFERENCES VIAJE_2(id_viaje),
    FOREIGN KEY (id_agencia_viajes) REFERENCES AGENCIA_DE_VIAJES_2(id_agencia_viajes)
);


--------------------------------------------------------
-- MODELO DIMENSIONAL: DATA WAREHOUSE (DataWarehouseReservas)
--------------------------------------------------------
-- Tabla Dimensión: DIM_TIEMPO_2
CREATE TABLE DIM_TIEMPO_2 (
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

-- Tabla Dimensión: DIM_CLIENTE_2
CREATE TABLE DIM_CLIENTE_2 (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    nombre_cliente VARCHAR(255) NOT NULL,
    direccion_cliente VARCHAR(255),
    tipo_cliente VARCHAR(50) NOT NULL
);

-- Tabla Dimensión: DIM_AGENCIA_VIAJES_2
CREATE TABLE DIM_AGENCIA_VIAJES_2 (
    id_agencia_viajes INT PRIMARY KEY IDENTITY(1,1),
    nombre_agencia VARCHAR(255) UNIQUE NOT NULL,
    nombre_operador VARCHAR(255) NOT NULL
);

-- Tabla Dimensión: DIM_VIAJE_2
CREATE TABLE DIM_VIAJE_2 (
    id_viaje INT PRIMARY KEY IDENTITY(1,1),
    nombre_viaje VARCHAR(255) NOT NULL,
    descripcion_viaje TEXT,
    destino_viaje VARCHAR(100) NOT NULL,
    pais_destino VARCHAR(100) NOT NULL
);

-- Tabla de Hechos: FACT_RESERVA_2
CREATE TABLE FACT_RESERVA_2 (
    id_reserva BIGINT PRIMARY KEY IDENTITY(1,1),
    id_tiempo INT NOT NULL,
    id_cliente INT NOT NULL,
    id_agencia_viajes INT NOT NULL,
    id_viaje INT NOT NULL,
    cantidad_reservas INT NOT NULL DEFAULT 1,
    FOREIGN KEY (id_tiempo) REFERENCES DIM_TIEMPO_2(id_tiempo),
    FOREIGN KEY (id_cliente) REFERENCES DIM_CLIENTE_2(id_cliente),
    FOREIGN KEY (id_agencia_viajes) REFERENCES DIM_AGENCIA_VIAJES_2(id_agencia_viajes),
    FOREIGN KEY (id_viaje) REFERENCES DIM_VIAJE_2(id_viaje)
);
