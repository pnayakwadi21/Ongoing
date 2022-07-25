
--DBCC DROPCLEANBUFFERS
IF OBJECT_ID('tempdb..#date') IS NOT NULL DROP  TABLE #date
IF OBJECT_ID('tempdb..#bankholidays') IS NOT NULL DROP  TABLE #bankholidays
IF OBJECT_ID('tempdb..#ctypes_desc') IS NOT NULL DROP  TABLE #ctypes_desc


---#ctypes_desc

DECLARE @START_DATE  DATE ='1900/01/01' ,
        @END_DATE    DATE='2028/12/02' ,
		@CalenderYear Int,
		@CalenderMonth INT



;WITH fieldtypes AS
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
OUTER APPLY(SELECT [Data] splitdata FROM fn_Split_String (uv.udv_string,' ')
                       )r
					   WHERE uv.mod_id=2
					   )uv
 
                     LEFT JOIN  dbo.udf_codes uc ON uc.field_id=uv.field_id AND uc.udc_code=uv.udv_string  AND COALESCE(uc.active,'Y')='Y'
					 LEFT JOIN  dbo.udf_codes uco WITH (NOLOCK)  ON uco.field_id=uv.field_id AND uco.udc_code=uv.udv_string  AND uco.active='N'
)    


--SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
--WHERE cas_id=13009


--DROP TABLE #ctypes_desc

SELECT cas_id,
	
[Action Taken (S2)]	,
[Other Action Taken]	,
[FC Stage 1 Ext target date]	,
---CONVERT(DATE,[Date Investigation Concluded (S2)],23)
 [Date Investigation Concluded (S2)]	,
