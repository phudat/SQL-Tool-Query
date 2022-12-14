USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_synonyms]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	CREATE FUNCTION [dbo].[fn_get_synonyms] (@id INT) RETURNS NVARCHAR(max)
	BEGIN
			--DECLARE @id INT =308523
		DECLARE  @temptable TABLE ( [No1] bigint, [name] nvarchar(max), [slug] nvarchar(max) )
		DECLARE @json_result NVARCHAR(max) ='['
		DECLARE @no INT, @name NVARCHAR(500), @slug NVARCHAR(500)	
	
		INSERT INTO @temptable (No1,name,slug)	
		SELECT  ROW_NUMBER() OVER(ORDER BY synonym1 ASC) AS No1, dbo.GetUnsignString(synonym1) [name], LOWER(REPLACE(dbo.GetUnsignString(synonym1),' ', '-')) slug 
		FROM OPENJSON((SELECT JSON_VALUE(ExtraProperties,'$.synonyms')  FROM dbo.Compounds c WITH (NOLOCK) WHERE ID = @id),'$.synonym')
		WITH( synonym1 VARCHAR(max) '$' )
		WHILE (SELECT COUNT(1) FROM @temptable ) > 1
		BEGIN
			SELECT TOP 1 @no=No1,@name=[name], @slug = slug  FROM @temptable ORDER BY No1
			SET @json_result = @json_result + N'{"name": "'+@name+'","slug": "'+@slug+'"},'
			DELETE @temptable WHERE No1=@no
		END	

	
		SET @json_result = CASE WHEN @json_result='[' THEN '[]' ELSE  substring(@json_result, 1, (len(@json_result) - 1)) + ']' end
		RETURN @json_result
	END
	


--SELECT TOP 10 * FROM dbo.Compounds WITH (NOLOCK) WHERE ID = 
GO
