create database PrimeraParte_ParteB
go

set dateformat dmy
go

create table PrimeraParte_ParteB.dbo.usuarios (
	idUsuario int,
	nombre varchar(200),
	alias varchar(50),
	contra varchar(100),
	activo int,
	correo varchar(200),
	constraint pk_Usuarios primary key (idUsuario)
)
go

create table PrimeraParte_ParteB.dbo.categorias(
	idCategoria int,
	nombre varchar(100),
	descripcion varchar(200)
	constraint pk_Categorias primary key (idCategoria)
)
go

create table PrimeraParte_ParteB.dbo.noticias(
	idNoticia int,
	titulo varchar(150),
	idCategoria int,
	autor int,
	fecha date,
	ubicacion varchar(100)
	constraint pk_Noticias primary key (idNoticia),
	constraint fk_Noticias_Categorias foreign key (idCategoria) references categorias,
)
go

create table PrimeraParte_ParteB.dbo.comentarios(
	idComentario int,
	idNoticia int,
	texto varchar(200),
	idUsuario int,
	fecha date,
	constraint pk_Comentarios primary key (idComentario),
	constraint fk_Comentarios_Noticias foreign key (idNoticia) references noticias,
	constraint fk_Comentarios_Usuarios foreign key (idUsuario) references usuarios
)
go

create table PrimeraParte_ParteB.dbo.privilegios(
	idUsuario int,
	privilegio varchar(15),
	idCategoria int
	constraint fk_Privilegios_Usuarios foreign key (idUsuario) references usuarios,
	constraint fk_Privilegios_Categorias foreign key (idCategoria) references categorias
)
go

create table PrimeraParte_ParteB.dbo.votaciones(
	idVotacion int,
	idNoticia int,
	fechaInicio date,
	fechaFin date,
	pregunta varchar(100),
	respUno varchar(100),
	respDos varchar(100),
	respTres varchar(100),
	votosUno int,
	votosDos int,
	votosTres int
	constraint pk_Votaciones primary key (idVotacion),
	constraint fk_Votaciones_Noticias foreign key (idNoticia) references noticias
)
go

--Insert Usuarios
insert into usuarios (idUsuario, nombre, alias, contra, activo, correo) values (0, 'Jose Luis', 'SR Developer', '123$%^789', 1, 'seniordeveloper@koller.com')
insert into usuarios (idUsuario, nombre, alias, contra, activo, correo) values (1, 'Constantino', 'Web Scrapper Officer', 'pythonrocks', 1, 'pythonesco@gmail.com')
insert into usuarios (idUsuario, nombre, alias, contra, activo, correo) values (2,'Matias', 'PHP Rocks', 'phpisdead', 1, 'myownemail@matute.com')
insert into usuarios (idUsuario, nombre, alias, contra, activo, correo) values (3, 'Latour', 'Oxford dude', 'guater', 0, 'cambridge@gmail.com')
go

--Insert Categorias
insert into categorias(idCategoria, nombre, descripcion) values (0, 'Policiales', 'Noticias de incidentes, accidentes, transito, manifestaciones')
insert into categorias(idCategoria, nombre, descripcion) values (1, 'Politica', 'Destapando verdades de la politica Argentina')
insert into categorias(idCategoria, nombre, descripcion) values (2, 'Deportes', 'Toda la informacion sobre copas nacionales y mundiales')
go

--Insert Noticias
insert into noticias(idNoticia, titulo, idCategoria, autor, fecha, ubicacion) values (0, 'Se robaron hasta el papel higenico', 0, 1, '01/07/2022', 'Chacarita')
insert into noticias(idNoticia, titulo, idCategoria, autor, fecha, ubicacion) values (1, 'No dejaron ni los cordones', 2, 1, '11/03/2021', 'Neuquen')
go

--Insert Comentarios
insert into comentarios(idComentario,idNoticia, texto, idUsuario, fecha) values (1, 1,'NEUQUEN ES COMPROMISO', 0, '11/03/2021')
go

--Insert Privilegios
insert into privilegios(idUsuario, privilegio, idCategoria) values (0, 'Responsable', 0)
insert into privilegios(idUsuario, privilegio, idCategoria) values (1, 'Crear Noticia', 0)
insert into privilegios(idUsuario, privilegio, idCategoria) values (2, 'Crear Noticia', 1)
insert into privilegios(idUsuario, privilegio, idCategoria) values (3, 'Responsable', 1)
go

--Insert Votaciones
insert into votaciones(idVotacion, idNoticia, fechaInicio, fechaFin, pregunta, respUno, respDos, respTres, votosUno, votosDos, votosTres) values (0, 0, '01/07/2022', '08/07/2022', 'Era necesario?', 'Totalmente', 'No lo se', 'Indignante', 50, 4, 84)
insert into votaciones(idVotacion, idNoticia, fechaInicio, fechaFin, pregunta, respUno, respDos, respTres, votosUno, votosDos, votosTres) values (1, 1, '11/03/2021', '18/03/2021', 'Era necesario?', 'Totalmente', 'No lo se', 'Indignante', 123, 45, 34)
go