





SELECT  y.D4 ,p.DEPARTMENT department,p.EMPLOYEE_CLEAN_JOB_TITLE job_title---,v.POST_NUMBER post_number
,p.EMPLOYEE_POST_REFERENCE post_ref,amt [salary] 



FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS p

LEFT JOIN (SELECT PERSON_REF,COST_POST_REF,SUM(COST_AMOUNT ) Amt FROM RAW_D415M 
WHERE 
---PERSON_REF='01080542'   ---'01035110'
---AND 
(COST_TAX_YEAR_PER_SUPP_NO LIKE '%202204%' OR COST_TAX_YEAR_PER_SUPP_NO LIKE '%202216%' )
AND (COST_UNITS>0 OR COST_PE_ID=1000 OR COST_PE_ID=1002 OR COST_PE_ID=1077  OR COST_PE_ID=1002 ---OR COST_PE_ID=1331
)
GROUP BY PERSON_REF,COST_POST_REF
) r ON r.PERSON_REF=p.EMPLOYEE_PERSON_REFERENCE
    AND r.COST_POST_REF=p.EMPLOYEE_POST_REFERENCE 
	
INNER JOIN 

(	
SELECT  p.D4 ,ep.PERSON_REF,ep.EMP_POST_REF   FROM raw_d455m ep INNER JOIN dbo.RL_PERS_HIERARCHY p
ON ep.PERS_STR_REF_LINK=p.CHILD_ID

WHERE ep.EMP_POST_END_DATE IS NULL 
) y ON y.PERSON_REF=p.EMPLOYEE_PERSON_REFERENCE AND y.EMP_POST_REF=p.EMPLOYEE_POST_REFERENCE

WHERE EMPLOYEE_POST_END_DATE>GETDATE()
AND p.EMPLOYEE_POST_CONTRACTED_HOURS>0

AND r.PERSON_REF IS null

AND v.POST_START_DATE BETWEEN '2022/07/01' AND GETDATE()


SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS
WHERE EMPLOYEE_POST_REFERENCE=01002226 AND EMPLOYEE_POST_END_DATE>GETDATE()


SELECT * FROM dbo.SP_Portal_User_OrgHierarchy