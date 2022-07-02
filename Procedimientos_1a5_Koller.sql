CREATE PROCEDURE updatePrecioEstudio
	(@nombreEstudio VARCHAR(50), @nombreInstituto VARCHAR(50), @precioNuevo float) 
	AS
	BEGIN
		if exists (select instituto, estudio from institutos
					inner join precios on institutos.idinstituto = precios.idinstituto
					inner join estudios on estudios.idestudio = precios.idestudio
					where estudio = @nombreEstudio or instituto = @nombreInstituto)
			if exists (select precio from precios 
					inner join institutos on institutos.idinstituto = precios.idinstituto
					inner join estudios on estudios.idestudio = precios.idestudio)
			update precios set precio = @precioNuevo 
			
		else
			
	END
GO

--If EXISTS (select precio from precios where precio is not null)