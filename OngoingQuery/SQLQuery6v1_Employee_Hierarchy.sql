
IF OBJECT_ID('tempdb..#employee_manager_Hierar')           IS NOT NULL DROP TABLE #employee_manager_Hierar
IF OBJECT_ID('tempdb..#eer')                               IS NOT NULL DROP TABLE #eer    
IF OBJECT_ID('tempdb..#Employee_Parents')                  IS NOT NULL DROP TABLE #Employee_Parents
IF OBJECT_ID('tempdb..#EmployeeFinal')                     IS NOT NULL DROP TABLE #EmployeeFinal
IF OBJECT_ID('tempdb..#Employee_LineMgt_Hierarchy')        IS NOT NULL DROP TABLE #Employee_LineMgt_Hierarchy
--#Employee_LineMgt_Hierarchy









--CREATE  VIEW  [dbo].[Employee_Manager_Ref]
--AS

;WITH cte AS
(
 SELECT DISTINCT EMPLOYEE_DETAILS.PERSON_REF 
 ,pm.PERSON_REF Manager_Ref
 ---,pm.REF
 ,ROW_NUMBER()OVER (PARTITION  BY EMPLOYEE_DETAILS.PERSON_REF ORDER BY pm.START_DATE DESC,pm.main_flag ) MRno
 ,CONCAT(md.FIRST_FORNAME,' ',md.SURNAME) Manager_Name

 FROM 
						DBO.RAW_D500M   EMPLOYEE_DETAILS
  INNER JOIN			DBO.RAW_D580M   EMPLOYEE_POST                   ON (EMPLOYEE_POST.PERSON_REF = EMPLOYEE_DETAILS.PERSON_REF ---AND EMPLOYEE_POST.MAIN_FLAG = 'Y' 
  AND EMPLOYEE_POST.END_DATE IS NULL ) 
  INNER JOIN			DBO.RAW_D228M   POST_TO_POST                    ON (POST_TO_POST.POST_REF1 = EMPLOYEE_POST.REF AND POST_TO_POST.POST_RELATIONSHIP = 'R' 
  AND POST_TO_POST.HIERARCHY_EFF_COMPDATE = (SELECT MIN (D116M.EFF_COMPDATE)  FROM DBO.RAW_D116M D116M WHERE D116M.ID = POST_TO_POST.HIERARCHY_ID 
   AND D116M.EFF_DATE <= DATEADD(DD,0,DATEDIFF(DD,0,GETDATE()))))
  INNER JOIN raw_d580m pm ON pm.REF=POST_TO_POST.POST_REF2 AND (pm.END_DATE IS NULL OR pm.END_DATE>GETDATE()) AND pm.MAIN_FLAG='Y'
  INNER JOIN raw_d500m Md ON md.PERSON_REF=pm.PERSON_REF
  
  WHERE (EMPLOYEE_POST.END_DATE IS NULL OR EMPLOYEE_POST.END_DATE>GETDATE())
   AND EMPLOYEE_POST.MAIN_FLAG='Y'

   )


SELECT cte.PERSON_REF,
       cte.Manager_Ref,cte.Manager_Name
	INTO #employee_manager_Hierar 
FROM cte 
WHERE mrno=1










--SELECT * INTO #employee_manager_Hierar  FROM  employee_manager_ref  



--SELECT * FROM dbo.Employee_Manager_Ref
--WHERE PERSON_REF=00007077


SELECT  DISTINCT    r.MANAGER_PERSON_REFERENCE PERSON_REFERENCE,a.LOCATION_DESCRIPTION,a.ADDRESS_LINE_ONE,a.ADDRESS_LINE_TWO,a.ADDRESS_LINE_THREE,a.ADDRESS_LINE_FOUR into #EmployeeFinal 
FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY r
INNER JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY a ON a.EMPLOYEE_PERSON_REFERENCE=r.MANAGER_PERSON_REFERENCE
WHERE  a.EMPLOYEE_POST_END_DATE>GETDATE() AND r.EMPLOYEE_POST_END_DATE>GETDATE()




INSERT INTO #EmployeeFinal 
SELECT  DISTINCT   EMPLOYEE_PERSON_REFERENCE PERSON_REFERENCE,a.LOCATION_DESCRIPTION,a.ADDRESS_LINE_ONE,a.ADDRESS_LINE_TWO,a.ADDRESS_LINE_THREE,a.ADDRESS_LINE_FOUR 
 FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY a
WHERE EMPLOYEE_CLEAN_JOB_TITLE LIKE '%Care Administrator%'
AND EMPLOYEE_POST_END_DATE>GETDATE() 

--SELECT *     FROM #EmployeeFinal 

;WITH cte
AS
(
SELECT person_ref,Manager_ref ,1 ord FROM #employee_manager_Hierar c 
UNION ALL
SELECT ce.person_ref,e.Manager_ref,e.ord+1 AS ord FROM #employee_manager_Hierar ce
INNER JOIN  cte e ON ce.Manager_Ref=e.person_ref
WHERE e.ord<10
)

