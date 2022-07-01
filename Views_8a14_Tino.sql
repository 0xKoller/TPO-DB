-- Parte A: Vistas

-- Mati hace 1-2-3-4-5-6-7

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
