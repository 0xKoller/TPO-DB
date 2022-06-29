create database PrimeraParte_ParteA
go

create table PrimeraParte_ParteA.dbo.Artista(
	codArtista int,
	nombre varchar(100),
	constraint pk_Artista primary key (codArtista)
)

insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (1, 'Dua Lipa')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (2, 'Maroon 5')
insert into PrimeraParte_ParteA.dbo.Artista (codArtista, nombre) VALUES (3, 'YSY A')
go

create table PrimeraParte_ParteA.dbo.Generos(
	codGenero int,
	descripcion varchar(200),
	constraint pk_Generos primary key (codGenero)
)

insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (1, 'POP')
insert into PrimeraParte_ParteA.dbo.Generos (codGenero, descripcion) VALUES (2, 'TRAP')
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

set dateformat dmy
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (1,'Future Nostalgia', '27-03-2020', 1, 1)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (2,'JODRI (Deluxe)', '11-06-2021', 2, 1)
insert into PrimeraParte_ParteA.dbo.Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (3,'TRAP DE VERDAD', '11-11-2021', 3, 2)
go

create table PrimeraParte_ParteA.dbo.Temas(
	codTema int,
	titulo varchar(100),
	duracion float,
	codAlbum int,
	constraint pk_Temas primary key (codTema),
	constraint fk_Album foreign key (codAlbum) references PrimeraParte_ParteA.dbo.Albumes (codAlbum)
)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'Future Nostalgia', 3.04, 1)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'Dont Start Now', 3.03, 1)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (3, 'Levitating', 3.23, 1)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (4, 'Beautiful Mistakes', 3.47, 2)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (5, 'Lost', 2.53, 2)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (6, 'Echo', 2.59, 2)

insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (7, 'TRAP DE VERDAD', 2.12, 3)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (8, 'ORO Y PLATINO', 2.47, 3)
insert into PrimeraParte_ParteA.dbo.Temas (codTema, titulo,duracion,codAlbum) VALUES (9, 'INSPIRACION DIVINA', 3.11, 3)
go

create table PrimeraParte_ParteA.dbo.Cliente (
	codCliente int,
	nombre varchar(100),
	saldo float,
	constraint pk_Cliente primary key (codCliente)
)

insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (1, 'Jose Luis', 87.40)
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (2, 'Constantino', 7.30)
insert into PrimeraParte_ParteA.dbo.Cliente (codCliente, nombre, saldo) VALUES (3, 'Matias', 999.99)
go

create table PrimeraParte_ParteA.dbo.Pedidos (
	nroPedido int,
	fecha date,
	codCliente int,
	fechaEntrega date,
	lugarEntrega varchar(200),
	constraint pk_Pedidos primary key (nroPedido)
)

set dateformat dmy
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (1, '28-06-2022', 1, '01-07-2022', 'Bernardo de Irigoyen 924')
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (2, '30-06-2022', 3, '23-07-2022', 'Lima 755')
insert into PrimeraParte_ParteA.dbo.Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (3, '02-06-2022', 2, '10-06-2022', 'Av. Independencia 985')
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

set dateformat dmy
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (1, '28-06-2022', 1, 1,250.00,10.0,0.0,275.0)
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (2, '30-06-2022', 3, 2,2000.00,10.0,0.0,2200.0)
insert into PrimeraParte_ParteA.dbo.Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (3, '02-06-2022', 2, 1,180.00,10.0,0.0,198.0)
go

create table PrimeraParte_ParteA.dbo.Productos (
	codProducto int,
	descripcion varchar(200),
	stock int,
	puntoReposicion int,
	precio float,
	constraint pk_Productos primary key (codProducto)
)

insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (1, 'Walkman', 15, 5,250.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (2, 'PC', 20, 20,2000.00)
insert into PrimeraParte_ParteA.dbo.Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (3, 'Parlantes', 30, 50,180.00)
go

create table PrimeraParte_ParteA.dbo.ItemsPedido (
	codProducto int,
	codPedido int,
	cantidad int
	constraint fk_ItemsPedido_Productos foreign key (codProducto) references PrimeraParte_ParteA.dbo.Productos (codProducto),
	constraint fk_ItemsPedido_Pedido foreign key (codPedido) references PrimeraParte_ParteA.dbo.Pedidos (nroPedido)
)

insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (1, 2, 5)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (2, 3, 10)
insert into PrimeraParte_ParteA.dbo.ItemsPedido (codProducto, codPedido, cantidad) VALUES (3, 1, 15)
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

insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (1, 1, 1,275,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (2, 2, 1,2200,0)
insert into PrimeraParte_ParteA.dbo.ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (3, 3, 1,198,0)
go

create table PrimeraParte_ParteA.dbo.Composiciones(
	codProducto int,
	codProductoComponente int,
	cantidad int

	constraint pk_ProductoComponente primary key (codProductoComponente),
	constraint fk_Producto foreign key (codProducto) references PrimeraParte_ParteA.dbo.Productos (codProducto)
)

insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (1,1,100)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (2,2,25)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (3,3,400)
insert into PrimeraParte_ParteA.dbo.Composiciones VALUES (2,4,50)
go



