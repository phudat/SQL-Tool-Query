USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ConvertAttributeBarcodeToJsonArray]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
=============================================
Author			:	ThuongNM2
Create date		:	4/22/2022 - 4:20 PM
Description		:	
Note			:	
==============================================

*/

CREATE FUNCTION [dbo].[fn_ConvertAttributeBarcodeToJsonArray]
(
    @productID NVARCHAR(50),
    @attributeId INT
)
RETURNS NVARCHAR(MAX)
BEGIN
    DECLARE @json NVARCHAR(MAX) = N'[]';

    SELECT @json = JSON_MODIFY(@json, 'append $', b.CustomValue)
    FROM ProductAttributeValue b WITH (NOLOCK)
    WHERE b.AttributeId = @attributeId
          AND b.ProductId = @productID
    GROUP BY b.CustomValue;
    RETURN @json;
END;
GO
