SET dateformat dmy
GO 

-- 1)
CREATE VIEW vw_estudios AS
	SELECT estudio 'Nombre', 
		CASE activo
			WHEN 1 THEN 'SI'
			WHEN 0 THEN 'NO'
		END
		Estado
	FROM estudios
GO

-- 2)
CREATE VIEW vw_ooss AS
	SELECT nombre 'Nombre', categoria 'Categoria' FROM ooss
GO

-- 3)
CREATE VIEW vw_pacientes AS
	SELECT P.dni, P.nombre 'Nombre Paciente', P.apellido, P.sexo, P.nacimiento, OS.nombre 'Obra Social',Pl.nombre 'Plan',A.nroafiliado,OS.categoria 
		FROM pacientes P 
			INNER JOIN afiliados A ON A.dni=P.dni
			INNER JOIN ooss OS ON OS.sigla=A.sigla
			INNER JOIN planes Pl ON Pl.nroplan=A.nroplan
GO

-- 4)
CREATE VIEW vw_pacientes_sin_cobertura AS
	SELECT dni, nombre 'Nombre Paciente', apellido, sexo, nacimiento 
		FROM pacientes
GO

-- 5) 
CREATE VIEW vw_medicos_varias_especialidades AS
	SELECT T.especialidad, F.nombre,F.apellido,F.sexo,F.activo 
		FROM (SELECT M.matricula,M.nombre,M.apellido,M.sexo,M.activo,COUNT(EspM.Matricula) CantEspecialidades 
				FROM medicos M INNER JOIN espemedi EspM ON M.matricula=EspM.matricula
					GROUP BY M.matricula,M.nombre,M.apellido,M.sexo,M.activo) F 
					INNER JOIN (SELECT EspM.matricula,E.especialidad 
									FROM espemedi EspM INNER JOIN especialidades E ON EspM.idespecialidad=E.idespecialidad) T 
										ON F.matricula=T.matricula
	WHERE F.CantEspecialidades > 1 AND F.activo = 1
GO

-- 6) 
CREATE VIEW vw_total_medicos_sin_especialidades AS
	SELECT 
		CASE M.sexo 
			WHEN 'M' THEN 'MASCULINO'
			WHEN 'F' THEN 'FEMENINO'
		END
	Sexo,COUNT(M.matricula) 'Cantidad de Medicos' FROM medicos M LEFT JOIN espemedi EspM ON M.matricula=EspM.matricula WHERE EspM.matricula IS NULL
	GROUP BY M.sexo
GO

-- 7) 
CREATE VIEW vw_afiliados_con_una_cobertura AS
	SELECT pac.dni, pac.nombre, afi.nroAfiliado, afi.sigla, pla.nombre nombrePlan 
		FROM(SELECT pla.sigla, pla.nroplan, COUNT(pla.nroplan) cantCoberturas 
				FROM planes pla
				INNER JOIN coberturas cob on pla.sigla = cob.sigla and pla.nroplan = cob.nroplan
				GROUP BY pla.sigla, pla.nroplan
				HAVING COUNT(pla.nroPlan) = 1) cob
		INNER JOIN afiliados afi on cob.sigla = afi.sigla and cob.nroplan = afi.nroPlan
		INNER JOIN pacientes pac on afi.dni = pac.dni
		INNER JOIN planes pla on afi.sigla = pla.sigla and afi.nroPlan = pla.nroPlan	
GO

-- 8) 
CREATE VIEW vw_cantidad_estudios_por_institutos AS 
	SELECT instituto, estudio, VecesSolicitado FROM 
		(SELECT idEstudio, idInstituto, COUNT(idEstudio) as VecesSolicitado
			FROM HISTORIAS
			GROUP BY idEstudio, idInstituto) his
		INNER JOIN Institutos ins on his.idInstituto = ins.idInstituto 
		INNER JOIN Estudios est on his.idestudio = est.idestudio
		
GO

-- 9) 
CREATE VIEW vw_cantidad_estudios_por_medico AS
	SELECT med.matricula, nombre, VecesSolicitado FROM 
		(SELECT matricula, COUNT(Matricula) as VecesSolicitado
			FROM Historias
			GROUP BY matricula) his
		INNER JOIN Medicos med on his.matricula = med.matricula
GO

-- 10)
CREATE VIEW vw_historias_de_estudios AS
	SELECT pac.dni DniPaciente, pac.nombre NombrePaciente, pac.apellido ApellidoPaciente, med.matricula MatriculaMedico, med.nombre NombreMedico, med.apellido ApellidoMedico,
		his.fecha, his.sigla ObraSocial, instituto Instituto, estudio Estudio
		FROM Historias his
			INNER JOIN medicos med on his.matricula = med.matricula
			INNER JOIN pacientes pac on his.dni = pac.dni
			INNER JOIN institutos ins on his.idinstituto = ins.idinstituto
			INNER JOIN estudios est on his.idestudio = est.idestudio
GO


-- 11) 
CREATE VIEW vw_pagos_recientes AS
	SELECT pac.nombre, his.dni, est.estudio, fecha, precio
		FROM Historias his
			INNER JOIN Precios pre ON his.idEstudio = pre.idEstudio and his.idinstituto = pre.idinstituto
			INNER JOIN Pacientes pac ON his.dni = pac.dni
			INNER JOIN Estudios est on his.idestudio = est.idestudio
GO

-- 12) 
CREATE VIEW vw_ooss_pacientes AS
	SELECT oos.nombre OOSS, pla.nombre NombrePlan, pla.activo, pac.dni, pac.nombre, pac.apellido
		FROM ooss oos
			INNER JOIN planes pla on oos.sigla = pla.sigla
			LEFT JOIN Afiliados afi on oos.sigla = afi.sigla and pla.nroplan = afi.nroplan
			LEFT JOIN pacientes pac on afi.dni = pac.dni
GO

-- 13) 
CREATE VIEW vw_estudios_sin_cobertura AS
	SELECT estudio 
		FROM Estudios est
			LEFT JOIN coberturas cob on est.idestudio = cob.idestudio
				WHERE sigla is null
GO

-- 14) 
CREATE VIEW vw_planes_sin_cobertura AS
	SELECT pla.sigla, pla.nroplan, pla.nombre
		FROM Planes pla
			LEFT JOIN Coberturas cob on pla.sigla = cob.sigla and pla.nroplan = cob.nroplan
				WHERE idEstudio is null
GO

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
	SELECT dni, estudio, fecha 
		FROM historias 
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
	INNER JOIN (SELECT idestudio, COUNT(idestudio) AS CantEstudios 
				FROM historias WHERE fecha BETWEEN DATEADD(d,-7,GETDATE()) and GETDATE() GROUP BY idestudio ) 
				TablaEstudios ON TablaEstudios.idestudio = historias.idestudio
	INNER JOIN institutos ON historias.idinstituto = institutos.idinstituto
GO

--Ejer 20
CREATE VIEW vw_estudios_en_sabada AS 
	SELECT dni, fecha 
		FROM historias
		INNER JOIN (SELECT idestudio, COUNT(idestudio) AS CantEstudios FROM historias  GROUP BY idestudio)
		TablaEstudios ON historias.idestudio = TablaEstudios.idestudio 
	WHERE DATENAME(WEEKDAY, fecha) IN ('Saturday');