USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[RemoveNumericCharacters]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Function [dbo].[RemoveNumericCharacters](@Temp VarChar(1000))
Returns VarChar(1000)
AS
Begin

    Declare @NumRange as varchar(50) = '%[0-9]%'
    While PatIndex(@NumRange, @Temp) > 0
        Set @Temp = Stuff(@Temp, PatIndex(@NumRange, @Temp), 1, '')

    Return @Temp
End
GO
