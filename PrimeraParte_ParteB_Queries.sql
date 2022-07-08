--Ejer 14
SELECT nombre, alias, privilegio, idCategoria FROM usuarios INNER JOIN privilegios ON usuarios.idUsuario = privilegios.idUsuario

--Ejer 15
SELECT H.alias,T.[Votaciones Totales] FROM (
SELECT MAX(F.TotalVotaciones) 'Votaciones Totales'
FROM
(SELECT U.alias, SUM(votosUno+votosDos+votosTres) TotalVotaciones FROM votaciones V INNER JOIN noticias N ON V.idNoticia=N.idNoticia
INNER JOIN usuarios U ON N.autor=U.idUsuario GROUP BY U.alias) F) T
INNER JOIN (SELECT U.alias, SUM(votosUno+votosDos+votosTres) TotalVotaciones FROM votaciones V INNER JOIN noticias N ON V.idNoticia=N.idNoticia
INNER JOIN usuarios U ON N.autor=U.idUsuario GROUP BY U.alias) H ON H.TotalVotaciones=T.[Votaciones Totales]

--Ejer 16
	
SELECT N.titulo Noticia,SUM(votosUno + votosDos + votosTres) AS 'Votaciones Totales' FROM votaciones V 
INNER JOIN noticias N ON V.idNoticia=N.idNoticia group by N.titulo

--Ejer 17
SELECT alias, N.titulo Noticia FROM usuarios U INNER JOIN noticias N ON U.idUsuario=N.autor
INNER JOIN categorias C ON N.idCategoria=C.idCategoria
WHERE C.nombre='Policiales'
AND N.idNoticia = ANY(SELECT idNoticia FROM comentarios)

