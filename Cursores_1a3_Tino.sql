-- 1) 
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

-- 2)
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

-- 3)
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

