USE [BW]
GO
/****** Object:  UserDefinedFunction [dbo].[FnXmlToJson]    Script Date: 9/19/2022 2:47:08 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[FnXmlToJson](@Xml XML)

RETURNS NVARCHAR(MAX)

AS

     BEGIN

         DECLARE @json NVARCHAR(MAX);

         SELECT @json = STUFF((SELECT JSONValue  FROM ( SELECT ','+'{'+STUFF((SELECT ','+COALESCE(b.c.value('local-name(.)', 'NVARCHAR(max)'), '')+''':'+CASE WHEN b.c.value('count(*)', 'int') = 0

                                                                                                                      THEN dbo.[FnJsonEscape](b.c.value('text()[1]', 'NVARCHAR(MAX)'))

                                                                                                                      ELSE dbo.FnXmlToJson(b.c.query('*'))  END

                                                           FROM x.a.nodes('*') b(c)

                                                           FOR XML PATH(''), TYPE

                                                       ).value('(./text())[1]', 'NVARCHAR(MAX)'), 1, 1, '')+'}'

												FROM @Xml.nodes('/*') x(a)

                              ) JSON(JSONValue)

                              FOR XML PATH(''), TYPE

                          ).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

         RETURN @json;

     END;

GO
