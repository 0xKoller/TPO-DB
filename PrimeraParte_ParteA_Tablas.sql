create database PrimeraParte_ParteA
go
set dateformat dmy
create table PrimeraParte_ParteA.dbo.Artista(
	codArtista int,
	nombre varchar(100),
	constraint pk_Artista primary key (codArtista)
)
go

create table PrimeraParte_ParteA.dbo.Generos(
	codGenero int,
	descripcion varchar(200),
	constraint pk_Generos primary key (codGenero)
)
go

create table PrimeraParte_ParteA.dbo.Albumes (
	codAlbum int,
	titulo varchar(200),
	fecha date,
	codArtista int,
	codGenero int,
	constraint pk_Albumes primary key (codAlbum),
	constraint fk_Artista foreign key (codArtista) references PrimeraParte_ParteA.dbo.Artista (codArtista),
	constraint fk_Genero foreign key (codGenero) references PrimeraParte_ParteA.dbo.Generos (codGenero)
)
go

create table PrimeraParte_ParteA.dbo.Temas(
	codTema int,
	titulo varchar(100),
	duracion float,
	codAlbum int,
	constraint pk_Temas primary key (codTema),
	constraint fk_Album foreign key (codAlbum) references PrimeraParte_ParteA.dbo.Albumes (codAlbum)
)
go

create table PrimeraParte_ParteA.dbo.Cliente (
	codCliente int,
	nombre varchar(100),
	saldo float,
	constraint pk_Cliente primary key (codCliente)
)
go

create table PrimeraParte_ParteA.dbo.Pedidos (
	nroPedido int,
	fecha date,
	codCliente int,
	fechaEntrega date,
	lugarEntrega varchar(200),
	constraint pk_Pedidos primary key (nroPedido)
)
go

create table PrimeraParte_ParteA.dbo.Facturas (
	nroFactura int,
	fecha date,
	codCliente int,
	codPedido int,
	bruto float,
	iva float,
	IIBB float,
	final float,
	constraint pk_Facturas primary key (nroFactura),
	constraint fk_Cliente foreign key (codCliente) references PrimeraParte_ParteA.dbo.Cliente (codCliente),
	constraint fk_Pedido foreign key (codPedido) references PrimeraParte_ParteA.dbo.Pedidos (nroPedido)
)
go

create table PrimeraParte_ParteA.dbo.Productos (
	codProducto int,
	descripcion varchar(200),
	stock int,
	puntoReposicion int,
	precio float,
	constraint pk_Productos primary key (codProducto)
)
go

create table PrimeraParte_ParteA.dbo.ItemsPedido (
	codProducto int,
	codPedido int,
	cantidad int
	constraint fk_ItemsPedido_Productos foreign key (codProducto) references PrimeraParte_ParteA.dbo.Productos (codProducto),
	constraint fk_ItemsPedido_Pedido foreign key (codPedido) references PrimeraParte_ParteA.dbo.Pedidos (nroPedido)
)
go

create table PrimeraParte_ParteA.dbo.ItemsFactura(
	codProducto int,
	nroFactura int,
	cantidad int,
	precio float,
	descuento float,
	constraint fk_ItemsFactura_Productos foreign key (codProducto) references PrimeraParte_ParteA.dbo.Productos (codProducto),
	constraint fk_ItemsFactura_Factura foreign key (nroFactura) references PrimeraParte_ParteA.dbo.Facturas (nroFactura)
)
go

create table PrimeraParte_ParteA.dbo.Composiciones(
	codProducto int,
	codProductoComponente int,
	cantidad int

	constraint pk_ProductoComponente primary key (codProductoComponente),
	constraint fk_Producto foreign key (codProducto) references PrimeraParte_ParteA.dbo.Productos (codProducto)
)
go


--Insert Artistas
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (1, 'Dua Lipa')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (2, 'Maroon 5')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (3, 'YSY A')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (4, 'Guns and Roses')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (5, 'Ludwig van Beethoven')
go
--Insert Generos
insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (1, 'POP')
insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (2, 'TRAP')
insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (3, 'ROCK')
insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (4, 'CLASICO')
go
--Insert Albumes
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (1,'Future Nostalgia', '27-03-2020', 1, 1)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (2,'JODRI (Deluxe)', '11-06-2021', 2, 1)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (3,'TRAP DE VERDAD', '11-11-2021', 3, 2)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (4,'Use Your Illusion I', '17-09-1991', 4, 3)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (5,'Sinfonias', '01-01-1785', 5, 3)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (6,'Red Pill Blues', '05-03-2017', 2, 1)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (7,'V', '25-10-2014', 2, 1)
go
--Insert Temas
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'Future Nostalgia', 3.04, 1)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'Dont Start Now', 3.03, 1)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (3, 'Levitating', 3.23, 1)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (4, 'Beautiful Mistakes', 3.47, 2)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (5, 'Lost', 2.53, 2)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (6, 'Echo', 2.59, 2)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (7, 'TRAP DE ÒERDAD', 2.12, 3)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (8, 'ORO Y PLATIÒO', 2.47, 3)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (9, 'INSPIRACION DIVINA', 3.11, 3)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (10, 'Right Next Door to Hell', 3.03, 4)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (11, 'Perfect Crime', 2.24, 4)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (12, 'Bad Apples', 4.29, 4)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (13, 'Op.21 - Allegro Con Brio', 9.17, 5)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (14, 'Op.21 - Andante Cantabile Con Moto', 6.27, 5)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (15, 'Op.36 - Allegro Con Brio', 12.46, 5)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (16, 'Red Pill Blues', 3.59, 6)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (17, 'What Lovers Do', 3.19, 6)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (18, 'Closure', 11.28, 6)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (19, 'Maps', 3.10, 7)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (20, 'Animals', 3.49, 7)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (21, 'Sugar', 3.56, 7)
go
--Insert Clientes
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (1, 'Jose Luis', 87.40)
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (2, 'Constantino', 7.30)
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (3, 'Matias', 999.99)
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (4, 'Latour', -92.59)
go
--Insert Pedidos
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (1, '28-06-2022', 1, '01-07-2022', 'Bernardo de Irigoyen 924')
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (2, '30-06-2022', 3, '23-07-2022', 'Lima 755')
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (3, '02-06-2022', 2, '10-06-2022', 'Av. Independencia 985')
go
--Insert Facturas
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (1, '28-06-2022', 1, 1,5280.0,10.0,0.0,5808.0)
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (2, '30-06-2022', 3, 2,2000.00,10.0,0.0,2200.0)
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (3, '02-06-2022', 2, 3,180.00,10.0,0.0,198.0)
go
--Insert Productos
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (1, 'Walkman', 15, 5,250.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (2, 'PC', 20, 20,2000.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (3, 'Parlantes', 30, 50,180.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (4, 'Volante', 5, 3,5000.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (5, 'Mouse', 200, 50,100.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (6, 'Auriculares', 83, 10,50.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (7, 'PenDrive', 1000, 25,195.00)
go
--Insert ItemsPedido
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (1, 2, 5)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (2, 3, 10)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (3, 1, 15)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (5, 1, 5)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (4, 1, 1)
go
--Insert ItemsFactura
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (1, 2, 5,250,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (2, 2, 1,2200,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (3, 3, 1,198,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (3, 1, 15,180,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (5, 1, 5,100,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (4, 1, 1,5000,0)
go
--Insert Composiciones
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (1,1,100)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (2,2,25)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (3,3,400)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (2,4,50)
go
