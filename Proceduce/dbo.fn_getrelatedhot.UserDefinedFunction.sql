USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_getrelatedhot]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[fn_getrelatedhot] (@id INT) RETURNS NVARCHAR(max)
	BEGIN
	DECLARE @textResult NVARCHAR(max) =''
		SELECT @textResult=CONCAT('["', STRING_AGG(p.Code, '","') ,'"]') FROM dbo.Product p WITH (NOLOCK) 
			INNER JOIN dbo.LinkedProduct lp WITH (nolock) ON p.id=lp.ProductId WHERE lp.LinkedProductId = @id AND lp.LinkedType=0
		RETURN @textResult
	END
GO
