USE [FRTCRM_MDM]
GO
/****** Object:  StoredProcedure [dbo].[sp_IMP_Import_Amortization_Definition]    Script Date: 9/19/2022 2:06:32 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*====================================================================
Author					:		Datnp5
Create date				:		27/10/2021 23:05:19
Description				:		
====================================================================*/
ALTER PROC [dbo].[sp_IMP_Import_Amortization_Definition]
	@tempCRM_Amortizations_Definitions xml ,
	@CreatBy NCHAR(10)
AS
BEGIN
	DECLARE @ran VARCHAR(500)= RAND()
	set @ran='IMP_Import-'+cast(CAST(GETDATE() AS date) AS VARCHAR(50))+'-'+@ran
	--SELECT @ran
	

	DECLARE @xml XML SET @xml = @tempCRM_Amortizations_Definitions
	INSERT INTO dbo.CRM_Amortizations_Definitions_Logs
	        ( CreateDate ,
	          CreateBy ,
	          UpdateContent ,
	          BeforeUpdate
	        )
	VALUES  ( GETDATE() , -- CreateDate - datetime
	          @CreatBy , -- CreateBy - nvarchar(20)
	          @xml , -- UpdateContent - nvarchar(max)
	          N'sp_IMP_Import_Amortization_Definition '  -- BeforeUpdate - nvarchar(max)
	        )


