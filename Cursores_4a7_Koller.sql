-- 4)
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

-- 5)
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

-- 6)
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


-- 7)
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

