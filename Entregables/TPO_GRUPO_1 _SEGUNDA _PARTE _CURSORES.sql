-- 1 
DECLARE fichaPacientes CURSOR FOR 
	SELECT pac.dni, pac.nombre nombrePaciente, pac.apellido apellidoPaciente,  med.matricula, med.apellido apellidoMedico, est.estudio, ins.instituto 
		FROM Historias his
			INNER JOIN Pacientes pac on his.dni = pac.dni
			INNER JOIN Medicos med on his.matricula = med.matricula
			INNER JOIN Estudios est on his.idEstudio = est.idEstudio
			INNER JOIN Institutos ins on his.idinstituto = ins.idinstituto
			ORDER BY pac.nombre, matricula

declare @dni int, @nombrePac varchar(100), @apellidoPac varchar(100), @matricula int, @apellidoMed varchar(100), @estudio varchar(100), @instituto varchar(100) 
declare @dniAnt varchar(100), @matriculaAnt varchar(100)
SET @dniAnt = 0
SET @matriculaAnt = 0
OPEN fichaPacientes
FETCH fichaPacientes INTO @dni, @nombrePac, @apellidoPac, @matricula, @apellidoMed, @estudio, @instituto
WHILE @@FETCH_STATUS = 0
	BEGIN
		if @dni <> @dniAnt
			BEGIN print(CONVERT(varchar(100), @dni)+ ' ' + @nombrePac + ' ' + @apellidoPac) END
		if @matricula <> @matriculaAnt or @dni <> @dniAnt
			BEGIN print('	'+ CONVERT(varchar(100), @matricula) + ' '+ @apellidoMed) END
		print('		' + @estudio + ' ' + @instituto)
	
		SET @dniAnt = @dni
		SET @matriculaAnt = @matricula

		FETCH fichaPacientes INTO @dni, @nombrePac, @apellidoPac, @matricula, @apellidoMed, @estudio, @instituto 
	END
CLOSE fichaPacientes
DEALLOCATE fichaPacientes
GO

-- 2
DECLARE planesEstudios CURSOR FOR
	SELECT estudio, oos.nombre, pla.nombre, cobertura FROM coberturas cob
		INNER JOIN estudios est on cob.idEstudio = est.idestudio
		INNER JOIN planes pla on cob.nroplan = pla.nroplan and cob.sigla = pla.sigla
		INNER JOIN ooss oos on cob.sigla = oos.sigla
		ORDER BY cob.idEstudio, cob.sigla, cob.nroPlan, cobertura desc

DECLARE @estudio varchar(100), @nombreObra varchar(100), @nombrePlan varchar(100), @cobertura float, @estudioAnt varchar(100), @oosAnt varchar(100)
SET @estudioAnt = ''
SET @oosAnt = ''

OPEN planesEstudios

FETCH planesEstudios INTO @estudio, @nombreObra, @nombrePlan, @cobertura
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @estudio <> @estudioAnt
			BEGIN print(@estudio) END	
		IF @nombreObra <> @oosAnt or @estudio <> @estudioAnt
			BEGIN print('	'+@nombreObra) END 
		print('		'+@nombrePlan + ' ' + CONVERT(varchar(20), @cobertura))

		SET @estudioAnt = @estudio
		SET @oosAnt = @nombreObra

		FETCH planesEstudios INTO @estudio, @nombreObra, @nombrePlan, @cobertura
	END
CLOSE planesEstudios
DEALLOCATE planesEstudios
GO

-- 3
DECLARE estudiosPorInstitutos CURSOR FOR 
	SELECT pac.dni, nombre, apellido, instituto, cantEstudios
		FROM	
			(SELECT dni,idInstituto, COUNT(idEstudio) cantEstudios
				FROM Historias 
				GROUP BY dni,idInstituto) tab
		INNER JOIN pacientes pac on tab.dni = pac.dni
		INNER JOIN institutos ins on tab.idInstituto = ins.idInstituto
		ORDER BY pac.dni

DECLARE @dni int, @nombre varchar(100), @apellido varchar(100), @instituto varchar(100), @cantEstudios varchar(100)
DECLARE @dniAnt int, @cantEstudiosPac int
SET @dniAnt = 0

