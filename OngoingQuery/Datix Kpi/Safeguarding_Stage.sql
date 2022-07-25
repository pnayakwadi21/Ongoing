--USE [DatixReporting]
--GO

--/****** Object:  StoredProcedure [dbo].[DatixIncidentsSafeGuard]    Script Date: 01/07/2022 11:38:50 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


--CREATE PROCEDURE [dbo].[DatixIncidentsSafeGuard]
 
--	@StartDate VARCHAR(20),
--	@EndDate VARCHAR(20),
--	@IncType VARCHAR(20)
--	AS

	---[DatixIncidentsSafeGuard]  '2019/09/01','2019/09/12','All'
/*
==============================================================================================

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :02/08/2018
DESCRIPTION:External reporting added to the Safeguard report 

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :02/11/2018
DESCRIPTION:Three Part Objects replaced with synonyms ,View name replaced with DatixIncidentsExtData_View

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :07/12/2018
DESCRIPTION:Added new columns H&C 21 the onsite care provider?,Have you reported it to CQC/Local Authority?,Who is the alleged perpetrator?,External notifications: Police force


AUTHOR     :PRAVEEN NAYAKWADI
DATE       :17/12/2018
DESCRIPTION:Added new columns court location,who have you notified

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :24/10/2019
DESCRIPTION:Changed the fieldtypes  cte to use the field names  to filter'Who have you notified?','Who is the alleged perpetrator?'  for concatinated data 
            CR:157696   Missing 'Record old code descriptions'  are associated with there new  descriptions where available 

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :04/12/2019
DESCRIPTION:Added new field 'Did the incident meet Safeguarding criteria' 


AUTHOR     :PRAVEEN NAYAKWADI
DATE       :12/11/2020
DESCRIPTION:'Reported Time'  report field has been added  Explicit Try Convert function to  'submitted time' source field (Incident:98040      Change:198167)

AUTHOR     :PRAVEEN NAYAKWADI
DATE       :16/12/2020
DESCRIPTION:CR201,411  Date range for #Date table extended
==============================================================================================
*/

--DROP TABLE #safeguardingInciflow

DECLARE
	@StartDate VARCHAR(20)='2021/11/01',
	@EndDate VARCHAR(20)='2021/12/12',
	@IncType VARCHAR(20)='All'

IF OBJECT_ID(N'tempdb..#BANK_HOLIDAYS')             IS  NOT NULL DROP TABLE #BANK_HOLIDAYS
IF OBJECT_ID(N'tempdb..#DATE')                      IS  NOT NULL DROP TABLE #DATE
IF OBJECT_ID(N'tempdb..#CteProgressNotes')          IS  NOT NULL DROP TABLE #CteProgressNotes
IF OBJECT_ID(N'tempdb..#LastUpdUserLog')            IS  NOT NULL DROP TABLE #LastUpdUserLog
IF OBJECT_ID(N'tempdb..#orghier')            IS  NOT NULL DROP TABLE #orghier

IF OBJECT_ID(N'tempdb..#safeguardingInciflow')            IS  NOT NULL DROP TABLE #safeguardingInciflow
--DROP TABLE #safeguardingInciflow





			
;WITH fieldtypes AS
(
SELECT fld_name, udv_string,uv.field_id,COALESCE(uc.udc_description,uco.udc_description)udc_description,cas_id,udv_date,UDV_TEXT
FROM(
SELECT
 DISTINCT 
 uf.fld_name
        ,   CASE WHEN RTRIM(LTRIM(uf.fld_name)) IN ('Who have you notified?','Who is the alleged perpetrator?') THEN 		r.splitdata  ELSE    udv_string END udv_string
		,uv.cas_id
		,uf.mod_id
		,uv.field_id
		,udv_date
		,uv.UDV_TEXT
FROM dbo.udf_fields uf 
                    INNER JOIN  dbo.udf_values uv WITH (NOLOCK) ON uv.field_id=uf.recordid  
                     
                    CROSS APPLY( SELECT Data splitdata FROM fn_Split_String (uv.udv_string,' ')
                       )r
					   WHERE uv.mod_id=3
					   )uv
 
                     LEFT JOIN  dbo.udf_codes uc WITH (NOLOCK)  ON uc.field_id=uv.field_id AND uc.udc_code=uv.udv_string  AND uc.active='Y'
					  LEFT JOIN  dbo.udf_codes uco WITH (NOLOCK)  ON uco.field_id=uv.field_id AND uco.udc_code=uv.udv_string  AND uco.active='N'
)    




