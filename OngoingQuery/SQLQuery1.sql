DECLARE 	@StartDate VARCHAR(20)='2022/04/01',
	@EndDate VARCHAR(20)='2022/05/31',
	@IncType VARCHAR(20)='All'


----;WITH cteProgressNotes AS   
----(	
--SELECT DISTINCT CAT.pno_link_id AS [complaintID]
--,		  STUFF((    
--				SELECT '¬' + crby.fullname + ' '+ CAST(SUB.pno_createddate AS VARCHAR) + ' ' + SUB.pno_progress_notes + CHAR(13) + CHAR(10) AS [text()]                         
--				FROM dbo.progress_notes SUB  					   
--				INNER JOIN dbo.contacts_main crby  					   
--				ON crby.initials = SUB.pno_createdby                         
				                       
--				WHERE SUB.pno_link_id = CAT.pno_link_id AND sub.pno_link_module = cat.pno_link_module  			
--				ORDER BY SUB.pno_createddate DESC  		   
--				FOR XML PATH('')                          
--			), 1, 1, '' )              
--			AS [Progress Notes] 
			
--			INTO #cc
			
--			 FROM  dbo.progress_notes CAT  WHERE CAT.pno_link_module = 'COM'
			
--			---) 
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
--, code_org.cod_descr AS [Organisation Description]  
----, compl_main.com_unit AS [Business Stream Code]
--, code_unit.[description] AS [Business Stream Description]  
---- Added for Lindsey to include a separate Leasehold in Business Stream  
--, CASE	WHEN code_clingroup.cod_descr = 'Leasehold' THEN code_clingroup.cod_descr  		
--		ELSE code_unit.[description] 
--		END AS [Business Stream with Leasehold]  
----, compl_main.com_clingroup AS [Region Code]
--, code_clingroup.cod_descr AS [Region Description]  
----, compl_main.com_directorate AS [Area Code]
--, code_directorate.[description] AS [Area Description]  
--, compl_main.com_specialty AS [Scheme Code]
, LEFT(code_specialty.[description],4) AS [Scheme]  
--, 'Details' AS [Details]  
--, compl_main.com_method AS [Method of receipt code]
, code_com_method.[description] AS [Method of receipt description]  
--,[Progress Notes]


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
--INNER JOIN dbo.code_types code_org  
--ON code_org.cod_code = compl_main.com_organisation AND code_org.cod_type = 'ORG'  
--INNER JOIN dbo.code_unit  
--ON code_unit.code = compl_main.com_unit  
--INNER JOIN dbo.code_types code_clingroup  
--ON code_clingroup.cod_code = compl_main.com_clingroup AND code_clingroup.cod_type = 'CLINGROUP'  
--INNER JOIN dbo.code_directorate  
--ON code_directorate.code = compl_main.com_directorate  
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
WHERE 
 compl_main.com_dopened >= CAST(@StartDate AS DATETIME)
AND compl_main.com_dopened<= CAST(@EndDate AS DATETIME)
AND (CHARINDEX(code_com_type.[description], @incType) > 0 OR @IncType = 'ALL') -- current record type