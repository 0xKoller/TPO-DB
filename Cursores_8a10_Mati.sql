SET DATEFORMAT DMY
GO
--EJER 8 NO FUNCIONA EL PIVOT PARA HACER LAS TABLAS CRUZADAS
CREATE PROC sp_definirCursorImporteMensual
	(@mesesAnteriores int)
AS 
BEGIN
	DECLARE importeMensual CURSOR FOR
		SELECT P.precio,H.fecha,P.idinstituto FROM precios P INNER JOIN historias H ON P.idinstituto=H.idinstituto
		WHERE H.fecha BETWEEN (DATEADD(month,-@mesesAnteriores,GETDATE())) AND GETDATE()
		GROUP BY P.idinstituto,P.precio,h.fecha
	DECLARE @precio int,@fecha date, @idInstituto int
	OPEN importeMensual

	FETCH NEXT FROM importeMensual INTO @precio,@fecha,@idInstituto
	WHILE @@FETCH_STATUS = 0
		BEGIN
			


			FETCH NEXT FROM importeMensual INTO @precio,@fecha,@idInstituto
		END

	CLOSE importeMensual
	DEALLOCATE importeMensual

END
GO


--EJER 9
DECLARE actualizarObservaciones CURSOR FOR
	SELECT H.dni,H.idinstituto,H.matricula,H.observaciones FROM historias H INNER JOIN pacientes P ON H.dni=P.dni

DECLARE @dni int,@idInstituto int,@matricula int,@observaciones varchar(100)
DECLARE @instiSegundo int
SET @instiSegundo = 0

OPEN actualizarObservaciones

FETCH actualizarObservaciones INTO @dni,@idInstituto,@matricula,@observaciones
WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (@@ROWCOUNT = 2)
			BEGIN
				SET @instiSegundo = @idInstituto
				UPDATE historias
				SET @observaciones = 'Repetir estudio'
				print(CONCAT(@dni,' ',@idInstituto,' ',@matricula,' ',@observaciones))
			END
		IF (@idInstituto <> @instiSegundo AND @matricula=3)
			BEGIN 
				UPDATE historias
				SET @observaciones = 'Diagnóstico no confirmado'
				print(CONCAT(@dni,' ',@idInstituto,' ',@matricula,' ',@observaciones))
			END
		FETCH actualizarObservaciones INTO @dni,@idInstituto,@matricula,@observaciones
	END
CLOSE actualizarObservaciones
DEALLOCATE actualizarObservaciones
GO


--EJER 10
DECLARE actualizarPrecios CURSOR FOR
	SELECT P.precio,E.especialidad FROM precios P INNER JOIN estuespe EstuE ON P.idestudio=EstuE.idestudio
	INNER JOIN especialidades E ON EstuE.idespecialidad=E.idespecialidad
	INNER JOIN estudios Est ON EstuE.idestudio=Est.idestudio
	GROUP BY E.especialidad,P.precio

DECLARE @precio float,@especialidad varchar(100)
DECLARE @aumento float, @especialidadUsada varchar(100)
SET @aumento = 0.02

OPEN actualizarPrecios

FETCH actualizarPrecios INTO @precio,@especialidad
SET @especialidadUsada = @especialidad

WHILE @@FETCH_STATUS = 0
	BEGIN
		PRINT(@especialidad)
		IF (@especialidad <> @especialidadUsada)
			BEGIN	
				SET @especialidadUsada = @especialidad
					PRINT(CONCAT('   Precio Original: ', @precio))
				SET @precio = @precio + @precio * @aumento
				UPDATE precios
				SET precio = @precio
				SET @aumento = @aumento + 0.02
					PRINT(CONCAT('   Aumento: ',@aumento*100,'%'))
					PRINT(CONCAT('   Precio Final: ',@precio))			
			END
		ELSE
			BEGIN
					PRINT(CONCAT('   Precio Original: ', @precio))
				SET @precio = @precio + @precio * @aumento
					PRINT(CONCAT('   Aumento: ',@aumento*100,'%'))
					PRINT(CONCAT('   Precio Final: ',@precio))
					PRINT('   ')
			END
		FETCH actualizarPrecios INTO @precio,@especialidad
	END
CLOSE actualizarPrecios
DEALLOCATE actualizarPrecios
GO