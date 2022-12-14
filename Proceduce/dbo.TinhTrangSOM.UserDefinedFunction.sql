USE [BW]
GO
/****** Object:  UserDefinedFunction [dbo].[TinhTrangSOM]    Script Date: 9/19/2022 2:47:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[TinhTrangSOM]
( @orderStatus NVARCHAR(100) )

RETURNS NVARCHAR(500)

AS

BEGIN

	DECLARE @TinhTrang NVARCHAR(500);

	IF (@orderStatus = N'SUCCESS'						) BEGIN SET @TinhTrang = N'Giao dịch thành công' 						 END
	IF (@orderStatus = N'FAILED'						) BEGIN SET @TinhTrang = N'Giao dịch thất bại' 							 END
	IF (@orderStatus = N'CANCEL_FAILED'					) BEGIN SET @TinhTrang = N'Giao dịch thành công (Hủy không thành công)'	 END
	IF (@orderStatus = N'PARTIAL_CANCEL'				) BEGIN SET @TinhTrang = N'Huỷ 1 phần'									 END
	IF (@orderStatus = N'CANCELLED'						) BEGIN SET @TinhTrang = N'Đã hủy'										 END
	IF (@orderStatus = N'NON_SUPPORT'					) BEGIN SET @TinhTrang = N'Không hổ trợ'								 END
	IF (@orderStatus = N'CREATE'						) BEGIN SET @TinhTrang = N'Đã tạo giao dịch'							 END
	IF (@orderStatus = N'PUSHED_TO_POS'					) BEGIN SET @TinhTrang = N'Đã về POS'									 END
	IF (@orderStatus = N'REQUEST_CANCEL'				) BEGIN SET @TinhTrang = N'Giao dịch thành công (phát sinh yêu cầu hủy)' END
	IF (@orderStatus = N'PROCESSING'					) BEGIN SET @TinhTrang = N'Đang thực hiện'								 END
	IF (@orderStatus = N'CANCEL_PROCESSING'				) BEGIN SET @TinhTrang = N'Đang thực hiện huỷ'							 END
	IF (@orderStatus = N'NEED_ADDITIONAL_INFORMATION'   ) BEGIN SET @TinhTrang = N'Giao dịch thất bại'							 END


	RETURN @TinhTrang;

END;
GO
