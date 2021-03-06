/****** Script for SelectTopNRows command from SSMS  ******/
SELECT TOP (1000) [PERSON_REF]
      ,[EMP_PE_POST_REF]
      ,[EMP_PE_ID]
      ,[EES_AMT]
      ,[ERS_AMT]
      ,[UNITS]
      ,[ADMIN_CHGE]
      ,[EMP_PE_YTD_EES_CRCY_AMT]
      ,[EMP_PE_YTD_ERS_CRCY_AMT]
      ,[EMP_PE_YTD_DAYS_PAID]
      ,[EMP_PE_YTD_PERIOD_DAYS]
      ,[EMP_PE_YTD_EES_NORMAL_AMT]
      ,[EMP_PE_YTD_ERS_NORMAL_AMT]
  FROM [H21_STAGING].[dbo].[RAW_D655M]


  WHERE EMP_PE_ID IN ('0910')
  AND person_ref=01072174