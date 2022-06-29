create table Usuarios (
	idUsuario int,
	nombre varchar(200),
	alias varchar(50),
	contra varchar(100),
	activo int,
	correo varchar(200),
	constraint pk_Usuarios primary key (idUsuario)
)
go



create table categorias(
	idCategoria int,
	nombre varchar(100),
	descripcion varchar(200)
	constraint pk_Categorias primary key (idCategoria)
)
go

create table noticias(
	idNoticia int,
	titulo varchar(150),
	idCategoria int,
	autor varchar(100),
	fecha date,
	ubicacion varchar(100)
	constraint pk_Noticias primary key (idNoticia),
	constraint fk_Noticias_Categorias foreign key (idCategoria) references categorias,
)
go

create table comentarios(
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



create table privilegios(
	idUsuario int,
	privilegio varchar(15),
	idCategoria int
	constraint fk_Privilegios_Usuarios foreign key (idUsuario) references usuarios,
	constraint fk_Privilegios_Categorias foreign key (idCategoria) references categorias
)
go

create table votaciones(
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