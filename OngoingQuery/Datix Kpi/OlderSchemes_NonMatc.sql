SELECT DISTINCT scheme FROM Datix_Complaints_View cv
LEFT JOIN
(

SELECT Court_ID FROM [dbo].[Ql_Property_Schemes]
GROUP BY Court_ID) pr ON pr.Court_ID=cv.scheme
WHERE pr.Court_ID IS null