SELECT cas_id,
[External notifications: Police comments ]	,
[Did the incident result in an employee being unable to perform their scheduled duties for over seven days?]	,
[Do other staff need to be informed of this incident? ]	,
[Has the Health and Safety Executive advised that an external investigation is required?]	,
[Level 1 Details of support provided to persons involved]	,
[Investigation: Was a staff member involved in this event?]	,
[External notification: Local Authority reference]	,
[Investigation: Training and support free text (Please provide further details). ]	,
[Adverse incident: Contributing factors]	,
[Adverse incident: Remedial action to be undertaken]	,
[External notifications: Date reported to Police]	,
[External notifications: Date reported to Local Authority]	,
[External notification: Local Authority comments]	,
[External notification: Local Authority contact number]	,
[Location of incident]	,
[Part of Body]	,
[External notifications: Police force]	,
[What is the allegation?]	,
[Allegation raised against H21 by External Agency?]	,
[External notifications: Name of contact at Local Authority]	,
[Type of injury caused]	,

[External notification: Date reported to CQC]	,
[Duty of Candour: Please provide further information.]	,
[Detail your initial findings.]	,
[External notifications: Local Authority]	,
[Who have you notified?]	,
[Who was affected?]	,
[External notifications: CQC Further comments ]	,
[External notifications: Police reference]	,
[Was treatment provided in hospital?]	,
[Adverse incident: Prevention and learning]	,
[External notifications: Police officer contact number]	,
[External notifications: Police officer name ]	,
[Did the incident meet any of the following criteria: ]	,
[Please provide details]	,
[Incident: Incident outcome]	,
[Do you think further action is required?]	,
[Court Location]	,
[Please detail the reasons for not reporting it]	,
[Are H21 the onsite care provider?]	,
[Investigation: Was their training adequate and up to date? ]	,
[Did the Safeguarding event result in neglect, abuse or have an adverse effect?]	,
[Did the incident result in an immediate transfer to hospital with treatment provided?]	,
[Investigation level]	,
[Adverse incident: Conclusion]	,
[Did the incident result in an injury listed on the RIDDOR reportable list of specified injuries?]	,
[Further action: Does this incident require escalation and further investigation in order to be resolved?]	,
[Location of Incident?]	,
[Investigation: Was a Risk Assessment in place at the time of this incident? ]	,
[Category of Allegation?]	,
[Who has raised the allegation?]	,
[Does this require further investigation?]	,
[Adverse incident: Background]	,
[Gender of person affected]	,
[Detail your suggested further action. ]	,
[Investigation: Was the Risk Assessment being adhered to at the time of this incident? ]	,
[Investigation: Risk Assessment Free Text (Please provide further details). ]	,
[Who is the alleged perpetrator?]	,
[Adverse incident: Working environment and equipment]	,
[Adverse incident: Sharing the lessons learned]	,
[Safeguarding: Alleged perpetrator position]	,
[Have you reported your concern to any external agencies?]	,
[Please make appropriate selections]	,
[Have you reported it to CQC/Local Authority?]	,
[Duty of Candour: Date notified and apology provided]	,
[Age of person affected at time of Accident/Incident]	,
[External notification: CQC reference]	,
[Investigation: Were they being supervised? ]	,
[Did the incident take place at a H21 property / care service? ]	
INTO #safeguardingInciflow

FROM 
(
SELECT fld_name ,cas_id,COALESCE(udv_text,CONVERT(VARCHAR(100),udv_date), udc_description ,udv_string)udv_text FROM fieldtypes
--WHERE cas_id=12873
)pv


