

SELECT 

PERSON_REF,
       INT_EMP_ATT_POST_REF,
      ---- START_DATE,
       INT_EMP_ATT_ABS_TYPE,
       INT_EMP_ATT_ABS_REASON,
       INT_EMP_ATT_TOT_DAYS_TAKEN
	   , DATEADD(dd,-CONVERT(INT,START_DATE),'4537/11/26') Start_date  
	   ,CASE WHEN   INT_EMP_ATT_TOT_DAYS_TAKEN <=1 THEN DATEADD(dd,-CONVERT(INT,START_DATE),'4537/11/26') 
	   ELSE  DATEADD(dd,INT_EMP_ATT_TOT_DAYS_TAKEN,DATEADD(dd,-CONVERT(INT,START_DATE),'4537/11/26')) END End_date
	   
FROM [dbo].[RAW_D6820M]


WHERE PERSON_REF=01086534




SELECT * FROM Raw_D6819m r
WHERE PERSON_REF=01086534