-- Ejercicios de 1 a 13 y 18 hasta el ultimo son de la tabla de Musica 

--Ejer 1
SELECT COUNT (*) as CantTemas FROM Temas T 
	INNER JOIN Albumes A ON A.codAlbum = T. codAlbum 
	INNER JOIN Generos G ON G.codGenero = A.codGenero WHERE G.descripcion = 'ROCK'

--Ejer 2
SELECT COUNT (*) as CantArtistas FROM Artista A 
	INNER JOIN Albumes AL ON A.codArtista = AL. CodArtista 
	INNER JOIN Generos G ON G. codGenero=AL. codGenero WHERE G.descripcion = 'CLASICO'

--Ejer 3
select descripcion from Generos 
	inner join (select codGenero, count(codGenero) as Genero from Albumes group by codGenero having count(codGenero) > 3) 
	as TablaResultante on Generos.codGenero = TablaResultante.codGenero

--Ejer 4


--Ejer 5
select Albumes.titulo as nombreAlbum, Temas.titulo as nombreTema from Albumes inner join Temas on Albumes.codAlbum = Temas.codAlbum where Albumes.titulo = Temas.titulo

--Ejer 6 hay que dejarla mas linda, es alto chorizo
select nombre as NombreArtista, Albumes.titulo as NombreAlbum, Temas.titulo as NombreTema 
	from Artista inner join Albumes on Albumes.codArtista = Artista.codArtista 
	inner join Temas on Temas.codAlbum = Albumes.codAlbum 
	inner join Generos on Generos.codGenero=Albumes.codGenero 
	where Generos.descripcion = 'POP' AND temas.titulo like '%ñ%'

--Ejer 7
select nombre, saldo from Cliente where saldo < 0

--Ejer 8 paja

--Ejer 9

--Ejer 10 hacelo vos mati xq ni idea lo de composiones

--Ejer 11
select Productos.codProducto, descripcion from Productos 
	left join ItemsPedido on Productos.codProducto = ItemsPedido.codProducto 
	where ItemsPedido.codProducto is Null

--Ejer 12
select nombre, Facturas.final from Cliente 
	inner join Facturas on Facturas.codCliente = Cliente.codCliente 
	inner join (select max(final) as final from Facturas) as TablaResultante on TablaResultante.final = Facturas.final

--Ejer 13
select * from Productos where stock < puntoReposicion



