CREATE DATABASE PrimeraParte_ParteA
GO
SET DATEFORMAT dmy
CREATE TABLE PrimeraParte_ParteA.dbo.Artista(
	codArtista INT,
	nombre VARCHAR(100),
	CONSTRAINT pk_Artista PRIMARY KEY (codArtista)
)
go

CREATE TABLE PrimeraParte_ParteA.dbo.Generos(
	codGenero INT,
	descripcion VARCHAR(200),
	CONSTRAINT pk_Generos PRIMARY KEY (codGenero)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Albumes (
	codAlbum INT,
	titulo VARCHAR(200),
	fecha DATE,
	codArtista INT,
	codGenero INT,
	CONSTRAINT pk_Albumes PRIMARY KEY (codAlbum),
	CONSTRAINT fk_Artista FOREIGN KEY (codArtista) REFERENCES PrimeraParte_ParteA.dbo.Artista (codArtista),
	CONSTRAINT fk_Genero FOREIGN KEY (codGenero) REFERENCES PrimeraParte_ParteA.dbo.Generos (codGenero)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Temas(
	codTema INT,
	titulo VARCHAR(100),
	duracion FLOAT,
	codAlbum INT,
	CONSTRAINT pk_Temas PRIMARY KEY (codTema),
	CONSTRAINT fk_Album FOREIGN KEY (codAlbum) REFERENCES PrimeraParte_ParteA.dbo.Albumes (codAlbum)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Cliente (
	codCliente INT,
	nombre VARCHAR(100),
	saldo FLOAT,
	CONSTRAINT pk_Cliente PRIMARY KEY (codCliente)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Pedidos (
	nroPedido INT,
	fecha DATE,
	codCliente INT,
	fechaEntrega DATE,
	lugarEntrega VARCHAR(200),
	CONSTRAINT pk_Pedidos PRIMARY KEY (nroPedido)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Facturas (
	nroFactura INT,
	fecha DATE,
	codCliente INT,
	codPedido INT,
	bruto FLOAT,
	iva FLOAT,
	IIBB FLOAT,
	final FLOAT,
	CONSTRAINT pk_Facturas PRIMARY KEY (nroFactura),
	CONSTRAINT fk_Cliente FOREIGN KEY (codCliente) REFERENCES PrimeraParte_ParteA.dbo.Cliente (codCliente),
	CONSTRAINT fk_Pedido FOREIGN KEY (codPedido) REFERENCES PrimeraParte_ParteA.dbo.Pedidos (nroPedido)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Productos (
	codProducto INT,
	descripcion VARCHAR(200),
	stock INT,
	puntoReposicion INT,
	precio FLOAT,
	CONSTRAINT pk_Productos PRIMARY KEY (codProducto)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.ItemsPedido (
	codProducto INT,
	codPedido INT,
	cantidad INT
	CONSTRAINT fk_ItemsPedido_Productos FOREIGN KEY (codProducto) REFERENCES PrimeraParte_ParteA.dbo.Productos (codProducto),
	CONSTRAINT fk_ItemsPedido_Pedido FOREIGN KEY (codPedido) REFERENCES PrimeraParte_ParteA.dbo.Pedidos (nroPedido)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.ItemsFactura(
	codProducto INT,
	nroFactura INT,
	cantidad INT,
	precio FLOAT,
	descuento FLOAT,
	CONSTRAINT fk_ItemsFactura_Productos FOREIGN KEY (codProducto) REFERENCES PrimeraParte_ParteA.dbo.Productos (codProducto),
	CONSTRAINT fk_ItemsFactura_Factura FOREIGN KEY (nroFactura) REFERENCES PrimeraParte_ParteA.dbo.Facturas (nroFactura)
)
GO

CREATE TABLE PrimeraParte_ParteA.dbo.Composiciones(
	codProducto INT,
	codProductoComponente INT,
	cantidad INT

	CONSTRAINT pk_ProductoComponente PRIMARY KEY (codProductoComponente),
	CONSTRAINT fk_Producto FOREIGN KEY (codProducto) REFERENCES PrimeraParte_ParteA.dbo.Productos (codProducto)
)
GO


--Insert Artistas
INSERT INTO PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (1, 'Dua Lipa')
INSERT INTO PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (2, 'Maroon 5')
INSERT INTO PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (3, 'YSY A')
INSERT INTO PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (4, 'Guns and Roses')
INSERT INTO PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (5, 'Ludwig van Beethoven')
GO
--Insert Generos
INSERT INTO PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (1, 'POP')
INSERT INTO PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (2, 'TRAPS')
INSERT INTO PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (3, 'ROCK')
INSERT INTO PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (4, 'CLASICO')
GO
--Insert Albumes
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (1,'Future Nostalgia', '27-03-2020', 1, 1)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (2,'JODRI (Deluxe)', '11-06-2021', 2, 1)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (3,'TRAP DE VERDAD', '11-11-2021', 3, 2)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (4,'Use Your Illusion I', '17-09-1991', 4, 3)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (5,'Sinfonias', '01-01-1785', 5, 3)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (6,'Red Pill Blues', '05-03-2017', 2, 1)
INSERT INTO PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (7,'V', '25-10-2014', 2, 1)
GO
--Insert Temas
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'Future Òostalgia', 3.04, 1)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'Dont Start Òow', 3.03, 1)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (3, 'Levitating', 3.23, 1)


INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (4, 'Beautiful Mistakes', 3.47, 2)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (5, 'Lost', 2.53, 2)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (6, 'Echo', 2.59, 2)

INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (7, 'TRAP DE ÒERDAD', 2.12, 3)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (8, 'ORO Y PLATIÒO', 2.47, 3)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (9, 'INSPIRACION DIVINA', 3.11, 3)

INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (10, 'Right Next Door to Hell', 3.03, 4)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (11, 'Perfect Crime', 2.24, 4)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (12, 'Bad Apples', 4.29, 4)

INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (13, 'Op.21 - Allegro Con Brio', 9.17, 5)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (14, 'Op.21 - Andante Cantabile Con Moto', 6.27, 5)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (15, 'Op.36 - Allegro Con Brio', 12.46, 5)

INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (16, 'Red Pill Blues', 3.59, 6)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (17, 'What Lovers Do', 3.19, 6)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (18, 'Closure', 11.28, 6)

INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (19, 'Maps', 3.10, 7)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (20, 'Animals', 3.49, 7)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (21, 'Sugar', 3.56, 7)
INSERT INTO PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (22, 'Salt', 1.56, 7)
GO
--Insert Clientes
INSERT INTO PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (1, 'Jose Luis', 87.40)
INSERT INTO PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (2, 'Constantino', 7.30)
INSERT INTO PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (3, 'Matias', 999.99)
INSERT INTO PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (4, 'Latour', -92.59)
GO
--Insert Pedidos
INSERT INTO PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (1, '28-06-2022', 1, '01-07-2022', 'Bernardo de IriGOyen 924')
INSERT INTO PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (2, '30-06-2022', 3, '23-07-2022', 'Lima 755')
INSERT INTO PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (3, '02-06-2022', 2, '10-06-2022', 'Av. Independencia 985')
GO
--Insert Facturas
INSERT INTO PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (1, '28-06-2022', 1, 1,5280.0,10.0,0.0,5808.0)
INSERT INTO PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (2, '30-06-2022', 3, 2,2000.00,10.0,0.0,2200.0)
INSERT INTO PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (3, '02-06-2022', 2, 3,180.00,10.0,0.0,198.0)
GO
--Insert Productos
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (1, 'Walkman', 15, 5,250.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (2, 'PC', 20, 20,2000.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (3, 'Parlantes', 30, 50,180.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (4, 'Volante', 5, 3,5000.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (5, 'Mouse', 200, 50,100.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (6, 'Auriculares', 83, 10,50.00)
INSERT INTO PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (7, 'PenDrive', 1000, 25,195.00)
GO
--Insert ItemsPedido
INSERT INTO PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (1, 2, 5)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (2, 3, 10)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (3, 1, 15)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (5, 1, 5)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (4, 1, 1)
GO
--Insert ItemsFactura
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (1, 2, 5,250,0)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (2, 2, 1,2200,0)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (3, 3, 1,198,0)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (3, 1, 15,180,0)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (5, 1, 5,100,0)
INSERT INTO PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (4, 1, 1,5000,0)
GO
--Insert Composiciones
INSERT INTO PrimeraParte_ParteA.dbo.Composiciones VALUES (1,1,100)
INSERT INTO PrimeraParte_ParteA.dbo.Composiciones VALUES (2,2,25)
INSERT INTO PrimeraParte_ParteA.dbo.Composiciones VALUES (3,3,400)
INSERT INTO PrimeraParte_ParteA.dbo.Composiciones VALUES (2,4,50)
GO



CREATE DATABASE PrimeraParte_ParteB
GO


CREATE TABLE PrimeraParte_ParteB.dbo.usuarios (
	idUsuario INT,
	nombre VARCHAR(200),
	alias VARCHAR(50),
	contra VARCHAR(100),
	activo INT,
	correo VARCHAR(200),
	CONSTRAINT pk_Usuarios PRIMARY KEY (idUsuario)
)
GO

CREATE TABLE PrimeraParte_ParteB.dbo.categorias(
	idCategoria INT,
	nombre VARCHAR(100),
	descripcion VARCHAR(200)
	CONSTRAINT pk_Categorias PRIMARY KEY (idCategoria)
)
GO

CREATE TABLE PrimeraParte_ParteB.dbo.noticias(
	idNoticia INT,
	titulo VARCHAR(150),
	idCategoria INT,
	autor INT,
	fecha DATE,
	ubicacion VARCHAR(100)
	CONSTRAINT pk_Noticias PRIMARY KEY (idNoticia),
	CONSTRAINT fk_Noticias_Categorias FOREIGN KEY (idCategoria) REFERENCES categorias,
)
GO

CREATE TABLE PrimeraParte_ParteB.dbo.comentarios(
	idComentario INT,
	idNoticia INT,
	texto VARCHAR(200),
	idUsuario INT,
	fecha DATE,
	CONSTRAINT pk_Comentarios PRIMARY KEY (idComentario),
	CONSTRAINT fk_Comentarios_Noticias FOREIGN KEY (idNoticia) REFERENCES noticias,
	CONSTRAINT fk_Comentarios_Usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios
)
GO

CREATE TABLE PrimeraParte_ParteB.dbo.privilegios(
	idUsuario INT,
	privilegio VARCHAR(15),
	idCategoria INT
	CONSTRAINT fk_Privilegios_Usuarios FOREIGN KEY (idUsuario) REFERENCES usuarios,
	CONSTRAINT fk_Privilegios_Categorias FOREIGN KEY (idCategoria) REFERENCES categorias
)
GO

CREATE TABLE PrimeraParte_ParteB.dbo.votaciones(
	idVotacion INT,
	idNoticia INT,
	fechaInicio DATE,
	fechaFin DATE,
	pregunta VARCHAR(100),
	respUno VARCHAR(100),
	respDos VARCHAR(100),
	respTres VARCHAR(100),
	votosUno INT,
	votosDos INT,
	votosTres INT
	CONSTRAINT pk_Votaciones PRIMARY KEY (idVotacion),
	CONSTRAINT fk_Votaciones_Noticias FOREIGN KEY (idNoticia) REFERENCES noticias
)
GO

--Insert Usuarios
INSERT INTO usuarios (idUsuario, nombre, alias, contra, activo, correo) VALUES (0, 'Jose Luis', 'SR Developer', '123$%^789', 1, 'seniordeveloper@koller.com')
INSERT INTO usuarios (idUsuario, nombre, alias, contra, activo, correo) VALUES (1, 'Constantino', 'Web Scrapper Officer', 'pythonrocks', 1, 'pythonesco@gmail.com')
INSERT INTO usuarios (idUsuario, nombre, alias, contra, activo, correo) VALUES (2,'Matias', 'PHP Rocks', 'phpisdead', 1, 'myownemail@matute.com')
INSERT INTO usuarios (idUsuario, nombre, alias, contra, activo, correo) VALUES (3, 'Latour', 'Oxford dude', 'guater', 0, 'cambridge@gmail.com')
GO

--Insert Categorias
INSERT INTO categorias(idCategoria, nombre, descripcion) VALUES (0, 'Policiales', 'Noticias de incidentes, accidentes, transito, manifestaciones')
INSERT INTO categorias(idCategoria, nombre, descripcion) VALUES (1, 'Politica', 'Destapando verdades de la politica Argentina')
INSERT INTO categorias(idCategoria, nombre, descripcion) VALUES (2, 'Deportes', 'Toda la informacion sobre copas nacionales y mundiales')
GO

--Insert Noticias
INSERT INTO noticias(idNoticia, titulo, idCategoria, autor, fecha, ubicacion) VALUES (0, 'Se robaron hasta el papel higenico', 0, 1, '01/07/2022', 'Chacarita')
INSERT INTO noticias(idNoticia, titulo, idCategoria, autor, fecha, ubicacion) VALUES (1, 'No dejaron ni los cordones', 0, 2, '11/03/2021', 'Neuquen')
GO

--Insert Comentarios
INSERT INTO comentarios(idComentario,idNoticia, texto, idUsuario, fecha) VALUES (1, 1,'NEUQUEN ES COMPROMISO', 0, '11/03/2021')
GO

--Insert Privilegios
INSERT INTO privilegios(idUsuario, privilegio, idCategoria) VALUES (0, 'Responsable', 0)
INSERT INTO privilegios(idUsuario, privilegio, idCategoria) VALUES (1, 'Crear Noticia', 0)
INSERT INTO privilegios(idUsuario, privilegio, idCategoria) VALUES (2, 'Crear Noticia', 1)
INSERT INTO privilegios(idUsuario, privilegio, idCategoria) VALUES (3, 'Responsable', 1)
GO

--Insert Votaciones
INSERT INTO votaciones(idVotacion, idNoticia, fechaInicio, fechaFin, pregunta, respUno, respDos, respTres, votosUno, votosDos, votosTres) VALUES (0, 0, '01/07/2022', '08/07/2022', 'Era necesario?', 'Totalmente', 'No lo se', 'Indignante', 50, 4, 84)
INSERT INTO votaciones(idVotacion, idNoticia, fechaInicio, fechaFin, pregunta, respUno, respDos, respTres, votosUno, votosDos, votosTres) VALUES (1, 1, '11/03/2021', '18/03/2021', 'Era necesario?', 'Totalmente', 'No lo se', 'Indignante', 123, 45, 34)
GO