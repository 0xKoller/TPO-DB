CREATE DATABASE CentroMedico
GO

CREATE TABLE CentroMedico.dbo.medicos (
	matricula INT,
	nombre VARCHAR(50),
	apellido VARCHAR(100),
	activo INT,
	sexo CHAR,
	CONSTRAINT pk_medicos_matricula PRIMARY KEY (matricula)
)
GO

CREATE TABLE CentroMedico.dbo.especialidades (
	idespecialidad INT,
	especialidad VARCHAR(100),
	CONSTRAINT pk_especialidades PRIMARY KEY (idespecialidad)
)
GO

CREATE TABLE CentroMedico.dbo.espemedi (
	matricula INT,
	idespecialidad INT,
	CONSTRAINT fk_espemedi_medicos FOREIGN KEY (matricula) REFERENCES medicos,
	CONSTRAINT fk_espemedi_especialidades FOREIGN KEY (idespecialidad) REFERENCES especialidades
)
GO

CREATE TABLE CentroMedico.dbo.estudios (
	idestudio INT,
	estudio VARCHAR(100),
	activo INT,
	CONSTRAINT pk_estudios PRIMARY KEY (idestudio)
)
GO

CREATE TABLE CentroMedico.dbo.estuespe (
	idestudio INT,
	idespecialidad INT,
	CONSTRAINT pk_estuespe PRIMARY KEY(idestudio, idespecialidad),
	CONSTRAINT fk_estuespe_estudios FOREIGN KEY (idestudio) REFERENCES estudios,
	CONSTRAINT fk_estuespe_especialidad FOREIGN KEY (idespecialidad) REFERENCES especialidades
)
GO


CREATE TABLE CentroMedico.dbo.institutos (
	idinstituto INT,
	instituto VARCHAR(100),
	activo INT,
	CONSTRAINT pk_institutos PRIMARY KEY (idinstituto)
)
GO

CREATE TABLE CentroMedico.dbo.precios (
	idestudio INT,
	idinstituto INT,
	precio DECIMAL(10,2),
	CONSTRAINT fk_precios_institutos FOREIGN KEY (idinstituto) REFERENCES institutos,
	CONSTRAINT fk_precios_estudios FOREIGN KEY (idestudio) REFERENCES estudios,
	CONSTRAINT pk_precios PRIMARY KEY (idestudio, idinstituto)
)
GO

CREATE TABLE CentroMedico.dbo.ooss (
	sigla VARCHAR(10),
	nombre VARCHAR(50),
	categoria VARCHAR(50)
	CONSTRAINT pk_ooss PRIMARY KEY (sigla)
)
GO

CREATE TABLE CentroMedico.dbo.planes(
	sigla VARCHAR(10),
	nroplan INT,
	nombre VARCHAR(50),
	activo INT,
	CONSTRAINT pk_planes PRIMARY KEY(sigla, nroplan),
	CONSTRAINT fk_planes_ooss FOREIGN KEY (sigla) REFERENCES ooss,
)
GO

CREATE TABLE CentroMedico.dbo.coberturas(
	sigla VARCHAR(10),
	nroplan INT,
	idestudio INT,
	cobertura float,
	CONSTRAINT pk_coberturas PRIMARY KEY (sigla, nroplan, idestudio),
	CONSTRAINT fk_coberturas_estudios FOREIGN KEY (idestudio) REFERENCES estudios,
	CONSTRAINT fk_cobertuas_planes FOREIGN KEY (sigla, nroplan) REFERENCES planes
)
GO

CREATE TABLE CentroMedico.dbo.afiliados(
	dni INT,
	sigla VARCHAR(10),
	nroplan INT,
	nroafiliado INT,
	CONSTRAINT pk_afiliados PRIMARY KEY (dni, sigla),
	CONSTRAINT fk_afiliados_planes FOREIGN KEY (sigla, nroplan) REFERENCES planes
)
GO

CREATE TABLE CentroMedico.dbo.pacientes(
	dni INT,
	nombre VARCHAR(50),
	apellido VARCHAR(50),
	sexo CHAR,
	nacimiento DATE,
	CONSTRAINT pk_pacientes PRIMARY KEY (dni)
)
GO

CREATE TABLE CentroMedico.dbo.historias(
	dni INT,
	idestudio INT,
	idinstituto INT,
	fecha date,
	matricula INT,
	sigla VARCHAR(10),
	pagado INT,
	observaciones VARCHAR(500),
	CONSTRAINT pk_historias PRIMARY KEY (dni, idestudio, idinstituto, fecha),
	CONSTRAINT fk_historias_medicos FOREIGN KEY (matricula) REFERENCES medicos,
	CONSTRAINT fk_historias_pacientes FOREIGN KEY (dni) REFERENCES pacientes,
	CONSTRAINT fk_historias_afiliados FOREIGN KEY (dni, sigla) REFERENCES afiliados,
	CONSTRAINT fk_historias_precios FOREIGN KEY (idestudio, idinstituto) REFERENCES precios
)
GO

