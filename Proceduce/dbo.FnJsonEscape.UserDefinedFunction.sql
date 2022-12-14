USE [BW]
GO
/****** Object:  UserDefinedFunction [dbo].[FnJsonEscape]    Script Date: 9/19/2022 2:47:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FnJsonEscape](@val nvarchar(max) )

returns nvarchar(max)

as begin

 

if (@val is null) return 'null'
if (TRY_PARSE( @val as float) is not null) return @val
set @val=replace(@val,'\','\\')
set @val=replace(@val,'"','\"')

return '"'+@val+'"'

end

GO
