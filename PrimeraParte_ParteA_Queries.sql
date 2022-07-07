--Ejer 1
SELECT COUNT (*) as CantTemas FROM Temas T 
	INNER JOIN Albumes A ON A.codAlbum = T. codAlbum 
	INNER JOIN Generos G ON G.codGenero = A.codGenero WHERE G.descripcion = 'ROCK'

--Ejer 2
SELECT COUNT (*) AS CantArtistas FROM Artista A 
	INNER JOIN Albumes AL ON A.codArtista = AL. CodArtista 
	INNER JOIN Generos G ON G. codGenero=AL. codGenero WHERE G.descripcion = 'CLASICO'

--Ejer 3
SELECT descripcion FROM Generos 
	inner join (SELECT codGenero, count(codGenero) AS Genero FROM Albumes GROUP BY codGenero having count(codGenero) > 3) 
	AS TablaResultante on Generos.codGenero = TablaResultante.codGenero

--Ejer 4
SELECT F.titulo,tabla.[Cantidad de Temas] 
	FROM(SELECT MAX(F.cantTemas) 'Cantidad de Temas' 
		FROM (SELECT A.titulo,COUNT(T.codAlbum) cantTemas 
				FROM Temas T INNER JOIN Albumes A ON T.codAlbum=A.codAlbum GROUP BY T.codAlbum, A.titulo) F) tabla
	INNER JOIN (SELECT A.titulo,COUNT(T.codAlbum) cantTemas FROM Temas T INNER JOIN Albumes A ON T.codAlbum=A.codAlbum GROUP BY T.codAlbum, A.titulo) F on f.cantTemas = tabla.[Cantidad de Temas]

--Ejer 5
SELECT A.titulo AS nombreAlbum, T.titulo AS nombreTema 
	FROM Albumes A inner join Temas T on A.codAlbum = T.codAlbum WHERE A.titulo = T.titulo

--Ejer 6 hay que dejarla mas linda, es alto chorizo
SELECT nombre 'Artista', Alb.titulo 'Album', T.titulo 'Tema' 
	FROM Artista Art inner join Albumes Alb on Alb.codArtista = Art.codArtista 
	inner join Temas T on T.codAlbum = Alb.codAlbum 
	inner join Generos G on G.codGenero=Alb.codGenero 
	WHERE G.descripcion = 'POP' AND T.titulo like '%ñ%'

--Ejer 7
SELECT nombre, saldo 
	FROM Cliente 
		WHERE saldo < 0

--Ejer 8
SELECT bruto, F.nroFactura, SUM(I.precio) PrecioTotal 
	FROM Facturas F, ItemsFactura I WHERE F.nroFactura=I.nroFactura
	GROUP BY bruto, F.nroFactura
	HAVING bruto=SUM(I.precio)

--Ejer 9
SELECT F.nroFactura, SUM(ItemF.cantidad) 'Cantidad de Articulos x Factura' 
	FROM Facturas F INNER JOIN ItemsFactura ItemF ON ItemF.nroFactura=F.nroFactura 
	INNER JOIN ItemsPedido ItemP ON ItemP.codPedido=F.codPedido
	GROUP BY F.nroFactura,ItemP.cantidad
	HAVING SUM(ItemF.cantidad) < ItemP.cantidad

--Ejer 10
SELECT F.descripcion 'Producto',tabla.[Cantidad de Composiciones] 
	FROM(SELECT MAX(F.[Cantidad de Composiciones]) 'Cantidad de Composiciones' 
		FROM (SELECT P.descripcion,SUM(C.cantidad) 'Cantidad de Composiciones' 
				FROM Composiciones C INNER JOIN Productos P ON C.codProducto=P.codProducto GROUP BY c.codProducto, P.descripcion) F) tabla
	INNER JOIN (SELECT P.descripcion,SUM(C.cantidad) 'Cantidad de Composiciones' 
				FROM Composiciones C INNER JOIN Productos P ON C.codProducto=P.codProducto GROUP BY C.codProducto, P.descripcion) F on F.[Cantidad de Composiciones]= tabla.[Cantidad de Composiciones]

--Ejer 11
SELECT P.codProducto, descripcion FROM Productos P 
	LEFT JOIN ItemsPedido ItPe ON P.codProducto = ItPe.codProducto 
	WHERE ItPe.codProducto IS NULL

--Ejer 12
SELECT nombre, F.final FROM Cliente C
	INNER JOIN Facturas F on F.codCliente = C.codCliente 
	INNER JOIN (SELECT max(final) AS final FROM Facturas) AS TablaResultante ON TablaResultante.final = F.final

--Ejer 13
SELECT * FROM Productos WHERE stock < puntoReposicion

--Ejer 14
SELECT nombre, alias, privilegio, idCategoria 
	FROM usuarios U inner join privilegios P ON U.idUsuario = P.idUsuario

--Ejer 15 aca hay que agregar un max, x ahora pajita
SELECT alias, noticias.idNoticia 
	FROM noticias N INNER JOIN 
		(SELECT idNoticia,SUM(votosUno + votosDos + votosTres) AS TotalVotaciones 
			FROM votaciones group by idNoticia) AS TablaResultante ON N.idNoticia = TablaResultante.idNoticia 
	INNER JOIN usuarios U ON U.idUsuario = N.autor

--Ejer 16
	
--Ejer 17

--Ejer 18




--Ejer 18
SELECT A.titulo, descripcion AS NombreGenero FROM Albumes A 
	INNER JOIN Generos G ON G.codGenero = A.codGenero 
	WHERE descripcion LIKE '%p%' AND descripcion NOT LIKE '%s%'

--Ejer 19
SELECT P.nroPedido 'Pedido', Prod.descripcion 'Descripcion',LEN(Prod.descripcion) 'Cantidad de Caracteres' 
	FROM Pedidos P INNER JOIN ItemsPedido ItemP ON ItemP.codPedido=P.nroPedido 
	INNER JOIN Productos Prod ON Prod.codProducto=ItemP.codProducto
	GROUP BY P.nroPedido,Prod.descripcion
	HAVING LEN(Prod.descripcion) > 60

--Ejer 20
SELECT C.nombre,SUM(F.final) 'Factura Final' 
	FROM Cliente C INNER JOIN Facturas F ON F.codCliente=C.codCliente
	WHERE DATEPART(MONTH,F.fecha) = 2
	GROUP BY C.nombre
