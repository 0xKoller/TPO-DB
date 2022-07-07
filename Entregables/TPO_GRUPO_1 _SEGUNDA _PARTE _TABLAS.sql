create database CentroMedico
go

CREATE TABLE CentroMedico.dbo.medicos (
	matricula INT,
	nombre VARCHAR(50),
	apellido VARCHAR(100),
	activo INT,
	sexo CHAR,
	CONSTRAINT pk_medicos_matricula PRIMARY KEY (matricula)
)
go

create table CentroMedico.dbo.especialidades (
	idespecialidad int,
	especialidad varchar(100),
	constraint pk_especialidades primary key (idespecialidad)
)
go
create table CentroMedico.dbo.espemedi (
	matricula int,
	idespecialidad int,
	constraint fk_espemedi_medicos foreign key (matricula) references medicos,
	constraint fk_espemedi_especialidades foreign key (idespecialidad) references especialidades
)
go

create table CentroMedico.dbo.estudios (
	idestudio int,
	estudio varchar(100),
	activo int,
	constraint pk_estudios primary key (idestudio)
)
go

create table CentroMedico.dbo.estuespe (
	idestudio int,
	idespecialidad int,
	constraint pk_estuespe primary key(idestudio, idespecialidad),
	constraint fk_estuespe_estudios foreign key (idestudio) references estudios,
	constraint fk_estuespe_especialidad foreign key (idespecialidad) references especialidades
)
go


create table CentroMedico.dbo.institutos (
	idinstituto int,
	instituto varchar(100),
	activo int,
	constraint pk_institutos primary key (idinstituto)
)
go

create table CentroMedico.dbo.precios (
	idestudio int,
	idinstituto int,
	precio decimal(10,2),
	constraint fk_precios_institutos foreign key (idinstituto) references institutos,
	constraint fk_precios_estudios foreign key (idestudio) references estudios,
	constraint pk_precios primary key (idestudio, idinstituto)
)
go

create table CentroMedico.dbo.ooss (
	sigla varchar(10),
	nombre varchar(50),
	categoria varchar(50)
	constraint pk_ooss primary key (sigla)
)
go

create table CentroMedico.dbo.planes(
	sigla varchar(10),
	nroplan int,
	nombre varchar(50),
	activo int,
	constraint pk_planes primary key(sigla, nroplan),
	constraint fk_planes_ooss foreign key (sigla) references ooss,
)
go

create table CentroMedico.dbo.coberturas(
	sigla varchar(10),
	nroplan int,
	idestudio int,
	cobertura float,
	constraint pk_coberturas primary key (sigla, nroplan, idestudio),
	constraint fk_coberturas_estudios foreign key (idestudio) references estudios,
	constraint fk_cobertuas_planes foreign key (sigla, nroplan) references planes
)
go

create table CentroMedico.dbo.afiliados(
	dni int,
	sigla varchar(10),
	nroplan int,
	nroafiliado int,
	constraint pk_afiliados primary key (dni, sigla),
	constraint fk_afiliados_planes foreign key (sigla, nroplan) references planes
)
go

create table CentroMedico.dbo.pacientes(
	dni int,
	nombre varchar(50),
	apellido varchar(50),
	sexo char,
	nacimiento date,
	constraint pk_pacientes primary key (dni)
)
go

create table CentroMedico.dbo.historias(
	dni int,
	idestudio int,
	idinstituto int,
	fecha date,
	matricula int,
	sigla varchar(10),
	pagado int,
	observaciones varchar(500),
	constraint pk_historias primary key (dni, idestudio, idinstituto, fecha),
	constraint fk_historias_medicos foreign key (matricula) references medicos,
	constraint fk_historias_pacientes foreign key (dni) references pacientes,
	constraint fk_historias_afiliados foreign key (dni, sigla) references afiliados,
	constraint fk_historias_precios foreign key (idestudio, idinstituto) references precios
)
go

