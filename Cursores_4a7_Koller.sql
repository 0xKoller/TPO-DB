
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

-- 4)
DECLARE estudiosPorMedico CURSOR FOR
	SELECT med.nombre, med.matricula, estudio, fecha, paci.nombre
		FROM medicos med 
			INNER JOIN historias hist ON hist.matricula = med.matricula
			INNER JOIN pacientes paci ON hist.dni = paci.dni
			INNER JOIN estudios estu ON hist.idestudio = estu.idestudio
DECLARE @medNombre VARCHAR(50), @medMatri INT, @estudio VARCHAR(50), @fecha DATE, @paciNombre VARCHAR(50)
DECLARE @matriAnt INT, @cantEstudiosPorMed INT
--Canttidad del estudio ??
SET @matriAnt = 0
OPEN estudiosPorMedico
FETCH estudiosPorMedico INTO @medNombre, @medMatri, @estudio, @fecha, @paciNombre
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF @medMatri <> @matriAnt
			BEGIN
				PRINT(' '+CONVERT(VARCHAR(10), @cantEstudiosPorMed)) -- Esto no funciona nose porque
				PRINT(CONVERT(VARCHAR(10), @medMatri)+' '+@medNombre)
			END
		PRINT('	'+@estudio)
		PRINT('		'+CONVERT(VARCHAR(20),@fecha)+' '+@paciNombre)
		SET @cantEstudiosPorMed = @cantEstudiosPorMed + 1
		SET @matriAnt = @medMatri
		FETCH estudiosPorMedico INTO @medNombre, @medMatri, @estudio, @fecha, @paciNombre
	END
CLOSE estudiosPorMedico
DEALLOCATE estudiosPorMedico