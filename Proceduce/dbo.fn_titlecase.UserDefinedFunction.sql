USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_titlecase]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_titlecase](@str as nvarchar(1000))
returns nvarchar(1000)
as
begin
	declare @bitval bit;
	declare @result nvarchar(1000);
	declare @i int;
	declare @j nchar(1);
	select @bitval = 1, @i=1, @result = '';
	while (@i <= len(@str))
		select @j= substring(@str,@i,1),
		@result = @result + case when @bitval=1 then UPPER(@j) else LOWER(@j) end,
		@bitval = case when @j like '[a-zA-Z]' then 0 else 1 end,
		@i = @i +1
	return @result
end
GO
