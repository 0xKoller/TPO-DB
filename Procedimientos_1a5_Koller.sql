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

