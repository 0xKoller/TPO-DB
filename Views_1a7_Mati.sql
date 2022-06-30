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


SELECT * FROM HISTORIAS

SELECT * FROM vw_cantidad_estudios_por_institutos

INSERT INTO especialidades VALUES (1, 'Oculista'), (2, 'Traumatologo'), (3, 'Cirujano')

INSERT INTO estuespe VALUES (2,1), (1,2), (1,3)
SELECT * FROM ESTUDIOS
