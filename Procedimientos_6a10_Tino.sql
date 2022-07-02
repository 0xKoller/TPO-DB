-- Procedimientos 6 - 10 

-- 6) 
CREATE PROCEDURE proyectaEspecialidad
	(@especialidad NVARCHAR(100), @sexo CHAR = null)
	AS
	BEGIN
		DECLARE @sentencia nvarchar(1000)
		SET @sentencia = 
		'SELECT med.matricula, nombre, apellido, sexo
			FROM especialidades esp
				INNER JOIN espemedi on esp.idespecialidad = espemedi.idespecialidad
				INNER JOIN Medicos med on espemedi.matricula = med.matricula
				WHERE especialidad = ''' + @especialidad + ''''  
		IF @sexo IS NOT null 
			set @sentencia = @sentencia + ' and sexo = ''' + @sexo + ''''
		exec sp_executesql @sentencia	
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



-- 8)	
CREATE PROCEDURE estudiosPorOossYMedico
	(@nombreOoss NVARCHAR(100) = null, @nombrePlan NVARCHAR(100) = null, @matricula int = null)
	AS
	BEGIN
		DECLARE @sentencia nvarchar(1000)
		SET @sentencia = 
			'SELECT COUNT(idEstudio) as CantidadEstudios
				FROM historias his
					INNER JOIN afiliados afi on his.dni = afi.dni and his.sigla = afi.sigla
					INNER JOIN planes pla on afi.sigla = pla.sigla and afi.nroplan = pla.nroPlan '
		IF @nombreOoss IS NOT null
			BEGIN
			SET @sentencia = @sentencia + 'WHERE his.sigla = (SELECT sigla FROM ooss WHERE nombre = ''' + @nombreOoss + ''')'
			IF @nombrePlan IS NOT NULL 
				SET @sentencia = @sentencia + ' AND pla.nombre = ''' + @nombrePlan + ''''
			IF @matricula IS NOT null
				SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(nvarchar(25), @matricula)
			END
		ELSE
			BEGIN
			IF @nombrePlan is not null 
				SET @sentencia = @sentencia + 'WHERE pla.nombre = ''' + @nombrePlan + ''''
				IF @matricula IS NOT null
					SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(nvarchar(25), @matricula) 
			ELSE
				IF @matricula IS NOT null
					SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(nvarchar(25), @matricula)
			END
		print(@sentencia)
		exec sp_executesql @sentencia	
	END
GO
-- EJEMPLO: exec estudiosPorOossYMedico 'Osde', null , 1

-- 9)
CREATE PROCEDURE 
	(@nombreOoss NVARCHAR(100) = null, @nombrePlan NVARCHAR(100) = null, @matricula int = null)
	AS
	BEGIN
		DECLARE @sentencia nvarchar(1000)
		SET @sentencia = 

												
