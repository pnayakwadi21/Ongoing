

WITH  fieldtypes AS
(
SELECT fld_name, udv_string,uv.field_id,COALESCE(uc.udc_description,uco.udc_description)udc_description,cas_id,udv_date,udv_text
FROM(
SELECT DISTINCT uf.fld_name
        ,CASE WHEN RTRIM(LTRIM(uf.fld_name)) IN ('Compensation Type','Payment Type') THEN 		r.splitdata  ELSE    udv_string END udv_string
		,uv.cas_id
		,uf.mod_id
		,uv.field_id
		,udv_date
		,udv_text
FROM dbo.udf_fields uf 
INNER JOIN  dbo.udf_values uv ON uv.field_id=uf.recordid  
CROSS APPLY(SELECT [Data] splitdata FROM [dbo].[fn_split] (uv.udv_string,' ')
                       )r
					   WHERE uv.mod_id=2
					   )uv
 
                     LEFT JOIN  dbo.udf_codes uc ON uc.field_id=uv.field_id AND uc.udc_code=uv.udv_string  AND COALESCE(uc.active,'Y')='Y'
					 LEFT JOIN  dbo.udf_codes uco WITH (NOLOCK)  ON uco.field_id=uv.field_id AND uco.udc_code=uv.udv_string  AND uco.active='N'
)    



SELECT * FROM fieldtypes




SELECT * INTO #er  FROM dbo.compl_main   ------- complaints
WHERE com_dreceived>'2020/01/01'

SELECT * FROM #er
SELECT com_type
,com_subtype
,com_subject1 
,com_dincident
,com_dreceived
,com_dclosed
,com_dreopened
----,com_outcome,com_curstage,com_subject1 

FROM #er


GROUP BY com_type,com_subtype,com_subject1 


SELECT * FROM #er



SELECT *  FROM dbo.udf_fields uf 
WHERE uf.fld_name LIKE '%stage%'


SELECT recordid,inc_name,inc_type, inc_category,inc_subcategory  ,inc_dincident  FROM dbo.incidents_main   WITH (NOLOCK) ------Incidents 

SELECT recordid,com_name,com_type,com_dincident,com_subject1,com_subsubject1  FROM dbo.compl_main   ------- complaints
WHERE com_dreceived>'2020/01/01'