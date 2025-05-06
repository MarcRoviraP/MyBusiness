CREATE TABLE IF NOT EXISTS Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS Empresas (
    id_empresa SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(50),
    descripcion TEXT,
    url_img VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Usuario_Empresa (
    id_usuario_emp SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id_usuario),
    id_empresa INT REFERENCES Empresas(id_empresa),
    rol VARCHAR(20) CHECK (rol IN ('Administrador', 'Usuario')) NOT NULL
);

CREATE TABLE IF NOT EXISTS Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    id_empresa INT REFERENCES Empresas(id_empresa)
);

CREATE TABLE IF NOT EXISTS Productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(20,2) NOT NULL,
    url_img VARCHAR(255),
    id_empresa INT REFERENCES Empresas(id_empresa),
    id_categoria INT REFERENCES Categorias(id_categoria)
);

CREATE TABLE IF NOT EXISTS Inventario (
    id_inventario SERIAL PRIMARY KEY,
    fecha_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_empresa INT REFERENCES Empresas(id_empresa) UNIQUE,
    id_usuario INT REFERENCES Usuarios(id_usuario)
);
CREATE TABLE IF NOT EXISTS Inventario_Producto (
    id_inventario_producto SERIAL PRIMARY KEY,
    id_inventario INT REFERENCES Inventario(id_inventario),
    id_producto INT REFERENCES Productos(id_producto)  ON DELETE CASCADE,
    cantidad INT NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS Chat_Empresa (
    id_mensaje SERIAL PRIMARY KEY,
    id_empresa INT REFERENCES Empresas(id_empresa) NOT NULL,
    id_usuario INT REFERENCES Usuarios(id_usuario) NOT NULL,
    mensaje TEXT,
    imagen_url TEXT,
    fecha_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Invitacion_Empresa (
    id_invitacion SERIAL PRIMARY KEY,
    id_empresa INT REFERENCES Empresas(id_empresa) NOT NULL,
    id_usuario INT REFERENCES Usuarios(id_usuario) NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('Pendiente', 'Aceptada', 'Rechazada')) NOT NULL,
    fecha_solicitud TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);