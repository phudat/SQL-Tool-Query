USE [BW]
GO
/****** Object:  StoredProcedure [dbo].[SP_SOM_Report_PaymentServices_Real_API_GetData]    Script Date: 9/19/2022 2:36:25 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[SP_SOM_Report_PaymentServices_Real_API_GetData]
	  @TypeProvider INT,
      @URI VARCHAR(2000) = '',      
      @methodName VARCHAR(50) = '', 
      @requestBody VARCHAR(8000) = '', 
      @SoapAction VARCHAR(255), 
      @UserName NVARCHAR(100), -- Domain\UserName or UserName 
      @Password NVARCHAR(100), 
      @responseText NVARCHAR(MAX) OUTPUT,
      @scroll_id  VARCHAR(250) OUTPUT,
	  @hitsJS NVARCHAR(MAX) OUTPUT,
	  @UserExportRP VARCHAR(20)='28284'
AS		
PRINT @TypeProvider
DECLARE @ISDEBUG BIT  = 1, @StartTime DATETIME = GETDATE(),@URIscroll VARCHAR(100)= 'https://es03.fptshop.com.vn:9200/_search/scroll'
IF(@ISDEBUG =1) 
BEGIN 
	PRINT 'STep1:' + CAST( DATEDIFF(SS, @StartTime , GETDATE()) AS VARCHAR(20)); SET @StartTime = GETDATE() 	
END 

SET NOCOUNT ON
IF    @methodName = ''
BEGIN

      select FailPoint = 'Method Name must be set'
      RETURN
END

set   @responseText = 'FAILED'
DECLARE @providerName VARCHAR(50)
DECLARE @ResponseBody NVARCHAR(MAX)
DECLARE @objectID int
DECLARE @hResult int
DECLARE @source varchar(255), @desc varchar(255) 

IF @URI=@URIscroll
BEGIN
   
	BEGIN TRY
	    EXEC @hResult = sp_OACreate 'MSXML2.ServerXMLHTTP', @objectID OUT
	END TRY
	BEGIN CATCH		
		GOTO destroy 
		RETURN
	END CATCH
	
	
END
ELSE
BEGIN
    EXEC @hResult = sp_OACreate 'MSXML2.ServerXMLHTTP', @objectID OUT
END
IF @hResult <> 0 
BEGIN
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = convert(varbinary(4), @hResult), 
                  source = @source, 
                  description = @desc, 
                  FailPoint = 'Create failed', 
                  MedthodName = @methodName 	
      goto destroy 	  
      RETURN
END
--ignore ssl
EXEC @hResult= sp_OAMethod @objectID,'setOption',null, 2, 13056
PRINT 'ignore ssl'
-- open the destination URI with Specified method 
EXEC @hResult = sp_OAMethod @objectID, 'open', null, @methodName, @URI, 'false', @UserName, @Password
--EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', NULL, 'Authorization',@UserName, @Password
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', NULL,@UserName, @Password
--PRINT 'set Header Success'
IF @hResult <> 0 
BEGIN	
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = convert(varbinary(4), @hResult), 
            source = @source, 
            description = @desc, 
            FailPoint = 'Open failed', 
            MedthodName = @methodName 
			
      goto destroy 	  
      RETURN
END
-- set request headers 
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Type', 'application/json'
IF @hResult <> 0 
BEGIN
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = convert(varbinary(4), @hResult), 
            source = @source, 
            description = @desc, 
            FailPoint = 'SetRequestHeader failed', 
            MedthodName = @methodName 			
			PRINT '@hResult <> 0 '
      goto destroy 	  
      RETURN
END

declare @len int
set @len = len(@requestBody) 
EXEC @hResult = sp_OAMethod @objectID, 'setRequestHeader', null, 'Content-Length', @len 
IF @hResult <> 0
BEGIN	
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = convert(varbinary(4), @hResult), 
            source = @source, 
            description = @desc, 
            FailPoint = 'SetRequestHeader failed2', 
            MedthodName = @methodName 
			PRINT '@hResult <> 0 1'
      goto destroy 	 
      RETURN
END
--Exec sp_OAMethod @objectID, 'setRequestBody', null, 'Body', @requestBody
-- send the request 

EXEC @hResult = sp_OAMethod @objectID, 'send', NULL , @requestBody
IF    @hResult <> 0 
BEGIN	
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = CONVERT(VARBINARY(4), @hResult), 
            source = @source, 
            description = @desc, 
            FailPoint = 'Send failed', 
            MedthodName = @methodName 
		PRINT '@hResult <> 0 2'	
      GOTO destroy 	   
      RETURN
END
DECLARE @statusText VARCHAR(1000), @status VARCHAR(1000) 
-- Get status text 
EXEC sp_OAGetProperty @objectID, 'StatusText', @statusText OUT
EXEC sp_OAGetProperty @objectID, 'Status', @status OUT
IF(@ISDEBUG =1) BEGIN PRINT 'STep2:' + CAST( DATEDIFF(SS, @StartTime , GETDATE()) AS VARCHAR(20)); SET @StartTime = GETDATE() END 
--- Changed the call : removed @strLine OUtPUT
CREATE TABLE #tmp(dt NVARCHAR(MAX))
INSERT INTO #tmp 
EXEC @hResult =sp_OAGetProperty @objectID, 'ResponseText' 
IF(@ISDEBUG =1) BEGIN PRINT 'STep3:' + CAST( DATEDIFF(SS, @StartTime , GETDATE()) AS VARCHAR(20)); SET @StartTime = GETDATE() END 
---
SET @responseText = (SELECT  TOP 1 dt FROM #tmp)
PRINT @responseText
DROP TABLE #tmp -- clean up
IF @hResult <> 0 
BEGIN
      EXEC sp_OAGetErrorInfo @objectID, @source OUT, @desc OUT
      SELECT      hResult = CONVERT(VARBINARY(4), @hResult), 
            source = @source, 
            description = @desc, 
            FailPoint = 'ResponseText failed', 
            MedthodName = @methodName 
			PRINT '@hResult <> 0 4'
      GOTO destroy 
      RETURN
END
destroy: 



 
DECLARE @xxx NVARCHAR(MAX), @request VARCHAR(8000)
--==Payoo==--

BEGIN
    IF @URI!=@URIscroll
	BEGIN
	
	PRINT '--------------------------------------------------'
	INSERT INTO  [dbo].SOM_Report_PaymentServices_Tmp
	(
	    TotalValue,
	    scroll_id,
		TypeProvider,
	    UserExportRP,
	    billNo,
		paymentVoucherCode,
	    totalAmountIncludingFee,
	    creationTime,
	    region,
	    warehouseCode,
	    warehouseName,
	    productTransId,
	    orderStatus,
	    integrationRequestId,
		lastModificationTime,
		cancelBy,
		reason
	)	
    SELECT  js.TotalValue,js.scroll_id,@TypeProvider,@UserExportRP,a.*	
	FROM OPENJSON(@responseText)  
	WITH (
		TotalValue NVARCHAR(MAX) '$.hits.total.value',
		scroll_id VARCHAR(250) '$._scroll_id',		
		hitsJS NVARCHAR(MAX) '$.hits.hits' AS json 
	) AS js
	outer apply openjson( hitsJS ) 
    with ( 
		billNo VARCHAR(50) '$._source.billNo',
		paymentVoucherCode VARCHAR(50) '$._source.paymentVoucherCode',
		totalAmountIncludingFee float '$._source.indexingOrderTransactions[0].totalAmountIncludingFee' ,
		creationTime VARCHAR(50) '$._source.creationTime' ,
		region  VARCHAR(50) '$._source.region' ,
		warehouseCode VARCHAR(50) '$._source.warehouseCode' ,
		warehouseName NVARCHAR(250) '$._source.warehouseName',
		productTransId VARCHAR(50) '$._source.productTransId' ,
		orderStatus NVARCHAR(50) '$._source.orderStatus',
		integrationRequestId VARCHAR(50) '$._source.integrationRequestId',
		lastModificationTime VARCHAR(50) '$._source.lastModificationTime',
		cancelBy VARCHAR(50) '$._source.cancelBy',
		reason NVARCHAR(500) '$._source.reason'
    )a

	
	SELECT TOP 1 @scroll_id=scroll_id FROM SOM_Report_PaymentServices_Tmp
	SELECT  @hitsJS=js.hitsJS	
	FROM OPENJSON(@responseText)  
	WITH (hitsJS NVARCHAR(MAX) '$.hits.hits' AS json ) AS js
	
	
END
	ELSE
	BEGIN
		PRINT @responseText
		IF ISNULL(@responseText,'FAILED')!='FAILED'
		BEGIN
	
			SELECT  @hitsJS=js.hitsJS	
			FROM OPENJSON(@responseText)  
			WITH (hitsJS NVARCHAR(MAX) '$.hits.hits' AS json ) AS js
			--outer apply openjson( hitsJS )
			PRINT ISNULL(@hitsJS,'')+' ----------@hitsJS'
			IF @hitsJS!='[]'
			BEGIN

				INSERT INTO  [dbo].SOM_Report_PaymentServices_Tmp
				(
					TotalValue,
					scroll_id,
					TypeProvider,
					UserExportRP,
					billNo,
					paymentVoucherCode,
					totalAmountIncludingFee,
					creationTime,
					region,
					warehouseCode,
					warehouseName,
					productTransId,
					orderStatus,
					integrationRequestId,
					lastModificationTime,
					cancelBy,
					reason
				)	
				SELECT  js.TotalValue,js.scroll_id,@TypeProvider,@UserExportRP,a.*	
				FROM OPENJSON(@responseText)  
				WITH (
					TotalValue NVARCHAR(MAX) '$.hits.total.value',
					scroll_id VARCHAR(250) '$._scroll_id',		
					hitsJS NVARCHAR(MAX) '$.hits.hits' AS json 
				) AS js
				outer apply openjson( hitsJS ) 
				with ( 
					billNo VARCHAR(50) '$._source.billNo',
					paymentVoucherCode VARCHAR(50) '$._source.paymentVoucherCode',
					totalAmountIncludingFee float '$._source.indexingOrderTransactions[0].totalAmountIncludingFee' ,
					creationTime VARCHAR(50) '$._source.creationTime' ,
					region  VARCHAR(50) '$._source.region' ,
					warehouseCode VARCHAR(50) '$._source.warehouseCode' ,
					warehouseName NVARCHAR(250) '$._source.warehouseName',
					productTransId VARCHAR(50) '$._source.productTransId' ,
					orderStatus NVARCHAR(50) '$._source.orderStatus',
					integrationRequestId VARCHAR(50) '$._source.integrationRequestId',
					lastModificationTime VARCHAR(50) '$._source.lastModificationTime',
					cancelBy VARCHAR(50) '$._source.cancelBy',
					reason NVARCHAR(500) '$._source.reason'
				)a
			END
	
			SELECT TOP 1 @scroll_id=scroll_id FROM SOM_Report_PaymentServices_Tmp
			SELECT  @hitsJS=js.hitsJS	
			FROM OPENJSON(@responseText)  
			WITH (hitsJS NVARCHAR(MAX) '$.hits.hits' AS json ) AS js
			----outer apply openjson( hitsJS )
	
		END
		ELSE
		BEGIN 
		PRINT 'SET @ISDEBUG =1'
			SET @hitsJS='[]'
			SET @ISDEBUG =1
		END
	
	
	END
END



IF(@ISDEBUG =1) BEGIN PRINT 'STep4:' + CAST( DATEDIFF(SS, @StartTime , GETDATE()) AS VARCHAR(20)); SET @StartTime = GETDATE() END 
IF(@ISDEBUG =1) BEGIN PRINT 'STep5:' + CAST( DATEDIFF(SS, @StartTime , GETDATE()) AS VARCHAR(20)); SET @StartTime = GETDATE() END 

     exec sp_OADestroy @objectID 

SET NOCOUNT OFF
