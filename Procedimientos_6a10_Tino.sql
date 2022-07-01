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
			SELECT est.estudio, cob.cobertura, pla.nombre 
				FROM estudios est
					INNER JOIN coberturas cob ON est.idestudio = cob.idestudio
					INNER JOIN (SELECT * FROM Planes WHERE nombre = @nombrePlan) pla on cob.nroplan = pla.nroplan and cob.sigla = pla.sigla
						WHERE 
							(SELECT sigla FROM ooss WHERE nombre = @nombreOoss) = cob.sigla 
							
		ELSE
			SELECT est.estudio, cob.cobertura, pla.nombre 
				FROM estudios est
					INNER JOIN coberturas cob ON est.idestudio = cob.idestudio
					INNER JOIN Planes pla on cob.nroplan = pla.nroplan and cob.sigla = pla.sigla
					WHERE (SELECT sigla FROM ooss WHERE nombre = @nombreOoss) = cob.sigla				
	END
GO

EXEC proyectaEstudiosCubiertosPorOoss 'Galeno'

