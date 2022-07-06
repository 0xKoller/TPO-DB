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
SELECT F.titulo,tabla.[Cantidad de Temas] FROM(
select MAX(F.cantTemas) 'Cantidad de Temas' 
from 
(select A.titulo,COUNT(T.codAlbum) cantTemas from Temas T INNER JOIN Albumes A ON T.codAlbum=A.codAlbum group by T.codAlbum, A.titulo) F) tabla
INNER JOIN (select A.titulo,COUNT(T.codAlbum) cantTemas from Temas T INNER JOIN Albumes A ON T.codAlbum=A.codAlbum group by T.codAlbum, A.titulo) F on f.cantTemas = tabla.[Cantidad de Temas]

--Ejer 5
select Albumes.titulo as nombreAlbum, Temas.titulo as nombreTema from Albumes inner join Temas on Albumes.codAlbum = Temas.codAlbum where Albumes.titulo = Temas.titulo

--Ejer 6 hay que dejarla mas linda, es alto chorizo
select nombre 'Artista', Albumes.titulo 'Album', Temas.titulo 'Tema' 
	from Artista inner join Albumes on Albumes.codArtista = Artista.codArtista 
	inner join Temas on Temas.codAlbum = Albumes.codAlbum 
	inner join Generos on Generos.codGenero=Albumes.codGenero 
	where Generos.descripcion = 'POP' AND temas.titulo like '%ñ%'

--Ejer 7
select nombre, saldo from Cliente where saldo < 0

--Ejer 8
select bruto, F.nroFactura, SUM(I.precio) PrecioTotal from Facturas F, ItemsFactura I where F.nroFactura=I.nroFactura
group by bruto, F.nroFactura
having bruto=SUM(I.precio)

--Ejer 9
select F.nroFactura, SUM(ItemF.cantidad) 'Cantidad de Articulos x Factura' from Facturas F INNER JOIN ItemsFactura ItemF ON ItemF.nroFactura=F.nroFactura 
INNER JOIN ItemsPedido ItemP ON ItemP.codPedido=F.codPedido
group by F.nroFactura,ItemP.cantidad
having SUM(ItemF.cantidad) < ItemP.cantidad

--Ejer 10
SELECT F.descripcion 'Producto',tabla.[Cantidad de Composiciones] FROM(
select MAX(F.[Cantidad de Composiciones]) 'Cantidad de Composiciones' 
from 
(select P.descripcion,SUM(C.cantidad) 'Cantidad de Composiciones' from Composiciones C INNER JOIN Productos P ON C.codProducto=P.codProducto group by c.codProducto, P.descripcion) F) tabla
INNER JOIN (select P.descripcion,SUM(C.cantidad) 'Cantidad de Composiciones' from Composiciones C INNER JOIN Productos P ON C.codProducto=P.codProducto group by C.codProducto, P.descripcion) F on F.[Cantidad de Composiciones]= tabla.[Cantidad de Composiciones]

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

--Ejer 18
select Albumes.titulo, descripcion as NombreGenero from Albumes 
	inner join Generos on Generos.codGenero = Albumes.codGenero 
	where descripcion like '%p%' and descripcion not like '%s%'

--Ejer 19
select P.nroPedido 'Pedido', Prod.descripcion 'Descripcion',LEN(Prod.descripcion) 'Cantidad de Caracteres' from Pedidos P INNER JOIN ItemsPedido ItemP ON ItemP.codPedido=P.nroPedido 
INNER JOIN Productos Prod ON Prod.codProducto=ItemP.codProducto
group by P.nroPedido,Prod.descripcion
HAVING LEN(Prod.descripcion) > 60

--Ejer 20
select C.nombre,SUM(F.final) 'Factura Final' from Cliente C INNER JOIN Facturas F on F.codCliente=C.codCliente
where DATEPART(MONTH,F.fecha) = 2
group by C.nombre