OPEN estudiosPorInstitutos

FETCH estudiosPorInstitutos into @dni, @nombre, @apellido, @instituto, @cantEstudios
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @dni <> @dniAnt
			BEGIN
				PRINT('	'+CONVERT(VARCHAR(10), @cantEstudiosPac))
				PRINT(CONVERT(VARCHAR(10), @dni)+' '+@nombre+' '+@apellido) 
				SET @cantEstudiosPac = 0
			END
		print('	'+@instituto + ' '+ CONVERT(VARCHAR(10), @cantEstudios))
		SET @cantEstudiosPac = @cantEstudiosPac + @cantEstudios
		SET @dniAnt = @dni
		FETCH estudiosPorInstitutos into @dni, @nombre, @apellido, @instituto, @cantEstudios
	END
CLOSE estudiosPorInstitutos
DEALLOCATE estudiosPorInstitutos
GO

-- 4
DECLARE estudiosPorMedico CURSOR FOR
	SELECT med.nombre, med.matricula, estudio, fecha, paci.nombre
		FROM medicos med 
			INNER JOIN historias hist ON hist.matricula = med.matricula
			INNER JOIN pacientes paci ON hist.dni = paci.dni
			INNER JOIN estudios estu ON hist.idestudio = estu.idestudio
DECLARE @medNombre VARCHAR(50), @medMatri INT, @estudio VARCHAR(50), @fecha DATE, @paciNombre VARCHAR(50)
DECLARE @matriAnt INT, @cantEstudiosPorMed INT, @cantMismoEstudio INT, @estuAnt VARCHAR(50)
SET @matriAnt = 0

OPEN estudiosPorMedico

FETCH estudiosPorMedico INTO @medNombre, @medMatri, @estudio, @fecha, @paciNombre
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @medMatri <> @matriAnt
			BEGIN
				PRINT('	'+CONVERT(VARCHAR(10), @cantEstudiosPorMed))
				SET @cantEstudiosPorMed = 0
				SET @estuAnt = @estudio
				PRINT(CONVERT(VARCHAR(10), @medMatri)+' '+@medNombre)
				PRINT('	'+@estudio)
			END
		IF @estudio <> @estuAnt
			BEGIN
				PRINT('		'+CONVERT(VARCHAR(20), @cantMismoEstudio))
				SET @cantMismoEstudio = 0
			END
		PRINT('		'+CONVERT(VARCHAR(20),@fecha)+' '+@paciNombre)
		SET @cantEstudiosPorMed = @cantEstudiosPorMed + 1
		SET @cantMismoEstudio = @cantMismoEstudio + 1
		SET @matriAnt = @medMatri
		FETCH estudiosPorMedico INTO @medNombre, @medMatri, @estudio, @fecha, @paciNombre
	END
CLOSE estudiosPorMedico
DEALLOCATE estudiosPorMedico
GO

-- 5
CREATE PROCEDURE resumenMensualCursor
	(@nombreOOSS VARCHAR(20), @fechaLiquidar DATE)
	AS
	BEGIN
		DECLARE resumenMensual CURSOR FOR
			SELECT nombre,  instituto, estudio, precio, fecha
			FROM ooss os INNER JOIN historias his ON os.sigla = his.sigla 
			INNER JOIN institutos inst ON inst.idinstituto = his.idinstituto
			INNER JOIN estudios estu ON estu.idestudio = his.idestudio
			INNER JOIN precios prec ON prec.idestudio = his.idestudio
		DECLARE @OOSS VARCHAR(20),@instituto VARCHAR(20) , @estudio VARCHAR(20), @precio FLOAT, @fecha DATE
		DECLARE  @instAnt VARCHAR(20), @totalInst FLOAT, @totalOOSS FLOAT, @flag INT
		SET @instAnt = ''
		SET @totalOOSS = 0
		SET @flag = 0

		OPEN resumenMensual

		FETCH resumenMensual INTO @OOSS, @instituto, @estudio, @precio
		WHILE @@FETCH_STATUS = 0
		BEGIN
			IF @OOSS = @nombreOOSS
				BEGIN
					IF MONTH(@fechaLiquidar) = MONTH(@fecha) AND YEAR(@fechaLiquidar) = YEAR(@fecha)
						BEGIN
							BEGIN
								IF @flag = 0
									BEGIN
										PRINT(@OOSS)
									END
								IF @instituto <> @instAnt
									BEGIN
										PRINT(' '+@totalInst)
										PRINT('	'+@instituto)
										SET @totalInst = 0
									END
								ELSE
									BEGIN
										PRINT('		'+@estudio+'	'+@precio)
										SET @totalInst = @totalInst + @precio
										SET @totalOOSS = @totalOOSS + @precio
									END
							END
						END
				END
			FETCH resumenMensual INTO @OOSS, @instituto, @estudio, @precio
		END
		PRINT(@totalOOSS)
	END