SELECT  * INTO #eer   FROM cte  





SELECT person_ref,[1],[2],[3],[4],[5],[6],[7],[8],[9],[10]

INTO #Employee_Parents

FROM 
(

SELECT 
person_ref,
manager_ref 
,ord
FROM #eer r
--WHERE person_ref=00007077
) p
PIVOT (MAX(manager_ref) FOR  ord IN ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10])) pv



--SELECT * FROM #Employee_Parents

SELECT e.person_ref AS Employee_Person_Ref

,concat(ep.EMPLOYEE_FIRST_NAME,' ',ep.EMPLOYEE_LAST_NAME) Employee_Name
,CONCAT(ed_Level1.EMPLOYEE_FIRST_NAME,' ',ed_Level1.EMPLOYEE_LAST_NAME)  Level1_Employee,
concat(ed_Level2.EMPLOYEE_FIRST_NAME,' ',ed_Level2.EMPLOYEE_LAST_NAME)  Level2_Employee,
concat(ed_Level3.EMPLOYEE_FIRST_NAME,' ',ed_Level3.EMPLOYEE_LAST_NAME)  Level3_Employee
,concat(ed_Level4.EMPLOYEE_FIRST_NAME,' ',ed_Level4.EMPLOYEE_LAST_NAME)   Level4_Employee,
concat(ed_Level5.EMPLOYEE_FIRST_NAME,' ',ed_Level5.EMPLOYEE_LAST_NAME)    Level5_Employee,
concat(ed_Level6.EMPLOYEE_FIRST_NAME,' ',ed_Level6.EMPLOYEE_LAST_NAME)    Level6_Employee,
concat(ed_Level7.EMPLOYEE_FIRST_NAME,' ',ed_Level7.EMPLOYEE_LAST_NAME)    Level7_Employee,
concat(ed_Level8.EMPLOYEE_FIRST_NAME,' ',ed_Level8.EMPLOYEE_LAST_NAME)    Level8_Employee,
concat(ed_Level9.EMPLOYEE_FIRST_NAME,' ',ed_Level9.EMPLOYEE_LAST_NAME)    Level9_Employee,
concat(ed_Level10.EMPLOYEE_FIRST_NAME,' ',ed_Level10.EMPLOYEE_LAST_NAME)    Level10_Employee
,ep.EMPLOYEE_POST_NUMBER,ep.EMPLOYEE_CLEAN_JOB_TITLE,ep.EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level1.EMPLOYEE_POST_NUMBER  Level1_EMPLOYEE_POST_NUMBER,ed_Level1.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level1_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level1.EMPLOYEE_EMPLOYEE_NUMBER ed_Level1_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level2.EMPLOYEE_POST_NUMBER  Level2_EMPLOYEE_POST_NUMBER,ed_Level2.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level2_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level2.EMPLOYEE_EMPLOYEE_NUMBER ed_Level2_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level3.EMPLOYEE_POST_NUMBER  Level3_EMPLOYEE_POST_NUMBER,ed_Level3.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level3_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level3.EMPLOYEE_EMPLOYEE_NUMBER ed_Level3_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level4.EMPLOYEE_POST_NUMBER  Level4_EMPLOYEE_POST_NUMBER,ed_Level4.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level4_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level4.EMPLOYEE_EMPLOYEE_NUMBER ed_Level4_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level5.EMPLOYEE_POST_NUMBER  Level5_EMPLOYEE_POST_NUMBER,ed_Level5.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level5_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level5.EMPLOYEE_EMPLOYEE_NUMBER ed_Level5_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level6.EMPLOYEE_POST_NUMBER  Level6_EMPLOYEE_POST_NUMBER,ed_Level6.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level6_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level6.EMPLOYEE_EMPLOYEE_NUMBER ed_Level6_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level7.EMPLOYEE_POST_NUMBER  Level7_EMPLOYEE_POST_NUMBER,ed_Level7.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level7_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level7.EMPLOYEE_EMPLOYEE_NUMBER ed_Level7_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level8.EMPLOYEE_POST_NUMBER  Level8_EMPLOYEE_POST_NUMBER,ed_Level8.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level8_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level8.EMPLOYEE_EMPLOYEE_NUMBER ed_Level8_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level9.EMPLOYEE_POST_NUMBER  Level9_EMPLOYEE_POST_NUMBER,ed_Level9.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level9_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level9.EMPLOYEE_EMPLOYEE_NUMBER ed_Level9_EMPLOYEE_EMPLOYEE_NUMBER
,ed_Level10.EMPLOYEE_POST_NUMBER  Level10_EMPLOYEE_POST_NUMBER,ed_Level10.EMPLOYEE_CLEAN_JOB_TITLE  ed_Level10_EMPLOYEE_CLEAN_JOB_TITLE,ed_Level10.EMPLOYEE_EMPLOYEE_NUMBER ed_Level10_EMPLOYEE_EMPLOYEE_NUMBER


INTO #Employee_LineMgt_Hierarchy

FROM #Employee_Parents e

