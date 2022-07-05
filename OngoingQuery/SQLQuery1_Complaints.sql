

IF OBJECT_ID('tempdb..#date') IS NOT NULL DROP  TABLE #date
IF OBJECT_ID('tempdb..#bankholidays') IS NOT NULL DROP  TABLE #bankholidays
IF OBJECT_ID('tempdb..#ctypes_desc') IS NOT NULL DROP  TABLE #ctypes_desc


---#ctypes_desc

DECLARE @START_DATE  DATE ='1900/01/01' ,
        @END_DATE    DATE='2028/12/02' ,
		@CalenderYear Int,
		@CalenderMonth INT


CREATE TABLE #DATE (Calender_Date DATE,Caleder_Week INT,Fiscal_Date DATE,Fiscal_Week INT ,
DayOfMonth INT,Weekday INT,Month INT,Year int,
WeekDayName VARCHAR(50),MonthName VARCHAR(20))
WHILE @START_DATE<@END_DATE
BEGIN
INSERT INTO #DATE (Calender_Date,Caleder_Week,Fiscal_Date,Fiscal_Week, DayOfMonth,WeekDay,Month,year,WeekDayName,MonthName)
SELECT @START_DATE Calendar_Date,DatePart(wk,@START_DATE) CalenderWeek
---,DATEADD(Month,3,@START_DATE)
, DATEADD(Month,-3,@START_DATE) Fiscal_Date,
  DATEPART(WEEK,DATEADD(Month,-3,@START_DATE))  FiscalWeek
 
 ,DATEPART(DAY,@START_DATE) [DayOfFMonth]
  ,DATEPART(WEEKDAY,@START_DATE) [DayOfFMonth]
 ,DATEPART(Month,@START_DATE) [Month]
  ,DATEPART(Year,@START_DATE) [Month]
  ,DATENAME(WEEKDAY,@START_DATE)
  , DATENAME(MONTH,@START_DATE)
  
SET @START_DATE=DATEADD(DD,1,@START_DATE)
END 



--SELECT * FROM #DATE
--ORDER BY Calender_Date DESC





--IF OBJECT_ID(N'dbo.PBI_DATE',N'U') IS NOT NULL
--DROP TABLE dbo.PBI_DATE

-- bank holidays till 2023

-------'29-08-2022','26-12-2022','02-01-2023','07-04-2023','10-04-2023','01-05-2023','29-05-2023','28-08-2023','25-12-2023','26-12-2023'



CREATE TABLE #bankholidays
(HolidayDt Date)

INSERT INTO #bankholidays
(
    HolidayDt
)
VALUES
('2022/01/03'),('2022/04/15'),('2022/04/18'),('2022/06/02'),('2022/06/03'),('2022/08/29'),('2022/12/26'),('01-02-2023'),('2023/04/07'),('2023/04/10'),('2023/05/01'),('2023/05/29'),('2023/08/28'),('2023/12/25'),('2023/12/26')





--SELECT * INTO dbo.PBI_DATE FROM #DATE
--ORDER BY Calender_Date DESC

--DROP  TABLE #DATE



  ALTER TABLE #DATE
ADD   IsWorkingDay int


UPDATE r
SET  isworkingday=0

FROM #date r
WHERE  WeekDayName IN ('Saturday','Sunday')

UPDATE r
SET  IsWorkingDay=0

FROM #DATE r
INNER JOIN  #bankholidays e
ON r.Calender_Date=e.HolidayDt

UPDATE r
SET  IsWorkingDay=1

FROM #date r
WHERE IsWorkingDay  IS null


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

INTO #ctypes_desc
FROM 
(
SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
--WHERE cas_id=12873
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
DECLARE 	@StartDate VARCHAR(20)='2022/04/01',
	@EndDate VARCHAR(20)='2022/05/31',
	@IncType VARCHAR(20)='All'



SELECT --'Summary' AS [Summary]  
--, 
DISTINCT
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

, LEFT(code_specialty.[description],4) AS [Scheme]  

, code_com_method.[description] AS [Method of receipt description]  
--,[Progress Notes]
,cd.*
,SUM(d.isworkingday) OVER (PARTITION BY compl_main.recordid ORDER BY compl_main.recordid )-1 [Informal Response Time]
,SUM(ack.isworkingday) OVER (PARTITION BY compl_main.recordid ORDER BY compl_main.recordid )-1 [Acknowledgement_ResponseTime (S1)]
,SUM(ack2.isworkingday) OVER (PARTITION BY compl_main.recordid ORDER BY compl_main.recordid )-1 [Acknowledgement_ResponseTime (S2)]
,SUM(rs1.isworkingday) OVER (PARTITION BY compl_main.recordid ORDER BY compl_main.recordid )-1 [[ResponseTime (S1)]
,compl_main.com_dreceived dd , [Informal Complaint Date Responded]

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
  
INNER JOIN dbo.code_specialty  
ON code_specialty.code = compl_main.com_specialty  
INNER JOIN dbo.code_com_method  
ON compl_main.com_method = code_com_method.code 
INNER JOIN dbo.contacts_main respmgr  
ON respmgr.initials = compl_main.com_mgr  
LEFT OUTER JOIN dbo.contacts_main escmgr  
ON escmgr.initials = COALESCE(compl_main.com_head, LEFT(compl_main.com_investigator, 3))  
 
--LEFT OUTER JOIN cteProgressNotes  
--ON cteProgressNotes.complaintID = compl_main.recordid  
LEFT OUTER JOIN dbo.code_com_outcome fcOutcome  
ON fcOutcome.code = compl_main.com_outcome  
LEFT OUTER JOIN dbo.code_com_stages  
ON compl_main.com_curstage = code_com_stages.code 
INNER JOIN  #ctypes_desc cd ON cd.cas_id=compl_main.recordid 

left JOIN #date d ON d.Calender_Date>=compl_main.com_dreceived AND d.Calender_Date<=cd. [Informal Complaint Date Responded]
left JOIN #date ack ON d.Calender_Date>=[Date Formal Complaint opened] AND d.Calender_Date<=cd.[Date Formal Complaint Acknowledged]
left JOIN #date ack2 ON ack2.Calender_Date>= [Date Formal Complaint Opened (S2)]AND d.Calender_Date<=cd.[Date Formal Complaint Acknowledged (S2)]
left JOIN #date rs1 ON d.Calender_Date>=[Date Formal Complaint opened] AND d.Calender_Date<=cd.[Date Final Response Sent]
left JOIN #date rs2 ON d.Calender_Date>=[Date Formal Complaint Opened (S2)] AND d.Calender_Date<=cd.[Date Final Response Sent (S2)]

----Date Formal Complaint Acknowledged
--[Date Formal Complaint Acknowledged (S2)]
----- [Dt_FormComp_Opened].udv_date, [Dt_Final_Response_Sent].udv_date) 




WHERE 
 compl_main.com_dopened >= CAST(@StartDate AS DATETIME)
AND compl_main.com_dopened<= CAST(@EndDate AS DATETIME)
AND (CHARINDEX(code_com_type.[description], @incType) > 0 OR @IncType = 'ALL') -- current record type



SELECT * FROM dbo.udf_fields
WHERE fld_name LIKE '%final%'



------ [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  