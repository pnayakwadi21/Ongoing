

--SELECT  *   FROM  dbo.udf_fields uf 
--ORDER BY fld_name


--USE [DatixReporting]
--GO

--/****** Object:  StoredProcedure [dbo].[DatixComplaints]    Script Date: 16/11/2022 09:15:32 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO





--CREATE  PROCEDURE [dbo].[DatixComplaints] 
--	(
--  @StartDate VARCHAR(20),
--	@EndDate VARCHAR(20),
--	@IncType VARCHAR(20)
--	)
--AS

--/*
----==============================================================================================
----Author:			Nigel Garrett
----Creation Date:	10/11/2016
----Description:	Datix Complaints Data Dump

----Amendment History
----------------------

----Date		By				Description
---------		---				------------
----10/11/2016	Nigel Garrett 	Initial version
----28/12/2016	Nigel Garrett	Added new variables: Date Formal Complaint Opened and Complaint Creator
----15/02/2017	Nigel Garrett	Change request 25517 - re-arranging of the fields in the report
----07/03/2017	Nigel Garrett	Changed two JOINS to include unapproved complaints
----							Changed the description on formal compalint month if date has not been set
----11/04/2017	Nigel Garrett	Copied from DatixComplaintsDataDump
----							Added compliment type
----							Added date range and call type to parameters
----07/12/2018  Praveen Nayakwadi Changed the objects to use  synonyms and added new fields 'Date Initial Response / Contact
----,Compensation to be awarded?,Compensation Payment Status,Compensation Type

--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :24/10/2019
--DESCRIPTION:157696 Changed the fieldtypes  cte to use the field names  to filter compensation type and payment type  for concatinated data 
--           Missing 'Record old code descriptions'  are associated with there new  descriptions where available 

--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :07/12/2020
--DESCRIPTION:Request200083: Added new fields for the complaints Modules Formal Complaint Timeframes (Stage1),Extension (Stage1),Formal Complaint Timeframes (Stage2),Extension (Stage2),
--Formal Complaint Outcome (Stage1),Formal Complaint Outcome (Stage2)


--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :16/03/2021
--DESCRIPTION:Informal responsetime band changed to include 0 days ,[Stage 1 Payment type] changed to include multiple payment types

--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :07/04/2021
--DESCRIPTION:Outcome Confirmed field added

--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :12/08/2021
--DESCRIPTION:summary key changes to impliment field added
--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :07/09/2021
--DESCRIPTION:Payment Type S2 field added

--AUTHOR     :PRAVEEN NAYAKWADI
--DATE       :06/05/2022
--DESCRIPTION:CRChange #263983  Fix for negatiove values for fields [ResponseTime (S1)] [Acknowledgement_ResponseTime (S1)] [Informal_ResponseTime] [Acknowledgement_ResponseTime (S2)] [ResponseTime (S2)]

----==============================================================================================
--**/
-----Old comments prior to 07/12/2018
---- This is a dump of all the data concerned with the Datix complaints
---- It is a mirror of all of the contents of the complaints screen
---- This includes both titles and codes for fields
---- Both of these are not necessary, but it does help in debugging and development
---- It was done this way because of the complete lack of a specification for reporting
---- When a specification is made, remove the fields / joins that are not required






----- Date Formal Complaint Received

DECLARE 	@StartDate VARCHAR(20)='2022/07/01',
	@EndDate VARCHAR(20)='2022/12/10',
	@IncType VARCHAR(20)='All'



;WITH cteProgressNotes AS   
(	
SELECT DISTINCT CAT.pno_link_id AS [complaintID]
,		  STUFF((    
				SELECT '¬' + crby.fullname + ' '+ CAST(SUB.pno_createddate AS VARCHAR) + ' ' + SUB.pno_progress_notes + CHAR(13) + CHAR(10) AS [text()]                         
				FROM dbo.progress_notes SUB  					   
				INNER JOIN dbo.contacts_main crby  					   
				ON crby.initials = SUB.pno_createdby                         
				                       
				WHERE SUB.pno_link_id = CAT.pno_link_id AND sub.pno_link_module = cat.pno_link_module  			
				ORDER BY SUB.pno_createddate DESC  		   
				FOR XML PATH('')                          
			), 1, 1, '' )              
			AS [Progress Notes]  FROM  dbo.progress_notes CAT  WHERE CAT.pno_link_module = 'COM') 
			
--SELECT * FROM  cteProgressNotes
,fieldtypes AS
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



