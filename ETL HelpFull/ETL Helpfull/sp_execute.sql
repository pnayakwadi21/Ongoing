

DECLARE @query Nvarchar(MAX),
@Hid nVARCHAR(100)='pers',
@select nVARCHAR(100)='str_id,str_ref ',
@execpara nVARCHAR(100)='@select VARCHAR(100),@Hid VARCHAR(100)'



SET @query='select '+@select+'from raw_d126m
where HIERARCHY_ID='''+@Hid+''''
--SELECT @query

EXEC sp_executesql @query,@execpara,@select=@select,@Hid=@Hid




SELECT * FROM dbo.RAW_D126M
WHERE HIERARCHY_ID='pers'


