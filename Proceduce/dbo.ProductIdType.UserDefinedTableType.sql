USE [STG_FRT_MDM]
GO
/****** Object:  UserDefinedTableType [dbo].[ProductIdType]    Script Date: 9/19/2022 2:49:26 PM ******/
CREATE TYPE [dbo].[ProductIdType] AS TABLE(
	[ProductId] [int] NOT NULL,
	PRIMARY KEY CLUSTERED 
(
	[ProductId] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO
