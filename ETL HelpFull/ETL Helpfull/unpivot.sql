/****** Script for SelectTopNRows command from SSMS  ******/

  SELECT [Employee.EmployeeExternalID],EmployeeCustom_Guaranteed_Pay_Element_1  eli1 ,EmployeeCustom_Guaranteed_Pay_Element_2 eli2 INTO #cc FROM [H21_STAGING].[dbo].[RLMainExtract]

  SELECT DISTINCT  [Employee.EmployeeExternalID], eli2+'test el3' eli3,eli2 INTO #ec FROM #cc
  SELECT DISTINCT [Employee.EmployeeExternalID],'eli1' eli1,'eli2' eli2,'eli3' eli3 INTO  #er FROM #cc
 

 DECLARE @query NVARCHAR(max),
 @values NVARCHAR(max)

 SET @values='VALUES(rr.eli1,c.eli1),(rr.eli2,c.eli2),(rr.eli3,e.eli3))r(NAME,Value)'
  SET  @Query='SELECT  c.[Employee.EmployeeExternalID] ,name,r.Value FROM #cc c INNER JOIN #ec e ON e.[Employee.EmployeeExternalID]=c.[Employee.EmployeeExternalID]
  INNER JOIN #er rr ON c.[Employee.EmployeeExternalID]=rr.[Employee.EmployeeExternalID]
  CROSS APPLY('+@values
  
EXEC(@query)


  --  DROP TABLE #cc
  --DROP TABLE #ec
  --DROP TABLE  #er


  