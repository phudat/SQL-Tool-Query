USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fnStringToAscii]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnStringToAscii]
(
  @Value AS NVARCHAR(4000)
)
RETURNS
  VARCHAR(8000) 
AS
BEGIN
IF (@Value IS NULL OR DATALENGTH(@Value) = 0)
  RETURN ''

DECLARE @Index  INT
DECLARE @Result VARCHAR(8000)

SET @Result = ''
SET @Index  = 1

WHILE (@Index <= DATALENGTH(@Value))
BEGIN
  SET @Result = @Result + dbo.fnCharToAscii(SUBSTRING(@Value, @Index, 1))
  SET @Index = @Index + 1   
END

RETURN @Result
END
GO
