-- 1
SET DATEFORMAT DMY
go

CREATE PROCEDURE updatePrecioEstudio
	(@nombreEstudio VARCHAR(50), @nombreInstituto VARCHAR(50), @precioNuevo float) 
	AS
	BEGIN
		DECLARE @idEstudio INT
		DECLARE @idInstituto INT
		DECLARE @idEstudioNuevo INT
		DECLARE @idInstitutoNuevo INT
		IF EXISTS (SELECT instituto, estudio FROM institutos
					INNER JOIN precios ON institutos.idinstituto = precios.idinstituto
					INNER JOIN estudios ON estudios.idestudio = precios.idestudio
					WHERE estudio = @nombreEstudio OR instituto = @nombreInstituto)
			BEGIN
				
				IF EXISTS (SELECT precio FROM precios 
						INNER JOIN institutos ON institutos.idinstituto = precios.idinstituto
						INNER JOIN estudios ON estudios.idestudio = precios.idestudio)
					BEGIN
					SELECT @idEstudio = idestudio FROM estudios 
					WHERE estudio= @nombreEstudio
					SELECT @idInstituto = idinstituto FROM institutos
					WHERE instituto = @nombreInstituto
					update precios SET precio=@precioNuevo WHERE idestudio=@idEstudio AND idinstituto=@idInstituto
					END
			END
		ELSE
			BEGIN
				SELECT @idEstudio = estudios.idestudio FROM estudios 
				INNER JOIN (SELECT MAX(idestudio) AS idestudio FROM estudios) Tabla ON estudios.idestudio = Tabla.idestudio
				SELECT @idInstituto = institutos.idinstituto FROM institutos
				INNER JOIN (SELECT MAX(idinstituto) AS idinstituto FROM institutos) Tabla ON institutos.idinstituto = Tabla.idinstituto
				SET @idEstudioNuevo = SUM(1+@idEstudio)
				SET @idInstitutoNuevo = SUM(1+@idInstituto)
				INSERT estudios VALUES (@idEstudioNuevo, @nombreEstudio, 1)
				INSERT institutos VALUES (@idInstitutoNuevo, @nombreInstituto, 1)
				INSERT precios VALUES (@idEstudioNuevo,@idInstitutoNuevo,@precioNuevo)
			END
			
	END
GO

-- 2
CREATE PROCEDURE estudiosProgramados
	(@nombreEstudio VARCHAR(50), @dniPaciente INT, @matriculaMedico INT, @nombreInstituto VARCHAR(50),
	@siglaOOSS VARCHAR(10), @cantEstudios INT, @franjaDias INT)
AS
	BEGIN
		IF @franjaDias > @cantEstudios
			BEGIN
				IF EXISTS (SELECT matricula FROM medicos WHERE matricula = @matriculaMedico) 
				AND EXISTS (SELECT instituto FROM institutos WHERE instituto = @nombreInstituto)
				AND EXISTS (SELECT estudio FROM estudios WHERE estudio = @nombreEstudio)
				AND EXISTS (SELECT sigla FROM ooss WHERE sigla = @siglaOOSS)
				AND EXISTS (SELECT dni FROM pacientes WHERE dni = @dniPaciente)
				BEGIN
					DECLARE @idEstudio INT
					DECLARE @idInstituto INT
					SELECT @idEstudio = idestudio FROM estudios WHERE estudio = @nombreEstudio
					SELECT @idInstituto = idinstituto FROM institutos WHERE instituto = @nombreInstituto
					DECLARE @i INT = 0
					DECLARE @currentDate DATE = GETDATE()
					WHILE @i < @cantEstudios 
						BEGIN
							SET @i = @i + 1
							INSERT historias VALUES (@dniPaciente, @idEstudio, @idInstituto, @currentDate, @matriculaMedico, @siglaOOSS)
							SET @currentDate = DATEADD(d,1,@currentDate)
						END
				END
			END
		ELSE
			BEGIN
				PRINT('Solo se permite 1 estudio por dia, por favor ingrese una mayor franja de dias.')
			END
	END
GO

-- 3
CREATE PROCEDURE ingresarAfiliado
	(@dniPaciente INT, @siglaOOSS VARCHAR(50), @nroPlan INT, @nroAfiliado INT)
	AS
	BEGIN
		IF EXISTS (SELECT dni, sigla, nroplan, nroafiliado FROM afiliados 
		WHERE dni=@dniPaciente AND sigla=@siglaOOSS)
		BEGIN
			UPDATE afiliados SET nroplan=@nroPlan, nroafiliado=@nroAfiliado 
			WHERE dni=@dniPaciente AND sigla=@siglaOOSS
		END
		ELSE
		BEGIN
			INSERT afiliados values (@dniPaciente, @siglaOOSS, @nroPlan, @nroAfiliado)
		END
	END
GO

-- 4
CREATE PROCEDURE estudiosMY
	(@month INT, @year INT)
	AS
	BEGIN
		IF EXISTS (SELECT * FROM historias WHERE MONTH(fecha)=@month AND YEAR(fecha)=@year)
			BEGIN
				SELECT * FROM historias WHERE MONTH(fecha)=@month AND YEAR(fecha)=@year
			END
		ELSE
			BEGIN
				PRINT('No se encuentran estudio realizados para la fecha ingresada.')
			END
	END
GO

-- 5
CREATE PROCEDURE pacienteEdad
	(@min INT, @max INT)
	AS
	BEGIN
		IF EXISTS (SELECT * FROM pacientes WHERE DATEDIFF(YY, nacimiento, GETDATE()) BETWEEN @min AND @max)
			BEGIN
				SELECT *,DATEDIFF(YY, nacimiento, GETDATE()) AS Edad  FROM pacientes WHERE DATEDIFF(YY, nacimiento, GETDATE()) BETWEEN @min AND @max
			END
		ELSE
			BEGIN
				PRINT('No existen pacientes en el rango de edad seleccionado.')
			END
	END
