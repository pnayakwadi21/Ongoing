
---create a new environemnt by right clicking on the folder

INSERT INTO [internal].[environment_variables]
([environment_id]
,[name]
,[description]
,[type]
,[sensitive]
,[value]
,[sensitive_value]
,[base_data_type])
SELECT  83 as environment_id  --New Environment ID
,[name]
,[description]
,[type]
,[sensitive]
,[value]
,[sensitive_value]
,[base_data_type]
FROM [SSISDB].[internal].[environment_variables]
where environment_id = 75  ---Previous Environment ID