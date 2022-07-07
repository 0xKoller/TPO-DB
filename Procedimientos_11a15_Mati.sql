--Ejer 11
SET DATEFORMAT DMY
GO

CREATE PROC sp_PrecioTotalAFacturar
	(@nombreOS VARCHAR(100), @fechaIni DATE, @fechaFin DATE)
AS
BEGIN
	SELECT SUM(P.precio) 'Total a Facturar',COUNT(H.idestudio) 'Cantidad de Estudios' FROM precios P 
	INNER JOIN historias H ON P.idestudio=H.idestudio AND P.idinstituto=H.idinstituto
	INNER JOIN ooss OS ON H.sigla=OS.sigla
	WHERE OS.nombre=@nombreOS AND H.fecha BETWEEN @fechaIni AND @fechaFin
END
GO

EXEC sp_PrecioTotalAFacturar 'Osde', '25-06-2022', '05-07-2022'
GO

SET DATEFORMAT DMY
GO
--Ejer 12
CREATE PROC sp_PagoPacienteMoroso
	(@dniPaciente INT,@nombreEstudio VARCHAR(100),@fechaEstudio DATE, @punitorio FLOAT)
AS
BEGIN
	DECLARE @punitorioDiario FLOAT
	DECLARE @punitarioCorrespondiente FLOAT

	SET @punitorioDiario = (@punitorio / 30)
	SET @punitarioCorrespondiente = @punitorioDiario  * (DATEDIFF(DAY,@fechaEstudio,GETDATE()))

	SELECT (F.precio/@punitarioCorrespondiente) 'Precio con Punitorio' FROM (SELECT P.precio FROM precios P
			INNER JOIN estudios E ON P.idestudio=E.idestudio
			INNER JOIN historias H ON E.idestudio=H.idestudio
			WHERE (H.fecha BETWEEN @fechaEstudio AND GETDATE())
			AND E.estudio=@nombreEstudio AND H.dni=@dniPaciente) F

END
GO

EXEC sp_PagoPacienteMoroso 4,'Tomografia','30-06-2022',4.50
GO

--Ejer 13
CREATE PROC sp_PreciosMinMax
	(@siglaOS VARCHAR(100))
AS
BEGIN
	SELECT H.sigla 'Obra Social',MIN(P.precio) 'Precio Minimo' FROM precios P 
		INNER JOIN historias H ON P.idestudio=H.idestudio
		WHERE H.sigla=@siglaOS
		GROUP BY H.sigla

	SELECT H.sigla 'Obra Social',MAX(P.precio) 'Precio Maximo' FROM precios P 
		INNER JOIN historias H ON P.idestudio=H.idestudio
		WHERE H.sigla=@siglaOS
		GROUP BY H.sigla
END
GO

exec sp_PreciosMinMax 'OSDE'
GO

--Ejer 14 NI IDEEAAA 
CREATE PROC sp_CombinatoriaMedicos
	(@enteroN INT)
AS
BEGIN
	DECLARE @combinatoria INT,@factorialM INT,@factorialN INT, @enteroM INT, @restaEnteros INT,@factorialRestaEnteros INT
	SET @combinatoria = 0
	SET @factorialM = 1
	SET @factorialN = 1
	SET @factorialRestaEnteros = 1

	SET @enteroM = (SELECT COUNT(matricula) CantidadMedicos FROM medicos)
	SET @restaEnteros = @enteroM - @enteroN

	WHILE @enteroN > 0 
		BEGIN
			SET @factorialN = @factorialN*@enteroN
			SET @enteroN = @enteroN - 1
		END
	WHILE @enteroM > 0 
		BEGIN
			SET @factorialM = @factorialM*@enteroM
			SET @enteroM = @enteroM - 1
		END
	WHILE @restaEnteros > 0 
		BEGIN
			SET @factorialRestaEnteros = @factorialRestaEnteros*@restaEnteros
			SET @restaEnteros = @restaEnteros - 1
		END
	SET @combinatoria = @factorialM / (@factorialN * @factorialRestaEnteros)
	SELECT @combinatoria AS 'Combinatoria'
END
GO

EXEC sp_CombinatoriaMedicos 4
GO


--Ejer 15 
CREATE PROC sp_PacMed_Estudios
	(@mes INT, @año INT)
AS
BEGIN
	SELECT COUNT(H.dni) 'Cantidad de Pacientes', COUNT(H.matricula) 'Cantidad de Medicos' FROM historias H
	WHERE (H.fecha BETWEEN CONCAT('01-',@mes,'-',@año) AND CONCAT('30-',@mes,'-',@año))
END
GO

EXEC sp_PacMed_Estudios 6,2022
GO