CLOSE resumenMensualCursor
DEALLOCATE resumenMensualCursor
GO

-- 6
CREATE PROCEDURE refeCruzadaOOSSEstuCursor
	(@nombreOOSS VARCHAR(20))
	AS
	BEGIN
		DECLARE refCruzadaOOSSEstu CURSOR FOR
			SELECT os.nombre, pla.nroplan, estudio, count(pla.nroplan) as cantXPlan FROM historias his
				INNER JOIN afiliados af ON af.sigla = his.sigla
				INNER JOIN estudios est ON est.idestudio = his.idestudio
				INNER JOIN planes pla ON pla.nroplan = af.nroplan
				INNER JOIN ooss os ON os.sigla = his.sigla
				GROUP BY his.sigla,pla.nroplan, estudio, os.nombre
		DECLARE @OOSS VARCHAR(20), @nroPlan INT, @nombreEstudio VARCHAR(20), @cantXPlan INT
		DECLARE @tablaResultante TABLE (nroplan INT, estudio VARCHAR(20), cant INT)

		OPEN refCruzadaOOSSEstu

		FETCH refCruzadaOOSSEstu INTO @OOSS, @nroPlan, @nombreEstudio, @cantXPlan
		WHILE @@FETCH_STATUS = 0
			BEGIN
				IF @OOSS = @nombreOOSS
					INSERT @tablaResultante VALUES(@nroPlan, @nombreEstudio, @cantXPlan)
				FETCH refCruzadaOOSSEstu INTO @OOSS, @nroPlan, @nombreEstudio, @cantXPlan
			END	
		SELECT * FROM @tablaResultante
		CLOSE refCruzadaOOSSEstu
		DEALLOCATE refCruzadaOOSSEstu
	END
GO

-- 7
CREATE PROCEDURE refeCruzadaEstInstFechaCursos
	(@inicio DATE, @fin DATE)
	AS
	BEGIN
		DECLARE refeCruzadaEstInstFecha CURSOR FOR
			SELECT instituto, estudio, count(estudio) as CantEstu FROM historias his
			INNER JOIN institutos ins ON ins.idinstituto = his.idinstituto
			INNER JOIN estudios estu ON estu.idestudio = his.idestudio
			WHERE his.fecha BETWEEN @inicio and @fin
			GROUP BY instituto, estudio
		DECLARE @nomInsti VARCHAR(20), @nomEstu VARCHAR(20), @cantEstu INT
		DECLARE @tablaResultante TABLE (inst VARCHAR(20), estu VARCHAR(20), cant INT)

		OPEN refeCruzadaEstInstFecha

		FETCH refeCruzadaEstInstFecha INTO @nomInsti, @nomEstu, @cantEstu
		WHILE @@FETCH_STATUS = 0
			BEGIN
				INSERT @tablaResultante VALUES (@nomInsti, @nomEstu, @cantEstu)
				FETCH refeCruzadaEstInstFecha INTO @nomInsti, @nomEstu, @cantEstu
			END
		CLOSE refeCruzadaEstInstFecha
		DEALLOCATE refeCruzadaEstInstFecha
	END
GO

-- 8
CREATE PROC sp_definirCursorImporteMensual
	(@mesesAnteriores INT)
