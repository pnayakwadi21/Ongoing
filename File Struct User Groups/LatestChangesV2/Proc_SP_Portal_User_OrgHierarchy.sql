USE [H21_STAGING]
GO

/****** Object:  StoredProcedure [dbo].[Proc_SP_Portal_User_OrgHierarchy]    Script Date: 05/04/2022 09:52:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[Proc_SP_Portal_User_OrgHierarchy]

/***
Author:Praveen Nayakwadi
Desc  :Loads User Organisation Hierarchy Data
Date  :25/01/2022
*/




AS
	
	
TRUNCATE TABLE SP_Portal_User_OrgHierarchy
	;WITH SORTEDOUTPUT
	AS
	( 

	
	SELECT CHILD_ID,
           SHORT_DESC [Ld0],
           L1,
           L2,
           L3,
           L4,
           L5,
           L6,
           L7,
           L8,
           D1 H7,
           D2 H6,
           D3 H5,
           D4 H4,
           D5 H3,
           D6 H2,
           D7 H1,
           D8 H8,
           C1,
           C2,
           C3,
           C4,
           C5,
           C6,
           C7,
           C8,
           r,
    	
		 SUBSTRING(long_desc,1,CASE WHEN CHARINDEX(',',long_desc,1)>=1 AND D8<>long_desc THEN CHARINDEX(',',long_desc,1)-1 ELSE LEN(long_desc) END       )    H0,--Chose the first scheme for merged scheme,some long desc have , separated values which needs to be kept  expre  D8<>long_desc checks for the same 
		   Obs_Date ,
		   long_desc olong_desc
		  --INTO #SORTEDOUTPUT
		   FROM dbo.RL_PERS_HIERARCHY
		)




INSERT INTO [dbo].[SP_Portal_User_OrgHierarchy]
           ([SD0]
           ,[SD7]
           ,[c7]
           ,[c8]
           ,[Ld0]
           ,[H1]
           ,[H2]
           ,[H3]
           ,[H5]
           ,[H7]
           ,[Users])
	
SELECT ---*
Ld0 SD0,
CASE WHEN c7=c8 THEN NULL ELSE L1 END SD7,
c7,c8,
H0 Ld0,
H1,
H2,
H3,
H5 ,
H7  ,
o.EMPLOYEE_USER_NAME [Users]


FROM  SORTEDOUTPUT s
LEFT JOIN dbo.Org_users_View o ON s.Ld0=	o.SHORT_DESC 



GO


