


-----NULL	ADAM	CULYER	Senior Building Surveyor - South	 	NULL	No


SELECT 
       r.[Email Address],
       r.[First Name],
       r.Surname,
       r.[Job Title],
       r.Telephone,
       r.Mobile,
      MAX( r.Active) Active --,
       --r.Latest_emp_jobtitle,
       --r.Latest_emp_jobtitle 
	   
	   
	   FROM (
SELECT 
e.PERSON_REF,
EMPLOYEE_EMAIL_ADDRESS [Email Address]
,EMPLOYEE_FIRST_NAME  [First Name]
,EMPLOYEE_LAST_NAME  [Surname]
,EMPLOYEE_CLEAN_JOB_TITLE [Job Title]
,e.WORK_TEL_NO [Telephone]
,EMPLOYEE_MOBILE_TELEPHONE_NUMBER [Mobile] ,
CASE WHEN EMPLOYEE_END_DATE>GETDATE() THEN 'Yes' ELSE 'No' END [Active]
,ROW_NUMBER() OVER (PARTITION BY e.PERSON_REF ORDER BY r.EMPLOYEE_END_DATE DESC) Latest_emp_jobtitle
---,ROW_NUMBER() OVER (PARTITION BY e.FIRST_FORNAME,r.MANAGER_LAST_NAME ORDER BY r.EMPLOYEE_END_DATE DESC) Latest_emp_jobtitle
-----,USER_GROUP
----,structure
FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY r
INNER JOIN raw_d500m e ON e.PERSON_REF=r.EMPLOYEE_PERSON_REFERENCE



GROUP BY e.PERSON_REF,EMPLOYEE_EMAIL_ADDRESS,EMPLOYEE_FIRST_NAME,EMPLOYEE_LAST_NAME,EMPLOYEE_CLEAN_JOB_TITLE,e.WORK_TEL_NO ,EMPLOYEE_MOBILE_TELEPHONE_NUMBER,EMPLOYEE_END_DATE
) r


WHERE r.Latest_emp_jobtitle=1
AND ( r.Telephone IS NOT NULL OR LEN(LTRIM(RTRIM(r.Telephone)))>1)

GROUP BY r.[Email Address],
       r.[First Name],
       r.Surname,
       r.[Job Title],
       r.Telephone,
       r.Mobile
ORDER BY r.[First Name]


--SELECT  * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY

--WHERE EMPLOYEE_PERSON_REFERENCE IN (01062144,01072207)


