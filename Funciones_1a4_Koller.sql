--Ejer 1
CREATE FUNCTION edadPaciente
	(@fechaNacimiento AS DATE)
RETURNS INT
AS
BEGIN
	RETURN
		DATEDIFF(YYYY, @fechaNacimiento, GETDATE())
END
go

--Ejer 2
CREATE FUNCTION preciosEstudio
	(@nombreEstudio VARCHAR(50))
RETURNS @preciosEstudio TABLE(mayorPrecio FLOAT, menorPrecio FLOAT, precioPromedio FLOAT)
AS
BEGIN
		DECLARE @mayor FLOAT
		DECLARE @menor FLOAT
		DECLARE @prom FLOAT
		SELECT @prom = AVG(precio) FROM precios 
			INNER JOIN estudios ON precios.idestudio = estudios.idestudio
			WHERE estudio = @nombreEstudio 
		SELECT @mayor = MAX(precio)FROM precios 
			INNER JOIN estudios ON precios.idestudio = estudios.idestudio
			WHERE estudio = @nombreEstudio
		SELECT @menor = MIN(precio)FROM precios 
			INNER JOIN estudios ON precios.idestudio = estudios.idestudio
			WHERE estudio = @nombreEstudio
		INSERT INTO @preciosEstudio VALUES (@mayor, @menor, @prom)
		RETURN
END
GO

--Ejer 3
CREATE FUNCTION tablaInfoAlfa
()
RETURNS @tablaFinal TABLE(ooss VARCHAR(50), especialidades VARCHAR(50), institutos VARCHAR(50), estudios VARCHAR(50))
as
	BEGIN
		INSERT INTO @tablaFinal (ooss) SELECT nombre FROM ooss ORDER BY nombre ASC
		INSERT INTO @tablaFinal (especialidades) SELECT especialidad FROM especialidades ORDER BY especialidad ASC
		INSERT INTO @tablaFinal (institutos) SELECT instituto FROM institutos ORDER BY instituto ASC
		INSERT INTO @tablaFinal (estudios) SELECT estudio FROM estudios ORDER BY estudio ASC
		RETURN
	END
GO

--Ejer 4
CREATE FUNCTION instMasEspe
	(@nombreEspecialidad VARCHAR(50), @cantInst INT)
RETURNS @tablaFinal TABLE (instituto VARCHAR(50))
as
	BEGIN
		DECLARE @idespecialidad VARCHAR(50)
		SELECT @idespecialidad = @idespecialidad FROM especialidades WHERE especialidad = @nombreEspecialidad
		INSERT INTO @tablaFinal SELECT TOP(@cantInst) inst.instituto from especialidades espes 
		INNER JOIN estuespe ON estuespe.idespecialidad = espes.idespecialidad
		INNER JOIN estudios estu ON estu.idestudio = estuespe.idestudio
		INNER JOIN historias hist ON hist.idestudio = estu.idestudio
		INNER JOIN institutos inst ON inst.idinstituto = hist.idinstituto
		where espes.idespecialidad = @idespecialidad
		GROUP BY inst.instituto 
		ORDER BY hist.idinstituto DESC 
		RETURN
	END
go

--Ejer 5
CREATE FUNCTION estudiosNoRealizados
	(@dias INT)
RETURNS @tablaFinal TABLE (idestudio INT, nombreEstudio VARCHAR(50))
AS
	BEGIN
		INSERT INTO @tablaFinal (idestudio, nombreEstudio)
			SELECT historias.idestudio, estudio FROM historias 
				INNER JOIN estudios ON historias.idestudio = estudios.idestudio
				WHERE fecha BETWEEN DATEADD(d, -@dias, GETDATE()) AND GETDATE()
		RETURN
	END
GO