left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ep ON e.person_ref=ep.EMPLOYEE_PERSON_REFERENCE AND ep.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level1 ON e.[1]=ed_Level1.EMPLOYEE_PERSON_REFERENCE AND ed_Level1.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level2 ON e.[2]=ed_Level2.EMPLOYEE_PERSON_REFERENCE AND ed_Level2.EMPLOYEE_POST_END_DATE>GETDATE()
LEFT JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level3 ON e.[3]=ed_Level3.EMPLOYEE_PERSON_REFERENCE AND ed_Level3.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level4 ON e.[4]=ed_Level4.EMPLOYEE_PERSON_REFERENCE  AND ed_Level4.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level5 ON e.[5]=ed_Level5.EMPLOYEE_PERSON_REFERENCE   AND ed_Level5.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level6 ON e.[6]=ed_Level6.EMPLOYEE_PERSON_REFERENCE  AND ed_Level6.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level7 ON e.[7]=ed_Level7.EMPLOYEE_PERSON_REFERENCE    AND ed_Level7.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level8 ON e.[8]=ed_Level8.EMPLOYEE_PERSON_REFERENCE    AND ed_Level8.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level9 ON e.[9]=ed_Level9.EMPLOYEE_PERSON_REFERENCE    AND ed_Level9.EMPLOYEE_POST_END_DATE>GETDATE()
left JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY ed_Level10 ON e.[10]=ed_Level10.EMPLOYEE_PERSON_REFERENCE  AND ed_Level10.EMPLOYEE_POST_END_DATE>GETDATE()




-----00007077
--SELECT * FROM  #Employee_Parents e
--WHERE e.PERSON_REF=00007077


SELECT 
em.PERSON_REFERENCE
,
eh.Employee_Name
,eh.EMPLOYEE_CLEAN_JOB_TITLE
,eh.EMPLOYEE_POST_NUMBER
,eh.EMPLOYEE_EMPLOYEE_NUMBER
,em.LOCATION_DESCRIPTION
,em.ADDRESS_LINE_ONE
,em.ADDRESS_LINE_TWO
,em.ADDRESS_LINE_THREE
,em.ADDRESS_LINE_FOUR

--eh.Employee_Person_Ref,
--eh.Employee_Name,
,eh.Level1_Employee,
eh.Level2_Employee,
eh.Level3_Employee,
eh.Level4_Employee,
eh.Level5_Employee,
eh.Level6_Employee,
eh.Level7_Employee,
eh.Level8_Employee,
eh.Level9_Employee,
eh.Level10_Employee,
--eh.EMPLOYEE_POST_NUMBER,
--eh.EMPLOYEE_CLEAN_JOB_TITLE,
--eh.EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level1_EMPLOYEE_POST_NUMBER,
eh.ed_Level1_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level1_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level2_EMPLOYEE_POST_NUMBER,
eh.ed_Level2_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level2_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level3_EMPLOYEE_POST_NUMBER,
eh.ed_Level3_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level3_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level4_EMPLOYEE_POST_NUMBER,
eh.ed_Level4_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level4_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level5_EMPLOYEE_POST_NUMBER,
eh.ed_Level5_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level5_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level6_EMPLOYEE_POST_NUMBER,
eh.ed_Level6_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level6_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level7_EMPLOYEE_POST_NUMBER,
eh.ed_Level7_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level7_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level8_EMPLOYEE_POST_NUMBER,
eh.ed_Level8_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level8_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level9_EMPLOYEE_POST_NUMBER,
eh.ed_Level9_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level9_EMPLOYEE_EMPLOYEE_NUMBER,
eh.Level10_EMPLOYEE_POST_NUMBER,
eh.ed_Level10_EMPLOYEE_CLEAN_JOB_TITLE,
eh.ed_Level10_EMPLOYEE_EMPLOYEE_NUMBER
FROM   #Employee_LineMgt_Hierarchy eh 
right JOIN  #EmployeeFinal em ON eh.Employee_Person_Ref=em.PERSON_REFERENCE
WHERE eh.Employee_Person_Ref IS null





-------01032979,00007159


--SELECT * FROM #Employee_Parents e 
--WHERE e.PERSON_REF IN (01032979,00007159)


--SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY
--WHERE EMPLOYEE_EMPLOYEE_NUMBER='010377'
--AND EMPLOYEE_POST_END_DATE>GETDATE()


------01031497,01032667,01034316,01047989,01057210


---sub 01062519,01066318


---cw 01076926



--SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS

--WHERE EMPLOYEE_PERSON_REFERENCE=01031497 AND EMPLOYEE_POST_END_DATE>GETDATE()




--SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY

--WHERE EMPLOYEE_PERSON_REFERENCE=01031497 AND EMPLOYEE_POST_END_DATE>GETDATE()





--SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY
--WHERE EMPLOYEE_PERSON_REFERENCE=01015188
--AND EMPLOYEE_POST_END_DATE>GETDATE()




--SELECT * FROM #eer

--WHERE PERSON_REF=01031497




--SELECT * FROM employee_manager_ref  
--WHERE PERSON_REF=01031497
