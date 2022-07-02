CREATE PROCEDURE updatePrecioEstudio
	(@nombreEstudio VARCHAR(50), @nombreInstituto VARCHAR(50), @precioNuevo float) 
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