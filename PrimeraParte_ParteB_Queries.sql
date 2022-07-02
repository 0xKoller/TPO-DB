--Ejer 14
select nombre, alias, privilegio, idCategoria from usuarios inner join privilegios on usuarios.idUsuario = privilegios.idUsuario

--Ejer 15 aca hay que agregar un max, x ahora pajita
select alias, noticias.idNoticia from noticias 
	inner join (select idNoticia,SUM(votosUno + votosDos + votosTres) as TotalVotaciones from votaciones group by idNoticia) as TablaResultante on noticias.idNoticia = TablaResultante.idNoticia 
	inner join usuarios on usuarios.idUsuario = noticias.autor

--Ejer 16

--Ejer 17

--Ejer 18

