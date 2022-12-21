USE [Versaa_Prod_DW]
GO

/****** Object:  StoredProcedure [HC21].[H21_FRA_Detailed_Risk_Status]    Script Date: 19/12/2022 15:18:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




/*
====================================================================================================================
Author:			Trishna Mistry
Creation Date:	01/08/2019
Description:	FRA_Detailed_Risk_Status - Shows details of each risk logged against courts and what status they are 
										   in.

Amendment History
------------------

Date      		By            		Description
-----     		---           		------------
01/08/2019		Trishna Mistry		Initial version
31/10/2019		Trishna Mistry		Add RiskAction_Text column as per Keret and Liam 
									and renamed to Detail of action taken by risk owner
18/02/2021		Trishna Mistry		Added parameter for comp_id to be used to filter in report
====================================================================================================================
*/

CREATE PROCEDURE [HC21].[H21_FRA_Detailed_Risk_Status]
@Asset_Management_Region  nvarchar(max),
@Housing_Region  nvarchar(max),
@Risk_Status  nvarchar(max),
@Risk_Owner  nvarchar(max),
@RAG  nvarchar(max),
@Comp_ID		nvarchar(max)

as

;with 
All_risks_cte
as
(

-----The Building Section

select 	
		'Obs1' as Fra_Type,
		Obs1.RiskID_Text,
		Obs1.FormID_Text,
		Obs1.Risk_Text,
		Obs1.Comments_Text,
		Obs1.Deadline_DateTime,
		Obs1.Owner_Text,
		Obs1.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA100ObVservations AS Obs1

--where RiskID_Text is not null

union

------MEANS OF GIVING WARNING IN CASE OF FIRE  Section
select 	
		'Obs2' as Fra_Type,
		Obs2.RiskID_Text,
		Obs2.FormID_Text,
		Obs2.Risk_Text,
		Obs2.Comments_Text,
		Obs2.Deadline_DateTime,
		Obs2.Owner_Text,
		Obs2.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA200Observations AS Obs2

--where RiskID_Text is not null

union

-------------Details of Fire Loss Section
select 	
		'Obs3' as Fra_Type,
		Obs3.RiskID_Text,
		Obs3.FormID_Text,
		Obs3.Risk_Text,
		Obs3.Comments_Text,
		Obs3.Deadline_DateTime,
		Obs3.Owner_Text,
		Obs3.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA300Observations AS Obs3

--where RiskID_Text is not null

union

--------The Occupant - Information provided by the Court Manager Section
select 	
		'Obs4' as Fra_Type,
		Obs4.RiskID_Text,
		Obs4.FormID_Text,
		Obs4.Risk_Text,
		Obs4.Comments_Text,
		Obs4.Deadline_DateTime,
		Obs4.Owner_Text,
		Obs4.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA400Observations AS Obs4

--where RiskID_Text is not null

union

----------Evacuation Strategy and Training Section

select 	
		'Obs5' as Fra_Type,
		Obs5.RiskID_Text,
		Obs5.FormID_Text,
		Obs5.Risk_Text,
		Obs5.Comments_Text,
		Obs5.Deadline_DateTime,
		Obs5.Owner_Text,
		Obs5.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA500Observations AS Obs5

--where RiskID_Text is not null

union

--------Fire Hazards - Elimination & Control Section

select 	
		'Obs6' as Fra_Type,
		Obs6.RiskID_Text,
		Obs6.FormID_Text,
		Obs6.Risk_Text,
		Obs6.Comments_Text,
		Obs6.Deadline_DateTime,
		Obs6.Owner_Text,
		Obs6.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA600Observations AS Obs6

--where RiskID_Text is not null

union

----------Fire Protection Measures Section

select 	
		'Obs7' as Fra_Type,
		Obs7.RiskID_Text,
		Obs7.FormID_Text,
		Obs7.Risk_Text,
		Obs7.Comments_Text,
		Obs7.Deadline_DateTime,
		Obs7.Owner_Text,
		Obs7.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA700Observations AS Obs7

--where RiskID_Text is not null

union

---------Measures to limit fire spread and development Section

select 	
		'Obs8' as Fra_Type,
		Obs8.RiskID_Text,
		Obs8.FormID_Text,
		Obs8.Risk_Text,
		Obs8.Comments_Text,
		Obs8.Deadline_DateTime,
		Obs8.Owner_Text,
		Obs8.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA800Observations AS Obs8

--where RiskID_Text is not null

union

---------Escape Lighting Section

select 	
		'Obs9' as Fra_Type,
		Obs9.RiskID_Text,
		Obs9.FormID_Text,
		Obs9.Risk_Text,
		Obs9.Comments_Text,
		Obs9.Deadline_DateTime,
		Obs9.Owner_Text,
		Obs9.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA900Observations AS Obs9

--where RiskID_Text is not null

union

----------Fire Safety and Notices Section

select 	
		'Obs10' as Fra_Type,
		Obs10.RiskID_Text,
		Obs10.FormID_Text,
		Obs10.Risk_Text,
		Obs10.Comments_Text,
		Obs10.Deadline_DateTime,
		Obs10.Owner_Text,
		Obs10.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1000Observations AS Obs10

--where RiskID_Text is not null

UNION

-------------Fire Fighting Equipment Section

select 	
		'Obs11' as Fra_Type,
		Obs11.RiskID_Text,
		Obs11.FormID_Text,
		Obs11.Risk_Text,
		Obs11.Comments_Text,
		Obs11.Deadline_DateTime,
		Obs11.Owner_Text,
		Obs11.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1100Observations AS Obs11

--where RiskID_Text is not null

union

--------------Automatic Fire Systems i.e. suppression system Section

select 	
		'Obs12' as Fra_Type,
		Obs12.RiskID_Text,
		Obs12.FormID_Text,
		Obs12.Risk_Text,
		Obs12.Comments_Text,
		Obs12.Deadline_DateTime,
		Obs12.Owner_Text,
		Obs12.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1200Observations AS Obs12

--where RiskID_Text is not null

union

-----------Other relevant fixed systems Section

select 	
		'Obs13' as Fra_Type,
		Obs13.RiskID_Text,
		Obs13.FormID_Text,
		Obs13.Risk_Text,
		Obs13.Comments_Text,
		Obs13.Deadline_DateTime,
		Obs13.Owner_Text,
		Obs13.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1300Observations AS Obs13

--where RiskID_Text is not null

union

--------------------Access by Emergency Services Section

select 	
		'Obs14' as Fra_Type,
		Obs14.RiskID_Text,
		Obs14.FormID_Text,
		Obs14.Risk_Text,
		Obs14.Comments_Text,
		Obs14.Deadline_DateTime,
		Obs14.Owner_Text,
		Obs14.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1400Observations AS Obs14

--where RiskID_Text is not null


union all

--------------------------Management of Fire Safety Section

select 	
		'Obs15' as Fra_Type,
		Obs15.RiskID_Text,
		Obs15.FormID_Text,
		Obs15.Risk_Text,
		Obs15.Comments_Text,
		Obs15.Deadline_DateTime,
		Obs15.Owner_Text,
		Obs15.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1500Observations AS Obs15

--where RiskID_Text is not null

union all

---------------------------Testing and Maintenance Section

select 	
		'Obs16' as Fra_Type,
		Obs16.RiskID_Text,
		Obs16.FormID_Text,
		Obs16.Risk_Text,
		Obs16.Comments_Text,
		Obs16.Deadline_DateTime,
		Obs16.Owner_Text,
		Obs16.FRASection_Text

from dbo.Transaction_Task_FireRiskAssessmentFRA1600Observations AS Obs16

--where RiskID_Text is not null

)
--SELECT * FROM All_risks_cte
,

