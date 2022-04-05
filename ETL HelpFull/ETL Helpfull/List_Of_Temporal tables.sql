SELECT
    OBJECT_NAME(object_id) AS 'Temporal Table'
    ,OBJECT_NAME(history_table_id) AS 'History Table'
FROM sys.tables
WHERE temporal_type = 2     