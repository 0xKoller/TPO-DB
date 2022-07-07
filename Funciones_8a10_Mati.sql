--Ejer 8 NI IDEEEEEEAAAA
CREATE FUNCTION cadenaInicialEnMayus
	(@stringInicial varchar(400))
	RETURNS varchar(400)
AS
BEGIN
	DECLARE @stringResultante varchar(400)
	DECLARE @listaStrings varchar(400)
	

	SET @listaStrings = SUBSTRING(@stringInicial,0,CHARINDEX(' ',@stringInicial))+SUBSTRING(@stringInicial,CHARINDEX(' ',@stringInicial),LEN(@stringInicial))
	

	SET @stringResultante = UPPER(SUBSTRING(@stringInicial,1,1))+LOWER(SUBSTRING(@stringInicial,2,LEN(@stringInicial)-1))

	RETURN @stringResultante
END
GO

SELECT dbo.cadenaInicialEnMayus (
  'buenas tardes mi nombre es matias')
GO

--Ejer 9 NO FUNCAAAAAAAAAAA
CREATE FUNCTION OSenEstudios
	(@nombreEstudio varchar(100))
	RETURNS TABLE
AS
RETURN
	(SELECT OS.nombre, OS.categoria FROM historias H
	INNER JOIN estudios Est ON H.idestudio=Est.idestudio
	INNER JOIN coberturas Cob ON Est.idestudio=Cob.idestudio
	INNER JOIN ooss OS ON Cob.sigla=OS.sigla
	INNER JOIN planes P ON OS.sigla=P.sigla
	WHERE Est.estudio=@nombreEstudio 
		AND H.idinstituto = ANY(SELECT idinstituto FROM historias)
		AND P.nroplan = ALL(SELECT coberturas.nroplan FROM coberturas WHERE OS.sigla=Cob.sigla)
	GROUP BY OS.nombre,OS.categoria
	)
GO

SELECT * FROM OSenEstudios('Radiografia')
GO


--Ejer 10
CREATE FUNCTION CantEstudiosEInstitutos
	(@sigla varchar(100))
	RETURNS TABLE
AS
RETURN
	(SELECT OS.nombre,Est.estudio,COUNT(H.idestudio) CantEstudios,Ins.instituto, COUNT(H.idinstituto) CantInstitutos FROM historias H
	INNER JOIN ooss OS ON H.sigla=OS.sigla INNER JOIN estudios Est ON H.idestudio=Est.idestudio
	INNER JOIN institutos Ins ON H.idinstituto=Ins.idinstituto WHERE OS.sigla=@sigla
	GROUP BY OS.nombre,Est.estudio,Ins.instituto)
GO

SELECT * FROM dbo.CantEstudiosEInstitutos(
	'GALE')
GO
