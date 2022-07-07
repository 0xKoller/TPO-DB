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
	SELECT P.dni, P.nombre 'Nombre Paciente', P.apellido, P.sexo, P.nacimiento, OS.nombre 'Obra Social',Pl.nombre 'Plan',A.nroafiliado,OS.categoria FROM pacientes P 
		INNER JOIN afiliados A ON A.dni=P.dni
		INNER JOIN ooss OS ON OS.sigla=A.sigla
		INNER JOIN planes Pl ON Pl.nroplan=A.nroplan
GO

-- 4)
CREATE VIEW vw_pacientes_sin_cobertura AS
	SELECT dni, nombre 'Nombre Paciente', apellido, sexo, nacimiento FROM pacientes
GO

-- 5) FALTA QUE MUESTRE LAS ESPECIALIDADES
CREATE VIEW vw_medicos_varias_especialidades AS
	SELECT T.especialidad, F.nombre,F.apellido,F.sexo,F.activo FROM (
						SELECT M.matricula,M.nombre,M.apellido,M.sexo,M.activo,COUNT(EspM.Matricula) CantEspecialidades FROM medicos M INNER JOIN espemedi EspM ON M.matricula=EspM.matricula
						GROUP BY M.matricula,M.nombre,M.apellido,M.sexo,M.activo) F 
						INNER JOIN (SELECT EspM.matricula,E.especialidad FROM espemedi EspM INNER JOIN especialidades E ON EspM.idespecialidad=E.idespecialidad) T ON F.matricula=T.matricula
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
	SELECT pac.dni, pac.nombre, afi.nroAfiliado, afi.sigla, pla.nombre nombrePlan FROM
		(SELECT pla.sigla, pla.nroplan, COUNT(pla.nroplan) cantCoberturas FROM planes pla
			INNER JOIN coberturas cob on pla.sigla = cob.sigla and pla.nroplan = cob.nroplan
			GROUP BY pla.sigla, pla.nroplan
			HAVING COUNT(pla.nroPlan) = 1) cob
		INNER JOIN afiliados afi on cob.sigla = afi.sigla and cob.nroplan = afi.nroPlan
		INNER JOIN pacientes pac on afi.dni = pac.dni
		INNER JOIN planes pla on afi.sigla = pla.sigla and afi.nroPlan = pla.nroPlan	
GO

