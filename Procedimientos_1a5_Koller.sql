--Ejer 1
CREATE PROCEDURE updatePrecioEstudio
	(@nombreEstudio VARCHAR(50), @nombreInstituto VARCHAR(50), @precioNuevo float) 
	AS
	BEGIN
		DECLARE @idEstudio INT
		DECLARE @idInstituto INT
		DECLARE @idEstudioNuevo INT
		DECLARE @idInstitutoNuevo INT
		IF exists (SELECT instituto, estudio FROM institutos
					INNER JOIN precios on institutos.idinstituto = precios.idinstituto
					INNER JOIN estudios on estudios.idestudio = precios.idestudio
					WHERE estudio = @nombreEstudio or instituto = @nombreInstituto)
			BEGIN
				
				IF exists (SELECT precio FROM precios 
						INNER JOIN institutos on institutos.idinstituto = precios.idinstituto
						INNER JOIN estudios on estudios.idestudio = precios.idestudio)
					BEGIN
					SELECT @idEstudio = idestudio FROM estudios 
					WHERE estudio= @nombreEstudio
					SELECT @idInstituto = idinstituto FROM institutos
					WHERE instituto = @nombreInstituto
					update precios SET precio=@precioNuevo WHERE idestudio=@idEstudio AND idinstituto=@idInstituto
					END
				
			END
		else
			BEGIN
				SELECT @idEstudio = estudios.idestudio FROM estudios 
				INNER JOIN (SELECT max(idestudio) AS idestudio FROM estudios) Tabla ON estudios.idestudio = Tabla.idestudio
				SELECT @idInstituto = institutos.idinstituto FROM institutos
				INNER JOIN (SELECT max(idinstituto) AS idinstituto FROM institutos) Tabla ON institutos.idinstituto = Tabla.idinstituto
				SET @idEstudioNuevo = sum(1+@idEstudio)
				SET @idInstitutoNuevo = sum(1+@idInstituto)
				INSERT estudios values (@idEstudioNuevo, @nombreEstudio, 1)
				INSERT institutos values (@idInstitutoNuevo, @nombreInstituto, 1)
				INSERT precios values (@idEstudioNuevo,@idInstitutoNuevo,@precioNuevo)
			END
			
	END
GO

exec updatePrecioEstudio Radiografia, Policlinico, 99999
go

--Ejer 2
CREATE PROCEDURE estudiosProgramados
	(@nombreEstudio varchar(50), @dniPaciente INT, @matriculaMedico INT, @nombreInstituto varchar(50),
	@siglaOOSS varchar(10), @cantEstudios INT, @franjaDias INT)
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
					DECLARE @currentDate date = getDate()
					WHILE @i < @cantEstudios 
						BEGIN
							SET @i = @i + 1
							INSERT historias values (@dniPaciente, @idEstudio, @idInstituto, @currentDate, @matriculaMedico, @siglaOOSS)
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

--Ejer 3
CREATE PROCEDURE ingresarAfiliado
	(@dniPaciente INT, @siglaOOSS varchar(50), @nroPlan INT, @nroAfiliado INT)
	AS
	BEGIN
		IF EXISTS (SELECT dni, sigla, nroplan, nroafiliado FROM afiliados 
		WHERE dni=@dniPaciente AND sigla=@siglaOOSS)
		BEGIN
			update afiliados SET nroplan=@nroPlan, nroafiliado=@nroAfiliado 
			WHERE dni=@dniPaciente AND sigla=@siglaOOSS
		END
		ELSE
		BEGIN
			INSERT afiliados values (@dniPaciente, @siglaOOSS, @nroPlan, @nroAfiliado)
		END
	END
GO

exec ingresarAfiliado 41436383, MEDI, 1, 25
exec ingresarAfiliado 1, MEDI, 1, 5
GO

--Ejer 4
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
exec estudiosMY 12, 3040
exec estudiosMY 06, 2022
go

--Ejer 5
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

exec pacienteEdad 20, 35
exec pacienteEdad 0, 5
go