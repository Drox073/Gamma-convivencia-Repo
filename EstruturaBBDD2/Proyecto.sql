-- Crear la base de datos
CREATE DATABASE gestion_campo_clinico;
USE gestion_campo_clinico;

-- Tabla de usuarios generales
CREATE TABLE Usuarios (
    username VARCHAR(50) PRIMARY KEY,         -- Institutional username
    password_hash VARCHAR(255) NOT NULL,      -- Encrypted password
    rol ENUM('student','teacher','admin','coordinator') NOT NULL,
    activo BOOLEAN DEFAULT TRUE               -- Indicates if the account is active
);

-- Tabla de estudiantes
CREATE TABLE Estudiantes (
    username VARCHAR(50) PRIMARY KEY,         -- Linked to Usuarios
    nombre_completo VARCHAR(100) NOT NULL,    -- Full name
    rut VARCHAR(20) UNIQUE NOT NULL,          -- National ID
    email VARCHAR(100) UNIQUE NOT NULL,       -- Institutional email
    carrera VARCHAR(100) NOT NULL,            -- Degree program
    campus VARCHAR(50) NOT NULL,              -- University campus
    semestre_actual INT NOT NULL,             -- Current semester
    FOREIGN KEY (username) REFERENCES Usuarios(username)
);

-- Tabla de docentes
CREATE TABLE Docentes (
    username VARCHAR(50) PRIMARY KEY,         -- Linked to Usuarios
    nombre_completo VARCHAR(100) NOT NULL,    -- Full name
    email VARCHAR(100) UNIQUE NOT NULL,       -- Institutional email
    departamento VARCHAR(100) NOT NULL,       -- Academic department
    FOREIGN KEY (username) REFERENCES Usuarios(username)
);

-- Tabla de administrativos
CREATE TABLE Administrativos (
    username VARCHAR(50) PRIMARY KEY,         -- Linked to Usuarios
    nombre_completo VARCHAR(100) NOT NULL,    -- Full name
    email VARCHAR(100) UNIQUE NOT NULL,       -- Institutional email
    unidad VARCHAR(100) NOT NULL,             -- Administrative unit
    FOREIGN KEY (username) REFERENCES Usuarios(username)
);

-- Tabla de fichas estudiantiles
CREATE TABLE Ficha_Estudiante (
    id_ficha INT PRIMARY KEY AUTO_INCREMENT,  -- Unique record ID
    username VARCHAR(50) NOT NULL,            -- Associated student
    fecha_creacion DATE DEFAULT (CURRENT_DATE),
    estado ENUM('pendiente','aprobada','rechazada') DEFAULT 'pendiente',
    documentos_adjuntos TEXT,                 -- Uploaded documents (store path, not the file itself)
    observaciones TEXT,
    FOREIGN KEY (username) REFERENCES Estudiantes(username)
);

-- Tabla de campos clínicos
CREATE TABLE Campos_Clinicos (
    id_campo INT PRIMARY KEY AUTO_INCREMENT,  -- Clinical field ID
    nombre VARCHAR(100) NOT NULL,             -- Center name
    ubicacion VARCHAR(100) NOT NULL,          -- Location
    requisitos TEXT                           -- Center requirements
);

-- Tabla de asignaturas
CREATE TABLE Asignaturas (
    id_asignatura INT PRIMARY KEY AUTO_INCREMENT, -- Subject ID
    nombre VARCHAR(100) NOT NULL,                 -- Subject name
    profesor_responsable VARCHAR(50) NOT NULL,    -- Professor username
    semestre INT NOT NULL,                        -- Semester offered
    FOREIGN KEY (profesor_responsable) REFERENCES Docentes(username)
);

-- Tabla de asignaciones a campos clínicos
CREATE TABLE Asignacion_Campo_Clinico (
    id_asignacion INT PRIMARY KEY AUTO_INCREMENT, -- Assignment ID
    username VARCHAR(50) NOT NULL,                -- Student username
    id_campo INT NOT NULL,                        -- Assigned clinical field
    id_asignatura INT NOT NULL,                   -- Related subject
    fecha_inicio DATE NOT NULL,                   -- Practice start date
    fecha_fin DATE NOT NULL,                      -- Practice end date
    FOREIGN KEY (username) REFERENCES Estudiantes(username),
    FOREIGN KEY (id_campo) REFERENCES Campos_Clinicos(id_campo),
    FOREIGN KEY (id_asignatura) REFERENCES Asignaturas(id_asignatura)
);

-- Tabla de historial de fichas
CREATE TABLE Historial_Fichas (
    id_historial INT PRIMARY KEY AUTO_INCREMENT,  -- History ID
    id_ficha INT NOT NULL,                        -- Modified record
    fecha_modificacion DATE DEFAULT (CURRENT_DATE),
    modificado_por VARCHAR(50) NOT NULL,          -- Modified by user
    cambios TEXT NOT NULL,                        -- Change description
    FOREIGN KEY (id_ficha) REFERENCES Ficha_Estudiante(id_ficha),
    FOREIGN KEY (modificado_por) REFERENCES Usuarios(username)
);
