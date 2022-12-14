USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_get_rootidcate]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
	Create FUNCTION [dbo].[fn_get_rootidcate] (@Id INT) RETURNS int
	BEGIN
		DECLARE @parent_id INT;
		WITH parent AS
		(
			SELECT id, ParentCategoryId from dbo.Category WHERE id = @id
			UNION ALL 
			SELECT t.id, t.ParentCategoryId FROM parent
			INNER JOIN dbo.Category t ON t.id =  parent.ParentCategoryId
		)
		SELECT @parent_id=parent.Id FROM parent WHERE parent.ParentCategoryId =0;
		RETURN @parent_id
	END
	


--SELECT TOP 10 * FROM dbo.Compounds WITH (NOLOCK) WHERE ID = 
GO
