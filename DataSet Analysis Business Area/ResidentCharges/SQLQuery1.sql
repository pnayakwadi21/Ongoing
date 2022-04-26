
declare

	@Location	VARCHAR(4)='4324',
	@Company	CHAR(30)	= 'H21'



	DROP TABLE IF EXISTS #genhmast
	DROP TABLE IF EXISTS #ecr


	SELECT 
	CAST(CAST(FINANCIAL_YEAR_QL AS VARCHAR(4)) + PERIOD AS INT) AS PERIOD_YEAR_MONTH,
	CAST(FINANCIAL_YEAR_QL AS INT)								AS PERIOD_YEAR,
	PERIOD														AS PERIOD_MONTH,

	GEN_CODE, 
	BUDGET_AMOUNT 
	INTO #GENHMAST
FROM
(
SELECT 
	  2020						AS FINANCIAL_YEAR_QL
	  ,GEN_CODE				        AS GEN_CODE
	
	  
      ,COALESCE(P1_WB_NACC,0)		AS [01]
      ,COALESCE(P2_WB_NACC,0)		AS [02]
      ,COALESCE(P3_WB_NACC,0)		AS [03]
      ,COALESCE(P4_WB_NACC,0)		AS [04]
      ,COALESCE(P5_WB_NACC,0)		AS [05]
      ,COALESCE(P6_WB_NACC,0)		AS [06]
      ,COALESCE(P7_WB_NACC,0)		AS [07]
      ,COALESCE(P8_WB_NACC,0)		AS [08]
      ,COALESCE(P9_WB_NACC,0)		AS [09]
      ,COALESCE(P10_WB_NACC,0)		AS [10]
      ,COALESCE(P11_WB_NACC,0)		AS [11]
      ,COALESCE(P12_WB_NACC,0)		AS [12]
	
FROM 
	GENMAST g

WHERE 
	COMP_ID = 'H21') ALIAS
UNPIVOT
	(
		BUDGET_AMOUNT FOR PERIOD IN 
		(
			[01],
			[02],
			[03],
			[04],
			[05],
			[06],
			[07],
			[08],
			[09],
			[10],
			[11],
			[12]
		)
) ALIAS --WHERE BUDGET_AMOUNT <> 0


DECLARE		@PY_Start	int		= (SELECT ((curr_yr -1) * 100) + 1 FROM [QL_ResCharges].[dbo].[genparam] WHERE comp_id = @Company),
				@PY_End		int		= (SELECT ((curr_yr -1) * 100) + 12 FROM [QL_ResCharges].[dbo].[genparam] WHERE comp_id = @Company);

				---SELECT @PY_Start,@PY_End
	
	SELECT	SUM(gentran.fival) fivval,n.tier_7,n.tier_9,n.tier_6,n.account_code,n.account_desc
	---,SUM(gh.BUDGET_AMOUNT) OVER (PARTITION BY n.account_code ORDER BY GENTRAN.py_id) rr
	,GENTRAN.py_id
	 ,BUDGET_AMOUNT 
	  INTO #ecr    
	FROM [QL_ResCharges].[dbo].[gentran] GENTRAN
	INNER JOIN HC21.H21_nominal_hierarchy n ON RIGHT(GENTRAN.gen_code,5)=n.account_code
	INNER JOIN #GENHMAST gh ON gh.PERIOD_YEAR_MONTH=GENTRAN.py_id
	AND gh.gen_code=GENTRAN.gen_code
   WHERE SUBSTRING(GENTRAN.gen_code,4,4)='4324'
   AND GENTRAN.py_id BETWEEN @PY_Start AND @PY_End
   AND n.tier_7 IN ('Service Charge & Leasehold Balances','Service Costs','Service Utilities & Support')
   GROUP BY
   n.tier_7,n.tier_9,n.tier_6,n.account_code,n.account_desc,gh.BUDGET_AMOUNT
   ,GENTRAN.py_id,BUDGET_AMOUNT


  

  SELECT 
  tier_7,tier_9,tier_6,account_code,py_id,account_desc,
  SUM(fivval) OVER (PARTITION BY account_code ORDER BY py_id) Ytd_Act,fivval  act,BUDGET_AMOUNT
  FROM #ecr
  GROUP BY
tier_7,tier_9,tier_6,account_code,account_desc,py_id,fivval,BUDGET_AMOUNT