[Date of contact (S2)]	,
CONVERT(DATE,[Date Formal Complaint Opened (S2)],23) 
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
CONVERT(DATE,[Date Final Response Approved (S2)],23)[Date Final Response Approved (S2)]		,
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
---CONVERT(DATE,[Date Formal Complaint opened],23)
[Date Formal Complaint opened]	,
[Compensation]	,
[Summarise key change(s) made or to be implemented]	,
---CONVERT(DATE,[Date Formal Complaint Acknowledged (S2)],23)
[Date Formal Complaint Acknowledged (S2)]	,
[Reason(s) target date not met (S2)]	,
[Action Taken following Outcome]	,
[Is this Formal Complaint under external review?]	,
[Reason extension required?]	,
--CONVERT(DATE,[Date Initial Response / Contact],23)
[Date Initial Response / Contact]	,
[Extension required?]	,
[Compensation to be awarded? (S2)]	,
[Date approved by Head of Service]	,
[External enquiry: Who is undertaking the external enquiry?]	,
[Add supporting info as required]	,
---CONVERT(DATE,[Date Final Response Sent],23)
[Date Final Response Sent]	,
[External review: Who is undertaking this review?]	,
[Ombudsman Outcomes]	,
[Residents Panel Outcome]	,
[Contact from Ombudsman?]	,
---CONVERT(DATE,[Date Initial Response / Contact (S2)],23) 
[Date Initial Response / Contact (S2)]	,
---CONVERT(DATE,[Date Formal Complaint Acknowledged],23)
[Date Formal Complaint Acknowledged]	,
[Is Consent required?]	,
CONVERT(DATE,[Date Final Response Sent (S2)],23) [Date Final Response Sent (S2)]	,
[Compensation Type (S2)]	,
[Lessons learned]	,
[Payment Type]	,
[Add supporting info as required (S2)]	,
[FC Stage 2 Target Date Met?]	
---,cd.[Date Formal Complaint Opened (S2)] ,cd.[Date Final Response Sent (S2)] 
INTO #ctypes_desc
FROM 
(
SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
---WHERE cas_id=13009
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

--DROP TABLE #ctypes_desc
DECLARE 	@StartDate VARCHAR(20)='2019/04/01',
	@EndDate VARCHAR(20)='2022/06/30',
	@IncType VARCHAR(20)='All'



SELECT --'Summary' AS [Summary]  
--, 
DISTINCT



--mer_sch.scheme_cd,
--mer_sch.[New Scheme ID],

compl_main.recordid AS [Complaint ID]  
, compl_main.com_name AS [Person Affected]
, respmgr.fullname AS [Responsible Manager Name]  -- moved to front  
, COALESCE(escmgr.fullname, 'None') AS [Escalate to a Manager Name]  -- moved to front
, compl_main.com_last_updated AS [Last Updated] 
--, compl_main.createdby AS [Created By Code] 
, crtdUser.fullname AS [Complaint Created By]

, repRefTypeDesc.udc_description AS [Reported Record Type Description]  
--, compl_main.com_type AS [Current Type Code]  
, code_com_type.[description] AS [Current Type Description] 
-- 11/04/2017 compliment type
, COALESCE(code_com_subtype.[description], '') AS [Compliment Type] 
 
, COALESCE(code_com_subject.[description], 'No Subject') AS [Subject Description]  
																   
, COALESCE(code_sub_subject.[description], 'No Sub-Subject') AS [Sub-Subject Description]  

, code_com_outcome.[description] AS [Subject Outcome Description] 
, code_com_stages.[description] AS [Current Stage Description]  -- moved to front 
--, 'Key Dates' AS [Key Dates]  
, compl_main.com_dreceived AS [Date Received]  
--, DATENAME(MONTH, compl_main.com_dreceived) AS [Month Received]  
, compl_main.com_dopened AS [Date Opened] 
, COALESCE(DATENAME(MONTH, compl_main.com_dopened),' Date not set') AS [Month opened] 
, compl_main.com_dincident AS [Date of Events]  
, compl_main.com_dclosed AS [Date Closed]  
, compl_main.com_dreopened AS [Date Re-opened]  
, CASE	WHEN YEAR(compl_main.com_dcompleted1) = 1900 THEN NULL  		
		ELSE compl_main.com_dcompleted1 
		END AS [Date Closed (for Formal Complaints only)]  

,COALESCE( mer_sch.[New Scheme ID],LEFT(code_specialty.DESCRIPTION,4) ) Scheme

---, code_com_method.[description] AS [Method of receipt description]  
--,[Progress Notes]
,cd.*

,ict.[Informal Response Time]

,[Acknowledgement_ResponseTime (S1)]

,ck2.[Acknowledgement_ResponseTime (S2)]

,rt1.[ResponseTime (S1)]
,SUM(rs2.isworkingday) OVER (PARTITION BY compl_main.recordid ORDER BY compl_main.recordid )-1 [[ResponseTime (S2)]

INTO Complaintstest

--DROP TABLE Complaints

FROM dbo.compl_main  
LEFT OUTER JOIN dbo.contacts_main crtdUser
ON crtdUser.initials = compl_main.createdby
INNER JOIN dbo.udf_values repRefType  
ON repRefType.mod_id = 2 AND repRefType.cas_id = compl_main.recordid AND repRefType.field_id = 42  
INNER JOIN dbo.udf_codes repRefTypeDesc  
ON repRefTypeDesc.field_id = repRefType.field_id AND repRefTypeDesc.udc_code = repRefType.udv_string  
-- 07/03/2017 join changed from INNER to LEFT OUTER to include unapproved complaints
LEFT OUTER JOIN dbo.code_com_type  
ON code_com_type.code = compl_main.com_type
-- 15/03/2017 add compliment type, aka complaint subtype
LEFT OUTER JOIN dbo.code_com_subtype
ON code_com_subtype.code = compl_main.com_subtype
LEFT OUTER JOIN dbo.code_com_subject  
ON code_com_subject.code = compl_main.com_subject1  
LEFT OUTER JOIN dbo.code_sub_subject  
ON code_sub_subject.code = compl_main.com_subsubject1  
LEFT OUTER JOIN dbo.code_com_outcome  
ON code_com_outcome.code = compl_main.com_outcome1  

INNER  JOIN dbo.code_specialty 
ON code_specialty.code = compl_main.com_specialty  
INNER JOIN dbo.code_com_method  
ON compl_main.com_method = code_com_method.code 
inner JOIN dbo.contacts_main respmgr  
ON respmgr.initials = compl_main.com_mgr  
LEFT OUTER JOIN dbo.contacts_main escmgr  
ON escmgr.initials = COALESCE(compl_main.com_head, LEFT(compl_main.com_investigator, 3))  
 
LEFT OUTER JOIN dbo.code_com_outcome fcOutcome  
ON fcOutcome.code = compl_main.com_outcome  
LEFT OUTER JOIN dbo.code_com_stages  
ON compl_main.com_curstage = code_com_stages.code 
INNER JOIN  #ctypes_desc cd ON cd.cas_id=compl_main.recordid 

OUTER APPLY( SELECT SUM (isworkingday) [Informal Response Time]  FROM dbo.Reportsdate  d WHERE  d.Calender_Date>=compl_main.com_dreceived AND d.Calender_Date<=cd. [Informal Complaint Date Responded])ict
OUTER apply (SELECT SUM (isworkingday) [Acknowledgement_ResponseTime (S1)] FROM  dbo.Reportsdate ack WHERE ack.Calender_Date>=[Date Formal Complaint opened] AND ack.Calender_Date<=cd.[Date Formal Complaint Acknowledged])ak1
OUTER APPLY( SELECT SUM (isworkingday) [Acknowledgement_ResponseTime (S2)] FROM   dbo.Reportsdate  ack2 WHERE  ack2.Calender_Date>= [Date Formal Complaint Opened (S2)]AND ack2.Calender_Date<=cd.[Date Formal Complaint Acknowledged (S2)])ck2
OUTER APPLY (SELECT SUM (isworkingday) [ResponseTime (S1)]   FROM  dbo.Reportsdate rs1 WHERE  rs1.Calender_Date>=[Date Formal Complaint opened] AND rs1.Calender_Date<=cd.[Date Final Response Sent]) rt1
LEFT JOIN dbo.Reportsdate  rs2 ON rs2.Calender_Date>=[Date Formal Complaint Opened (S2)] AND rs2.Calender_Date<=cd.[Date Final Response Sent (S2)] -----optimization needed

LEFT JOIN  [dbo].[QL_Migrated_Schemes] mer_sch ON mer_sch.scheme_cd=LEFT(code_specialty.DESCRIPTION,4) 



