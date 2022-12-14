USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_indications]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[fn_get_indications] (@productId INT, @type int) RETURNS NVARCHAR(max)
	BEGIN
			--DECLARE @id INT =308523
		DECLARE  @temptable TABLE ( [No1] bigint, [name] nvarchar(max), Slug NVARCHAR(max),[Type] SMALLINT,SystemType INT, ShortDescription NVARCHAR(1000) )
		DECLARE @json_result NVARCHAR(max) ='['
		DECLARE @no INT , @name NVARCHAR(500) ='', @Slug NVARCHAR(max) ='',@SystemType INT, @ShortDescription NVARCHAR(1000) =''
	
		INSERT INTO @temptable (No1,[name],Slug,[Type],SystemType,ShortDescription)	
		SELECT  ROW_NUMBER() OVER(ORDER BY [name],Slug ASC) AS No1, [name], d.Slug,pd.Type,d.SystemType,d.ShortDescription FROM dbo.ProductDiseases pd WITH (NOLOCK) 
		INNER JOIN dbo.Diseases d WITH (nolock) ON pd.DiseasesID = d.id WHERE pd.ProductID = @productId and pd.TYPE=@type
		--SET @json_result = (SELECT CAST(SUM(No1) as varchar(20)) FROM @temptable )
		WHILE (SELECT COUNT(1) FROM @temptable ) > 0
		BEGIN
			SELECT TOP 1 @no=No1, @name=[name],@Slug=Slug,@SystemType=SystemType,@ShortDescription=ShortDescription FROM @temptable ORDER BY No1
			IF @type=0--indications
			BEGIN			    
				SET @json_result = @json_result + N'{"name": "'+@name+'","slug":"'+@Slug+'","type":"'+CAST(@Type AS VARCHAR(20))+'","systemType":"'+CAST(@SystemType AS VARCHAR(20))+'","shortDescription":"'+@ShortDescription+'"},'
				DELETE @temptable WHERE No1=@no
			END
			ELSE--contraindications
            BEGIN               
				SET @json_result = @json_result + N'{"name": "'+@name+'","slug":"'+@Slug+'","type":"'+CAST(@Type AS VARCHAR(20))+'","systemType":"'+CAST(@SystemType AS VARCHAR(20))+'","shortDescription":"'+@ShortDescription+'"},'
				DELETE @temptable WHERE No1=@no
            END			
		END	

	
		SET @json_result = CASE WHEN @json_result='[' OR ISNULL(@json_result,'')='' THEN '[]' ELSE  substring(@json_result, 1, (len(@json_result) - 1)) + ']' end
		RETURN @json_result
	END
	


--SELECT TOP 10 * FROM dbo.Compounds WITH (NOLOCK) WHERE ID = 
GO