PIVOT (MAX(udv_text) FOR fld_name IN ([External notifications: Police comments ]	,
[Did the incident result in an employee being unable to perform their scheduled duties for over seven days?]	,
[Do other staff need to be informed of this incident? ]	,
[Has the Health and Safety Executive advised that an external investigation is required?]	,
[Level 1 Details of support provided to persons involved]	,
[Investigation: Was a staff member involved in this event?]	,
[External notification: Local Authority reference]	,
[Investigation: Training and support free text (Please provide further details). ]	,
[Adverse incident: Contributing factors]	,
[Adverse incident: Remedial action to be undertaken]	,
[External notifications: Date reported to Police]	,
[External notifications: Date reported to Local Authority]	,
[External notification: Local Authority comments]	,
[External notification: Local Authority contact number]	,
[Location of incident]	,
[Part of Body]	,
[External notifications: Police force]	,
[What is the allegation?]	,
[Allegation raised against H21 by External Agency?]	,
[External notifications: Name of contact at Local Authority]	,
[Type of injury caused]	,

[External notification: Date reported to CQC]	,
[Duty of Candour: Please provide further information.]	,
[Detail your initial findings.]	,
[External notifications: Local Authority]	,
[Who have you notified?]	,
[Who was affected?]	,
[External notifications: CQC Further comments ]	,
[External notifications: Police reference]	,
[Was treatment provided in hospital?]	,
[Adverse incident: Prevention and learning]	,
[External notifications: Police officer contact number]	,
[External notifications: Police officer name ]	,
[Did the incident meet any of the following criteria: ]	,
[Please provide details]	,
[Incident: Incident outcome]	,
[Do you think further action is required?]	,
[Court Location]	,
[Please detail the reasons for not reporting it]	,
[Are H21 the onsite care provider?]	,
[Investigation: Was their training adequate and up to date? ]	,
[Did the Safeguarding event result in neglect, abuse or have an adverse effect?]	,
[Did the incident result in an immediate transfer to hospital with treatment provided?]	,
[Investigation level]	,
[Adverse incident: Conclusion]	,
[Did the incident result in an injury listed on the RIDDOR reportable list of specified injuries?]	,
[Further action: Does this incident require escalation and further investigation in order to be resolved?]	,
[Location of Incident?]	,
[Investigation: Was a Risk Assessment in place at the time of this incident? ]	,
[Category of Allegation?]	,
[Who has raised the allegation?]	,
[Does this require further investigation?]	,
[Adverse incident: Background]	,
[Gender of person affected]	,
[Detail your suggested further action. ]	,
[Investigation: Was the Risk Assessment being adhered to at the time of this incident? ]	,
[Investigation: Risk Assessment Free Text (Please provide further details). ]	,
[Who is the alleged perpetrator?]	,
[Adverse incident: Working environment and equipment]	,
[Adverse incident: Sharing the lessons learned]	,
[Safeguarding: Alleged perpetrator position]	,
[Have you reported your concern to any external agencies?]	,
[Please make appropriate selections]	,
[Have you reported it to CQC/Local Authority?]	,
[Duty of Candour: Date notified and apology provided]	,
[Age of person affected at time of Accident/Incident]	,
[External notification: CQC reference]	,
[Investigation: Were they being supervised? ]	,
[Did the incident take place at a H21 property / care service? ]	
))r

SELECT --'Record summary' AS [Record summary]
--, 
----top 10
DISTINCT
 --incidents_main.recordid,
incidents_main.inc_ourref AS [Record reference]
, incidents_main.inc_name AS [Person Affected]
, incidents_main.recordid AS [ID to link record]

, code_inc_type.[description] AS [Type of record description]

, code_inc_cat.[description] AS [Who was affected description]

, code_inc_subcat.[description] AS [Category Description]

, COALESCE(medErr.cod_descr, '') AS [Medication Error]


, incidents_main.inc_dincident AS [Incident Date]
, DATENAME(MONTH, incidents_main.inc_dincident) AS [Incident Month]
, SUBSTRING(incidents_main.inc_time, 1, 2) + ':' + SUBSTRING(incidents_main.inc_time, 3, 2) AS [Incident Time]
, incidents_main.inc_dreported AS [Reported Date]
, DATENAME(MONTH, incidents_main.inc_dreported) AS [Reported Month]



, incidents_main.inc_dopened AS [Date Opened]

, incidents_main.inc_specialty AS [Scheme Code]
---, LEFT(code_specialty.[description],4) AS [Scheme]

