/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  [name]
      ,[object_id]
      ,[principal_id]
      ,[schema_id]
      ,[parent_object_id]
      ,[type]
      ,[type_desc]
      ,[create_date]
      ,[modify_date]
      ,[is_ms_shipped]
      ,[is_published]
      ,[is_schema_published]
  FROM [H21_STAGING].[sys].[all_objects]

  WHERE type='u' AND schema_id=1

  AND name LIKE '%RAW_HPDSCREC%'
ORDER BY create_date 