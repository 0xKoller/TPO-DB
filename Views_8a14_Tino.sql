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


