/****** Script for SelectTopNRows command from SSMS  ******/




SELECT      IDENTITY(INT,1,1) AS id,cs.* INTO #ee   FROM [H21_STAGING].[dbo].[complaint_schemes]   cs 



DROP TABLE  #comp

SELECT scheme,parent,COALESCE([1],'') nameprt1,COALESCE([2],'') nameprt2
INTO #comp
FROM
(
SELECT splitdata
      ,[Scheme]
      ,[Parent]
	  ,id
	  ,ROW_NUMBER() OVER (PARTITION BY cs.id ORDER BY scheme) rno
  FROM #ee   cs 
  OUTER APPLY( SELECT splitdata FROM dbo.fnSplitString([com_name],' ')) name

  ) pv

  PIVOT (MAX(splitdata) FOR rno IN ([1],[2] ))p




  SELECT ca.forename,REPLACE(ca.surname,'(deceased)','') surname,ca.clientfullname ,rs.court_id 
  INTO #renacctSche
  FROM clientaccnt ca
  INNER JOIN [H21_STAGING].[dbo].[RentAcctScheme] rs ON ca.rent_account_no=rs.rent_account_no

  SELECT *  INTO #excep1 FROM #comp
  except
  SELECT DISTINCT  cm.*  FROM #comp cm  INNER  JOIN #renacctSche rc ON(cm.scheme=rc.court_id  AND RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(nameprt1))+'%')
 AND ( RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(nameprt2))+'%')


 ---TAMLIN   ,LOUISE,0104

 SELECT * FROM #renacctSche
 WHERE 
 clientfullname LIKE '%child%'
 --AND 


 court_id='0104'


   SELECT DISTINCT  cm.*  INTO #preexcep2 FROM #excep1 cm  INNER  JOIN #renacctSche rc ON  RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(cm.nameprt1))+'%'
 AND RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(cm.nameprt2))+'%' ---cm.scheme=rc.court_id  AND


 ---4702
 DROP TABLE #excep2
 SELECT pc.* INTO #excep2 FROM #preexcep2   pc
 INNER JOIN #renacctSche  rc ON pc.nameprt1=rc.forename AND pc.nameprt2=rc.surname

 SELECT * FROM #renacctSche 



 SELECT * INTO #preexcep3 FROM #excep1
 EXCEPT
 SELECT * FROM #excep2


   SELECT * FROM #preexcep3 cm  INNER  JOIN #renacctSche rc ON  RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(cm.nameprt1))+'%'
 AND RTRIM(LTRIM(rc.clientfullname)) LIKE '%'+RTRIM(LTRIM(cm.nameprt2))+'%' ---cm.scheme=rc.court_id  AND
 WHERE LEN(cm.nameprt1)>1 AND  LEN(cm.nameprt2)>1 AND cm.nameprt1<>cm.nameprt2