SET XACT_ABORT ON
BEGIN TRANSACTION Definition_Import_New
BEGIN TRY
	SELECT ItemCode,ItemName INTO #tempproduct
	FROM [10.1.13.71].FRT_MDM.dbo.OITM WITH (NOLOCK) WHERE frozenFor = 'N'
	
	DECLARE @tempimport TABLE 
	(
		[RowID] INT IDENTITY NOT NULL PRIMARY KEY,
		[ComCode] [INT] ,
		[ComName] [NVARCHAR](250) ,
		[LaiSuatPhang] [FLOAT] ,
		[LaiSuatHopDong] [FLOAT] ,
		[Khoanvaymin] [FLOAT] ,
		[Khoanvaymax] [FLOAT] ,
		[GiaMayMin] [FLOAT] ,
		[GiaMayMax] [FLOAT] ,	
		[BaoHiem] [FLOAT] ,
		[TraTruocMin] [FLOAT] ,
		[TraTruocMax] [FLOAT] ,
		[KyHanMin] [NVARCHAR](50) ,
		[KyHanMax] [NVARCHAR](50) ,
		[PhiThuHo] [FLOAT] ,
		[BatBuoc] [INT] ,
		[TuyChon1] [NVARCHAR](500) ,
		[TuyChon2] [NVARCHAR](500) ,	
		[NganhHang] [NVARCHAR](500) ,
		[LoaiHang] [NVARCHAR](500) ,
		[MaSPLoaiTru] [VARCHAR](MAX) ,
		[MaSP] [NVARCHAR](MAX) ,
		[TenSP] [NVARCHAR](MAX) ,
		[NgayBatDau] [NVARCHAR](50) ,
		[NgayKetThuc] [NVARCHAR](50) ,
		[HangXa] [INT] ,
		[LoaiCT] [INT],
		[isSubsidy] INT,
		[GoiTraGop] [NVARCHAR](1000),
		[NhomGoiTraGop] [NVARCHAR](1000),
		[NhomTraGop] [INT],
		[PhiThamGia] FLOAT,
		[LoaiGoiTG] FLOAT,
		[TinhApDung] NVARCHAR(500),
		UNIQUE NONCLUSTERED (RowID) --INCLUDE (RowID,ComCode,ComName,LaiSuatPhang,LaiSuatHopDong,TraTruocMin,TraTruocMax,KyHanMin,GiaMayMin,GiaMayMax,BatBuoc,TuyChon1,TuyChon2) 
	) 
	INSERT INTO @tempimport
	(
		ComCode,
		ComName,
		LaiSuatPhang,
		LaiSuatHopDong,
		Khoanvaymin,
		Khoanvaymax,
		GiaMayMin,
		GiaMayMax,
		BaoHiem,
		TraTruocMin,
		TraTruocMax,
		KyHanMin,
		KyHanMax,
		PhiThuHo,
		BatBuoc,
		TuyChon1,
		TuyChon2,
		NganhHang,
		LoaiHang,
		MaSPLoaiTru,
		MaSP,
		TenSP,
		NgayBatDau,
		NgayKetThuc,
		HangXa,
		LoaiCT,
		isSubsidy,
		GoiTraGop,
		NhomGoiTraGop,
		NhomTraGop,
		PhiThamGia,
		LoaiGoiTG,
		TinhApDung
	)
	SELECT
		Tbl.Col.value('ComCode[1]', 'INT') , 
		Tbl.Col.value('ComName[1]', 'NVARCHAR(250)') , 
		Tbl.Col.value('LaiSuatPhang[1]', 'FLOAT') ,  
		Tbl.Col.value('LaiSuatHopDong[1]', 'FLOAT') ,
		Tbl.Col.value('Khoanvaymin[1]', 'FLOAT') ,
		Tbl.Col.value('Khoanvaymax[1]', 'FLOAT') ,
		Tbl.Col.value('GiaMayMin[1]', 'FLOAT') ,
		Tbl.Col.value('GiaMayMax[1]', 'FLOAT') ,
		Tbl.Col.value('BaoHiem[1]', 'FLOAT'),
		Tbl.Col.value('TraTruocMin[1]', 'FLOAT'),  
		Tbl.Col.value('TraTruocMax[1]', 'FLOAT'),  
		Tbl.Col.value('KyHanMin[1]', 'NVARCHAR(50)'),
		Tbl.Col.value('KyHanMax[1]', 'NVARCHAR(50)'),
		Tbl.Col.value('PhiThuHo[1]', 'FLOAT'),
		Tbl.Col.value('BatBuoc[1]', 'INT'),
		Tbl.Col.value('TuyChon1[1]', 'NVARCHAR(500)'),  
		Tbl.Col.value('TuyChon2[1]', 'NVARCHAR(500)'),
		Tbl.Col.value('NganhHang[1]', 'NVARCHAR(500)'),
		Tbl.Col.value('LoaiHang[1]', 'NVARCHAR(500)'),
		Tbl.Col.value('MaSPLoaiTru[1]', 'NVARCHAR(MAX)'), 
		Tbl.Col.value('MaSP[1]', 'NVARCHAR(MAX)'),
		Tbl.Col.value('TenSP[1]', 'NVARCHAR(MAX)'),
		Tbl.Col.value('NgayBatDau[1]', 'NVARCHAR(50)'),  
		Tbl.Col.value('NgayKetThuc[1]', 'NVARCHAR(50)'),
		Tbl.Col.value('HangXa[1]', 'INT'),  
		Tbl.Col.value('LoaiCT[1]', 'INT'),
		Tbl.Col.value('IsSubsidy[1]', 'INT'),
		Tbl.Col.value('SchemeCode[1]', 'NVARCHAR(MAX)'),
		Tbl.Col.value('SchemeGroup[1]', 'NVARCHAR(MAX)'),
		Tbl.Col.value('ChuongtrinhHang[1]', 'INT'),
		Tbl.Col.value('PhiThamGia[1]', 'FLOAT'),
		Tbl.Col.value('LoaiGoiTG[1]', 'FLOAT'),
		Tbl.Col.value('TinhApDung[1]','NVARCHAR(500)')

	FROM   @xml.nodes('/ArrayOfImportData/ImportData') Tbl(Col) 
	CREATE TABLE #IMP_Installemt_Error
	(
	[RowID] [int] NULL,
	[ComCode] [int] NULL,
	[ComName] [nvarchar] (250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LaiSuatPhang] [float] NULL,
	[LaiSuatHopDong] [float] NULL,
	[GiaMayMin] [float] NULL,
	[GiaMayMax] [float] NULL,
	[Khoanvaymin] [float] NULL,
	[Khoanvaymax] [float] NULL,
	[BaoHiem] [float] NULL,
	[TraTruocMin] [float] NULL,
	[TraTruocMax] [float] NULL,
	[KyHanMin] [nchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KyHanMax] [int] NULL,
	[PhiThuHo] [float] NULL,
	[BatBuoc] [int] NULL,
	[TuyChon1] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TuyChon2] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NganhHang] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LoaiHang] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaSPLoaiTru] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaSP] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenSP] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NgayBatDau] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NgayKetThuc] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HangXa] [int] NULL,
	[LoaiCT] [int] NULL,
	[isSubsidy] [int] NULL,
	[CreateBy] [nvarchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NULL,
	[GoiTraGop] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NhomGoiTraGop] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NhomTraGop] [int] NULL,
	[PhiThamGia] [float] NULL,
	[LoaiGoiTG] [float] NULL,
	[TinhAppDung] [NVARCHAR](500),
	[Maloi] [int] NULL,
	[TenLoi] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
	) 
	INSERT INTO #IMP_Installemt_Error
	(
	    RowID,
	    ComCode,
	    ComName,
	    LaiSuatPhang,
	    LaiSuatHopDong,
	    GiaMayMin,
	    GiaMayMax,
	    Khoanvaymin,
	    Khoanvaymax,
	    BaoHiem,
	    TraTruocMin,
	    TraTruocMax,
	    KyHanMin,
	    KyHanMax,
	    PhiThuHo,
	    BatBuoc,
	    TuyChon1,
	    TuyChon2,
	    NganhHang,
	    LoaiHang,
	    MaSPLoaiTru,
	    MaSP,
	    TenSP,
	    NgayBatDau,
	    NgayKetThuc,
	    HangXa,
	    LoaiCT,
	    isSubsidy,
	    CreateBy,
	    CreateDate,
	    GoiTraGop,
	    NhomTraGop,
	    PhiThamGia,
	    LoaiGoiTG,
		TinhAppDung,
		Maloi,
	    TenLoi,
	    NhomGoiTraGop	)
	SELECT ti.RowID,
           ti.ComCode,
           ti.ComName,
           ti.LaiSuatPhang,
           ti.LaiSuatHopDong,
           ti.Khoanvaymin,
           ti.Khoanvaymax,
           ti.GiaMayMin,
           ti.GiaMayMax,
           ti.BaoHiem,
           ti.TraTruocMin,
           ti.TraTruocMax,
           ti.KyHanMin,
           ti.KyHanMax,
           ti.PhiThuHo,
           ti.BatBuoc,
           ti.TuyChon1,
           ti.TuyChon2,
           ti.NganhHang,
           ti.LoaiHang,
           ti.MaSPLoaiTru,
           ti.MaSP,
           ti.TenSP,
           ti.NgayBatDau,
           ti.NgayKetThuc,
           ti.HangXa,
           ti.LoaiCT,
           ti.isSubsidy,
		   @CreatBy,
		   GETDATE(),
           ti.GoiTraGop,
           ti.NhomTraGop,
           ti.PhiThamGia,
           ti.LoaiGoiTG,
		   ti.TinhApDung,
		    1,
		   N'Sản phẩm sai hoặc chưa được định nghĩa ở HT POS.'  ,
		   ti.NhomGoiTraGop
		   FROM @tempimport ti LEFT JOIN #tempproduct tp ON ti.MaSP=tp.ItemCode WHERE ISNULL(tp.ItemCode,'')='' AND ISNULL(ti.MaSP,'')!=''
	DELETE t FROM @tempimport t INNER JOIN #IMP_Installemt_Error e ON t.RowID=e.RowID 

	INSERT INTO dbo.IMP_Installemt_Error
	(
	    RowID,
	    ComCode,
	    ComName,
	    LaiSuatPhang,
	    LaiSuatHopDong,
	    GiaMayMin,
	    GiaMayMax,
	    Khoanvaymin,
	    Khoanvaymax,
	    BaoHiem,
	    TraTruocMin,
	    TraTruocMax,
	    KyHanMin,
	    KyHanMax,
	    PhiThuHo,
	    BatBuoc,
	    TuyChon1,
	    TuyChon2,
	    NganhHang,
	    LoaiHang,
	    MaSPLoaiTru,
	    MaSP,
	    TenSP,
	    NgayBatDau,
	    NgayKetThuc,
	    HangXa,
	    LoaiCT,
	    isSubsidy,
	    CreateBy,
	    CreateDate,
	    GoiTraGop,
	    NhomTraGop,
	    PhiThamGia,
	    LoaiGoiTG,
	    Maloi,
	    TenLoi,
	    TinhApDung,
		NhomGoiTraGop		
	)
	 SELECT RowID,
        ComCode,
        ComName,
        LaiSuatPhang,
        LaiSuatHopDong,
        GiaMayMin,
        GiaMayMax,
        Khoanvaymin,
        Khoanvaymax,
        BaoHiem,
        TraTruocMin,
        TraTruocMax,
        KyHanMin,
        KyHanMax,
        PhiThuHo,
        BatBuoc,
        TuyChon1,
        TuyChon2,
        NganhHang,
        LoaiHang,
        MaSPLoaiTru,
        MaSP,
        TenSP,
        NgayBatDau,
        NgayKetThuc,
        HangXa,
        LoaiCT,
        isSubsidy,
        CreateBy,
        CreateDate,
        GoiTraGop,
        NhomTraGop,
        PhiThamGia,
        LoaiGoiTG,
        Maloi,
        TenLoi,
        TinhAppDung, NhomGoiTraGop FROM #IMP_Installemt_Error DELETE #IMP_Installemt_Error
	--DELETE @tempimport WHERE RowID IN (SELECT RowID FROM dbo.IMP_Installemt_Error WITH (NOLOCK))
	DELETE @tempimport WHERE TraTruocMin!=TraTruocMax
	UPDATE @tempimport SET KyHanMax= NULL WHERE KyHanMax=0
	UPDATE @tempimport SET KyHanMin ='0'+KyHanMin WHERE KyHanMin IN ('3','4','5','6','7','8','9')
	--// bang nay de luu cac ma sanphamloaitru
	INSERT INTO dbo.CRM_Amortizations_Definitions_import_log
	( ComCode ,
	    ComName ,
	    LaiSuatPhang ,
	    LaiSuatHopDong ,
	    GiaMayMin ,
	    GiaMayMax ,
	    Khoanvaymin ,
	    Khoanvaymax ,
	    BaoHiem ,
	    TraTruocMin ,
	    TraTruocMax ,
	    KyHanMin ,
	    KyHanMax ,
	    PhiThuHo ,
	    BatBuoc ,
	    TuyChon1 ,
	    TuyChon2 ,
	    NganhHang ,
	    LoaiHang ,
	    MaSPLoaiTru ,
	    MaSP ,
	    TenSP ,
	    NgayBatDau ,
	    NgayKetThuc ,
	    HangXa ,
	    LoaiCT ,
	    isSubsidy ,
	    CreateBy ,
	    CreateDate,
		GoiTraGop,
		NhomTraGop,
		PhiThamGia,
		LoaiGoiTG,
		TinhApDung,NhomGoiTraGop
	)
	SELECT ComCode ,
	    ComName ,
	    LaiSuatPhang ,
	    LaiSuatHopDong ,
	    GiaMayMin ,
	    GiaMayMax ,
	    Khoanvaymin ,
	    Khoanvaymax ,
	    BaoHiem ,
	    TraTruocMin ,
	    TraTruocMax ,
	    KyHanMin ,
	    KyHanMax ,
	    PhiThuHo ,
	    BatBuoc ,
	    TuyChon1 ,
	    TuyChon2 ,
	    NganhHang ,
	    LoaiHang ,
	    MaSPLoaiTru ,
	    MaSP ,
	    TenSP ,
	    NgayBatDau ,
	    NgayKetThuc ,
	    HangXa ,
	    LoaiCT ,
	    isSubsidy ,
	    @CreatBy ,
	    GETDATE(),
		GoiTraGop,
		NhomTraGop,
		PhiThamGia,
		LoaiGoiTG,
		TinhApDung,NhomGoiTraGop
		FROM @tempimport 
	--// import lôi du lieu trung
	BEGIN
	    SELECT id,ComCode,InterestEvenFrom,InterestContractFrom,PrePayFromID,AmortizationType,FromDate,ToDate,ProductPriceFrom,ProductPriceTo 
		INTO #tmp_defi FROM dbo.CRM_Amortizations_Definitions WITH (NOLOCK) 
		WHERE Status=1
		SELECT d.*,p.ItemCode INTO #tmp_de_pro FROM dbo.CRM_Amortizations_Definitions_Products p WITH (NOLOCK) INNER JOIN #tmp_defi d ON d.id=p.id 
		DROP TABLE #tmp_defi
		SELECT dp.*,t.TermID INTO #tmp_de_pro_tm FROM dbo.CRM_Amortizations_Definitions_Terms t WITH (NOLOCK) INNER JOIN #tmp_de_pro dp WITH (nolock) ON dp.id=t.id 
		DROP TABLE #tmp_de_pro
		SELECT dpt.*,pp.ProID INTO #tmp_de_pro_tm_pp FROM dbo.CRM_Amortizations_Definitions_Properties pp WITH (NOLOCK) INNER JOIN #tmp_de_pro_tm dpt WITH (nolock) ON dpt.id=pp.id
		DROP TABLE #tmp_de_pro_tm

		INSERT INTO #IMP_Installemt_Error
		(
	    RowID,
	    ComCode,
	    ComName,
	    LaiSuatPhang,
	    LaiSuatHopDong,
	    GiaMayMin,
	    GiaMayMax,
	    Khoanvaymin,
	    Khoanvaymax,
	    BaoHiem,
	    TraTruocMin,
	    TraTruocMax,
	    KyHanMin,
	    KyHanMax,
	    PhiThuHo,
	    BatBuoc,
	    TuyChon1,
	    TuyChon2,
	    NganhHang,
	    LoaiHang,
	    MaSPLoaiTru,
	    MaSP,
	    TenSP,
	    NgayBatDau,
	    NgayKetThuc,
	    HangXa,
	    LoaiCT,
	    isSubsidy,
	    CreateBy,
	    CreateDate,
	    GoiTraGop,
	    NhomTraGop,
	    PhiThamGia,
	    LoaiGoiTG,
		TinhAppDung,
		Maloi,
	    TenLoi,NhomGoiTraGop
		)
		SELECT DISTINCT ti.RowID,
           ti.ComCode,
           ti.ComName,
           ti.LaiSuatPhang,
           ti.LaiSuatHopDong,
           ti.Khoanvaymin,
           ti.Khoanvaymax,
           ti.GiaMayMin,
           ti.GiaMayMax,
           ti.BaoHiem,
           ti.TraTruocMin,
           ti.TraTruocMax,
           ti.KyHanMin,
           ti.KyHanMax,
           ti.PhiThuHo,
           ti.BatBuoc,
           ti.TuyChon1,
           ti.TuyChon2,
           ti.NganhHang,
           ti.LoaiHang,
           ti.MaSPLoaiTru,
           ti.MaSP,
           ti.TenSP,
           ti.NgayBatDau,
           ti.NgayKetThuc,
           ti.HangXa,
           ti.LoaiCT,
           ti.isSubsidy,
		   @CreatBy,
		   GETDATE(),
           ti.GoiTraGop,
           ti.NhomTraGop,
           ti.PhiThamGia,
           ti.LoaiGoiTG,
		   ti.TinhApDung,
		   2,
		   N'Dữ liệu trùng.' ,ti.NhomGoiTraGop
		   FROM #tmp_de_pro_tm_pp d WITH (NOLOCK) 
		INNER JOIN @tempimport ti ON d.ComCode=ti.ComCode 
		AND d.InterestEvenFrom=ti.LaiSuatPhang 
		AND d.InterestContractFrom=ti.LaiSuatHopDong 
		AND d.PrePayFromID=ti.TraTruocMin
		AND (ISNULL(d.AmortizationType,0)=ISNULL(ti.isSubsidy,0) OR ISNULL(ti.isSubsidy,0)=0) 
		AND CONVERT(DATE,d.FromDate,103)=CONVERT(DATE,ti.NgayBatDau,103) 
		AND CONVERT(DATE,d.ToDate,103)=CONVERT(DATE,ti.NgayKetThuc,103)
		AND d.ProductPriceFrom=ti.GiaMayMin AND d.ProductPriceTo=ti.GiaMayMax
		--product
		AND d.ItemCode=ti.MaSP
		--term
		AND d.TermID = ti.KyHanMin
		--proper
		AND ( d.ProID = ti.BatBuoc OR d.ProID IN (SELECT value FROM dbo.ufn_StringToTable(ti.TuyChon1,',',0)) OR d.ProID IN (SELECT value FROM dbo.ufn_StringToTable(ti.TuyChon2,',',0)))
		--//xoa du lieu trùng
		--DELETE @tempimport WHERE RowID IN (SELECT RowID FROM dbo.IMP_Installemt_Error WITH (NOLOCK) WHERE Maloi=2 )
		DELETE t FROM @tempimport t INNER JOIN #IMP_Installemt_Error e ON t.RowID=e.RowID 
		INSERT INTO dbo.IMP_Installemt_Error
		(
		    RowID,
		    ComCode,
		    ComName,
		    LaiSuatPhang,
		    LaiSuatHopDong,
		    GiaMayMin,
		    GiaMayMax,
		    Khoanvaymin,
		    Khoanvaymax,
		    BaoHiem,
		    TraTruocMin,
		    TraTruocMax,
		    KyHanMin,
		    KyHanMax,
		    PhiThuHo,
		    BatBuoc,
		    TuyChon1,
		    TuyChon2,
		    NganhHang,
		    LoaiHang,
		    MaSPLoaiTru,
		    MaSP,
		    TenSP,
		    NgayBatDau,
		    NgayKetThuc,
		    HangXa,
		    LoaiCT,
		    isSubsidy,
		    CreateBy,
		    CreateDate,
		    GoiTraGop,
		    NhomTraGop,
		    PhiThamGia,
		    LoaiGoiTG,
		    Maloi,
		    TenLoi,
		    TinhApDung,NhomGoiTraGop
		) 
		SELECT RowID,
               ComCode,
               ComName,
               LaiSuatPhang,
               LaiSuatHopDong,
               GiaMayMin,
               GiaMayMax,
               Khoanvaymin,
               Khoanvaymax,
               BaoHiem,
               TraTruocMin,
               TraTruocMax,
               KyHanMin,
               KyHanMax,
               PhiThuHo,
               BatBuoc,
               TuyChon1,
               TuyChon2,
               NganhHang,
               LoaiHang,
               MaSPLoaiTru,
               MaSP,
               TenSP,
               NgayBatDau,
               NgayKetThuc,
               HangXa,
               LoaiCT,
               isSubsidy,
               CreateBy,
               CreateDate,
               GoiTraGop,
               NhomTraGop,
               PhiThamGia,
               LoaiGoiTG,
               Maloi,
               TenLoi,
               TinhAppDung,NhomGoiTraGop FROM #IMP_Installemt_Error DROP TABLE #IMP_Installemt_Error
	END

	
				--//
	
                BEGIN
					DECLARE @tblINDENTITYID TABLE (id INT, RowId int)					
					---------------INSERT BẢNG ĐỊNH NGHĨA THEO IDKEY--------------------------
					INSERT INTO [dbo].[CRM_Amortizations_Definitions]
				   ([ObjectID]
				   ,[ObjectName]
				   ,[ComCode]
				   ,[ComName]
				   ,[InterestEvenFrom]
				   ,[InterestEvenTo]
				   ,[InterestContractFrom]
				   ,[InterestContractTo]
				   ,[ProductPriceFrom]
				   ,[ProductPriceTo]
				   ,LoanAmountMin
				   ,LoanAmountMax 
				   ,Hierachies 
				   ,HierachiesType 
				   ,[PrePayFromID]
				   ,[PrePayFromName]
				   ,[PrePayToID]
				   ,[PrePayToName]
				   ,[CreateBy]
				   ,[CreateDate]
				   ,[UpdateBy]
				   ,[UpdateDate]
				   ,[AmortizationName]
				   ,[Fee]
				   ,[PrepayMoney]
				   ,[FeeWarrantity]
				   ,[Status]
				   ,[FromDate]
				   ,[ToDate]
				    ,AmortizationType
					,TypeAplly
					,SSID
					,SchemeCode
					,AmortizationBy
					,Phithamgia
					,LoaigoiTG
					,Province
					,RowId,SchemeGroup
				   )
					OUTPUT INSERTED.ID, INSERTED.RowId INTO @tblINDENTITYID
					SELECT  0 AS [ObjectID]
				   ,'' AS [ObjectName]
				   ,a.Comcode AS [ComCode]
				   ,a.ComName AS [ComName]
				   ,LaiSuatPhang AS [InterestEvenFrom]
				   ,LaiSuatPhang AS [InterestEvenTo]
				   ,LaiSuatHopDong AS [InterestContractFrom]
				   ,LaiSuatHopDong AS [InterestContractTo]
				   ,ISNULL(GiaMayMin,0) AS [ProductPriceFrom]
				   ,ISNULL(GiaMayMax,0) AS [ProductPriceTo]
				   ,ISNULL(KhoanVayMin,0) AS LoanAmountMin
				   ,ISNULL(KhoanVayMax,0) AS LoanAmountMax
				   ,ISNULL(NganhHang,'') Hierachies 
				   ,ISNULL(LoaiHang,'') HierachiesType 
				   , a.TraTruocMin   AS [PrePayID]
				   ,N'Trả trước '+  CONVERT(NVARCHAR(20),a.TraTruocMin) + CASE WHEN a.TraTruocMin>100 THEN N'đồng' ELSE N'%' END  AS PrePayName
				   ,a.TraTruocMax  as PrePayToID
				   ,N'Trả trước '+ CONVERT(NVARCHAR(20),a.TraTruocMax)++ CASE WHEN a.TraTruocMin>100 THEN N'đồng' ELSE N'%' END AS  PrePayToName
				    ,@CreatBy AS [CreateBy]
				   ,GETDATE() AS [Createdate]
				   ,@CreatBy AS [UpdateBy]
				   ,GETDATE() AS [UpdateDate]
				   ,'' AS [AmortizationName]
				 , ISNULL(a.PhiThuHo,0)/1000 AS Fee
				   ,CASE WHEN a.TraTruocMin>100 THEN a.TraTruocMin ELSE 0 END  AS PrepayMoney
				   ,CASE WHEN ISNULL(a.BaoHiem,0)=0 THEN 0 
						  ELSE a.BaoHiem END AS Insurrance
				   ,1 AS [Status]
				   ,CONVERT(DATETIME,NgayBatDau,103) AS  [FromDate]
				   ,CONVERT(DATETIME,NgayKetThuc,103) AS  [ToDate]
				   ,CASE WHEN ISNULL(a.isSubsidy,'0')='0' THEN a.[HangXa] ELSE 2 END 
				   ,a.LoaiCT
				   ,NEWID()
				   ,goitragop
				   ,nhomtragop
				   ,a.PhiThamGia
				   ,CASE WHEN ISNULL(a.MaSP,'')='' THEN a.LoaiGoiTG ELSE 0 END
				   ,a.TinhApDung
                   ,a.RowID,a.NhomGoiTraGop
					FROM @tempimport a
					
					
					
					-----------------------INSERT VÀO BẢNG ĐỊNH NGHĨA KỲ HẠN -------------
					INSERT INTO [dbo].[CRM_Amortizations_Definitions_Terms]
					(
						[ID]
					   ,[TermID]
					   ,[TermName]
					   ,[CreateBy]
					   ,[Createdate]
					   ,[UpdateBy]
					   ,[UpdateDate]
					   ,Phithamgia
					)
					   SELECT dd.id
					   ,a.[TermID]
					   ,a.[TermName]
					   ,@CreatBy AS [CreateBy]
					   ,GETDATE() AS [Createdate]
					   ,@CreatBy AS [UpdateBy]
					   ,GETDATE() AS [UpdateDate]
					   ,t.PhiThamGia
				   FROM dbo.CRM_Amortizations_Terms a WITH (nolock) 
				   INNER JOIN @tempimport t ON a.TermID=t.KyHanMin 
				   INNER JOIN @tblINDENTITYID dd ON dd.RowId = t.RowID
				   --WHERE a.TermID=@Termstr --',' +  @Termstr + ',' LIKE '%,'+ cast(cast(TermID AS INT) AS VARCHAR(20)) +',%'
				   --ORDER BY a.TermID
				   
					--INNER JOIN dbo.ufn_StringToTable(@Termstr,',',0) AS b ON CONVERT(INT,a.TermID)=CONVERT(INT,LTRIM(RTRIM(b.VALUE)))
					--WHERE LTRIM(RTRIM(b.VALUE))<>''

					-------------------------INSERT BẢNG ĐỊNH NGHĨA VÀ GIẤY TỜ BẮT BUỘC----------------------
					INSERT INTO dbo.CRM_Amortizations_Definitions_Properties
					        ( ID ,
					          ObjectID ,
					          ObjectName ,
					          ProID ,
					          ProName ,
					          Isrequire ,
					          ProIDEquivalent ,
					          ProNameEquivalent ,
					          OptionType ,
					          CreateBy ,
					          CreateDate ,
					          UpdateBy ,
					          UpdateDate
					        )
				   SELECT 
						   dd.id AS  [ID]
						   ,0 AS [ObjectID]
						   ,'' AS [ObjectName]
						   ,a.[ProID]
						   ,a.ProValue
						   ,1 Isrequire
						   ,0 AS [ProIDEquivalent]
						   ,'' AS [ProNameEquivalent]
						   ,0 AS OptionType
							,@CreatBy AS [CreateBy]
						   ,GETDATE() AS [Createdate]
						   ,@CreatBy AS [UpdateBy]
						   ,GETDATE() AS [UpdateDate]
				   FROM dbo.CRM_Amortizations_Properties a  INNER JOIN @tempimport t ON a.ProID=t.BatBuoc 
				   INNER JOIN @tblINDENTITYID dd ON dd.RowId = t.RowID	   
					
					 
					INSERT INTO dbo.CRM_Amortizations_Definitions_Properties
					        ( ID ,
					          ObjectID ,
					          ObjectName ,
					          ProID ,
					          ProName ,
					          Isrequire ,
					          ProIDEquivalent ,
					          ProNameEquivalent ,
					          OptionType ,
					          CreateBy ,
					          CreateDate ,
					          UpdateBy ,
					          UpdateDate
					        )
				   SELECT dd.id AS  [ID]
				   ,0 AS [ObjectID]
				   ,'' AS [ObjectName]
				   ,a.[ProID]
				   ,a.ProValue
				   ,0 Isrequire
				   ,0 AS [ProIDEquivalent]
				   ,'' AS [ProNameEquivalent]
				   ,1 AS OptionType
				    ,@CreatBy AS [CreateBy]
				   ,GETDATE() AS [Createdate]
				   ,@CreatBy AS [UpdateBy]
				   ,GETDATE() AS [UpdateDate]
				   FROM dbo.CRM_Amortizations_Properties a INNER JOIN @tempimport t ON a.ProID IN (SELECT value FROM dbo.ufn_StringToTable(t.TuyChon1,',',0)) 
				   INNER JOIN @tblINDENTITYID dd ON dd.RowId = t.RowID	  
					-------------------------INSERT BẢNG ĐỊNH NGHĨA VÀ GIẤY TỜ TÙY CHỌN 2----------------------
					-------------LẤY DỮ LIỆU CỘT GIẤY TỜ					
					 
					INSERT INTO dbo.CRM_Amortizations_Definitions_Properties
					        ( ID ,
					          ObjectID ,
					          ObjectName ,
					          ProID ,
					          ProName ,
					          Isrequire ,
					          ProIDEquivalent ,
					          ProNameEquivalent ,
					          OptionType ,
					          CreateBy ,
					          CreateDate ,
					          UpdateBy ,
					          UpdateDate
					        )
				   SELECT dd.id AS  [ID]
				   ,0 AS [ObjectID]
				   ,'' AS [ObjectName]
				   ,a.[ProID]
				   ,a.ProValue
				   ,0 Isrequire
				   ,0 AS [ProIDEquivalent]
				   ,'' AS [ProNameEquivalent]
				   ,2 AS OptionType
				    ,@CreatBy AS [CreateBy]
				   ,GETDATE() AS [Createdate]
				   ,@CreatBy AS [UpdateBy]
				   ,GETDATE() AS [UpdateDate]
				   FROM dbo.CRM_Amortizations_Properties a INNER JOIN @tempimport t ON a.ProID IN (SELECT value FROM dbo.ufn_StringToTable(t.TuyChon2,',',0)) 
				   INNER JOIN @tblINDENTITYID dd ON dd.RowId = t.RowID	  
					
					
					-------------------------INSERT BẢNG ĐỊNH NGHĨA VÀ SẢN PHẨM ----------------------
					
					    INSERT INTO [dbo].[CRM_Amortizations_Definitions_Products]
					   ([ID]
					   ,[ItemCode]
					   ,[ItemName]
					   ,[ObjectID]
					   ,[ObjectName]
					   ,[CreateBy]
					   ,[Createdate]
					   ,[UpdateBy]
					   ,[UpdateDate]
					   , IsType
					   ,LoaigoiTG)
					   SELECT dd.id AS  [ID]
					   ,p.ItemCode
					   ,p.ItemName
					   ,0 AS [ObjectID]
					   ,'' AS [ObjectName]
					   ,@CreatBy AS [CreateBy]
					   ,GETDATE() AS [Createdate]
					   ,@CreatBy AS [UpdateBy]
					   ,GETDATE() AS [UpdateDate]
					   ,ISNULL(t.HangXa,0)
					   ,t.LoaiGoiTG
					   FROM @tempimport t 
					   INNER JOIN #tempproduct p ON t.MaSP=p.ItemCode
						INNER JOIN @tblINDENTITYID dd ON dd.RowId = t.RowID	WHERE ISNULL(t.MaSP,'')!=''
					
					
					---------------XÓA BẢNG INDENTITYID ĐỂ LẤY ID MỚI ------------
					DELETE @tblINDENTITYID
					DELETE @tempimport
				END
              
			DROP TABLE #tempproduct

	

	SELECT 1 AS RESULT_CODE,N'Import dữ liệu thành công' AS RESULT_TEXT
	
	--BEGIN TRY
	--	EXEC [dbo].[sp_CRM_Amortization_Definition_Import_New_SendMail] @SSID
	--END TRY
--	BEGIN CATCH
--	END CATCH
COMMIT
END TRY
BEGIN CATCH
	ROLLBACK
	DECLARE @ErrorMessage VARCHAR(2000)
	SET @ErrorMessage = ERROR_MESSAGE()
	SELECT -1 AS RESULT_CODE,@ErrorMessage AS RESULT_TEXT
	
	INSERT INTO  EXEC_LOG(DateTimeCreated, ProcName, ErrLog)
	SELECT GETDATE(), '[dbo].[sp_CRM_Amortization_Definition_Import_New]', @ErrorMessage
	
	
	
END CATCH
END





