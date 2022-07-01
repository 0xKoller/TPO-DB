-- Procedimientos 6 - 10 

-- 6) 
CREATE PROCEDURE proyectaEspecialidad
	(@especialidad VARCHAR(100), @sexo CHAR = null)
	AS
	BEGIN
		IF @sexo IS NOT null 
			SELECT med.matricula, nombre, apellido, sexo 
				FROM especialidades esp
					INNER JOIN espemedi on esp.idespecialidad = espemedi.idespecialidad
					INNER JOIN Medicos med on espemedi.matricula = med.matricula
				WHERE especialidad = @especialidad and sexo = @sexo
		ELSE
			SELECT *
				FROM especialidades esp
						INNER JOIN espemedi on esp.idespecialidad = espemedi.idespecialidad
						INNER JOIN Medicos med on espemedi.matricula = med.matricula
					WHERE especialidad = @especialidad
	END
GO

-- 7)
CREATE PROCEDURE proyectaEstudiosCubiertosPorOoss
	(@nombreOoss VARCHAR(50), @nombrePlan VARCHAR(50) = null) 
	AS
	BEGIN
		IF @nombrePlan IS NOT NULL
			SELECT est.estudio, cob.cobertura 
				FROM estudios est
					INNER JOIN coberturas cob ON est.idestudio = cob.idestudio
					INNER JOIN (SELECT sigla FROM ooss WHERE nombre = @nombreOoss) oos ON cob.sigla = oos.sigla
		ELSE
			SELECT est.estudio, cob.cobertura 
				FROM estudios est
					INNER JOIN coberturas cob ON est.idestudio = cob.idestudio
					INNER JOIN (SELECT sigla FROM ooss WHERE nombre = @nombreOoss) oos ON cob.sigla = oos.sigla
					
	END


INSERT INTO medicos values (2, 'Matias', 'Santoro', 1,'F')
INSERT INTO especialidades values (1, 'Cirujano'), (2, 'Otorrino')

INSERT INTO espemedi VALUES (2,1), (2,2)

EXEC proyectaEspecialidad 'Cirujano', 'M'

EXEC proyectaEstudiosCubiertosPorOoss 'Galeno'

INSERT INTO ooss VALUES ('GALE', 'Galeno', 'Salud'), ('OSDE', 'Osde', 'Salud')
INSERT INTO Planes VALUES ('GALE',1 , 'ORO', 1), ('OSDE', 1, '210', 1) 


INSERT INTO Estudios VALUES (1, 'Tomografia', 1), (2, 'Radiografia',1)

INSERT INTO Coberturas VALUES ('GALE',1,1,90), ('GALE',1,2,100), ('OSDE', 1, 1, 70), ('OSDE', 1, 2, 90)