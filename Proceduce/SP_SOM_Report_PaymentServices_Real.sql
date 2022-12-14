USE [BW]
GO
/****** Object:  StoredProcedure [dbo].[SP_SOM_Report_PaymentServices_Real]    Script Date: 9/19/2022 2:36:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*====================================================================
Author					:		Datnp5
Create date				:		03/03/2022 10:04:53
Description				:		
EXEC dbo.SP_SOM_Report_PaymentServices_Real @TypeReport = 1,          -- int
                                            @TypeProvider = 1,        -- int
                                            @BillStatus = '',         -- varchar(20)
                                            @FromDate = '2022-03-08', -- date
                                            @ToDate = '2022-03-08',   -- date
                                            @size = 10000,            -- int
											@UserExportRP ='28284'    --VARCHAR(20) 
====================================================================*/



ALTER PROCEDURE [dbo].[SP_SOM_Report_PaymentServices_Real]
(
	@TypeReport	INT =1,--1 ngay thu, ngay chi
	@TypeProvider INT,-- 1payoo,2smartpay,3viettel,4ftel,5momo,6viettelpay,7vietjet,8Vinasure,9zalopay
	@BillStatus VARCHAR(20) ='',
	@FromDate DATE,
	@ToDate DATE,
	@size INT,
	@UserExportRP VARCHAR(20) ='28284'
)
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY
		DECLARE @Body NVARCHAR(MAX),@source NVARCHAR(MAX),@xxx NVARCHAR(MAX),@providerId VARCHAR(250)
		--set size
		IF ISNULL(@size,0)=0
		BEGIN
		    SET @size= 10000
		END
		--set @providerId--==payoo==--	
		SET @providerId= CASE @TypeProvider WHEN 1 THEN 'a6f07639-83a1-45fd-a0e0-85217ff75de2' --payoo
											WHEN 2 THEN '32587075-cbaa-4afc-a6b5-fe2c5299a38f' --smartpay
											WHEN 3 THEN '67defced-5f16-4ba9-9db8-5eac8fe9df68' --viettel
											WHEN 4 THEN 'cd976dc0-07f9-4351-a82c-95e4460e2b1b' --ftel
											WHEN 5 THEN 'd37f26c5-a7ea-45ca-98c4-6a91be8055c4' --momo
											--WHEN 6 THEN '8a7a2eee-d5e8-47bd-9e4d-effa0171873e' --viettelpay
											WHEN 7 THEN '8a7a2eee-d5e8-47bd-9e4d-effa0171873e' --vietjet
											WHEN 8 THEN 'b58718ec-7e02-4e59-b591-2f3e5cb06249' --Vinasure
											WHEN 9 THEN '1cf7809a-ae90-4a02-8f72-de4c6705b941' --zalopay
											END                                            
		
		SET @source =N'"_source": [
								"billNo",
								"paymentVoucherCode",
								"indexingOrderTransactions.totalAmountIncludingFee",
								"creationTime",
								"region",
								"warehouseCode",
								"warehouseName",
								"productTransId",
								"orderStatus",
								"integrationRequestId",
								"paymentVoucherCode",
								"lastModificationTime",
								"reason",
								"cancelBy"
							],'
		
		--valid fromdate, todate
		IF (@FromDate='' OR @Todate='')
		BEGIN
			SET @FromDate= FORMAT (GETDATE(), 'yyyy-MM-dd')
			SET @ToDate =FORMAT (GETDATE(), 'yyyy-MM-dd')
		END
		ELSE
		BEGIN
			SET @FromDate= FORMAT (@FromDate, 'yyyy-MM-dd') 
			SET @ToDate= FORMAT (@ToDate, 'yyyy-MM-dd') 
		END
		BEGIN
		    SET @Body = N'{
							'+@source+'
							"query": {
								"bool": {
									"filter": [ {
										"range": {
											"creationTime": {
												"gte": "'+CAST(@FromDate AS VARCHAR(20))+'T00:00:00",
												"lte": "'+CAST(@ToDate AS VARCHAR(20))+'T23:59:59"
											}
										}
									}],
									"must": [
										{"exists": {"field": "paymentVoucherCode"}},
										{
											"nested": {
												"path": "indexingOrderTransactions",
												"query": {
													"bool": {
														"must": [{
															"match": {
																"indexingOrderTransactions.providerId": {
																	"query": "'+@providerId+'"
																}
															}}]                          
													}
												}
											}
										}] 
									}
							},
							"size": '+CAST(@size AS VARCHAR(10))+',
							"sort": [{
								"creationTime": {
									"order": "desc"
								}
							}]
										  
						}'

			
		END
		PRINT @Body
		--RETURN
		DECLARE @scroll_id  VARCHAR(250),@hitsJS NVARCHAR(MAX),@request NVARCHAR(MAX),@URIscroll VARCHAR(100)='https://es03.fptshop.com.vn:9200/_search/scroll'		
		BEGIN		   
			EXEC SP_SOM_Report_PaymentServices_Real_API_GetData @TypeProvider=@TypeProvider, @URI= 'https://es03.fptshop.com.vn:9200/frt_som_order_alias/_search?scroll=2m&pretty=true&filter_path=took,%20_scroll_id,hits.total,hits.hits._source'
			,@methodName='POST',@requestBody= @Body,@SoapAction= '', @UserName='Authorization',@Password='Basic ZnJ0X2ZwdHNob3A6ZnB0c2hvcDIwMjFFUw==',@responseText =@xxx OUTPUT, @scroll_id=@scroll_id OUTPUT, @hitsJS=@hitsJS OUTPUT,@UserExportRP=@UserExportRP
		END		
		WHILE @hitsJS != '[]'
		BEGIN
			
			SET @request ='{
			  "scroll":"2m",
			  "scroll_id": "'+@scroll_id+'"
			}' 
			PRINT 'chay vo buowc 2: '+ISNULL(@request,'') +' -----'
		   DECLARE @responseText NVARCHAR(MAX),
		           @scroll_id1 VARCHAR(250),
		           @hitsJS1 NVARCHAR(MAX);
		   EXEC dbo.SP_SOM_Report_PaymentServices_Real_API_GetData @TypeProvider = @TypeProvider,                            -- int
		                                                       @URI = @URIscroll,                            -- varchar(2000)
		                                                       @methodName = 'POST',                     -- varchar(50)
		                                                       @requestBody = @request,                    -- varchar(8000)
		                                                       @SoapAction = '',                     -- varchar(255)
		                                                       @UserName = N'Authorization',                      -- nvarchar(100)
		                                                       @Password = N'Basic ZnJ0X2ZwdHNob3A6ZnB0c2hvcDIwMjFFUw==',                      -- nvarchar(100)
		                                                       @responseText = @xxx OUTPUT, -- nvarchar(max)
		                                                       @scroll_id = @scroll_id1 OUTPUT,      -- varchar(250)
		                                                       @hitsJS = @hitsJS1 OUTPUT             -- nvarchar(max)
															   ,@UserExportRP=@UserExportRP
		  
			SET @hitsJS=@hitsJS1
			
		END;
		
		--==// result \\==--
		
		SELECT * INTO #tempquanhuyen FROM dbo.SOM_QuanHuyen WITH ( NOLOCK );
		SELECT * INTO #temptinhthanh FROM dbo.SOM_TinhThanh WITH ( NOLOCK );
		SELECT a.WarehouseCodeB1, a.WarehouseName,c.[Name] AS Place,C.ID AS ProvinceId INTO #tempwareplace  FROM  Warehouse A WITH ( NOLOCK ) 
		INNER JOIN #tempquanhuyen B ( NOLOCK ) ON A.QuanHuyen = B.ID
		INNER JOIN #temptinhthanh C ( NOLOCK ) ON B.CityID = C.ID
        
	
		BEGIN
			--CREATE TABLE [#tmp_doc_urct]
			--(
			--norow INT ide
			--[paymentVoucherCode] VARCHAR(50)
			--)
			SELECT paymentVoucherCode INTO #tmp_doc_urct FROM [dbo].[SOM_Report_PaymentServices_Tmp] WHERE UserExportRP=@UserExportRP AND TypeProvider=@TypeProvider
			SELECT DocEntry,U_AcDate,U_MoCash INTO #tmp_urct FROM [10.1.13.71].FRT_POS.dbo.[@FPTURCT] WITH (NOLOCK) WHERE DocEntry IN (SELECT paymentVoucherCode FROM #tmp_doc_urct  )
			DROP TABLE #tmp_doc_urct
			SELECT 
				tp.Place [Tỉnh],
				r.warehouseCode [Mã Shop],
				r.warehouseName [Tên Shop],
				r.lastModificationTime [Ngày Hủy],
				CASE WHEN ISNULL((SELECT dbo.TinhTrangSOM(orderStatus)),'') = '' THEN  orderStatus ELSE (SELECT dbo.TinhTrangSOM(orderStatus)) END AS	[Tình Trạng],
				r.billNo [Số Phiếu],
				r.productTransId [Mã Giao Dịch NCC],
				r.paymentVoucherCode [Mã Phiếu Chi],
				r.totalAmountIncludingFee [Số Tiền Thu],
				CAST(u.U_MoCash AS FLOAT) [Số tiền hoàn trả],
				CAST(u.U_MoCash AS FLOAT) [Số Tiền Điều Chỉnh],
				r.reason [Lý do hủy],
				r.cancelBy [User Yêu Cầu Hủy],
				CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000' [Ngày tạo phiếu thu],
				CASE WHEN u.U_MoCash=r.totalAmountIncludingFee THEN N'Hủy hết' ELSE N'Hủy 1 phần' END [NCC trả kết quả]
			FROM [dbo].[SOM_Report_PaymentServices_Tmp] r WITH (NOLOCK) 
				LEFT JOIN #tempwareplace tp ON r.warehouseCode=tp.WarehouseCodeB1
				LEFT JOIN #tmp_urct u ON r.paymentVoucherCode=u.DocEntry
			WHERE r.TypeProvider=@TypeProvider AND r.UserExportRP=@UserExportRP
			DELETE [dbo].[SOM_Report_PaymentServices_Tmp] WHERE UserExportRP=@UserExportRP AND TypeProvider=@TypeProvider
		END
		DROP TABLE #tempquanhuyen,#temptinhthanh, #tempwareplace;
	END TRY
	BEGIN CATCH
		
		INSERT INTO dbo.SOM_Report_Collection
		    (
		         CreateDateTime
		       , CreateBy
		       , Content
		    )
		VALUES
		    (
		         GETDATE()
		       , N'SP_SOM_Report_Collection_Real'
		       , N'Lỗi EXEC [SP_SOM_Report_Collection_Real]  @Type'+ CAST(@TypeProvider AS VARCHAR(10))+N', @FromDate: '+CAST(@FromDate AS VARCHAR(50))+N', @ToDate '+CAST(@ToDate AS VARCHAR(50))+N'. - Err: ' + ERROR_MESSAGE() + ' Line: ' + CONVERT(VARCHAR, ERROR_LINE())
		    )
	END CATCH
END

