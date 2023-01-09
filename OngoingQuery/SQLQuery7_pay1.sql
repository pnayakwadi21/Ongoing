SELECT 
DISTINCT 
	CASE	WHEN T1.COST_PAY_OR_DEDN_FLAG = 'D' THEN T1.COST_AMOUNT * - 1
			ELSE T1.COST_AMOUNT
			END AS AMOUNT
	,T4.SORT_CODE
	,T3.LONG_DESC
	,T3.PAY_ELEMENT_ID
	,T2.INITIALS
	,T2.SURNAME
	,T1.COST_TYPE_ALPHA
	,T1.COST_TAX_YEAR_PER_SUPP_NO
	,SUBSTRING(T1.LONG_COST_CENTRE_CODE, 1, 2)	    GL1 	
	,SUBSTRING(T1.LONG_COST_CENTRE_CODE, 3, 4)	    GL2
	,SUBSTRING(T1.LONG_COST_CENTRE_CODE, 7, 3)      GL3
	,SUBSTRING(T1.LONG_COST_CENTRE_CODE, 10, 5)     GL4
	,T1.COST_PE_ID_CODE
	,T1.COST_PAY_TYPE 
	,T1.COST_PAY_OR_DEDN_FLAG
	,T1.COST_PAY_DATE
	,T1.COST_LEVEL1_PAY_STR_ID
	,T1.COST_AMOUNT 
	,T1.EMPLOYEE_NUMBER 
	,T1.LONG_COST_CENTRE_CODE 

FROM RAW_D415M T1
	INNER JOIN RAW_D500M T2 ON T1.PERSON_REF = T2.PERSON_REF
	INNER JOIN RAW_D755M T3 ON T1.COST_PE_ID = T3.PAY_ELEMENT_ID
	INNER JOIN RAW_D200M T5 ON T1.COST_POST_NUMBER = T5.NUMBER_R
	LEFT JOIN  RAW_D300M T4 ON T5.JOB_REF = T4.REF
WHERE   
(T1.COSTING_RUN_NUMBER		= @RUN_NO )
AND
(T1.COST_LEVEL1_PAY_STR_ID	= @PAY_ST_ID )
ORDER BY 
	COST_PAY_DATE ASC
	,GL2 ASC
	,EMPLOYEE_NUMBER ASC
	,GL3 ASC
	,GL4 ASC

	SELECT * FROM RAW_D755M T3



	SELECT t3.LONG_DESC,t1.* FROM RAW_D415M t1
LEFT JOIN RAW_D755M T3 ON T1.COST_PE_ID = T3.PAY_ELEMENT_ID
	WHERE COST_PAY_TYPE='W'
	AND COST_TAX_YEAR_PER_SUPP_NO LIKE '%202217%'
	--AND COST_UNITS>0
	---AND COST_PE_ID IN (6039,1333,1312,1373,1311,1311)
	AND PERSON_REF=01000618
	ORDER BY PERSON_REF
	GROUP BY COST_PE_ID 
	
	
	----0135
	SELECT *  FROM raw_D559M 

	SELECT * FROM RAW_D755M T3
	WHERE T3.PAY_ELEMENT_ID=1077
	---6039,1333,1312,1373,1311,1311


	SELECT * FROM RAW_D580v
	WHERE PERSON_REF=01002466
	
	
	SELECT * FROM 		 [dbo].[RAW_D591M] AS [D591M]	
	WHERE D591M.PERSON_REF=01000618

	SELECT DISTINCT person_ref  FROM #cc
	except
	SELECT person_ref FROM #ee
	---3058,0102,0100
	---1077
	--DROP TABLE #ee
	SELECT * FROM raw_D559M 
 WHERE ---PERSON_REF
---IN (SELECT * FROM #tt) --00009695
--AND
  EMP_PH_TAX_YEAR=2022 
 ---AND EMP_PH_PE_ERS_FULL_AMT>0
AND id =1000 --0135--- IN (3058,0102,0100,0135) ----OR id IN (1002)
AND EMP_PH_TAX_PERIOD=4
 GROUP BY id
 INTERSECT
 
 	select PERSON_REF FROM raw_D559M 
 WHERE
--PERSON_REF=01071067
--AND
  EMP_PH_TAX_YEAR=2022 
 AND id=1000
 GROUP BY PERSON_REF

	SELECT DISTINCT EMPLOYEE_PERSON_REFERENCE
	--,PAYROLL_FREQUENCY,EMPLOYEE_CLEAN_JOB_TITLE,EMPLOYEE_POST_CONTRACTED_HOURS,EMPLOYEE_POST_START_DATE,EMPLOYEE_POST_END_DATE 
	INTO #tt
	
	FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS
	--WHERE  PAYROLL_FREQUENCY LIKE '%weekl%' AND 
WHERE 	EMPLOYEE_POST_END_DATE>GETDATE()
AND EMPLOYEE_PERSON_REFERENCE NOT IN (SELECT person_ref FROM #cc)
AND EMPLOYEE_POST_START_DATE<GETDATE()
EXCEPT
SELECT DISTINCT person_ref  FROM #ee