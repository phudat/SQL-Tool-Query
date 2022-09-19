USE [CRM-Event-Monitor]
GO
/****** Object:  StoredProcedure [dbo].[SP_Job_Monitor_for_NHDV]    Script Date: 9/19/2022 3:40:07 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*====================================================================
Author					:		Datnp5
Create date				:		02/04/2020 10:45:18
Description				:		EXEC dbo.SP_Job_Monitor_for_NHDV @type = '' -- varchar(20)
EXEC dbo.SP_Job_Monitor_for_NHDV @type = 'MoMo' -- varchar(20)
job depend on 
====================================================================*/


ALTER PROC [dbo].[SP_Job_Monitor_for_NHDV]	
@type VARCHAR(20) =''
AS	
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(4000) = N'EXEC dbo.SP_SOM_Scan_Transcation_Waiting'
	EXEC sys.sp_executesql @SQL
	DECLARE @hour SMALLINT =DATEPART(hour, GETDATE()),@FromDate VARCHAR(40),@ToDate VARCHAR(40),@Title NVARCHAR(250),@Content NVARCHAR(max),@Subject NVARCHAR(250)
	
	IF @hour < 8 AND @type !='MoMo'
	BEGIN
	    SET @FromDate =CONVERT(VARCHAR(40),GETDATE()-1, 23)+ ' 00:00:00.000'
		SET @ToDate = CONVERT(VARCHAR(40),GETDATE(), 23)+  ' 12:00:00.000'
		SET @Type=''
		SET @Title=N'MONITOR CÁC PHIẾU THẺ CÀO / THU HỘ CHỜ DUYỆT HỦY'
		SET @Subject = N'[NHDV] Monitor các phiếu thu hộ đang chờ duyệt / timeout NCC'
		SET @Content =N'<h5>Dear anh/chị Ngành hàng,<br />Hiện tại phát sinh một số giao dịch tình trạng chờ duyệt hủy, chưa nhận được kết quả cuối. Nhờ anh chị hổ trợ kiểm lại cùng nhà cung cấp và khách hàng.</h5>'
	END
	IF @hour < 8 AND @type ='MoMo'
	BEGIN
	    SET @FromDate =CONVERT(VARCHAR(40),GETDATE()-1, 23)+ ' 00:00:00.000'
		SET @ToDate = CONVERT(VARCHAR(40),GETDATE(), 23)+  ' 08:00:00.000'
		SET @Type='MoMo'
		SET @Title=N'GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Subject = N'[MOMO] – GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Content =N'<h5>Dear anh/chị MoMo, Shop, Ngành hàng, QA và CSKH, <br />Hiện tại phát sinh một số giao dịch tình trạng chờ duyệt hủy, chưa nhận được kết quả cuối. Nhờ anh chị hổ trợ kiểm lại cùng nhà cung cấp và khách hàng.<br /><br />
		Anh, chị vui lòng phản hồi kết quả xử lý trong 48h theo cam kết của 2 bên.</br></br>
		Anh, chị khối Shop, Ngành hàng, CSKH, Support tiếp nhận thông tin từ nhà cung cấp và xử lý tiếp theo quy trình.</br></br></h5>'
	END
	IF @hour>8 AND @hour<12 AND @type ='MoMo'
	BEGIN
	    SET @FromDate =  CONVERT(VARCHAR(40),GETDATE(), 23)+  ' 08:00:00.000'
		SET @ToDate =CONVERT(VARCHAR(40),GETDATE(), 23)+ ' 12:00:00.000'
		SET @Type='MoMo'
		SET @Title=N'GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Subject = N'[MOMO] – GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Content =N'<h5>Dear anh/chị MoMo, Shop, Ngành hàng, QA và CSKH, <br />Hiện tại phát sinh một số giao dịch tình trạng chờ duyệt hủy, chưa nhận được kết quả cuối. Nhờ anh chị hổ trợ kiểm lại cùng nhà cung cấp và khách hàng.<br /><br />
		Anh, chị vui lòng phản hồi kết quả xử lý trong 48h theo cam kết của 2 bên.</br></br>
		Anh, chị khối Shop, Ngành hàng, CSKH, Support tiếp nhận thông tin từ nhà cung cấp và xử lý tiếp theo quy trình.</br></br></h5>'
	END
	IF @hour>12 AND @type ='MoMo'
	BEGIN
	    SET @FromDate = CONVERT(VARCHAR(40),GETDATE(), 23)+ ' 12:00:00.000'
		SET @ToDate = CONVERT(VARCHAR(40),GETDATE(), 23)+' 18:00:00.000'
		SET @Type='MoMo'
		SET @Title=N'[MOMO] – GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Subject = N'GIAO DỊCH NẠP TIỀN MOMO CHỜ DUYỆT HỦY'
		SET @Content =N'<h5>Dear anh/chị MoMo, Shop, Ngành hàng, QA và CSKH, <br />Hiện tại phát sinh một số giao dịch tình trạng chờ duyệt hủy, chưa nhận được kết quả cuối. Nhờ anh chị hổ trợ kiểm lại cùng nhà cung cấp và khách hàng.<br /><br />
		Anh, chị vui lòng phản hồi kết quả xử lý trong 48h theo cam kết của 2 bên.</br></br>
		Anh, chị khối Shop, Ngành hàng, CSKH, Support tiếp nhận thông tin từ nhà cung cấp và xử lý tiếp theo quy trình.</br></br></h5>'
	END	
	
	CREATE TABLE 
	#Tmp_sendmailwaiting(bill VARCHAR(50), ncc NVARCHAR(100), dvcc NVARCHAR(100), loaidv NVARCHAR(100),trangthai Nvarchar(100),magiaodich varchar(100),
	 makh NVARCHAR(100), tongtien VARCHAR(20), ngaytao DATETIME, nhanvien NVARCHAR(100), email VARCHAR(100),mashop NVARCHAR(250),lydohuy NVARCHAR(100),magdncc varchar(100))
	
	 IF @type ='MoMo'
	 BEGIN
	      INSERT INTO #Tmp_sendmailwaiting
			(
				bill,
				ncc,
				dvcc,
				loaidv,
				trangthai,
				magiaodich,
				makh,
				tongtien,
				ngaytao,
				nhanvien,
				email,
				mashop,
				lydohuy,
				magdncc
			)
		SELECT
				ISNULL(billNo,''),
				ISNULL(UPPER(p.Name),''), 
				ISNULL(r.categoryName,''), 				
				ISNULL(r.productName,''),
				CASE r.orderStatus WHEN 'CREATE' THEN N'Khởi tạo' 
									WHEN 'PROCESSING' THEN N'Đang xử lý (PROCESSING)' 
									WHEN 'CANCEL_PROCESSING' THEN N'Đang chờ duyệt (CANCEL_PROCESSING)' 
									ELSE r.orderStatus END ,
				ISNULL(integrationRequestId,''),
				ISNULL(r.productCustomerCode,''),
				ISNULL(CAST(totalAmountIncludingFee AS  DECIMAL(18,0)),0),
				CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000',
				ISNULL(r.employeeName,''),
				ISNULL(u.Email,''),
				ISNULL(warehouseCode,''),'', ISNULL(r.productTransId,'')
			FROM dbo.Transcation_Waiting r WITH (NOLOCK) 
			LEFT JOIN [DEV-CRM-Product-Service].dbo.Provider AS P WITH (nolock)ON r.providerId=p.id
			LEFT JOIN [INSIDE].FRTInsideV2.dbo.[User] u WITH (nolock) ON r.creationBy=u.EmployeeCode
			WHERE CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000' BETWEEN @FromDate AND @ToDate AND ISNULL(r.categoryName,'') =N'Dịch vụ MoMo' 
			AND CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000'< GETDATE()-'00:10:00.000'
			
	 END
	IF @type='' AND @hour<12
     BEGIN
	 PRINT N'@hour : '+CAST(@hour AS NVARCHAR(50))
	 PRINT N'@FromDate : '+ISNULL(@FromDate ,' null')
	      INSERT INTO #Tmp_sendmailwaiting
			(
				bill,
				ncc,
				dvcc,
				loaidv,
				trangthai,
				magiaodich,
				makh,
				tongtien,
				ngaytao,
				nhanvien,
				email,
				mashop,
				lydohuy,
				magdncc
			)
			
		SELECT
				ISNULL(billNo,''),
				ISNULL(UPPER(p.Name),''),
				ISNULL(r.productName,''), 
				ISNULL(r.categoryName,''), 
				CASE r.orderStatus WHEN 'CREATE' THEN N'Khởi tạo' 
									WHEN 'PROCESSING' THEN N'Đang xử lý (PROCESSING)' 
									WHEN 'CANCEL_PROCESSING' THEN N'Đang chờ duyệt (CANCEL_PROCESSING)' 
									ELSE r.orderStatus END ,
				ISNULL(integrationRequestId,''),
				ISNULL(r.productCustomerCode,''),
				ISNULL(CAST(totalAmountIncludingFee AS  DECIMAL(18,0)),0),
				CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000',
				ISNULL(r.employeeName,''),
				ISNULL(u.Email,''),
				ISNULL(warehouseCode,''),'',ISNULL(r.productTransId,'')
			FROM dbo.Transcation_Waiting r WITH (NOLOCK) 
			LEFT JOIN [DEV-CRM-Product-Service].dbo.Provider AS P WITH (nolock)ON r.providerId=p.id
			LEFT JOIN [INSIDE].FRTInsideV2.dbo.[User] u WITH (nolock) ON r.creationBy=u.EmployeeCode
			WHERE-- CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000' BETWEEN @FromDate AND @ToDate
			 --AND 
			 CAST(CAST(r.creationTime AS DATETIME2) AS DATETIME )+'07:00:00.000'< GETDATE()-'00:10:00.000'
	 END
	
	SELECT DISTINCT email INTO #tempmail FROM #Tmp_sendmailwaiting 
	DECLARE @listmail NVARCHAR(max)= N''
	SELECT @listmail = COALESCE(@listmail + ';', '') + email 
	FROM #tempmail	
	IF @Type='MoMo'
	BEGIN		
	    SET @listmail='GQKN@MSERVICE.COM.VN;FRTSUPPORT@FPT.COM.VN;FRT.CSKH@FPT.COM.VN'+@listmail+';HuyHCQ@fpt.com.vn;ChiTNB@fpt.com.vn;TaoLQ2@fpt.com.vn;PhatTV4@fpt.com.vn;MinhTND@fpt.com.vn;AnhHT73@fpt.com.vn;TamGTT@fpt.com.vn;ThamLT10@fpt.com.vn;Thaontm3@fpt.com.vn;HieuBT14@fpt.com.vn;DatNP5@fpt.com.vn'
	END
	ELSE
	BEGIN
		
	    SET @listmail='FRTSUPPORT@FPT.COM.VN;FRT.CSKH@FPT.COM.VN;HuyHCQ@fpt.com.vn;ChiTNB@fpt.com.vn;TaoLQ2@fpt.com.vn;PhatTV4@fpt.com.vn;MinhTND@fpt.com.vn;AnhHT73@fpt.com.vn;TamGTT@fpt.com.vn;ThamLT10@fpt.com.vn;Thaontm3@fpt.com.vn;HieuBT14@fpt.com.vn;DatNP5@fpt.com.vn'
	END
	
	BEGIN
	    PRINT @listmail
	SET @FromDate =left(@FromDate, len(@FromDate) - 7);
	SET @ToDate =left(@ToDate, len(@ToDate) - 7);
	--mail
	DECLARE @HTML_STR NVARCHAR(MAX) = ''
	IF EXISTS(SELECT TOP 1 1 FROM #Tmp_sendmailwaiting)
		BEGIN
			SET @HTML_STR = N'<html xmlns="http://www.w3.org/1999/xhtml">
							<head>
							<style>
								table,th, td {
								border: 1px solid black;
								width:auto;
								border-collapse: collapse;
								}
								body {
								font-family: Roboto, Raleway, Open Sans, Droid Sans, Arial, sans-serif; 
								}
								hr.endofmail {
								border-top: 1px dotted gray
								}
							</style>
							<meta charset="UTF-8">
							</head>
							<body>
							<h1 style="text-align:center; color: blue;">'+@Title+N'</h1>
							<h2 style="text-align:center;"> Từ ' + CAST(@FromDate AS VARCHAR(40)) + N' đến ' + CAST(@ToDate AS VARCHAR(40))+ '</h2>' + 
							@Content +N'<br/>'+
														
								N'<table style="border: 1px solid black;width:auto;border-collapse: collapse;">
									<tr style="border: 1px solid black;width:auto;border-collapse: collapse;">
										<th style="border: 1px solid black;width:10px;border-collapse: collapse;">STT</th>
										<th style="border: 1px solid black;width:150px;border-collapse: collapse;">Số Phiếu</th>
										<th style="border: 1px solid black;width:50px;border-collapse: collapse;">Nhà Cung Cấp</th>
										<th style="border: 1px solid black;width:90px;border-collapse: collapse;">Đơn Vị Cung Cấp</th>
										<th style="border: 1px solid black;width:90px;border-collapse: collapse;">Loại Dịch Vụ</th>
										<th style="border: 1px solid black;width:70px;border-collapse: collapse;">Trạng Thái</th>
										<th style="border: 1px solid black;width:50px;border-collapse: collapse;">Mã Giao Dịch</th>
										<th style="border: 1px solid black;width:50px;border-collapse: collapse;">Mã Khách Hàng</th>
										<th style="border: 1px solid black;width:50px;border-collapse: collapse;">Tổng Tiền</th>
										<th style="border: 1px solid black;width:50px;border-collapse: collapse;">Ngày Tạo</th>
										<th style="border: 1px solid black;width:150px;border-collapse: collapse;">Nhân Viên</th>
										<th style="border: 1px solid black;width:90px;border-collapse: collapse;">Mã Shop</th>
										<th style="border: 1px solid black;width:90px;border-collapse: collapse;">Lý do hủy</th>
										<th style="border: 1px solid black;width:90px;border-collapse: collapse;">Mã Giao Dịch NCC</th>
									</tr>'													

	
				SELECT @HTML_STR = @HTML_STR
							+ N'<tr style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ N'<td style="text-align:center;border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ROW_NUMBER() OVER (ORDER BY ISNULL(t.bill, ''))) + N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(t.bill, '')) + N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(t.ncc, ''))+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.dvcc,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.loaidv,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.trangthai,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.magiaodich,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.makh,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.tongtien,''))
							+ N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(VARCHAR, T.ngaytao, 103) + N' ' +CONVERT(VARCHAR, T.ngaytao, 108) + N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.nhanvien,''))+N'-'+CONVERT(NVARCHAR, ISNULL(T.email,'')) + N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.mashop,''))  + N'</td>'
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.lydohuy,'')) + N'</td>'	
							+ N'<td style="border: 1px solid black;width:auto;border-collapse: collapse;">'
							+ CONVERT(NVARCHAR, ISNULL(T.magdncc,'')) + N'</td>'
				FROM
					#Tmp_sendmailwaiting AS T
				ORDER BY
					  T.bill

				SET @HTML_STR = @HTML_STR + N'
				</table>
				<h4>					
					<hr class="endofmail">					
				</h4>
				</body></html>';
			END
	ELSE
		BEGIN
			RETURN
			SET @HTML_STR = N'<html xmlns="http://www.w3.org/1999/xhtml">
								<head>
								<style>
									body {
									font-family: Roboto, Raleway, Open Sans, Droid Sans, Arial, sans-serif; 
									}
									hr.endofmail {
									border-top: 1px dotted gray
									}
								</style>
								</head>
								<body>
									<h1 style="text-align:center;color: red">
									Khong co giao dich cho duyet </br>
									
									</h1>
									<hr class="endofmail">
										
								</body>
								</html>'
		END
			--<i style="font-size:0.7em;color:gray;">
										--	IP: 10.96.97.20</br>
										--	DB: FRTCRM</br>
										--	Store procedure: SP_Job_Monitor_for_NHDV_Datnp5</br>
										--</i>
		PRINT N'@HTML_STR: '+ISNULL(@HTML_STR,' null')
		IF @HTML_STR !=''
		BEGIN
			INSERT INTO dbo.LogSendMail
			(
				NamePro,
				CreateDate
			)
			VALUES
			(   
				'SP_Job_Monitor_for_NHDV',       -- NamePro - varchar(250)
				GETDATE() -- CreateDate - datetime
			)
			EXEC [10.1.13.81].msdb.dbo.sp_send_dbmail 
				@profile_name = 'frtautomail'
			--, @recipients = 'DatNP5@fpt.com.vn'
			, @recipients = @listmail--- 'HuyHCQ@fpt.com.vn;TaoLQ2@fpt.com.vn;ToanVB2@fpt.com.vn;HieuBT14@fpt.com.vn;DatNP5@fpt.com.vn'					
			, @subject = @Subject
			, @body = @HTML_STR
			, @body_format = 'HTML';
		END	
		ELSE
		BEGIN
			PRINT N'@HTML_STR null'
		END
	END
	DROP  TABLE #Tmp_sendmailwaiting,#tempmail
END




