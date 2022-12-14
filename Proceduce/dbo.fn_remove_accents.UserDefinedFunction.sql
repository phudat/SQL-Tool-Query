USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_remove_accents]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--DROP FUNCTION IF EXISTS fn_remove_accents;
   
    CREATE FUNCTION [dbo].[fn_remove_accents]( @textvalue NVARCHAR(max) ) 
	RETURNS VARCHAR(max)
	AS
    BEGIN


		DECLARE @withaccents nchar(136),@withoutaccents nchar(136),@special nchar(136), @count  int

        -- ACCENTS
        SET @withaccents = 'ŠšŽžÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔÕÖØÙÚÛÜÝŸÞàáâãäåæçèéêëìíîïñòóôõöøùúûüýÿþƒ';
        SET @withoutaccents = 'SsZzAAAAAAACEEEEIIIINOOOOOOUUUUYYBaaaaaaaceeeeiiiinoooooouuuuyybf';
        SET @count = LEN(@withaccents);

        WHILE @count > 0
		BEGIN
            SET @textvalue = REPLACE(@textvalue, SUBSTRING(@withaccents, @count, 1), SUBSTRING(@withoutaccents, @count, 1));
            SET @count = @count - 1;
        END 

        -- SPECIAL CHARS
        SET @special = '!@#$%¨&*()_+=§¹²³£¢¬"`´{[^~}]<,>.:;?/°ºª+*|\\''';
        SET @count = LEN(@special);

        WHILE @count > 0 
		BEGIN
            SET @textvalue = REPLACE(@textvalue, SUBSTRING(@special, @count, 1), '');
            SET @count = @count - 1;
        END

        RETURN @textvalue;

    END
    
   
GO
