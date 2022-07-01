-- INSERTORES

INSERT INTO Pacientes VALUES (1, 'Constantino', 'Monteavaro', 'M', '28/10/2001'), (2, 'Luciana', 'Ramirez', 'F', '21/05/1992')

INSERT INTO OOSS VALUES ('OSDE', 'Osde', 'Osde')

INSERT INTO Planes VALUES ('OSDE', 1, 'Binario', 1)

INSERT INTO Afiliados VALUES (1, 'OSDE', 1, 1), (2, 'OSDE', 1, 2)

INSERT INTO Estudios VALUES (1, 'Radiografia', 1), (2, 'Oftalmologia', 1)

INSERT INTO Coberturas VALUES ('OSDE', 1, 1, 100), ('OSDE', 1, 2, 80)  

INSERT INTO Institutos VALUES (1, 'Trinidad Palermo', 1), (2, 'Hospital Fernandez', 1)

INSERT INTO Precios VALUES (1, 1, 2500), (1,2,2000), (2,1,1500), (2,2, 2000)

INSERT INTO Medicos VALUES (1, 'Jose Luis', 'Koller', 1, 'M'), (2, 'Matias', 'Santoro', 1, 'M')

INSERT INTO Historias VALUES (1, 1, 1, '30/06/2022', 1, 'OSDE', 1, ''), (2, 1, 1, '30/06/2022', 2, 'OSDE', 1, ''), (1,1,2,'29/06/2022', 1, 'OSDE', 1, '')