SELECT [Complaint ID]
      ,[Person Affected]
      ,[Responsible Manager Name]
      ,[Escalate to a Manager Name]
      ,[Last Updated]
      ,[Complaint Created By]
      ,[Reported Record Type Description]
      ,[Current Type Description]
      ,[Compliment Type]
      ,[Subject Description]
      ,[Sub-Subject Description]
      ,[Subject Outcome Description]
      ,[Current Stage Description]
      ,[Date Received]
      ,[Date Opened]
      ,[Month opened] [Month_opened]
      ,[Date of Events]
      ,[Date Closed]
      ,[Date Re-opened]
      ,[Date Closed (for Formal Complaints only)]
      ,[Organisation Description]
      ,[Business Stream Description]
      ,[Business Stream with Leasehold]
      ,[Region Description]
      ,[Area Description]
      ,[Scheme Description]
      ,[Method of receipt description]
      ,[Date Formal Complaint opened]
      ,[Month Formal Complaint opened]
      ,[Date Formal Complaint Acknowledged]
      ,[Date Investigation Concluded]
      ,[Date Final Response Approved]
      ,[Date Final Response Sent]
      ,[ResponseTime]
      ,[Outcome Description]
      ,[Action Taken Description]
      ,[Record Approval Description]
      ,[FCI - Failures in care or service delivery]
      ,[FCI - Compensation]
      ,[FCI - Lessons learned]
      ,[FCI - Training]
      ,[FCI - Outcome]
      ,[Description]
      ,[Immediate Action Taken]
      ,[Progress Notes]
      ,[Is this Formal Complaint under external enquiry?]
      ,[Who is undertaking the external enquiry? Description]
      ,[Enquiry outcome Description]
      ,[Is this Formal Complaint under external review?]
      ,[Who is undertaking this review? Description]
      ,[Details of other external agency review]
      ,[Residents Panel outcome Description]
      ,[Ombudsman outcomes Description]
      ,[Date Initial Response/Contact]
      ,[Compensation To be Awarded]
      ,[Compensation Type]
      ,[Compensation Payment Status]
      ,[Payment Type]
      ,[Date InFormal Complaint Responded]
      ,[Informal_ResponseTime]
	  ,CASE WHEN [Informal_ResponseTime] BETWEEN 0 AND 10 THEN 'YES'
	        WHEN [Informal_ResponseTime] >10 THEN 'NO' END  [Informal_ResponseTime Target Met]
      ,[Stage1 Date Formal Complaint Opened]
      ,[Stage1 Month Formal Complaint Opened]
      ,[Stage1 Date Formal Complaint Acknowledged]
      ,[Acknowledgement_ResponseTime (S1)]


	  ,CASE WHEN [Acknowledgement_ResponseTime (S1)]<=5 THEN 'Yes'
	  WHEN [Acknowledgement_ResponseTime (S1)]>5 THEN 'No' END 
	  [Acknowledgement Reponse Target Met]
      ,[FC Stage 1 Target Date]
      ,[Stage1 Date Initial Response / Contact]
      ,[Stage1 Date Investigation Concluded]
      ,[Date Approved By Head of Service]
      ,[Stage1 Date Final Response Sent]
      ,[ResponseTime (S1)]
      ,[FC Stage 1 Target Date Met?]
      ,[Reason Trgt Date Not_Met S1]
      ,[Extension Required?]
      ,[Reason Extension Required?]
      ,[Add Supporting Info As Required]
      ,[Date_of_Contact]
      ,[FC Stage 1 Ext Target Date]
      ,[Date Formal Complaint Opened (S2) ]
      ,[Month Formal Complaint Opened (S2) ]
      ,[Date Formal Complaint Acknowledged S2]
      ,[Acknowledgement_ResponseTime (S2)]
      ,[FC Stage 2 Target Date]
      ,[Date Initial Response / Contact (S2)]
      ,[Date Investigation Concluded (S2)]
      ,[Date Final Response Approved (S2)]
      ,[Date Final Response Sent (S2)]
      ,[ResponseTime (S2)]
      ,[Extension Required (S2)]
      ,[Reason Extension Required? (S2)]
      ,[Add Supporting Info As Required (S2)]
      ,[Date_Of_Contact (S2)]
      ,[FC Stage 2 Ext Target Date]
      ,[FC Stage 2 Target Date Met?]
      ,[Reason(s) target date not met (S2)]
      ,[Outcome]
      ,[Action_Taken_Following_Outcome]
      ,[Stage1 Compensation To Be Awarded]
      ,[Stage1 Compensation_ Type]
      ,[Stage1 Compensation Payment Status]
      ,[Stage1 Payment Type]
      ,[Outcome (S2)]
      ,[Action Taken (S2)]
      ,[Compensation To Be Awarded? (S2)]
      ,[Compensation Type (S2)]
      ,[Compensation Payment Status (S2)]
      ,[Contact_From_Ombudsman?]
	  ,[Outcome Confirmed?]
	  ,[Summary Key Changes To Impliment]
	  ,[Payment Type (S2)]
	
	  FROM 


