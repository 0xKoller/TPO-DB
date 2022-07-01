--Ejer 1
SELECT COUNT (*) as CantTemas FROM Temas T INNER JOIN Albumes A ON A.codAlbum = T. codAlbum INNER JOIN Generos G ON G.codGenero = A.codGenero WHERE G.descripcion = 'ROCK'

--Ejer 2
SELECT COUNT (*) as CantArtistas FROM Artista A INNER JOIN Albumes AL ON A.codArtista = AL. CodArtista INNER J0IN Generos G ON G. codGenero-AL. codGenero WHERE G.descripcion = 'CLASICO'