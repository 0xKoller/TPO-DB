-- 6) 
CREATE FUNCTION cantidadEstudios
	(@cantidadMinima int, @fechaInicio date, @fechaFin date)
RETURNS TABLE 
AS
RETURN
	(SELECT dni, idEstudio, COUNT(idEstudio) cantidadEstudio FROM Historias
		WHERE fecha BETWEEN @fechaInicio and @fechaFin
		GROUP BY dni,idEstudio
		HAVING COUNT(idEstudio) > @cantidadMinima)		

go

-- 7) 
CREATE FUNCTION medicosQueRepitenEstudios
	(@cantidadDias int)
RETURNS TABLE
AS
RETURN
	SELECT matricula 
		FROM
			(SELECT matricula, dni, idestudio, count(idEstudio) cant
				FROM Historias
				WHERE fecha > DATEADD(DAY, -@cantidadDias, GetDate())
				GROUP BY matricula,dni,idEstudio
				HAVING count(idEstudio) > 1) tabla
GO

SELECT * FROM HISTORIAS