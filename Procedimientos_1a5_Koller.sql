--Ejer 1
CREATE PROCEDURE updatePrecioEstudio
	(@nombreEstudio VARCHAR(50), @nombreInstituto VARCHAR(50), @precioNuevo float) 
	AS
	BEGIN
		declare @idEstudio int
		declare @idInstituto int
		declare @idEstudioNuevo int
		declare @idInstitutoNuevo int
		if exists (select instituto, estudio from institutos
					inner join precios on institutos.idinstituto = precios.idinstituto
					inner join estudios on estudios.idestudio = precios.idestudio
					where estudio = @nombreEstudio or instituto = @nombreInstituto)
			BEGIN
				
				if exists (select precio from precios 
						inner join institutos on institutos.idinstituto = precios.idinstituto
						inner join estudios on estudios.idestudio = precios.idestudio)
					BEGIN
					select @idEstudio = idestudio from estudios 
					where estudio= @nombreEstudio
					select @idInstituto = idinstituto from institutos
					where instituto = @nombreInstituto
					update precios set precio=@precioNuevo where idestudio=@idEstudio and idinstituto=@idInstituto
					END
				
			END
		else
			BEGIN
				select @idEstudio = estudios.idestudio from estudios 
				inner join (select max(idestudio) as idestudio from estudios) Tabla on estudios.idestudio = Tabla.idestudio
				select @idInstituto = institutos.idinstituto from institutos
				inner join (select max(idinstituto) as idinstituto from institutos) Tabla on institutos.idinstituto = Tabla.idinstituto
				set @idEstudioNuevo = sum(1+@idEstudio)
				set @idInstitutoNuevo = sum(1+@idInstituto)
				insert estudios values (@idEstudioNuevo, @nombreEstudio, 1)
				insert institutos values (@idInstitutoNuevo, @nombreInstituto, 1)
				insert precios values (@idEstudioNuevo,@idInstitutoNuevo,@precioNuevo)
			END
			
	END
GO

exec updatePrecioEstudio Radio, Poli, 200
go

--Ejer 2


--Ejer 3
create procedure ingresarAfiliado
	(@dniPaciente int, @siglaOOSS varchar(50), @nroPlan int, @nroAfiliado int)
	AS
	BEGIN
		IF EXISTS (SELECT dni, sigla, nroplan, nroafiliado FROM afiliados 
		WHERE dni=@dniPaciente and sigla=@siglaOOSS)
		BEGIN
			--ESTE NO FUNCIONA XQ NO SE QUE NO ACTUALIZA LAS FK
			update afiliados set nroplan=@nroPlan, nroafiliado=@nroAfiliado 
			where dni=@dniPaciente and sigla=@siglaOOSS
		END
		ELSE
		BEGIN
			insert afiliados values (@dniPaciente, @siglaOOSS, @nroPlan, @nroAfiliado)
		END
	END
GO

exec ingresarAfiliado 41436383, MEDI, 1, 25
exec ingresarAfiliado 1, MEDI, 23, 5
GO
--Ejer 4
create procedure estudiosMY
	(@month int, @year int)
	AS
	BEGIN
		IF EXISTS (SELECT * from historias where MONTH(fecha)=@month and YEAR(fecha)=@year)
			BEGIN
				SELECT * from historias where MONTH(fecha)=@month and YEAR(fecha)=@year
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
create procedure pacienteEdad
	(@min int, @max int)
	AS
	BEGIN
		IF EXISTS (select * from pacientes where DATEDIFF(YY, nacimiento, GETDATE()) between @min and @max)
			BEGIN
				select *,DATEDIFF(YY, nacimiento, GETDATE()) AS Edad  from pacientes where DATEDIFF(YY, nacimiento, GETDATE()) between @min and @max
			END
		ELSE
			BEGIN
				print('No existen pacientes en el rango de edad seleccionado.')
			END
	END
GO

exec pacienteEdad 20, 35
exec pacienteEdad 0, 5
go