------All Risks created joined to Risk Task completions------

Risk_Task_Completions_cte
as
(

select  risks.RiskID_Text,
		risks.Fra_Type,
		risks.FRASection_Text,
		risks.FormID_Text,
		CASE WHEN risks.Risk_Text = 'High' and Fra_RiskTasks.SysCompletedAt_DateTime IS NOT NULL 
					THEN 'High Risk Closed'
			 WHEN risks.Risk_Text = 'High' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime >= getdate() 
					THEN 'High Risk to be actioned'
			WHEN risks.Risk_Text = 'High' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime <= getdate() 
					THEN 'High Risk Overdue'
			WHEN risks.Risk_Text = 'Medium' and Fra_RiskTasks.SysCompletedAt_DateTime IS NOT NULL 
					THEN 'Medium Risk closed'
			WHEN risks.Risk_Text = 'Medium' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime >= getdate() 
					THEN 'Medium Risk to be actioned'
			WHEN risks.Risk_Text = 'Medium' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime <= getdate() 
					THEN 'Medium Risk Overdue'
			WHEN risks.Risk_Text = 'Low' and Fra_RiskTasks.SysCompletedAt_DateTime IS NOT NULL 
					THEN 'Low Risk closed'
			WHEN risks.Risk_Text = 'Low' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime >= getdate() 
					THEN 'Low Risk to be actioned'
			WHEN risks.Risk_Text = 'Low' and Fra_RiskTasks.SysCompletedAt_DateTime IS NULL AND Risks.Deadline_DateTime <= getdate() 
					THEN 'Low Risk Overdue'

		ELSE 'Observation Only' END AS FRA_Risk_Status,

		CASE WHEN Fra_RiskTasks.SysCompletedAt_DateTime IS NOT NULL 
			  THEN 'Risk Closed' 
		ELSE 'Risk Open' 
		END AS [Risk_Open_or_Closed],
		
		risks.Risk_Text as Risk_RAG,
		Fra_RiskTasks.SysCompletedAt_DateTime as Completed_Date_Of_Risk,
		risks.Comments_Text as Risk_Comments,
		risks.Deadline_DateTime,
		risks.Owner_Text as Risk_Owner,
		Fra_RiskTasks.RiskAction_Text

 FROM 
	dbo.Transaction_task_FireRiskTask_Table1 as Fra_RiskTasks  
-----join to get completions and identify non completed tasks
	right join
		All_risks_cte as risks
	on  Fra_RiskTasks.RiskID_Text = risks.RiskID_Text

--	where risks.RiskID_Text is not null
--where risks.FormID_Text =  '120131072019'

)
--SELECT * FROM Risk_Task_Completions_cte
,

