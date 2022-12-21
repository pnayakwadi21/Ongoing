--INSERT INTO metadata
--SELECT apiref,'WorkerPosts',cref FROM [dbo].[metadata]
--WHERE desttable='ZellisPost'

--UPDATE  metadata
--SET apiref=REPLACE(apiref,'Posts','WorkerPosts')
----DELETE  metadata
--WHERE desttable='WorkerPosts'

--SELECT * FROM dbo.metadata
------https://api.hcm.zellis.com/hotest/odata
DECLARE @jmap VARCHAR(100)=''
DECLARE @BaseUrl NVARCHAR(MAX)
DECLARE @table VARCHAR(100)
SET @table='MapPersonnelHierarchyToPosts'
SET @BaseUrl='https://api.hcm.zellis.com/hotest/odata'
DECLARE @path VARCHAR(100)='/MapPersonnelHierarchyToPosts'
DECLARE @relativePath nVARCHAR(max)=@BaseUrl+@path
---SELECT @relativePath

DECLARE @query NVARCHAR(MAX)
SET @query='INSERT INTO metadata

select '''+@relativePath+''' , '''+@table+''' , '''+@jmap+''''
exec (@query)



--SELECT * FROM  dbo.metadata
--WHERE desttable in ('LeaveReasons')


--SELECT * FROM Workers