(
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
--, 'Subjects' AS [Subjects]  
--, COALESCE(compl_main.com_subject1,'') AS [Subject Code]  
, COALESCE(code_com_subject.[description], 'No Subject') AS [Subject Description]  
																   
, COALESCE(code_sub_subject.[description], 'No Sub-Subject') AS [Sub-Subject Description]  
--, COALESCE(compl_main.com_subsubject1,'') AS [Sub-Subject Code]  
--, compl_main.com_outcome1 AS [Subject Outcome Code]  
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
--, 'Location' AS [Location]  
--, compl_main.com_organisation AS [Organisation Code]
, code_org.cod_descr AS [Organisation Description]  
--, compl_main.com_unit AS [Business Stream Code]
, code_unit.[description] AS [Business Stream Description]  
-- Added for Lindsey to include a separate Leasehold in Business Stream  
, CASE	WHEN code_clingroup.cod_descr = 'Leasehold' THEN code_clingroup.cod_descr  		
		ELSE code_unit.[description] 
		END AS [Business Stream with Leasehold]  
--, compl_main.com_clingroup AS [Region Code]
, code_clingroup.cod_descr AS [Region Description]  
--, compl_main.com_directorate AS [Area Code]
, code_directorate.[description] AS [Area Description]  
--, compl_main.com_specialty AS [Scheme Code]
, code_specialty.[description] AS [Scheme Description]  
--, 'Details' AS [Details]  
--, compl_main.com_method AS [Method of receipt code]
, code_com_method.[description] AS [Method of receipt description]  

, compDateOpen.udv_date AS [Date Formal Complaint opened]
, COALESCE(DATENAME(MONTH, compDateOpen.udv_date),' Date not set') AS [Month Formal Complaint opened]
, compDateAck.udv_date AS [Date Formal Complaint Acknowledged]  
, dateInvCon.udv_date AS [Date Investigation Concluded]  
, dateFinRespApp.udv_date AS [Date Final Response Approved]  
, dateFinRespSent.udv_date AS [Date Final Response Sent]  
-- NG required to do something about bank holidays  
-- to do this we need a table with the bank holiday dates  
-- see http://www.sqlservercentral.com/articles/Advanced+Querying/calculatingworkdays/1660/  
, DATEDIFF(DAY, compDateOpen.udv_date, dateFinRespSent.udv_date)  	
- DATEDIFF(WEEK, compDateOpen.udv_date, dateFinRespSent.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN compDateOpen.udv_date AND dateFinRespSent.udv_date) 	
- CASE WHEN DATENAME(dw, compDateOpen.udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw, dateFinRespSent.udv_date) = 'Saturday' THEN 1 ELSE 0 END AS ResponseTime  

, COALESCE(fcOutcome.[description], '') AS [Outcome Description]  
 
, COALESCE(fcActionDesc.udc_description, '') AS [Action Taken Description]  
, code_approval_status.[description] AS [Record Approval Description]  
  
, COALESCE(fciFail.udv_text, '') AS [FCI - Failures in care or service delivery]  
, COALESCE(fciComp.udv_text, '') AS [FCI - Compensation]  
, COALESCE(fciLessons.udv_text, '') AS [FCI - Lessons learned]  
, COALESCE(fciTrain.udv_text, '') AS [FCI - Training]  
, COALESCE(fciOutcome.udv_text, '') AS [FCI - Outcome] 
, compl_main.com_detail AS [Description]  -- moved to end
, uAction.udv_text AS [Immediate Action Taken]  -- moved to end 
, REPLACE(REPLACE(cteProgressNotes.[Progress Notes], '&#x0D;',CHAR(13)),'¬','') AS [Progress Notes]  -- moved to end  
, COALESCE(formCompEnq.udv_string, '') AS [Is this Formal Complaint under external enquiry?]   
--, COALESCE(whoExtEnq.udv_string, '') AS [Who is undertaking the external enquiry? Code]  
, COALESCE(whoExtEnqCode.udc_description, '') AS [Who is undertaking the external enquiry? Description]  
--, COALESCE(enqOutcome.udv_string, '') AS [Enquiry outcome Code]  
, COALESCE(enqOutcomeCode.udc_description, '') AS [Enquiry outcome Description]  
, COALESCE(formCompRev.udv_string, '') AS [Is this Formal Complaint under external review?]  
--, COALESCE(whoUndertakingRev.udv_string, '') AS [Who is undertaking this review? Code]  
, COALESCE(whoUndertakingRevCode.udc_description, '') AS [Who is undertaking this review? Description]  
, COALESCE(othExtAgRev.udv_text, '') AS [Details of other external agency review]  
--, COALESCE(resPanOut.udv_string, '') AS [Residents Panel outcome Code]  
, COALESCE(resPanOutCode.udc_description, '') AS [Residents Panel outcome Description]  
--, COALESCE(ombudsOut.udv_string, '') AS [Ombudsman outcomes Code]  
, COALESCE(ombudsOutCode.udc_description, '') AS [Ombudsman outcomes Description]  
--, 'Formal Complaint Investigation' AS [Formal Complaint Investigation]

,dateInitialRespon_Contact.udv_date [Date Initial Response/Contact]    
,COALESCE(compen_Awarded.udc_description,compen_Awarded.udv_string) [Compensation To be Awarded]
,REPLACE(compen_type.ct,'amp;','')   [Compensation Type]
,COALESCE(compen_Paid .udc_description,compen_Paid.udv_string)    [Compensation Payment Status]

,REPLACE(payment.pt,'amp;','')  [Payment Type]

-- add_supp_req
---Dt_InFormComp_Opened
,CONVERT(VARCHAR(10),Dt_InFormComp_Responded.udv_date,103) [Date InFormal Complaint Responded]


----compl_main.com_dopened AS [Date Opened] 



, 
CASE WHEN DATEDIFF(DAY, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date)  	
- DATEDIFF(WEEK, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN compl_main.com_dreceived AND Dt_InFormComp_Responded.udv_date) 	<1
THEN 
DATEDIFF(DAY, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date)  	
- DATEDIFF(WEEK, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN compl_main.com_dreceived AND Dt_InFormComp_Responded.udv_date)
ELSE

DATEDIFF(DAY, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date)  	
- DATEDIFF(WEEK, compl_main.com_dreceived, Dt_InFormComp_Responded.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN compl_main.com_dreceived AND Dt_InFormComp_Responded.udv_date)

- CASE WHEN DATENAME(dw, compl_main.com_dreceived) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw,Dt_InFormComp_Responded.udv_date) = 'Saturday' THEN 1 ELSE 0 END END  AS [Informal_ResponseTime]




,CONVERT(VARCHAR(10),Dt_FormComp_Opened.udv_date,103) [Stage1 Date Formal Complaint Opened]
---,COALESCE(MONTHName(Dt_FormComp_Opened),'Date Not Set') [Month Formal Complaint Opened]
,COALESCE(DATENAME(MONTH,Dt_FormComp_Opened.udv_date),'Date Not Set') [Stage1 Month Formal Complaint Opened]
,CONVERT(VARCHAR(10),Dt_FormComp_Ackn.udv_date,103) [Stage1 Date Formal Complaint Acknowledged]






---------------------------------------------Custom date table can be an alternate method
--,
--CASE WHEN 
-- DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  	
--- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date) * 2
--- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND Dt_FormComp_Ackn.udv_date)<1
--THEN 


-- DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  	
--- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date) * 2
--- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND Dt_FormComp_Ackn.udv_date)
--ELSE 

--DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  	
--- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date) * 2
--- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND Dt_FormComp_Ackn.udv_date) 	
--- CASE WHEN DATENAME(dw, [Dt_FormComp_Opened].udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
--- CASE WHEN DATENAME(dw,Dt_FormComp_Ackn.udv_date) = 'Saturday' THEN 1 ELSE 0 END END AS [Acknowledgement_ResponseTime (S1)]


,
CASE WHEN 
 DATEDIFF(DAY, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date)  	
- DATEDIFF(WEEK, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Date Formal Complaint Received].udv_date AND [Dt_FormComp_Opened].udv_date)<1
THEN 


 DATEDIFF(DAY, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date)  	
- DATEDIFF(WEEK, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Date Formal Complaint Received].udv_date AND [Dt_FormComp_Opened].udv_date)
ELSE 

