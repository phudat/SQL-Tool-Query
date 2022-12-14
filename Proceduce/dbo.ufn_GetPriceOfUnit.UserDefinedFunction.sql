USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetPriceOfUnit]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[ufn_GetPriceOfUnit]
(
  @productId int
)
RETURNS DECIMAL (18,2)
AS
BEGIN
	DECLARE @result  DECIMAL (18,2), @maxlevle INT = (SELECT MAX(Level) FROM ProductMeasureUnit WITH (NOLOCK) WHERE ProductId=@productId )
  SET @result = (SELECT TOP 1 (p.BasePrice)/ISNULL(mr.Ratio,1) from  dbo.Product p WITH (NOLOCK) 
	INNER JOIN dbo.ProductMeasureUnit pmu ON p.id=pmu.ProductId --and pmu.Level = @maxlevle
	INNER JOIN dbo.MeasureRate mr ON mr.Id = pmu.MeasureRateId 
	INNER JOIN dbo.MeasureUnit mu ON mu.Id = mr.FromMeasureId
	WHERE  p.id =@productId AND pmu.Is_Default=1)
  RETURN ISNULL(@result,0)
END
GO
