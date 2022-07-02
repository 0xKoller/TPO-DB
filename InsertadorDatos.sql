-- INSERTORES
SET DATEFORMAT DMY
go

INSERT INTO Pacientes 
	VALUES 
	(1, 'Constantino', 'Monteavaro', 'M', '28/10/2001'),
	(2, 'Luciana', 'Ramirez', 'F', '21/05/1992'),
	(3, 'Paloma', 'Koller', 'F', '01/03/2000'),
	(4, 'Antonio', 'Perez', 'M', '01/10/1996'),
	(5, 'Ezequiel', 'Estevez', 'M', '12/02/1994')

INSERT INTO OOSS 
	VALUES 
	('GALE', 'Galeno', 'Galeno'), 
	('OSDE', 'Osde', 'Osde'), 
	('MEDI', 'Medife', 'Medife')

INSERT INTO Planes 
	VALUES 
	('GALE', 1, 'ORO',1), 
	('OSDE', 2, '210', 1), 
	('OSDE', 1, 'Binario', 1), 
	('MEDI', 1, 'Platino', 1), 
	('MEDI', 2, 'Bronce', 0)

INSERT INTO Afiliados 
	VALUES 
	(1, 'OSDE', 1, 1),
	(2, 'OSDE', 1, 2),
	(3, 'GALE', 1, 1),
	(4, 'OSDE', 2, 2),
	(5, 'MEDI', 1, 5)

INSERT INTO Estudios 
	VALUES 
	(3, 'Tomografia', 1),
	(1, 'Radiografia', 1),
	(2, 'Oftalmologia', 1),
	(4, 'Laboratorio', 1),
	(5, 'Ecografia', 0),
	(6, 'Hisopado', 1)

INSERT INTO Coberturas 
	VALUES 
	--Cobertura Radio
	('GALE', 1,1,100), 
	('OSDE', 1, 1, 100), 
	--Cobertura Oftalmologia
	('OSDE', 2, 2, 90), 
	('OSDE', 1, 2, 80),  
	--Cobertura Tomografia
	('MEDI', 1, 3, 80),
	('GALE', 1, 3, 80),
	--Cobertura Laboratorio
	('MEDI', 1, 4, 67),
	('OSDE', 1, 4, 10),
	--Cobertura Ecografia
	('OSDE', 1, 5, 95),
	('OSDE', 2, 5, 30),
	('GALE', 1, 5, 45),
	('MEDI', 1, 5, 20)

INSERT INTO Institutos 
	VALUES 
	(1, 'Trinidad Palermo', 1),
	(2, 'Hospital Fernandez', 1),
	(3, 'Policlinico', 1),
	(4, 'ADOS', 0)

INSERT INTO Precios 
	VALUES 
	(1, 1, 2500),
	(1,2,2000),
	(1,3,1000),
	(2,1, 1500),
	(2,2, 2000),
	(2,3, 3405),
	(3,1, 500),
	(3,2, 200),
	(3,3, 405),
	(4,1, 150),
	(4,2, 250),
	(4,3, 340)

INSERT INTO Medicos 
	VALUES 
	(1, 'Jose Luis', 'Koller', 1, 'M'), 
	(2, 'Matias', 'Santoro', 1, 'M'),
	(3, 'Paola', 'Torres', 1, 'F'),
	(4, 'Leandro', 'Montero', 0, 'M')

INSERT INTO Historias 
	VALUES 
	(5,2,1,'04/07/2022', 3, 'MEDI', 1, ''),
	(4,3,2,'03/07/2022', 2, 'OSDE', 1, ''),
	(3,2,2,'01/07/2022', 3, 'GALE', 1, ''),
	(1, 1, 1, '30/06/2022', 1, 'OSDE', 1, ''),
	(2, 1, 1, '30/06/2022', 2, 'OSDE', 1, ''),
	(1,1,2,'29/06/2022', 1, 'OSDE', 1, '')

