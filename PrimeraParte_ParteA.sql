create table Artista(
	codArtista int,
	nombre varchar(100),
	constraint pk_Artista primary key (codArtista)
)

insert into Artista (codArtista, nombre) VALUES (1, 'Dua Lipa')
insert into Artista (codArtista, nombre) VALUES (2, 'Maroon 5')
insert into Artista (codArtista, nombre) VALUES (3, 'YSY A')

create table Generos(
	codGenero int,
	descripcion varchar(200),
	constraint pk_Generos primary key (codGenero)
)

insert into Generos (codGenero, descripcion) VALUES (1, 'POP')
insert into Generos (codGenero, descripcion) VALUES (2, 'TRAP')

create table Albumes (
	codAlbum int,
	titulo varchar(200),
	fecha date,
	codArtista int,
	codGenero int,
	constraint pk_Albumes primary key (codAlbum),
	constraint fk_Artista foreign key (codArtista) references Artista (codArtista),
	constraint fk_Genero foreign key (codGenero) references Generos (codGenero)
)

insert into Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (1,'Future Nostalgia', '27/03/2020', 1, 1)
insert into Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (2,'JODRI (Deluxe)', '11/06/2021', 2, 1)
insert into Albumes (codAlbum, titulo, fecha, codArtista, codGenero) VALUES (3,'TRAP DE VERDAD', '11/11/2021', 3, 2)


create table Temas(
	codTema int,
	titulo varchar(100),
	duracion float,
	codAlbum int,
	constraint pk_Temas primary key (codTema),
	constraint fk_Album foreign key (codAlbum) references Albumes (codAlbum)
)

insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'Future Nostalgia', 3.04, 1)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'Dont Start Now', 3.03, 1)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (5, 'Levitating', 3.23, 1)

insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'Beautiful Mistakes', 3.47, 2)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'Lost', 2.53, 2)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (3, 'Echo', 2.59, 2)

insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (1, 'TRAP DE VERDAD', 2.12, 3)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (2, 'ORO Y PLATINO', 2.47, 3)
insert into Temas (codTema, titulo,duracion,codAlbum) VALUES (8, 'INSPIRACION DIVINA', 3.11, 3)

create table Cliente (
	codCliente int,
	nombre varchar(100),
	saldo float,
	constraint pk_Cliente primary key (codCliente)
)

insert into Cliente (codCliente, nombre, saldo) VALUES (01, 'Jose Luis', 87.40)
insert into Cliente (codCliente, nombre, saldo) VALUES (02, 'Constantino', 7.30)
insert into Cliente (codCliente, nombre, saldo) VALUES (99, 'Matias', 999.99)


create table Pedidos (
	nroPedido int,
	fecha date,
	codCliente int,
	fechaEntrega date,
	lugarEntrega varchar(200),
	constraint pk_Pedidos primary key (nroPedido)
)

insert into Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (11, '28/06/2022', 01, '01/07/2022', 'Bernardo de Irigoyen 924')
insert into Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (16, '30/06/2022', 03, '23/07/2022', 'Lima 755')
insert into Pedidos (nroPedido, fecha, codCliente,fechaEntrega,lugarEntrega) VALUES (02, '02/06/2022', 02, '10/06/2022', 'Av. Independencia 985')

create table Facturas (
	nroFactura int,
	fecha date,
	codCliente int,
	codPedido int,
	bruto float,
	iva float,
	IIBB float,
	final float,
	constraint pk_Facturas primary key (nroFactura),
	constraint fk_Cliente foreign key (codCliente) references Cliente (codCliente),
	constraint fk_Pedido foreign key (codPedido) references Pedidos (nroPedido)
)

insert into Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (95, '28/06/2022', 01, 11,250.00,10.0,0.0,275.0)
insert into Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (55, '30/06/2022', 03, 16,2000.00,10.0,0.0,2200.0)
insert into Facturas (nroFactura, fecha, codCliente,codPedido,bruto,iva,IIBB,final) VALUES (15, '02/06/2022', 02, 11,180.00,10.0,0.0,198.0)

create table Productos (
	codProducto int,
	descripcion varchar(200),
	stock int,
	puntoReposicion int,
	precio float,
	constraint pk_Productos primary key (codProducto)
)

insert into Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (01, 'Walkman', 15, 5,250.00)
insert into Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (25, 'PC', 20, 20,2000.00)
insert into Productos (codProducto, descripcion, stock,puntoReposicion,precio) VALUES (99, 'Parlantes', 30, 50,180.00)

create table ItemsPedido (
	codProducto int,
	codPedido int,
	cantidad int
	constraint fk_ItemsPedido_Productos foreign key (codProducto) references Productos (codProducto),
	constraint fk_ItemsPedido_Pedido foreign key (codPedido) references Pedidos (nroPedido)
)

insert into ItemsPedido (codProducto, codPedido, cantidad) VALUES (01, 11, 1)
insert into ItemsPedido (codProducto, codPedido, cantidad) VALUES (25, 03, 1)
insert into ItemsPedido (codProducto, codPedido, cantidad) VALUES (99, 02, 1)

create table ItemsFactura(
	codProducto int,
	nroFactura int,
	cantidad int,
	precio float,
	descuento float,
	constraint fk_ItemsFactura_Productos foreign key (codProducto) references Productos (codProducto),
	constraint fk_ItemsFactura_Factura foreign key (nroFactura) references Facturas (nroFactura)
)

insert into ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (01, 95, 1,275,0)
insert into ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (25, 55, 1,2200,0)
insert into ItemsFactura (codProducto, nroFactura, cantidad, precio, descuento) VALUES (99, 15, 1,198,0)

create table Composiciones(
	codProducto int,
	codProductoComponente int,
	cantidad int

	constraint pk_ProductoComponente primary key (codProductoComponente),
	constraint fk_Producto foreign key (codProducto) references Productos (codProducto)
)

insert into Composiciones VALUES (01,01,100)
insert into Composiciones VALUES (25,02,25)
insert into Composiciones VALUES (99,03,400)
insert into Composiciones VALUES (25,04,50)

go



