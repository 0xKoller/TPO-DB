--Ejer 8
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

--Ejer 9
CREATE FUNCTION OSenEstudios
	(@nombreEstudio varchar(100))
	RETURNS TABLE
AS
RETURN
	(SELECT OS.nombre,OS.categoria FROM ooss OS INNER JOIN planes Pl ON OS.sigla=Pl.sigla 
	INNER JOIN coberturas Cob ON Pl.nroplan=Cob.nroplan
	INNER JOIN estudios Est ON Cob.idestudio=Est.idestudio 
	WHERE Est.estudio = @nombreEstudio AND EXISTS(SELECT * FROM planes)
	GROUP BY OS.nombre,OS.categoria)
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