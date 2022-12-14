USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveExtraChars]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[RemoveExtraChars] ( @p_OriginalString varchar(50) )
returns varchar(50) as
begin

  declare @i int = 1;  -- must start from 1, as SubString is 1-based
  declare @OriginalString varchar(100) = @p_OriginalString Collate SQL_Latin1_General_CP1253_CI_AI;
  declare @ModifiedString varchar(100) = '';

  while @i <= Len(@OriginalString)
  begin
    if SubString(@OriginalString, @i, 1) like '[a-Z]'
    begin
      set @ModifiedString = @ModifiedString + SubString(@OriginalString, @i, 1);
    end
    set @i = @i + 1;
  end

  return @ModifiedString

end
GO