DATEDIFF(DAY, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date)  	
- DATEDIFF(WEEK, [Date Formal Complaint Received].udv_date, [Dt_FormComp_Opened].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Date Formal Complaint Received].udv_date AND [Dt_FormComp_Opened].udv_date) 	
- CASE WHEN DATENAME(dw, [Date Formal Complaint Received].udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw,[Dt_FormComp_Opened].udv_date) = 'Saturday' THEN 1 ELSE 0 END END AS [Acknowledgement_ResponseTime (S1)]








,CONVERT(VARCHAR(10),FC_Stage1_TargetDate.udv_date,103)   [FC Stage 1 Target Date]	

----
,CONVERT(VARCHAR(10),Dt_Ini_Resp__Cntct.udv_date,103) [Stage1 Date Initial Response / Contact]

,CONVERT(VARCHAR(10),Dt_Investig_Conclud.udv_date,103) [Stage1 Date Investigation Concluded]
,CONVERT(VARCHAR(10),Dt_Approved_HeadOfService.udv_date,103) [Date Approved By Head of Service]
,CONVERT(VARCHAR(10),Dt_Final_Response_Sent.udv_date,103) [Stage1 Date Final Response Sent]




------ Date Formal Complaint Received



,
CASE WHEN 
 DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, [Dt_Final_Response_Sent].udv_date)  	
- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, [Dt_Final_Response_Sent].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND [Dt_Final_Response_Sent].udv_date) 	

<1 THEN

 DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  	
- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND Dt_FormComp_Ackn.udv_date)
ELSE 

 DATEDIFF(DAY, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date)  	
- DATEDIFF(WEEK, [Dt_FormComp_Opened].udv_date, Dt_FormComp_Ackn.udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND Dt_FormComp_Ackn.udv_date)

- CASE WHEN DATENAME(dw, [Dt_FormComp_Opened].udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw, Dt_Final_Response_Sent.udv_date) = 'Saturday' THEN 1 ELSE 0 END END  AS [ResponseTime (S1)]




---Dt_Final_Response_Sent.udv_date ,Dt_FormComp_Opened.udv_date
,CASE WHEN COALESCE(FC_Stage1_Trgt_Date_Met .udc_description,FC_Stage1_Trgt_Date_Met.udv_string)='Y' THEN 'YES' 
WHEN COALESCE(FC_Stage1_Trgt_Date_Met .udc_description,FC_Stage1_Trgt_Date_Met.udv_string)='N' THEN 'NO'  END [FC Stage 1 Target Date Met?]

--Reason_Trgt_Date_Not_Met_S1


,Reason_Trgt_Date_Not_Met_S1.udv_text [Reason Trgt Date Not_Met S1]

,CASE WHEN COALESCE(Extension_required .udc_description,Extension_required.udv_string)='Y' THEN 'YES' 
WHEN COALESCE(Extension_required .udc_description,Extension_required.udv_string)='N' THEN 'NO'  END [Extension Required?]

,COALESCE(Reason_Extens_Required.udc_description,Reason_Extens_Required.udv_string) [Reason Extension Required?]
---,COALESCE(add_supp_req.udc_description,add_supp_req.udv_string,add_supp_req.udv_text)    [Add supporting info as required]
,COALESCE(Add_Suprt_Info_Requi.udc_description,Add_Suprt_Info_Requi.udv_string,Add_Suprt_Info_Requi.udv_text)    [Add Supporting Info As Required]

,CONVERT(VARCHAR(10),Date_of_contact.udv_date,103) [Date_of_Contact]


,CONVERT(VARCHAR(10),FC_Stage1_Ext_target_date.udv_date,103) [FC Stage 1 Ext Target Date]

,CONVERT(VARCHAR(10),[Dt_Formal_Complain_ Opened_S2].udv_date,103) [Date Formal Complaint Opened (S2) ]
,COALESCE(DATENAME(MONTH,[Dt_Formal_Complain_ Opened_S2].udv_date),'Date Not Set') [Month Formal Complaint Opened (S2) ]


,CONVERT(VARCHAR(10),[Dt_Formal_Complaint_Acknow(S2)].udv_date,103) [Date Formal Complaint Acknowledged S2]


----Ack ResponseTimeS2

, 
CASE WHEN  DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND [Dt_Formal_Complaint_Acknow(S2)].udv_date) <1
THEN DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND [Dt_Formal_Complaint_Acknow(S2)].udv_date)
ELSE
DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [Dt_Formal_Complaint_Acknow(S2)].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_FormComp_Opened].udv_date AND [Dt_Formal_Complaint_Acknow(S2)].udv_date)	
- CASE WHEN DATENAME(dw, [Dt_Formal_Complain_ Opened_S2].udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw,[Dt_Formal_Complaint_Acknow(S2)].udv_date) = 'Saturday' THEN 1 ELSE 0 END END  AS [Acknowledgement_ResponseTime (S2)]







,CONVERT(VARCHAR(10),[FC_Stage2_Trgt_Dt].udv_date,103) [FC Stage 2 Target Date]
,CONVERT(VARCHAR(10),[Date_Initial_Response_ContactS2].udv_date,103) [Date Initial Response / Contact (S2)]
,CONVERT(VARCHAR(10),[dt_Investiga_Conclu].udv_date,103) [Date Investigation Concluded (S2)]
,CONVERT(VARCHAR(10),[dt_FinalResponse_ApprS2].udv_date,103) [Date Final Response Approved (S2)]
,CONVERT(VARCHAR(10),[dt_FinalResponse_SentS2].udv_date,103) [Date Final Response Sent (S2)]

, CASE WHEN DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_Formal_Complain_ Opened_S2].udv_date AND [dt_FinalResponse_SentS2].udv_date) <1
THEN


DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_Formal_Complain_ Opened_S2].udv_date AND [dt_FinalResponse_SentS2].udv_date) 	

ELSE
DATEDIFF(DAY, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date)  	
- DATEDIFF(WEEK, [Dt_Formal_Complain_ Opened_S2].udv_date, [dt_FinalResponse_SentS2].udv_date) * 2
- (SELECT COUNT(*) FROM DatixReporting.DBO.BANK_HOLIDAYS WHERE HOLDATE BETWEEN [Dt_Formal_Complain_ Opened_S2].udv_date AND [dt_FinalResponse_SentS2].udv_date) 	
	
