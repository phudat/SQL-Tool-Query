USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ConvertAttributeToJsonArray]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
=============================================
Author			:	Datnp5
Create date		:	4/22/2022 - 5:17 PM
Description		:	
Note			:	
==============================================

*/

CREATE FUNCTION [dbo].[fn_ConvertAttributeToJsonArray]
(
    @productID int,
	@type NVARCHAR(50)--barcode,age,agesAgg,agesSlug,specialFeatures
)
RETURNS NVARCHAR(MAX)
BEGIN
    DECLARE @json NVARCHAR(MAX) = N'[]';
	
	IF @type IN( 'age' ,'specialFeatures')--'age' 11, 'specialFeatures'--2
	BEGIN
	     SELECT @json = JSON_MODIFY(@json,'append $',pav.CustomValue)		
		FROM ProductAttributeValue pav WITH (NOLOCK) LEFT JOIN ProductAttributeOption pao WITH (NOLOCK) ON pao.Id = pav.AttributeOptionId
		WHERE AttributeId =(CASE WHEN @type= 'age' THEN 11 ELSE 2 end)  AND pav.ProductId = @productID
	END
	IF @type IN ('agesAgg','specialFeaturesAgg')
	BEGIN
	     SELECT @json = JSON_MODIFY(@json,'append $',pav.CustomValue + '|' + pao.Slug)		
		FROM ProductAttributeValue pav WITH (NOLOCK) LEFT JOIN ProductAttributeOption pao WITH (NOLOCK) ON pao.Id = pav.AttributeOptionId
		WHERE AttributeId =(CASE WHEN @type= 'agesAgg' THEN 11 ELSE 2 end)  AND pav.ProductId = @productID
	END
	IF @type IN ('agesSlug','specialFeaturesSlug')
	BEGIN
	     SELECT @json = JSON_MODIFY(@json,'append $',pao.Slug)		
		FROM ProductAttributeValue pav WITH (NOLOCK) LEFT JOIN ProductAttributeOption pao WITH (NOLOCK) ON pao.Id = pav.AttributeOptionId
		WHERE AttributeId =(CASE WHEN @type= 'agesSlug' THEN 11 ELSE 2 END)  AND pav.ProductId = @productID
	END
	IF @type IN( 'barcode','warehouseBarcode','expireBarcode')--88 barcode,135 [warehouseBarcode],136 [expireBarcode]
	BEGIN
	     SELECT @json = JSON_MODIFY(@json, 'append $', b.CustomValue)
		FROM ProductAttributeValue b WITH (NOLOCK)
		WHERE b.AttributeId = (CASE WHEN @type= 'barcode' THEN 88 WHEN @type='warehouseBarcode' THEN 135 ELSE 136 END)
				AND b.ProductId = @productID
		GROUP BY b.CustomValue;
	END
	IF @type IN( 'relatedHot','relatedReplace')
	BEGIN
	     SELECT @json = JSON_MODIFY(@json, 'append $', p.Code) 
		 FROM dbo.Product p WITH (NOLOCK) 
			INNER JOIN dbo.LinkedProduct lp WITH (NOLOCK) ON  p.id=lp.ProductId  		
			INNER JOIN dbo.ProductCategory pc WITH (NOLOCK) ON pc.ProductId = p.Id AND p.IsActive = 1 AND p.IsPublished=1
			INNER JOIN dbo.Category c  WITH (NOLOCK) ON pc.CategoryId = c.Id AND c.Level = 1 AND c.Id IN (814,821,812,811,810) AND c.Type = 0
			WHERE lp.LinkedProductId = @productID AND lp.LinkedType= (CASE WHEN @type='relatedHot' THEN 0 ELSE 1 END) 
			
			
	END
	IF @type =N'Categories'
	BEGIN
	    
		SELECT  @json = JSON_MODIFY(@json, 'append $',c.Name)
		FROM dbo.ProductCategory pc WITH (NOLOCK)
			INNER JOIN dbo.Category c WITH (NOLOCK) ON pc.CategoryId = c.Id
		WHERE pc.ProductId = @productID AND Type = 0
	
	END
	IF @type =N'Doi_Tuong'
	BEGIN
	    
		SELECT  @json = JSON_MODIFY(@json, 'append $',v.CustomValue)
		FROM dbo.ProductAttributeValue v WITH (NOLOCK)
		WHERE v.ProductId = @productID AND AttributeId = 10
	
	END
	IF @type='Ingredients'
	BEGIN
	    SELECT  @json = JSON_MODIFY(@json, 'append $',TRIM(CONCAT(Agg.Name,' ',Agg.Measure)))
		FROM (SELECT c.Name, pc.Value, pc.Value2, (CASE WHEN m.Name IS NULL THEN pc.DrugContent 
													ELSE CONCAT(pc.Value, '', m.Name) END) AS Measure
				FROM dbo.ProductCompounds pc
					INNER JOIN dbo.Compounds c ON pc.CompoundID = c.Id
					LEFT JOIN dbo.MeasureUnit m ON pc.MeasureUnits = m.Id
				WHERE c.SystemType = 10 AND pc.ProductID = @productID) Agg
	END
   
   SET @json = (CASE WHEN @json IN ('[]','[""]') THEN NULL ELSE @json end)
    RETURN @json;
END;
GO
