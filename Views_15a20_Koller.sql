--Ejer 15

--Ejer 16
create view vw_nomina_de_medicos as  
	select case sexo 
	when 'M' then concat('Dr. ', nombre, ' ', upper(apellido))
	when 'F' then concat('Dra. ', nombre, ' ', upper(apellido))
	end as Medicos
	from medicos
go

--Ejer 17
create view vw_estudios_en_tres_meses as
	select dni, estudio, fecha from historias 
	inner join estudios on estudios.idestudio = historias.idestudio
	where fecha between dateadd(m,-3,getdate()) and getdate()
go
--Ejer 18

go
--Ejer 19
create view vw_estudios_por_instituto as select dni, instituto, fecha, historias.idestudio from historias
	inner join 
	(select idestudio, count(idestudio) as CantEstudios from historias where fecha between dateadd(d,-7,getdate()) and getdate() group by idestudio ) TablaEstudios on TablaEstudios.idestudio = historias.idestudio
	inner join institutos on historias.idinstituto = institutos.idinstituto
go

--Ejer 20
create view vw_estudios_en_sabada as 
	select dni, fecha from historias
	inner join (select idestudio, count(idestudio) as CantEstudios from historias  group by idestudio) TablaEstudios on historias.idestudio = TablaEstudios.idestudio where datename(weekday, fecha) in ('Saturday');