- CASE WHEN DATENAME(dw, [Dt_Formal_Complain_ Opened_S2].udv_date) = 'Sunday' THEN 1 ELSE 0 END  	
- CASE WHEN DATENAME(dw, dt_FinalResponse_SentS2.udv_date) = 'Saturday' THEN 1 ELSE 0 END END  AS [ResponseTime (S2)]





,CASE WHEN COALESCE([Extension RequiredS2] .udc_description,[Extension RequiredS2].udv_string)='Y' THEN 'YES' 
WHEN COALESCE([Extension RequiredS2] .udc_description,[Extension RequiredS2].udv_string)='N' THEN 'NO'  END [Extension Required (S2)]

,COALESCE(Reason_extension_RequiredS2.udc_description,Reason_extension_RequiredS2.udv_string) [Reason Extension Required? (S2)]
,COALESCE(add_supp_req_S2.udc_description,add_supp_req_S2.udv_string,add_supp_req_S2.udv_text)    [Add Supporting Info As Required (S2)]
,CONVERT(VARCHAR(10),[Date_of_contactS2].udv_date,103)  [Date_Of_Contact (S2)]
,CONVERT(VARCHAR(10),[FC_Stage_2_Ext_target_dt].udv_date,103) [FC Stage 2 Ext Target Date]




,CASE WHEN COALESCE([FC Stage 2 Target Date Met?].udc_description,[FC Stage 2 Target Date Met?].udv_string)='Y' THEN 'Yes'
     WHEN COALESCE([FC Stage 2 Target Date Met?].udc_description,[FC Stage 2 Target Date Met?].udv_string)='N' THEN 'No'
END [FC Stage 2 Target Date Met?]
--[FC Stage 2 Target Date Met?] [Reason(s) target date not met (S2)]

,[Reason(s) target date not met (S2)].udv_text  [Reason(s) target date not met (S2)]

,([Outcome].udc_description) [Outcome]

,COALESCE([Action_Taken_Following_Outcome].udc_description,[Action_Taken_Following_Outcome].udv_string) [Action_Taken_Following_Outcome]
,CASE WHEN COALESCE([Compensation_to_be_awarded] .udc_description,[Compensation_to_be_awarded].udv_string)='Y' THEN 'YES' 
WHEN COALESCE([Compensation_to_be_awarded] .udc_description,[Compensation_to_be_awarded].udv_string)='N' THEN 'NO'  END [Stage1 Compensation To Be Awarded]

,([Compensation_Type].udc_description) [Stage1 Compensation_ Type]

,COALESCE([Compensation_Payment_Status].udc_description,[Compensation_Payment_Status].udv_string) [Stage1 Compensation Payment Status]
,REPLACE(payment.pt,'amp;','') [Stage1 Payment Type]

,([OutcomeS2].udc_description) [Outcome (S2)]
,COALESCE([Action_TakenS2].udc_description,[Action_TakenS2].udv_string) [Action Taken (S2)]
,CASE WHEN COALESCE([Compensation_to_be_awardedS2] .udc_description,[Compensation_to_be_awardedS2].udv_string)='Y' THEN 'YES' 
WHEN COALESCE([Compensation_to_be_awardedS2] .udc_description,[Compensation_to_be_awardedS2].udv_string)='N' THEN 'NO'  END [Compensation To Be Awarded? (S2)]


,([Compensation_TypeS2].udc_description) [Compensation Type (S2)]
,([Compensation_Payment_StatusS2].udc_description) [Compensation Payment Status (S2)]


,CASE WHEN COALESCE([Contact_from_Ombudsman?] .udc_description,[Contact_from_Ombudsman?].udv_string)='Y' THEN 'YES' 
WHEN COALESCE([Contact_from_Ombudsman?] .udc_description,[Contact_from_Ombudsman?].udv_string)='N' THEN 'NO'  END [Contact_From_Ombudsman?]

,CASE WHEN [Outcome Confirmed?].udv_string ='Y' THEN 'YES'
            WHEN [Outcome Confirmed?].udv_string ='N' THEN 'NO' ELSE NULL END  [Outcome Confirmed?]

,COALESCE([summary key changes to impliment].udc_description,[summary key changes to impliment].udv_text )   [summary key changes to impliment]

,COALESCE([Payment Type (S2)].udc_description,[Payment Type (S2)].udv_text )   [Payment Type (S2)]
-----[Payment Type (S2)]



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
INNER JOIN dbo.code_types code_org  
ON code_org.cod_code = compl_main.com_organisation AND code_org.cod_type = 'ORG'  
INNER JOIN dbo.code_unit  
ON code_unit.code = compl_main.com_unit  
INNER JOIN dbo.code_types code_clingroup  
ON code_clingroup.cod_code = compl_main.com_clingroup AND code_clingroup.cod_type = 'CLINGROUP'  
INNER JOIN dbo.code_directorate  
ON code_directorate.code = compl_main.com_directorate  
INNER JOIN dbo.code_specialty  
ON code_specialty.code = compl_main.com_specialty  
INNER JOIN dbo.code_com_method  
ON compl_main.com_method = code_com_method.code  
INNER JOIN dbo.udf_values uAction  
ON uAction.mod_id = 2 AND uAction.field_id = 41 AND uAction.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values qConsent  
ON qConsent.mod_id = 2 AND qConsent.field_id = 44 AND qConsent.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values consentDetails  
ON consentDetails.mod_id = 2 AND consentDetails.field_id = 45 AND consentDetails.cas_id = compl_main.recordid
LEFT OUTER JOIN dbo.udf_values compDateOpen
ON compDateOpen.mod_id = 2 AND compDateOpen.field_id = 86 AND compDateOpen.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values compDateAck  
ON compDateAck.mod_id = 2 AND compDateAck.field_id = 55 AND compDateAck.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values dateInvCon  
ON dateInvCon.mod_id = 2 AND dateInvCon.field_id = 56 AND dateInvCon.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values dateFinRespApp  
ON dateFinRespApp.mod_id = 2 AND dateFinRespApp.field_id = 57 AND dateFinRespApp.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values dateFinRespSent  
ON dateFinRespSent.mod_id = 2 AND dateFinRespSent.field_id = 58 AND dateFinRespSent.cas_id = compl_main.recordid  
INNER JOIN dbo.contacts_main respmgr  
ON respmgr.initials = compl_main.com_mgr  
LEFT OUTER JOIN dbo.contacts_main escmgr  
ON escmgr.initials = COALESCE(compl_main.com_head, LEFT(compl_main.com_investigator, 3))  
 
