SELECT OBJECT_SCHEMA_NAME(DP.referencing_id) + N'.' + OBJECT_NAME(DP.referencing_id) AS [object]
FROM sys.sql_expression_dependencies DP
WHERE DP.referenced_id = OBJECT_ID('dbo.RAW_hpmmatch');

SELECT OBJECT_SCHEMA_NAME([object_id]) + N'.' + OBJECT_NAME([object_id]) AS [object]
FROM sys.sql_modules
WHERE [definition] like N'%RAW[_]hpmmatch%';
