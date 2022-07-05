
----LEFT OUTER JOIN fieldtypes Dt_FormComp_Opened
--ON Dt_FormComp_Opened.cas_id = compl_main.recordid  
--AND RTRIM(LTRIM(Dt_FormComp_Opened.fld_name))='Date Formal Complaint opened'


WITH fieldtypes AS
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


--SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
--WHERE cas_id=12873


SELECT cas_id,
	
[Action Taken (S2)]	,
[Other Action Taken]	,
[FC Stage 1 Ext target date]	,
[Date Investigation Concluded (S2)]	,
[Date of contact (S2)]	,
[Date Formal Complaint Opened (S2)]	,
[Details of other external agency review]	,
[Compensation to be awarded?]	,
[Immediate Action Taken]	,
[Payment Type (S2)]	,
[FC Stage 2 Target Date]	,
[FC Stage 1 Target Date]	,
[Details of Consent]	,
[Outcome (S2)]	,
[Failures in care or service delivery]	,
[Extension Required? (S2)]	,
[Compensation Payment Status]	,
[FC Stage 1 Target Date Met?]	,
[Reported Compliment Subject]	,
[Informal Complaint Date Responded]	,
[Is this Formal Complaint under external enquiry?]	,
[FC Stage 2 Ext target date]	,
[Date Final Response Approved (S2)]	,
[Compensation Payment Status (S2)]	,
[Date Investigation Concluded]	,
[Reason(s) target date not met (S1)]	,
[Compensation Type]	,
[Date of contact]	,
[Reason extension required? (S2)]	,
[Reported Type]	,
[Outcome Notes]	,
[External enquiry: Enquiry outcome]	,
[Training]	,
[Outcome Confirmed?]	,
[Outcome]	,
[Date Formal Complaint opened]	,
[Compensation]	,
[Summarise key change(s) made or to be implemented]	,
[Date Formal Complaint Acknowledged (S2)]	,
[Reason(s) target date not met (S2)]	,
[Action Taken following Outcome]	,
[Is this Formal Complaint under external review?]	,
[Reason extension required?]	,
[Date Initial Response / Contact]	,
[Extension required?]	,
[Compensation to be awarded? (S2)]	,
[Date approved by Head of Service]	,
[External enquiry: Who is undertaking the external enquiry?]	,
[Add supporting info as required]	,
[Date Final Response Sent]	,
[External review: Who is undertaking this review?]	,
[Ombudsman Outcomes]	,
[Residents Panel Outcome]	,
[Contact from Ombudsman?]	,
[Date Initial Response / Contact (S2)]	,
[Date Formal Complaint Acknowledged]	,
[Is Consent required?]	,
[Date Final Response Sent (S2)]	,
[Compensation Type (S2)]	,
[Lessons learned]	,
[Payment Type]	,
[Add supporting info as required (S2)]	,
[FC Stage 2 Target Date Met?]	


FROM 
(
SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
WHERE cas_id=12873
)pv

PIVOT (MAX(udv_text) FOR fld_name IN (	
[Action Taken (S2)]	,
[Other Action Taken]	,
[FC Stage 1 Ext target date]	,
[Date Investigation Concluded (S2)]	,
[Date of contact (S2)]	,
[Date Formal Complaint Opened (S2)]	,
[Details of other external agency review]	,
[Compensation to be awarded?]	,
[Immediate Action Taken]	,
[Payment Type (S2)]	,
[FC Stage 2 Target Date]	,
[FC Stage 1 Target Date]	,
[Details of Consent]	,
[Outcome (S2)]	,
[Failures in care or service delivery]	,
[Extension Required? (S2)]	,
[Compensation Payment Status]	,
[FC Stage 1 Target Date Met?]	,
[Reported Compliment Subject]	,
[Informal Complaint Date Responded]	,
[Is this Formal Complaint under external enquiry?]	,
[FC Stage 2 Ext target date]	,
[Date Final Response Approved (S2)]	,
[Compensation Payment Status (S2)]	,
[Date Investigation Concluded]	,
[Reason(s) target date not met (S1)]	,
[Compensation Type]	,
[Date of contact]	,
[Reason extension required? (S2)]	,
[Reported Type]	,
[Outcome Notes]	,
[External enquiry: Enquiry outcome]	,
[Training]	,
[Outcome Confirmed?]	,
[Outcome]	,
[Date Formal Complaint opened]	,
[Compensation]	,
[Summarise key change(s) made or to be implemented]	,
[Date Formal Complaint Acknowledged (S2)]	,
[Reason(s) target date not met (S2)]	,
[Action Taken following Outcome]	,
[Is this Formal Complaint under external review?]	,
[Reason extension required?]	,
[Date Initial Response / Contact]	,
[Extension required?]	,
[Compensation to be awarded? (S2)]	,
[Date approved by Head of Service]	,
[External enquiry: Who is undertaking the external enquiry?]	,
[Add supporting info as required]	,
[Date Final Response Sent]	,
[External review: Who is undertaking this review?]	,
[Ombudsman Outcomes]	,
[Residents Panel Outcome]	,
[Contact from Ombudsman?]	,
[Date Initial Response / Contact (S2)]	,
[Date Formal Complaint Acknowledged]	,
[Is Consent required?]	,
[Date Final Response Sent (S2)]	,
[Compensation Type (S2)]	,
[Lessons learned]	,
[Payment Type]	,
[Add supporting info as required (S2)]	,
[FC Stage 2 Target Date Met?]	
)
)r