USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_get_shop_inventory]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
			
CREATE FUNCTION [dbo].[ufn_get_shop_inventory] (@itemcode NCHAR(50),@type TINYINT)				
RETURNS NVARCHAR(max)				
AS				
BEGIN				
   DECLARE @out nvarchar(max) =''
	 
	if @type =1 
	BEGIN
	    SELECT @Out = @Out +N'{"shop_code" : "'+ Shopcode+N'", "qty_available" : '+CAST(ISNULL(Quantity_available,0) AS VARCHAR(20))+'},'+ CHAR(13) + CHAR(10)  FROM dbo.OITW_1 WITH (nolock) WHERE ItemCode=@itemcode   
		
	END
	ELSE
	BEGIN
	    SELECT @Out = @Out +N'"'+ Shopcode+N'",'+ CHAR(13) + CHAR(10)  FROM dbo.OITW_1 WITH (nolock) WHERE ItemCode=@itemcode 
	END
	SET @out = '['+@out+']'
	RETURN @out			
END	
GO
