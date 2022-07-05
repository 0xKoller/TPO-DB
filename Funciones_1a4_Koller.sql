--Ejer 1
CREATE FUNCTION edadPaciente
	(@fechaNacimiento as Date)
RETURNS INT
AS
BEGIN
	RETURN
		DATEDIFF(YYYY, @fechaNacimiento, getDate())
END
go