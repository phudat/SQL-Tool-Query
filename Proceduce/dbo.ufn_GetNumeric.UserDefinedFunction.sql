USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetNumeric]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufn_GetNumeric]
(
  @strAlphaNumeric VARCHAR(256)
)
RETURNS VARCHAR(256)
AS
BEGIN
  DECLARE @intAlpha INT
  SET @intAlpha = PATINDEX('%[^0-9- ^]%', @strAlphaNumeric)
  BEGIN
    WHILE @intAlpha > 0
    BEGIN
      SET @strAlphaNumeric = STUFF(@strAlphaNumeric, @intAlpha, 1, '' )
      SET @intAlpha = PATINDEX('%[^0-9- ^]%', @strAlphaNumeric )
    END
  END
  RETURN ISNULL(@strAlphaNumeric,0)
END
GO
