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
-- select codAlbum from Temas inner join select max(cuenta) from (select codAlbum, count(codAlbum) cuenta from Temas group by codAlbum)  on Temas.codAlbum = T.codAlbum

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

--Ejer 8
