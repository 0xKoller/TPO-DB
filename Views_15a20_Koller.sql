--Ejer 15
CREATE VIEW vw_tabla_de_precios AS
	SELECT est.estudio, oos.nombre, cob.nroplan, ins.instituto, cob.cobertura, pre.precio, (pre.precio*(cobertura/100)) netoObraSocial, (pre.precio*(1-cobertura/100)) netoPaciente
		FROM coberturas cob
		INNER JOIN precios pre on cob.idEstudio = pre.idEstudio
		INNER JOIN estudios est on cob.idEstudio = pre.idEstudio
		INNER JOIN institutos ins on pre.idinstituto = ins.idinstituto
		INNER JOIN ooss oos on cob.sigla = oos.sigla
GO

--Ejer 16
CREATE VIEW vw_nomina_de_medicos AS  
	SELECT CASE sexo 
	when 'M' THEN CONCAT('Dr. ', nombre, ' ', UPPER(apellido))
	when 'F' THEN CONCAT('Dra. ', nombre, ' ', UPPER(apellido))
	END AS Medicos
	FROM medicos
GO

--Ejer 17
CREATE VIEW vw_estudios_en_tres_meses AS
	SELECT dni, estudio, fecha FROM historias 
	INNER JOIN estudios ON estudios.idestudio = historias.idestudio
	WHERE fecha BETWEEN DATEADD(m,-3,GETDATE()) and GETDATE()
GO
--Ejer 18

CREATE VIEW vw_estudios_por_mes AS
	SELECT MONTH(fecha) mes, sexo , idestudio, COUNT(idEstudio) cant 
		FROM HISTORIAS his
		INNER JOIN pacientes pac on his.dni = pac.dni
		GROUP BY month(fecha), idestudio, sexo
GO

--Ejer 19
CREATE VIEW vw_estudios_por_instituto AS SELECT dni, instituto, fecha, historias.idestudio FROM historias
	INNER JOIN 
	(SELECT idestudio, COUNT(idestudio) AS CantEstudios FROM historias WHERE fecha BETWEEN DATEADD(d,-7,GETDATE()) and GETDATE() GROUP BY idestudio ) TablaEstudios ON TablaEstudios.idestudio = historias.idestudio
	INNER JOIN institutos ON historias.idinstituto = institutos.idinstituto
GO

--Ejer 20
CREATE VIEW vw_estudios_en_sabada AS 
	SELECT dni, fecha FROM historias
	INNER JOIN (SELECT idestudio, COUNT(idestudio) AS CantEstudios FROM historias  GROUP BY idestudio) TablaEstudios ON historias.idestudio = TablaEstudios.idestudio WHERE DATENAME(WEEKDAY, fecha) IN ('Saturday');