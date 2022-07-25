SELECT 



FLOOR((COUNT(DISTINCT [complaint id])*1.0)/ (SELECT * FROM #rt))

FROM Datix_Complaints_View cv
LEFT JOIN
[dbo].[Ql_Property_Schemes] ps ON cv.scheme=ps.Court_ID





 SELECT COUNT(DISTINCT ps.Property_ID) *1.0/ 10000*1.0  ct INTO #rt FROM [dbo].[Ql_Property_Schemes] ps
WHERE ps.Property_Status='active'





