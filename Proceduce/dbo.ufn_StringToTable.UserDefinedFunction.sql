USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_StringToTable]    Script Date: 9/19/2022 2:49:26 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<duynb5@fpt.com.vn>
-- Create date: <31/03/2013>
-- Description:	<Chuyển một chuỗi ký tự với các ký tự phân biệt thành một bảng.>
-- =============================================
CREATE FUNCTION [dbo].[ufn_StringToTable]
(
	@str NVARCHAR(MAX),
	@splitChar NVARCHAR(25) = ',',
	@isGetEmptyValue BIT = 0
)
RETURNS @tblRet TABLE(VALUE NVARCHAR(255)) 
AS
BEGIN
	DECLARE @curValue NVARCHAR(255) = '', @curIndex INT
	IF CHARINDEX(@splitChar, @str, 0) = 0 AND ISNULL(@str,'') <> ''
		INSERT INTO @tblRet VALUES(@str);
	WHILE CHARINDEX(@splitChar, @str, 0) <> 0
	BEGIN
		SET @curIndex = CHARINDEX(@splitChar, @str, 0);
		INSERT INTO @tblRet VALUES(SUBSTRING(@str, 0, @curIndex));
		SET @str = RIGHT(@str, LEN(@str) - @curIndex);
		IF CHARINDEX(@splitChar, @str, 0) = 0
			INSERT INTO @tblRet VALUES(@str);
	END
	--IF @isGetEmptyValue = 0
	--	DELETE @tblRet WHERE dbo.ufn_Trim(VALUE,1,1)='';
	RETURN;
END


GO