LEFT OUTER JOIN cteProgressNotes  
ON cteProgressNotes.complaintID = compl_main.recordid  
LEFT OUTER JOIN dbo.code_com_outcome fcOutcome  
ON fcOutcome.code = compl_main.com_outcome  
LEFT OUTER JOIN dbo.udf_values fcAction  
ON fcAction.mod_id = 2 AND fcAction.field_id = 63 AND fcAction.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes fcActionDesc  
ON fcActionDesc.field_id = fcAction.field_id AND fcActionDesc.udc_code = fcAction.udv_string
INNER JOIN dbo.code_approval_status  
ON compl_main.rep_approved = code_approval_status.code AND code_approval_status.module = 'COM' 
-- 07/03/2017 join changed from INNER to LEFT OUTER to include unapproved complaints  
LEFT OUTER JOIN dbo.code_com_stages  
ON compl_main.com_curstage = code_com_stages.code  
LEFT OUTER JOIN dbo.udf_values formCompEnq  
ON formCompEnq.mod_id = 2 AND formCompEnq.field_id = 66 AND formCompEnq.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values whoExtEnq  
ON whoExtEnq.mod_id = 2 AND whoExtEnq.field_id = 67 AND whoExtEnq.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes whoExtEnqCode  
ON whoExtEnqCode.field_id = whoExtEnq.field_id AND whoExtEnqCode.udc_code = whoExtEnq.udv_string  
LEFT OUTER JOIN dbo.udf_values enqOutcome  
ON enqOutcome.mod_id = 2 AND enqOutcome.field_id = 68 AND enqOutcome.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes enqOutcomeCode  
ON enqOutcomeCode.field_id = enqOutcome.field_id AND enqOutcomeCode.udc_code = enqOutcome.udv_string  
LEFT OUTER JOIN dbo.udf_values formCompRev  
ON formCompRev.mod_id = 2 AND formCompRev.field_id = 64 AND formCompRev.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values whoUndertakingRev  
ON whoUndertakingRev.mod_id = 2 AND whoUndertakingRev.field_id = 53 AND whoUndertakingRev.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes whoUndertakingRevCode  
ON whoUndertakingRevCode.field_id = whoUndertakingRev.field_id AND whoUndertakingRevCode.udc_code = whoUndertakingRev.udv_string  
LEFT OUTER JOIN dbo.udf_values resPanOut  
ON resPanOut.mod_id = 2 AND resPanOut.field_id = 60 AND resPanOut.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes resPanOutCode  
ON resPanOutCode.field_id = resPanOut.field_id AND resPanOutCode.udc_code = resPanOut.udv_string  
LEFT OUTER JOIN dbo.udf_values ombudsOut  
ON ombudsOut.mod_id = 2 AND ombudsOut.field_id = 59 AND ombudsOut.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_codes ombudsOutCode  
ON ombudsOutCode.field_id = ombudsOut.field_id AND ombudsOutCode.udc_code = ombudsOut.udv_string  
LEFT OUTER JOIN dbo.udf_values othExtAgRev  
ON othExtAgRev.mod_id = 2 AND othExtAgRev.field_id = 43 AND othExtAgRev.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values fciFail  
ON fciFail.mod_id = 2 AND fciFail.field_id = 46 AND fciFail.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values fciComp  
ON fciComp.mod_id = 2 AND fciComp.field_id = 47 AND fciComp.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values fciLessons  
ON fciLessons.mod_id = 2 AND fciLessons.field_id = 48 AND fciLessons.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values fciTrain  
ON fciTrain.mod_id = 2 AND fciTrain.field_id = 49 AND fciTrain.cas_id = compl_main.recordid  
LEFT OUTER JOIN dbo.udf_values fciOutcome  
ON fciOutcome.mod_id = 2 AND fciOutcome.field_id = 50 AND fciOutcome.cas_id = compl_main.recordid 

----- Date Initial Response 

LEFT OUTER JOIN  fieldtypes  dateInitialRespon_Contact  
ON dateInitialRespon_Contact.cas_id=compl_main.recordid   
AND RTRIM(LTRIM(fld_name))='Date Initial Response / Contact'


------Compensation to be awarded
LEFT OUTER JOIN fieldtypes compen_Awarded 
ON compen_Awarded.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(compen_Awarded.fld_name))='Compensation to be awarded?'

------Compensation Paid
LEFT OUTER JOIN fieldtypes compen_Paid ON compen_Paid.cas_id = compl_main.recordid
AND compen_Paid.fld_name='Compensation Payment Status'


																				  
										

-----Compensation Type
OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE(compen_type.udc_description,compen_type.udv_string,'') ---udc_description
FROM fieldtypes compen_type
WHERE compen_type.cas_id = compl_main.recordid
AND  compen_type.fld_name='Compensation Type'
FOR XML PATH ('')),1,1,'') ct

)compen_type

-----payment type Dt_FormComp_Opened

OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE(paymen_type.udc_description,'') 
FROM fieldtypes paymen_type
WHERE paymen_type.cas_id = compl_main.recordid
AND  paymen_type.fld_name='payment type'
FOR XML PATH ('')),1,1,'') pt

)payment


---------------------------------- new fields
---Informal Complaint Date Responded	

----Dt_InFormComp_Responded.
LEFT OUTER JOIN fieldtypes Dt_InFormComp_Responded
ON Dt_InFormComp_Responded.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(Dt_InFormComp_Responded.fld_name))='Informal Complaint Date Responded'
                                                   ---- 'Informal Complaint Date Responded'
