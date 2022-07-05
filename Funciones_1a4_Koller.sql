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

--Ejer 2
CREATE FUNCTION preciosEstudio
	(@nombreEstudio varchar(50))
RETURNS @preciosEstudio TABLE(mayorPrecio float, menorPrecio float, precioPromedio float)
AS
BEGIN
		declare @mayor float
		declare @menor float
		declare @prom float
		select @prom = avg(precio) from precios 
			inner join estudios on precios.idestudio = estudios.idestudio
			where estudio = @nombreEstudio 
		select @mayor = max(precio)from precios 
			inner join estudios on precios.idestudio = estudios.idestudio
			where estudio = @nombreEstudio
		select @menor = min(precio)from precios 
			inner join estudios on precios.idestudio = estudios.idestudio
			where estudio = @nombreEstudio
		insert into @preciosEstudio values (@mayor, @menor, @prom)
		RETURN
END
GO

--Ejer 3
create function tablaInfoAlfa
()
returns @tablaFinal table(ooss varchar(50), especialidades varchar(50), institutos varchar(50), estudios varchar(50))
as
	BEGIN
		insert into @tablaFinal (ooss) select nombre from ooss order by nombre ASC
		insert into @tablaFinal (especialidades) select especialidad from especialidades order by especialidad ASC
		insert into @tablaFinal (institutos) select instituto from institutos order by instituto ASC
		insert into @tablaFinal (estudios) select estudio from estudios order by estudio ASC
		RETURN
	END
GO

--Ejer 4

--Ejer 5
create function estudiosNoRealizados
	(@dias int)
returns @tablaFinal table (idestudio int, nombreEstudio varchar(50))
AS
	BEGIN
		insert into @tablaFinal (idestudio, nombreEstudio)
			select historias.idestudio, estudio from historias 
				inner join estudios on historias.idestudio = estudios.idestudio
				where fecha between DATEADD(d, -@dias, GETDATE()) and getdate()
		RETURN
	END
GO