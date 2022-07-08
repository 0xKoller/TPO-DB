-- 1
CREATE FUNCTION edadPaciente
	(@fechaNacimiento AS DATE)
RETURNS INT
AS
	BEGIN
		RETURN
			DATEDIFF(YYYY, @fechaNacimiento, GETDATE())
	END
go

-- 2
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

-- 3
CREATE FUNCTION tablaInfoAlfa
()
RETURNS @tablaFinal TABLE(ooss VARCHAR(50), especialidades VARCHAR(50), institutos VARCHAR(50), estudios VARCHAR(50))
AS
	BEGIN
		INSERT INTO @tablaFinal (ooss) SELECT nombre FROM ooss ORDER BY nombre ASC
		INSERT INTO @tablaFinal (especialidades) SELECT especialidad FROM especialidades ORDER BY especialidad ASC
		INSERT INTO @tablaFinal (institutos) SELECT instituto FROM institutos ORDER BY instituto ASC
		INSERT INTO @tablaFinal (estudios) SELECT estudio FROM estudios ORDER BY estudio ASC
		RETURN
	END
GO

-- 4
CREATE FUNCTION instMasEspe
	(@nombreEspecialidad VARCHAR(50), @cantInst INT)
RETURNS @tablaFinal TABLE (instituto VARCHAR(50))
AS
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

-- 5
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

-- 6 
CREATE FUNCTION cantidadEstudios
	(@cantidadMinima int, @fechaInicio date, @fechaFin date)
RETURNS TABLE 
AS
RETURN
	(SELECT dni, idEstudio, COUNT(idEstudio) cantidadEstudio FROM Historias
		WHERE fecha BETWEEN @fechaInicio and @fechaFin
		GROUP BY dni,idEstudio
		HAVING COUNT(idEstudio) > @cantidadMinima)		

GO

-- 7
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

-- 8 
CREATE FUNCTION cadenaInicialEnMayus
	(@stringInicial varchar(400))
	RETURNS varchar(400)
AS
BEGIN
	DECLARE @index INT,	@stringResultante VARCHAR(200)
	SET @index = 1
	SET @stringResultante = ''
	WHILE (@index <LEN(@stringInicial)+1)
		BEGIN
			IF (@index = 1)
				BEGIN
					SET @stringResultante =	@stringResultante + UPPER(SUBSTRING(@stringInicial, @index, 1))
					SET @index = @index+ 1
				END
			ELSE IF ((SUBSTRING(@stringInicial, @index-1, 1) =' ') and @index+1 <> LEN(@stringInicial))
				BEGIN
					SET @stringResultante = @stringResultante + UPPER(SUBSTRING(@stringInicial,@index, 1))
					SET	@index = @index +1
				END
			ELSE
				BEGIN				
					SET @stringResultante = @stringResultante + LOWER(SUBSTRING(@stringInicial,@index, 1))
					SET @index = @index +1
				END
		END
	RETURN @stringResultante
END
GO

-- 9 
CREATE FUNCTION OSenEstudios
	(@nombreEstudio varchar(100))
	RETURNS TABLE
AS
RETURN
	(SELECT OS.nombre, OS.categoria FROM historias H
	INNER JOIN estudios Est ON H.idestudio=Est.idestudio
	INNER JOIN coberturas Cob ON Est.idestudio=Cob.idestudio
	INNER JOIN ooss OS ON Cob.sigla=OS.sigla
	INNER JOIN planes P ON OS.sigla=P.sigla
	WHERE Est.estudio=@nombreEstudio 
		AND H.idinstituto = ANY(SELECT idinstituto FROM historias)
		AND P.nroplan = ALL(SELECT coberturas.nroplan FROM coberturas WHERE OS.sigla=Cob.sigla)
	GROUP BY OS.nombre,OS.categoria
	)
GO

-- 10
CREATE FUNCTION CantEstudiosEInstitutos
	(@sigla varchar(100))
	RETURNS TABLE
AS
RETURN
	(SELECT OS.nombre,Est.estudio,COUNT(H.idestudio) CantEstudios,Ins.instituto, COUNT(H.idinstituto) CantInstitutos FROM historias H
	INNER JOIN ooss OS ON H.sigla=OS.sigla INNER JOIN estudios Est ON H.idestudio=Est.idestudio
	INNER JOIN institutos Ins ON H.idinstituto=Ins.idinstituto WHERE OS.sigla=@sigla
	GROUP BY OS.nombre,Est.estudio,Ins.instituto)
GO