,COALESCE( mer_sch.[New Scheme ID],LEFT(code_specialty.DESCRIPTION,4) ) Scheme
, COALESCE(code_location.[description], '') AS [Location]

, incidents_main.inc_notes AS [Describe the Incident/Accident]
--, COALESCE(initInspec.udv_text, 'No Initial Inpsection') AS [Detail your initial inspection]
, incidents_main.inc_actiontaken AS [What action did you take]
, COALESCE(conseqInv.[description], 'Unknown') AS [Consequence (investigation)]

, COALESCE(conseqInit.[description], 'Unknown') AS [Consequence (initial)]
, COALESCE(likeInv.[description], 'Unknown') AS [Likelihood of recurrence (investigation)]
, COALESCE(invGrade.[description], 'No Grade') AS [Grade (investigation)]
, COALESCE(likeInit.[description], 'Unknown') AS [Likelihood of recurrence (initial)]
, COALESCE(initGrade.[description], 'No Grade') AS [Grade (initial)]
, respmgr.fullname AS [Responsible Manager Name]

,sf.*
INTO SafeguardingTest
FROM dbo.incidents_main WITH (NOLOCK)
LEFT OUTER JOIN dbo.code_inc_type  WITH (NOLOCK)
ON code_inc_type.code = incidents_main.inc_type
--LEFT JOIN #LastUpdUserLog  Lu_aud_date ON Lu_aud_date.aud_record=incidents_main.recordid 
LEFT OUTER JOIN dbo.code_inc_cat  WITH (NOLOCK)
ON code_inc_cat.code = incidents_main.inc_category
LEFT OUTER JOIN dbo.code_inc_subcat  WITH (NOLOCK)
ON code_inc_subcat.code = incidents_main.inc_subcategory 
LEFT OUTER JOIN dbo.code_types medErr  WITH (NOLOCK)
ON medErr.cod_type = 'MEDERR' AND medErr.cod_code = incidents_main.inc_med_error
LEFT OUTER JOIN dbo.code_specialty  WITH (NOLOCK)
ON code_specialty.code = incidents_main.inc_specialty
LEFT OUTER JOIN dbo.code_inc_conseq conseqInit  WITH (NOLOCK)
ON conseqInit.code = incidents_main.inc_consequence_initial
LEFT OUTER JOIN dbo.code_inc_likeli likeInit  WITH (NOLOCK)
ON likeInit.code = incidents_main.inc_likelihood_initial
LEFT OUTER JOIN dbo.code_inc_grades initGrade   WITH (NOLOCK)
ON initGrade.code = incidents_main.inc_grade_initial
LEFT OUTER JOIN dbo.contacts_main respmgr  WITH (NOLOCK)
ON respmgr.initials = incidents_main.inc_mgr
LEFT OUTER JOIN dbo.code_inc_likeli likeInv  WITH (NOLOCK)
ON likeInv.code = incidents_main.inc_likelihood
LEFT OUTER JOIN dbo.code_inc_grades invGrade  WITH (NOLOCK)
ON invGrade.code = incidents_main.inc_grade
LEFT OUTER JOIN dbo.code_approval_status  WITH (NOLOCK)
ON code_approval_status.module = 'INC' AND code_approval_status.workflow = 1 AND code_approval_status.code = incidents_main.rep_approved
LEFT OUTER JOIN dbo.code_location  WITH (NOLOCK)
ON code_location.code = incidents_main.inc_loctype

LEFT OUTER JOIN dbo.code_inc_conseq conseqInv  WITH (NOLOCK)
ON conseqInv.code = incidents_main.inc_consequence

INNER JOIN  #safeguardingInciflow  sf ON sf.cas_id=incidents_main.recordid 
LEFT JOIN  [dbo].[QL_Migrated_Schemes] mer_sch ON mer_sch.scheme_cd=LEFT(code_specialty.DESCRIPTION,4) 



--WHERE incidents_main.inc_dincident >= CAST(@StartDate AS DATETIME)
-- AND incidents_main.inc_dincident <= CAST(@EndDate AS DATETIME)
-- AND (CHARINDEX(incidents_main.inc_type, @incType) > 0 OR @IncType = 'ALL')











 --SELECT COUNT(*)  FROM dbo.incidents_main 