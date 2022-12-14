USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_StripHTML]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[udf_StripHTML] (@HTMLText NVARCHAR(MAX))
RETURNS NVARCHAR(MAX)
AS
     BEGIN
         DECLARE @Start INT;
         DECLARE @End INT;
         DECLARE @Length INT;
         SET @Start = CHARINDEX('<', @HTMLText);
         SET @End = CHARINDEX('>', @HTMLText, CHARINDEX('<', @HTMLText));
         SET @Length = (@End - @Start) + 1;
         WHILE @Start > 0
               AND @End > 0
               AND @Length > 0
             BEGIN
                 SET @HTMLText = STUFF(@HTMLText, @Start, @Length, '');
                 SET @Start = CHARINDEX('<', @HTMLText);
                 SET @End = CHARINDEX('>', @HTMLText, CHARINDEX('<', @HTMLText));
                 SET @Length = (@End - @Start) + 1;
             END;
         RETURN LTRIM(RTRIM(@HTMLText));
     END;
GO