----Latest Form

Latest_fra_Check_cte

----Get latest fra per property
as
(
select  DateRank.BRMPropertySchemeCode_Text,
		DateRank.BRMPropertyPropID_Text,
		DateRank.SysCompletedAt_DateTime,
		DateRank.RowRank,
		DateRank.FormID_Text,
		DateRank.WFDocumentName_Text,
		DateRank.SysUserName_Text,
		DateRank.Comp_ID

	from

		(
		 SELECT   fra_chks.BRMPropertySchemeCode_Text,
				  fra_chks.BRMPropertyPropID_Text,
				  fra_chks.SysCompletedAt_DateTime,
				  fra_chks.WFDocumentName_Text,
				  fra_chks.BRMPropertyCompID_Text AS Comp_ID,
				 -- fra_chks.SysUserName_Text,
				 ---below line removes '\universe' from the username
				   right(fra_chks.SysUserName_Text, charindex('\', reverse(fra_chks.SysUserName_Text)) - 1) as SysUserName_Text,
				  fra_chks.FormID_Text,
				    
				  ROW_NUMBER() OVER (PARTITION BY fra_chks.BRMPropertySchemeCode_Text,fra_chks.BRMPropertyPropID_Text ORDER BY fra_chks.SysCompletedAt_DateTime DESC) 'RowRank'
				 
		 FROM  dbo.Transaction_Task_FireRiskAssessmentFRA_Table1 AS fra_chks --where FormID_Text = '110512072019'
		-- WHERE fra_chks.BRMPropertySchemeCode_Text = 3818
		-- WHERE   FormID_Text = '120131072019'
		 --'110512072019'
				

		) DateRank
)

----Latest FRA and Prop details and all risks

SELECT			latest_fra_chks.BRMPropertySchemeCode_Text as Court_ID,
				hi.BusinessUnitDescription as Court_Name,
				latest_fra_chks.BRMPropertyPropID_Text as Property_ID,

				latest_fra_chks.Comp_ID,

				case when latest_fra_chks.BRMPropertyPropID_Text like '%[_]S%' THEN 'Scheme' 
					
					 when latest_fra_chks.BRMPropertyPropID_Text like '%[_]F%' THEN 'Office'
				else 'Unknown'
				end as Property_Type,  
				latest_fra_chks.SysCompletedAt_DateTime as Fra_Date_of_Risk,
				latest_fra_chks.WFDocumentName_Text as Fra_Location,
				latest_fra_chks.SysUserName_Text as Fra_Carried_out_by,
				latest_fra_chks.FormID_Text,
				hi.BusinessStreamDescription as Housing_Business_Stream,
				hi.RegionServiceDescription as Housing_Region,
				hi.PatchDescription as Housing_Patch,
				--Surv_Hi.AMRegionDescription as Asset_Management_Region,
				ISNULL(Surv_Hi.AMRegionDescription,'NULL') AS Asset_Management_Region,
				Surv_Hi.AMPatchDescription as Surveyor_Patch,

				Comps.RiskID_Text,
				Comps.FRA_Risk_Status,
				Comps.Risk_Open_or_Closed,
				Comps.Completed_Date_Of_Risk,
				Comps.Fra_Type,
				Comps.FRASection_Text AS FRA_Section,
				Comps.Deadline_DateTime,
				Comps.Risk_RAG,
				Comps.Risk_Owner,
				Comps.Risk_Comments,
				Comps.RiskAction_Text AS [Detail_of_action_taken_by_risk_owner]
						
FROM	 HC21.OrgHierarchy AS hi 

				INNER JOIN
					 Latest_fra_Check_cte AS latest_fra_chks
				ON hi.BusinessUnitCode = latest_fra_chks.BRMPropertySchemeCode_Text
				AND latest_fra_chks.RowRank = 1 -----get latest form

				LEFT JOIN
					HC21.SurvHierarchy AS Surv_Hi
				ON  latest_fra_chks.BRMPropertySchemeCode_Text = Surv_Hi.AMSchemeCode

				LEFT JOIN
					Risk_Task_Completions_cte AS Comps
				ON latest_fra_chks.FormID_Text = Comps.FormID_Text

WHERE 
-------only include schemes and offices
------(Latest_fra_Chks.BRMPropertyPropID_Text	like '%[_]S%' or Latest_fra_Chks.BRMPropertyPropID_Text like '%[_]F%')

-------to be removed at Go Live ---RiskID_Text created 20190731 to enable risktask table to link to obs tables for completions
(comps.RiskID_Text is not null)

 --------AND(Surv_Hi.AMRegionDescription  IN (select val from [HC21].H21_fn_split (@Asset_Management_Region)) OR (@Asset_Management_Region) ='ALL') 



  AND (@Asset_Management_Region IS NULL OR ISNULL(Surv_Hi.AMRegionDescription,'NULL') IN (SELECT * FROM HC21.H21_SPLITSTRINGTOROWS(@Asset_Management_Region,',')))
 
AND (hi.RegionServiceDescription  IN (select val from [HC21].H21_fn_split (@Housing_Region)) OR (@Housing_Region) ='ALL')  
AND (Comps.FRA_Risk_Status IN (select val from [HC21].H21_fn_split (@Risk_Status)) OR (@Risk_Status) ='ALL')  
AND (Comps.Risk_Owner  IN (select val from [HC21].H21_fn_split (@Risk_Owner)) OR (@Risk_Owner) ='ALL')  
AND (Comps.Risk_RAG  IN (select val from [HC21].H21_fn_split (@RAG)) OR (@RAG) ='ALL') 
 AND  (@Comp_ID IS NULL OR ISNULL(latest_fra_chks.Comp_ID,'NULL') IN (SELECT * FROM HC21.H21_SPLITSTRINGTOROWS(@Comp_ID,',')))

order by latest_fra_chks.BRMPropertySchemeCode_Text
GO