GO

-- 6 
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


-- 7
CREATE PROCEDURE proyectaEstudiosCubiertosPorOoss
	(@nombreOoss VARCHAR(50), @nombrePlan VARCHAR(50) = null) 
	AS
	BEGIN
		IF @nombrePlan IS NOT NULL
			SELECT est.estudio, cob.cobertura, pla.nombre 
				FROM estudios est
					INNER JOIN coberturas cob ON est.idestudio = cob.idestudio
					INNER JOIN (SELECT * FROM Planes WHERE nombre = @nombrePlan) pla ON cob.nroplan = pla.nroplan AND cob.sigla = pla.sigla
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



-- 8	
CREATE PROCEDURE estudiosPorOossYMedico
	(@nombreOoss NVARCHAR(100) = null, @nombrePlan NVARCHAR(100) = null, @matricula INT = null)
	AS
	BEGIN
		DECLARE @sentencia NVARCHAR(1000)
		SET @sentencia = 
			'SELECT COUNT(idEstudio) as CantidadEstudios
				FROM historias his
					INNER JOIN afiliados afi on his.dni = afi.dni and his.sigla = afi.sigla
					INNER JOIN planes pla on afi.sigla = pla.sigla and afi.nroplan = pla.nroPlan '
		IF @nombreOoss IS NOT null
			BEGIN
				SET @sentencia = @sentencia + 'WHERE his.sigla = (SELECT sigla FROM ooss WHERE nombre = ''' + @nombreOoss + ''')'
				IF @nombrePlan IS NOT NULL 
					BEGIN
						SET @sentencia = @sentencia + ' AND pla.nombre = ''' + @nombrePlan + ''''
					END
				IF @matricula IS NOT NULL 
					BEGIN
						SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(NVARCHAR(25), @matricula)
					END
			END
		ELSE
			BEGIN
			IF @nombrePlan IS NOT NULL  
				BEGIN
					SET @sentencia = @sentencia + 'WHERE pla.nombre = ''' + @nombrePlan + ''''
					IF @matricula IS NOT NULL 
						BEGIN
							SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(NVARCHAR(25), @matricula) 
						END
				END
			ELSE
				BEGIN
					IF @matricula IS NOT NULL 
						BEGIN
							SET @sentencia = @sentencia + ' AND matricula = ' + CONVERT(NVARCHAR(25), @matricula)
						END
				END
			END
		print(@sentencia)
		exec sp_executesql @sentencia	
	END
GO

-- 9
CREATE PROCEDURE nPacientesMasViejosConPatronApellido
	(@cantidad INT, @patron VARCHAR(100) = NULL)
	AS
	BEGIN 	
		IF @patron IS NULL
			BEGIN
				SELECT dni, nacimiento, nombre, apellido FROM pacientes pac
					ORDER BY YEAR(nacimiento) ASC
					OFFSET 0 ROWS
					FETCH FIRST @cantidad ROWS ONLY 
			END
		ELSE
			BEGIN
				DECLARE @patronConvertido VARCHAR(110)
				SET @patronConvertido = '%' + @patron + '%'
				SELECT dni, nacimiento, nombre, apellido FROM pacientes pac
					WHERE apellido LIKE @patronConvertido
					ORDER BY YEAR(nacimiento) ASC
					OFFSET 0 ROWS
					FETCH FIRST @cantidad ROWS ONLY
			END
	END
GO									

-- 10
CREATE PROCEDURE precioLiquidarPorInstituto
	(@nombreIns varchar(100), @fechaInicio date, @fechaFin date)
	AS
	BEGIN
		SELECT SUM(precio) AS PrecioALiquidar
			FROM HISTORIAS his
			INNER JOIN precios pre ON his.idestudio = pre.idestudio AND his.idinstituto = pre.idinstituto
			WHERE (fecha BETWEEN @fechaInicio AND @fechaFin) 
				and his.idInstituto = (SELECT idInstituto FROM Institutos WHERE instituto = @nombreIns) 
	END

GO

-- 11
CREATE PROCEDURE sp_PrecioTotalAFacturar
	(@nombreOS VARCHAR(100), @fechaIni DATE, @fechaFin DATE)
AS
	BEGIN
		SELECT SUM(P.precio) 'Total a Facturar',COUNT(H.idestudio) 'Cantidad de Estudios' FROM precios P 
		INNER JOIN historias H ON P.idestudio=H.idestudio AND P.idinstituto=H.idinstituto
		INNER JOIN ooss OS ON H.sigla=OS.sigla
		WHERE OS.nombre=@nombreOS AND H.fecha BETWEEN @fechaIni AND @fechaFin
	END
GO


-- 12
CREATE PROCEDURE sp_PagoPacienteMoroso
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

-- 13
CREATE PROCEDURE sp_PreciosMinMax
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


-- 14
CREATE PROCEDURE sp_CombinatoriaMedicos
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

-- 15 
CREATE PROCEDURE sp_PacMed_Estudios
	(@mes INT, @año INT)
AS
	BEGIN
		SELECT COUNT(H.dni) 'Cantidad de Pacientes', COUNT(H.matricula) 'Cantidad de Medicos' 
		FROM historias H WHERE (H.fecha BETWEEN CONCAT('01-',@mes,'-',@año) AND CONCAT('30-',@mes,'-',@año))
	END
GO