AS 
BEGIN
	DECLARE importeMensual CURSOR FOR
		SELECT P.precio,H.fecha,P.idinstituto 
		FROM precios P INNER JOIN historias H ON P.idinstituto=H.idinstituto
		WHERE H.fecha BETWEEN (DATEADD(month,-@mesesAnteriores,GETDATE())) AND GETDATE()
		GROUP BY P.idinstituto,P.precio,h.fecha
	
	DECLARE @precio INT,@fecha DATE, @idInstituto INT
	DECLARE @resultado TABLE (precio INT, fecha DATE, idInsti INT)
	
	OPEN importeMensual

	FETCH importeMensual INTO @precio,@fecha,@idInstituto
	WHILE @@FETCH_STATUS = 0
		BEGIN
			INSERT @resultado VALUES (@precio,@fecha,@idInstituto)
			FETCH importeMensual INTO @precio,@fecha,@idInstituto
		END
	CLOSE importeMensual
	DEALLOCATE importeMensual
END
GO

-- 9
DECLARE actualizarObservaciones CURSOR FOR
	SELECT H.dni,H.idinstituto,H.matricula,H.observaciones FROM historias H INNER JOIN pacientes P ON H.dni=P.dni

DECLARE @dni INT,@idInstituto INT,@matricula INT,@observaciones VARCHAR(100)
DECLARE @instiSegundo INT
SET @instiSegundo = 0

OPEN actualizarObservaciones

FETCH actualizarObservaciones INTO @dni,@idInstituto,@matricula,@observaciones
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@@ROWCOUNT = 2)
			BEGIN
				SET @instiSegundo = @idInstituto
				UPDATE historias
				SET @observaciones = 'Repetir estudio'
				PRINT(CONCAT(@dni,' ',@idInstituto,' ',@matricula,' ',@observaciones))
			END
		IF (@idInstituto <> @instiSegundo AND @matricula=3)
			BEGIN 
				UPDATE historias
				SET @observaciones = 'Diagnóstico no confirmado'
				PRINT(CONCAT(@dni,' ',@idInstituto,' ',@matricula,' ',@observaciones))
			END
		FETCH actualizarObservaciones INTO @dni,@idInstituto,@matricula,@observaciones
	END
CLOSE actualizarObservaciones
DEALLOCATE actualizarObservaciones
GO


-- 10
DECLARE actualizarPrecios CURSOR FOR
	SELECT P.precio,E.especialidad FROM precios P INNER JOIN estuespe EstuE ON P.idestudio=EstuE.idestudio
	INNER JOIN especialidades E ON EstuE.idespecialidad=E.idespecialidad
	INNER JOIN estudios Est ON EstuE.idestudio=Est.idestudio
	GROUP BY E.especialidad,P.precio

DECLARE @precio FLOAT,@especialidad VARCHAR(100)
DECLARE @aumento FLOAT, @especialidadUsada VARCHAR(100)
SET @aumento = 0.02

OPEN actualizarPrecios

FETCH actualizarPrecios INTO @precio,@especialidad
SET @especialidadUsada = @especialidad

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@especialidad)
		IF (@especialidad <> @especialidadUsada)
			BEGIN	
				SET @especialidadUsada = @especialidad
					PRINT(CONCAT('   Precio Original: ', @precio))
				SET @precio = @precio + @precio * @aumento
				UPDATE precios
				SET precio = @precio
				SET @aumento = @aumento + 0.02
					PRINT(CONCAT('   Aumento: ',@aumento*100,'%'))
					PRINT(CONCAT('   Precio Final: ',@precio))			
			END
		ELSE
			BEGIN
					PRINT(CONCAT('   Precio Original: ', @precio))
				SET @precio = @precio + @precio * @aumento
					PRINT(CONCAT('   Aumento: ',@aumento*100,'%'))
					PRINT(CONCAT('   Precio Final: ',@precio))
					PRINT('   ')
			END
		FETCH actualizarPrecios INTO @precio,@especialidad
	END
CLOSE actualizarPrecios
DEALLOCATE actualizarPrecios
GO