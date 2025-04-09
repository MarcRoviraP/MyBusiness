CREATE TABLE Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    correo VARCHAR(255) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL
);

CREATE TABLE Empresas (
    id_empresa SERIAL PRIMARY KEY,
    nombre VARCHAR(255) UNIQUE NOT NULL,
    direccion VARCHAR(255),
    telefono VARCHAR(50)
);

CREATE TABLE Usuario_Empresa (
    id_usuario_emp SERIAL PRIMARY KEY,
    id_usuario INT REFERENCES Usuarios(id_usuario),
    id_empresa INT REFERENCES Empresas(id_empresa),
    rol VARCHAR(20) CHECK (rol IN ('Administrador', 'Usuario')) NOT NULL
);

CREATE TABLE Productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    id_empresa INT REFERENCES Empresas(id_empresa)
);

CREATE TABLE Inventario (
    id_inventario SERIAL PRIMARY KEY,
    id_producto INT REFERENCES Productos(id_producto),
    cantidad INT NOT NULL,
    ubicacion VARCHAR(255),
    fecha_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Inventario_Empresa (
    id_inv_empresa SERIAL PRIMARY KEY,
    id_inventario INT REFERENCES Inventario(id_inventario),
    id_empresa INT REFERENCES Empresas(id_empresa)
);

CREATE TABLE Historial_Inventario (
    id_historial SERIAL PRIMARY KEY,
    id_inventario INT REFERENCES Inventario(id_inventario),
    id_usuario INT REFERENCES Usuarios(id_usuario),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Categorias (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    id_empresa INT REFERENCES Empresas(id_empresa)
);

CREATE TABLE Producto_Categoria (
    id_producto_cat SERIAL PRIMARY KEY,
    id_producto INT REFERENCES Productos(id_producto),
    id_categoria INT REFERENCES Categorias(id_categoria)
);
