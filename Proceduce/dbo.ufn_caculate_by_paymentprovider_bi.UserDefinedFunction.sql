USE [BW]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_caculate_by_paymentprovider_bi]    Script Date: 9/19/2022 2:47:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
			
CREATE FUNCTION [dbo].[ufn_caculate_by_paymentprovider_bi] (@vendorcode NCHAR(50),@productName NVARCHAR(250),@totalamout FLOAT, @ProvinceId INT,@status VARCHAR(50),@productId NVARCHAR(250) ='')				
RETURNS FLOAT				
AS				
BEGIN				
    DECLARE  @fee FLOAT = 0, @percentFee FLOAT = 0, @totalFee FLOAT = 0, @date DATETIME = CAST(GETDATE() AS DATE)
	
	--Payoo
	IF @vendorcode='a6f07639-83a1-45fd-a0e0-85217ff75de2'
	BEGIN	    
		IF @status IN (N'SUCCESS',N'CREATE', N'PROCESSING',N'CANCEL_PROCESSING',N'CANCEL_FAILED')
		BEGIN
		
			IF @productName='FPT Polytechnic'
			BEGIN
			    SELECT @Fee =  ISNULL(DMT.PaymentFee, 0)
				FROM CRM_DiscountFee_MasterTable (NOLOCK) DMT
				WHERE  DMT.VendorCode=@vendorcode AND DMT.productName=@productName and ISNULL(DMT.MinAmount,0) = 0 AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate) AND @totalamout< DMT.MaxAmount

				SELECT @Fee =  ISNULL(DMT.PaymentFee, 0)
				FROM CRM_DiscountFee_MasterTable (NOLOCK) DMT
				WHERE  DMT.VendorCode=@vendorcode AND DMT.productName=@productName and ISNULL(DMT.MinAmount,0) <> 0 AND DMT.MaxAmount<> 0 AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate) AND @totalamout BETWEEN DMT.MinAmount and DMT.MaxAmount
			
				SELECT @Fee =  ISNULL(DMT.PaymentFee, 0)
				FROM CRM_DiscountFee_MasterTable (NOLOCK) DMT
				WHERE  DMT.VendorCode=@vendorcode AND DMT.productName=@productName AND ISNULL(DMT.MinAmount,0) <> 0 AND ISNULL(DMT.MaxAmount,0)= 0 AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate) AND @totalamout> DMT.MinAmount
			END
			ELSE
            BEGIN
                SELECT @fee =CEILING(ROUND(CASE WHEN ISNULL(DMT.PaymentFee, 0) = 0
                                       THEN ( ISNULL(DMT.PaymentFeePercent,0)
                                              * ISNULL(@totalamout,0) ) / 100
                                       ELSE ISNULL(DMT.PaymentFee,0)
                                  END, 0))
								  FROM CRM_DiscountFee_MasterTable DMT WITH (NOLOCK) 
								  WHERE DMT.VendorCode=@vendorcode AND DMT.productName=@productName AND DMT.productId=@productId			
            END		
			select @percentFee = 0
		END
	END	
	--smartpay
	IF @vendorcode='32587075-cbaa-4afc-a6b5-fe2c5299a38f'
	BEGIN 
		IF @status IN (N'SUCCESS',N'CREATE', N'PROCESSING',N'CANCEL_PROCESSING',N'CANCEL_FAILED')
		BEGIN
			SELECT @fee =ISNULL(DMT.PaymentFee,0) 
			FROM CRM_DiscountFee_MasterTable DMT WITH (NOLOCK)
			WHERE  VendorCode=@vendorcode and productName=@productName AND Status=1 AND @date BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate)
					AND (ISNULL(MinAmount,0)=0 OR @totalamout > ISNULL(MinAmount,0)) AND ISNULL(PhanKhuc,0)=0 AND (MaTinh = @ProvinceId OR ISNULL(FeeByProvice, 0) = 0)	

			select @percentFee = ISNULL(ISNULL(PaymentFeePercent,0) * @totalamout / 100,0)
			FROM dbo.CRM_DiscountFee_MasterTable (NOLOCK)
			WHERE VendorCode=@vendorcode and productName=@productName AND Status=1 AND @date BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate)
					AND (ISNULL(MinAmount,0)=0 OR @totalamout > ISNULL(MinAmount,0)) AND ISNULL(PhanKhuc,0)=0 AND (MaTinh = @ProvinceId OR ISNULL(FeeByProvice, 0) = 0)
	
		END
			
	END	
	--viettel
	IF @vendorcode='67defced-5f16-4ba9-9db8-5eac8fe9df68'
	BEGIN 
		IF @status IN (N'SUCCESS',N'CREATE', N'PROCESSING',N'CANCEL_PROCESSING',N'CANCEL_FAILED')
		BEGIN
			SELECT @fee =ISNULL(DMT.PaymentFee,0) 
			FROM CRM_DiscountFee_MasterTable DMT WITH (NOLOCK)
			WHERE  VendorCode=@vendorcode and DMT.productId=@productName AND Status=1 AND @date BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate)
					AND (ISNULL(MinAmount,0)=0 OR @totalamout > ISNULL(MinAmount,0)) AND ISNULL(PhanKhuc,0)=0 AND (MaTinh = @ProvinceId OR ISNULL(FeeByProvice, 0) = 0)	
			IF @productName IN ('9708168a-7692-4b3f-a14c-c09527aae6df','3791ab1a-dfa4-4293-84d3-f49a13796f07')
			BEGIN
			    SELECT TOP 1 @fee=ISNULL(PaymentFee,0)
				FROM dbo.CRM_DiscountFee_MasterTable (NOLOCK)
				WHERE VendorCode=@vendorcode and productId=@productName
					AND Status=1 AND CONVERT(DATE,GETDATE()) BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate)
						AND @totalamout BETWEEN ISNULL(MinAmount,0) AND ISNULL(MaxAmount,0)
			END


			select @percentFee = ISNULL(ISNULL(PaymentFeePercent,0) * @totalamout / 100,0)
			FROM dbo.CRM_DiscountFee_MasterTable (NOLOCK)
			WHERE VendorCode=@vendorcode and productId=@productName AND Status=1 AND @date BETWEEN CONVERT(DATE,FromDate) AND CONVERT(DATE,ToDate)
					AND (ISNULL(MinAmount,0)=0 OR @totalamout > ISNULL(MinAmount,0)) AND ISNULL(PhanKhuc,0)=0 AND (MaTinh = @ProvinceId OR ISNULL(FeeByProvice, 0) = 0)
	
		END
			
	END	
	--VAS	
	IF @vendorcode='65878774-ed81-4db8-9e28-1e860c50b35b'
	BEGIN
		IF @status IN (N'SUCCESS',N'CREATE', N'PROCESSING',N'CANCEL_PROCESSING',N'CANCEL_FAILED')
		BEGIN
		    SET @percentFee=@totalamout/4--25%			
		END	    
	END
				
	
				
				
	SET @totalFee = ISNULL(@fee, 0) + ISNULL(@percentFee, 0)			
	RETURN @totalFee			
END				




GO
