SELECT 

        a.PERSON_REF,
       a.INT_EMP_ATT_POST_REF
	   ---,
      ---- START_DATE,
      -- a.INT_EMP_ATT_ABS_TYPE,
      -- a.INT_EMP_ATT_ABS_REASON,
      --a. INT_EMP_ATT_TOT_DAYS_TAKEN
	   
  , INT_EMP_ATT_START_DATE
--,
--INT_EMP_ATT_END_DATE
--,p.LOCATION_DESCRIPTION
--,p.EMPLOYEE_EMPLOYEE_NUMBER
	   
FROM [dbo].[RAW_D6820M] a
INNER JOIN Raw_D6819m r ON a.PERSON_REF=r.PERSON_REF
AND a.INT_EMP_ATT_POST_REF=r.INT_EMP_ATT_POST_REF
AND a.INT_EMP_ATT_START_COMPDATE= r.INT_EMP_ATT_START_COMPDATE
AND a.INT_EMP_ATT_START_TIME=r.INT_EMP_ATT_START_TIME
AND a.INT_EMP_ATT_ABS_TYPE=r.INT_EMP_ATT_ABS_TYPE
INNER JOIN dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS p ON p.EMPLOYEE_PERSON_REFERENCE=a.PERSON_REF
AND p.EMPLOYEE_POST_REFERENCE=a.INT_EMP_ATT_POST_REF

WHERE 
INT_EMP_ATT_START_DATE>'2018-03-16 00:00:00.000'
--a.PERSON_REF=00001713
--	   AND a.INT_EMP_ATT_POST_REF=00001163
--	   AND a.INT_EMP_ATT_START_COMPDATE=919570

GROUP BY 
        a.PERSON_REF,
       a.INT_EMP_ATT_POST_REF
	    , INT_EMP_ATT_START_DATE


	   HAVING COUNT(DISTINCT a.INT_EMP_ATT_ABS_TYPE)>1