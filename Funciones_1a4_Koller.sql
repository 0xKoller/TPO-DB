--Ejer 1
CREATE FUNCTION edadPaciente
	(@fechaNacimiento as Date)
RETURNS INT
AS
BEGIN
	RETURN
		DATEDIFF(YYYY, @fechaNacimiento, getDate())
END
go

CREATE FUNCTION preciosEstudio
	(@nombreEstudio varchar(50))
RETURNS @precios TABLE(mayorPrecio float, menorPrecio float, precioPromedio float)
AS
BEGIN
		declare @mayor float
		declare @menor float
		declare @prom float
		select precio from precios 
			inner join estudios on precios.idestudio = estudios.idestudio
		RETURN
END
GO