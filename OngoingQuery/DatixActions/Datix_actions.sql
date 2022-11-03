SELECT 
RECORDID,ACT_CAS_ID,ACT_MODULE ,act_type[type], act_descr[Title],act_synopsis[Recomendation],ACT_PROGRESS [Evidence of completion/implimentation]
,ACT_RESOURCES [Action],ACT_MONITORING,ACT_DDONE [done date],ACT_DDUE [due date],ACT_DSTART [start date]


FROM dbo.raw_ca_actions
WHERE RECORDID=79

SELECT *
FROM dbo.raw_ca_actions
WHERE RECORDID=79
--SELECT * FROM dbo.compl_main
--WHERE recordid=680



SELECT 
act_module  module,
act_from_inits assigned_by
,act_type type
,act_descr title 
,act_synopsis [Recomendation]
,act_to_inits  responsibility 
,ACT_RESOURCES [Action]
,ACT_MONITORING [Reporting/Monitoring requirements]
,act_dstart start_date
,act_ddue end_date

,act_specialty [Scheme code/Court name]
,act_directorate [Area/Region]
,act_clingroup [Business Stream]
,act_organisation Organisation
,act_progress [Evidence of completion/implimentation]
,act_ddone done_date
,act_by_inits completed_by


,act_cas_id linked_record_id

,recordid [action id]
,act_record_name


 ,act_unit [Business_unit]


FROM raw_vw_actions_summary
WHERE CONVERT(NVARCHAR(100),recordid) LIKE '%79%'

SELECT * 
FROM raw_vw_actions_summary
WHERE CONVERT(NVARCHAR(100),recordid) LIKE '%79%'