LEFT OUTER JOIN fieldtypes Dt_FormComp_Opened
ON Dt_FormComp_Opened.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(Dt_FormComp_Opened.fld_name))='Date Formal Complaint opened'

LEFT OUTER JOIN fieldtypes [Date Formal Complaint Received]
ON [Date Formal Complaint Received].cas_id = compl_main.recordid  
AND RTRIM(LTRIM([Date Formal Complaint Received].fld_name))='Date Formal Complaint Received'



LEFT OUTER JOIN fieldtypes Dt_FormComp_Ackn
ON Dt_FormComp_Ackn.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(Dt_FormComp_Ackn.fld_name))='Date Formal Complaint Acknowledged'


----- Date Formal Complaint Received

LEFT OUTER JOIN fieldtypes FC_Stage1_TargetDate
ON FC_Stage1_TargetDate.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(FC_Stage1_TargetDate.fld_name))='FC Stage 1 Target Date'


LEFT OUTER JOIN fieldtypes Dt_Ini_Resp__Cntct
ON Dt_Ini_Resp__Cntct.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(Dt_Ini_Resp__Cntct.fld_name))='Date Initial Response / Contact'





LEFT OUTER JOIN fieldtypes Dt_Investig_Conclud
ON Dt_Investig_Conclud.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(Dt_Investig_Conclud.fld_name))='Date Investigation Concluded'


LEFT OUTER JOIN fieldtypes Dt_Approved_HeadOfService
ON  Dt_Approved_HeadOfService.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Dt_Approved_HeadOfService.fld_name))='Date approved by Head of Service'

LEFT OUTER JOIN fieldtypes Dt_Final_Response_Sent
ON  Dt_Final_Response_Sent.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Dt_Final_Response_Sent.fld_name))='Date Final Response Sent'

LEFT OUTER JOIN fieldtypes FC_Stage1_Trgt_Date_Met
ON  FC_Stage1_Trgt_Date_Met.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( FC_Stage1_Trgt_Date_Met.fld_name))='FC Stage 1 Target Date Met?'

LEFT OUTER JOIN fieldtypes Reason_Trgt_Date_Not_Met_S1
ON  Reason_Trgt_Date_Not_Met_S1.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Reason_Trgt_Date_Not_Met_S1.fld_name))='Reason(s) target date not met (S1)'

LEFT OUTER JOIN fieldtypes Extension_Required
ON  Extension_Required.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Extension_Required.fld_name))='Extension required?'

LEFT OUTER JOIN fieldtypes Reason_Extens_Required
ON  Reason_Extens_Required.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Reason_Extens_Required.fld_name))='Reason extension required?'

LEFT OUTER JOIN fieldtypes Add_Suprt_Info_Requi
ON  Add_Suprt_Info_Requi.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Add_Suprt_Info_Requi.fld_name))='Add supporting info as required'

LEFT OUTER JOIN fieldtypes Date_of_contact
ON  Date_of_contact.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( Date_of_contact.fld_name))='Date of contact'

LEFT OUTER JOIN fieldtypes FC_Stage1_Ext_target_date
ON  FC_Stage1_Ext_target_date.cas_id = compl_main.recordid  
AND RTRIM(LTRIM( FC_Stage1_Ext_target_date.fld_name))='FC Stage 1 Ext target date'

LEFT OUTER JOIN fieldtypes [Dt_Formal_Complain_ Opened_S2]
ON  [Dt_Formal_Complain_ Opened_S2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Dt_Formal_Complain_ Opened_S2].fld_name))='Date Formal Complaint Opened (S2)'


LEFT OUTER JOIN fieldtypes [Dt_Formal_Complaint_Acknow(S2)]
ON  [Dt_Formal_Complaint_Acknow(S2)].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Dt_Formal_Complaint_Acknow(S2)].fld_name))='Date Formal Complaint Acknowledged (S2)'


LEFT OUTER JOIN fieldtypes [FC_Stage2_Trgt_Dt]
ON  [FC_Stage2_Trgt_Dt].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [FC_Stage2_Trgt_Dt].fld_name))='FC Stage 2 Target Date'

LEFT OUTER JOIN fieldtypes [Date_Initial_Response_ContactS2]
ON  [Date_Initial_Response_ContactS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Date_Initial_Response_ContactS2].fld_name))='Date Initial Response / Contact (S2)'


LEFT OUTER JOIN  fieldtypes  dt_Investiga_Conclu 
ON dt_Investiga_Conclu.cas_id=compl_main.recordid   
AND RTRIM(LTRIM(dt_Investiga_Conclu.fld_name))='Date Investigation Concluded (S2)'



LEFT OUTER JOIN  fieldtypes  dt_FinalResponse_ApprS2 
ON dt_FinalResponse_ApprS2.cas_id=compl_main.recordid   
AND RTRIM(LTRIM(dt_FinalResponse_ApprS2.fld_name))='Date Final Response Approved (S2)'



LEFT OUTER JOIN  fieldtypes  dt_FinalResponse_SentS2 
ON dt_FinalResponse_SentS2.cas_id=compl_main.recordid   
AND RTRIM(LTRIM(dt_FinalResponse_SentS2.fld_name))='Date Final Response Sent (S2)'


LEFT OUTER JOIN fieldtypes [Extension RequiredS2]
ON  [Extension RequiredS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Extension RequiredS2].fld_name))='Extension Required? (S2)'


LEFT OUTER JOIN fieldtypes [Reason_extension_RequiredS2]
ON  [Reason_extension_RequiredS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Reason_extension_RequiredS2].fld_name))='Reason extension required? (S2)'

LEFT OUTER JOIN fieldtypes [Date_of_contactS2]
ON  [Date_of_contactS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Date_of_contactS2].fld_name))='Date of contact (S2)'

LEFT OUTER JOIN fieldtypes [FC_Stage_2_Ext_target_dt]
ON  [FC_Stage_2_Ext_target_dt].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [FC_Stage_2_Ext_target_dt].fld_name))='FC Stage 2 Ext target date'

OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Outcome_i].udc_description,'')
FROM fieldtypes [Outcome_i]
WHERE [Outcome_i].cas_id = compl_main.recordid
AND  [Outcome_i].fld_name='Outcome'
FOR XML PATH ('')),1,1,'')  udc_description
)[Outcome]


LEFT OUTER JOIN fieldtypes [Action_Taken_Following_Outcome]
ON  [Action_Taken_Following_Outcome].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Action_Taken_Following_Outcome].fld_name))='Action Taken following Outcome'


LEFT OUTER JOIN fieldtypes [Compensation_to_be_awarded]
ON  [Compensation_to_be_awarded].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Compensation_to_be_awarded].fld_name))='Compensation to be awarded?'




OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Compensation TYPE].udc_description,'')
FROM fieldtypes [Compensation TYPE]
WHERE [Compensation TYPE].cas_id = compl_main.recordid
AND  [Compensation TYPE].fld_name='Compensation Type'
FOR XML PATH ('')),1,1,'')  udc_description

)[Compensation_Type]

OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Compensation Payment_Status].udc_description,'')FROM fieldtypes [Compensation Payment_Status]
WHERE [Compensation Payment_Status].cas_id = compl_main.recordid
AND  [Compensation Payment_Status].fld_name='Compensation Payment Status'
FOR XML PATH ('')),1,1,'')  udc_description

)[Compensation Payment Status]


LEFT OUTER JOIN fieldtypes [Compensation_Payment_Status]
ON [Compensation_Payment_Status].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Compensation_Payment_Status].fld_name))='Compensation Payment Status'

--LEFT OUTER JOIN fieldtypes [Payment Type]
--ON [Payment Type].cas_id = compl_main.recordid  
--AND RTRIM(LTRIM( [Payment Type].fld_name))='Payment Type'



OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Outcome_S2].udc_description,'')
FROM fieldtypes [Outcome_S2]
WHERE [Outcome_S2].cas_id = compl_main.recordid
AND  [Outcome_S2].fld_name='Outcome (S2)'
FOR XML PATH ('')),1,1,'')  udc_description
)[OutcomeS2]

LEFT OUTER JOIN fieldtypes [Action_TakenS2]
ON [Action_TakenS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Action_TakenS2].fld_name))='Action Taken (S2)'

LEFT OUTER JOIN fieldtypes [Compensation_to_be_awardedS2]
ON [Compensation_to_be_awardedS2].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Compensation_to_be_awardedS2].fld_name))='Compensation to be awarded? (S2)'


OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Compensation TypeS2].udc_description,'')
FROM fieldtypes [Compensation TypeS2]
WHERE [Compensation TypeS2].cas_id = compl_main.recordid
AND  [Compensation TypeS2].fld_name='Compensation Type (S2)'
FOR XML PATH ('')),1,1,'')  udc_description

)[Compensation_TypeS2]


OUTER APPLY(
SELECT
STUFF((SELECT  ','+COALESCE([Compensation Payment StatusS2].udc_description,'')
FROM fieldtypes [Compensation Payment StatusS2]
WHERE [Compensation Payment StatusS2].cas_id = compl_main.recordid
AND  [Compensation Payment StatusS2].fld_name='Compensation Payment Status (S2)'
FOR XML PATH ('')),1,1,'')  udc_description

)[Compensation_Payment_StatusS2]


LEFT OUTER JOIN fieldtypes [Contact_from_Ombudsman?]
ON [Contact_from_Ombudsman?].cas_id = compl_main.recordid  
AND RTRIM(LTRIM( [Contact_from_Ombudsman?].fld_name))='Contact from Ombudsman?'



LEFT OUTER JOIN fieldtypes add_supp_req
ON add_supp_req.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(add_supp_req.fld_name))='Add supporting info as required'



LEFT OUTER JOIN fieldtypes add_supp_req_S2
ON add_supp_req_S2.cas_id = compl_main.recordid  
AND RTRIM(LTRIM(add_supp_req_S2.fld_name))='Add supporting info as required (S2)'



LEFT OUTER JOIN fieldtypes [FC Stage 2 Target Date Met?]
ON [FC Stage 2 Target Date Met?].cas_id = compl_main.recordid  
AND RTRIM(LTRIM([FC Stage 2 Target Date Met?].fld_name))='FC Stage 2 Target Date Met?'

LEFT OUTER JOIN fieldtypes [Reason(s) target date not met (S2)]
ON [Reason(s) target date not met (S2)].cas_id = compl_main.recordid  
AND RTRIM(LTRIM([Reason(s) target date not met (S2)].fld_name))='Reason(s) target date not met (S2)'

LEFT OUTER JOIN fieldtypes [Outcome Confirmed?]
ON [Outcome Confirmed?].cas_id = compl_main.recordid  
AND RTRIM(LTRIM([Outcome Confirmed?].fld_name))='Outcome Confirmed?'

LEFT OUTER JOIN fieldtypes [summary key changes to impliment]
ON [summary key changes to impliment].cas_id = compl_main.recordid  
--AND RTRIM(LTRIM([summary key changes to impliment].fld_name)) LIKE '%Summarise%'
AND [summary key changes to impliment].fld_name='Summarise key change(s) made or to be implemented'

LEFT OUTER JOIN fieldtypes [Payment Type (S2)]
ON [Payment Type (S2)].cas_id = compl_main.recordid  
--AND RTRIM(LTRIM([summary key changes to impliment].fld_name)) LIKE '%Summarise%'
AND [Payment Type (S2)].fld_name='Payment Type (S2)'

WHERE


 compl_main.com_dreceived >= CAST(@StartDate AS DATETIME)
AND compl_main.com_dreceived <= CAST(@EndDate AS DATETIME)
AND (CHARINDEX(code_com_type.[description], @incType) > 0 OR @IncType = 'ALL') -- current record type
AND ISNUMERIC(compl_main.recordid)=1







) r
ORDER BY  [Complaint ID]  






