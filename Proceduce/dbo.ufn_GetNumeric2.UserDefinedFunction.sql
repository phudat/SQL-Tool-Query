USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetNumeric2]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufn_GetNumeric2]
(
  @strAlphaNumeric NVARCHAR(256)
)
RETURNS NVARCHAR(256)
AS
BEGIN
	if @strAlphaNumeric is null or @strAlphaNumeric='' return null; 
	declare @len int = len(@strAlphaNumeric);
	declare @i int=1;
	while @i<= @len
	begin
		if SUBSTRING(@strAlphaNumeric, @i,1) like N'[0-9- ^.,<≤>≥=]'
			set @i=@i+1;
		else 
			return SUBSTRING(@strAlphaNumeric, 1,@i-1);
	end;
	if SUBSTRING(@strAlphaNumeric, 1,1) like N'[0-9- ^.,<≤>≥=]'
		return @strAlphaNumeric;
	
	return null;
END
GO
