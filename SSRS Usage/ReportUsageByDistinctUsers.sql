/****** Script for SelectTopNRows command from SSMS  ******/
SELECT  

[InstanceName]
      ,[ItemPath]
      --,[UserName]
      ----,[ExecutionId]
      --,[RequestType]
      --,[Format]
      --,[Parameters]
      --,[ItemAction]
      --,[TimeStart]
      --,[TimeEnd]
      --,[TimeDataRetrieval]
      --,[TimeProcessing]
      --,[TimeRendering]
      --,[Source]
      --,[Status]
      --,[ByteCount]
      --,[RowCount]
      --,[AdditionalInfo]
	  ,COUNT(DISTINCT UserName) ucnt
  FROM [ReportServer].[dbo].[ExecutionLog3]
  WHERE TimeStart>'2022/03/01'
  AND ItemPath NOT LIKE '%dataset%'
  AND ItemAction LIKE '%render%'


  GROUP BY 

  [InstanceName]
      ,[ItemPath]
      --,[UserName]
      ----,[ExecutionId]
      --,[RequestType]