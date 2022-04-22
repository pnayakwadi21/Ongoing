USE [H21_STAGING]
GO

/****** Object:  StoredProcedure [dbo].[Sp_Portal_User_Groups]    Script Date: 13/04/2022 15:19:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-----45073


SELECT COUNT(*) FROM dbo.SP_Portal_Users_Groups
CREATE  PROCEDURE [dbo].[Sp_Portal_User_Groups]

/**
Author:Praveen Nayakwadi
Date : 02/11/2021
Desc : Sites Team memberships section  added new category with the filter WHERE [HUB] !='' AND [USERS] IS NOT NULL AND [TYPE] = 'D'
Author:Praveen Nayakwadi cr244,344
Date : 08/12/2021
Desc:Entire department to have access to the top level library
Author:Praveen Nayakwadi 
Date : 26/01/2021
Desc:Procedure has been changed with new business rules which replaces the previous procedure logic

Author:Praveen Nayakwadi 
Date : 31/03/2022
Desc: CR260309 Addition of Public & Private for schemes
A secondary change is to only populate the MS group when both MS & SPO groups are both specified for a user.
*/


AS
TRUNCATE TABLE dbo.SP_Portal_Users_Groups

INSERT   INTO  dbo.SP_Portal_Users_Groups(users,[GROUP],[type],[role])
SELECT [Q].[USERS],
       [Q].[GROUP],
       [Q].[TYPE],
       [Q].[ROLE]
	   FROM
(
SELECT [G].[USERS],
       [G].[GROUP],
       [G].[TYPE],
       [G].[ROLE],
	   RANK() OVER (PARTITION BY [G].[USERS], [G].[GROUP]
	   ORDER BY [G].[TYPE]) TYPE_RANK
	   ---only populate the MS group when both MS & SPO groups are both specified for a user
	  
FROM
(
    -- ################ CORPORATE M365 GROUPS #################
    SELECT [S].[USERS],
           [S].[LD0] AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S]
    WHERE [S].[H5] LIKE 'CORPORATE'
          AND [S].[USERS] IS NOT NULL
    UNION ALL 
    SELECT [S1].[USERS],
           [S1].[H1] AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S1]
    WHERE [S1].[H5] LIKE 'CORPORATE'
          AND [S1].[USERS] IS NOT NULL
        UNION ALL 
    SELECT [S2].[USERS],
           [S2].[H2] AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S2]
    WHERE [S2].[H5] LIKE 'CORPORATE'
          AND [S2].[USERS] IS NOT NULL

    --################## CORPORATE SPO GROUPS ##################
    -- DIRECTORATE LEVEL
      UNION ALL 
    SELECT DISTINCT
           [O].[USERS],
           [S3].[LD0] AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S3]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O]
            ON [O].[LD0] = [S3].[H2]
    WHERE [S3].[H5] LIKE 'CORPORATE'
          AND [O].[USERS] IS NOT NULL
          AND [S3].[USERS] IS NOT NULL
    -- DEPARTMENT LEVEL
     UNION ALL 
    SELECT 
           [O2].[USERS],
           [S4].[LD0] AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S4]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O2]
            ON [O2].[LD0] = [S4].[H1]
    WHERE [S4].[H5] LIKE 'CORPORATE'
          AND [O2].[USERS] IS NOT NULL
          AND [S4].[USERS] IS NOT NULL

    -- ############ OPS M365 GROUPS ###########################
    -- Direct Business Unit
        UNION ALL
    SELECT [S5].[USERS],
           [S5].[LD0] + ' - Private' AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S5]
    WHERE [S5].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [S5].[USERS] IS NOT NULL
        UNION ALL 
    SELECT [S5].[USERS],
           [S5].[LD0] + ' - Public' AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S5]
    WHERE [S5].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [S5].[USERS] IS NOT NULL


    -- Hub Users (i.e. Court based Employees)
       UNION ALL 
    SELECT [OS].[USERS],
           [OS].[HUB] + ' Hub' AS [GROUP],
           'M365' AS [TYPE],
           'VISITOR' AS [ROLE]
    FROM [dbo].[SP_Portal_Org_Struct_View] [OS]
    WHERE [OS].[USER_TYPE] = 'C'

    -- Hub Managers (i.e. levels above court)
       UNION ALL 
    SELECT [OS1].[USERS],
           [OS1].[HUB] + ' Hub' AS [GROUP],
           'M365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [dbo].[SP_Portal_Org_Struct_View] [OS1]
    WHERE [OS1].[USER_TYPE] = 'M'

    -- ############ OPS O365 GROUPS ###########################

    -- Manager access to courts
              -- Directorate Level


       UNION ALL 
    SELECT 
           [O3].[USERS],
           [S6].[LD0] + ' - Private' AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S6]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O3]
            ON [O3].[LD0] = [S6].[H5]
    WHERE [S6].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O3].[USERS] IS NOT NULL
          AND [S6].[USERS] IS NOT NULL
       UNION ALL
    SELECT 
           [O3].[USERS],
           [S6].[LD0] + ' - Public' AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S6]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O3]
            ON [O3].[LD0] = [S6].[H5]
    WHERE [S6].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O3].[USERS] IS NOT NULL
          AND [S6].[USERS] IS NOT NULL

              -- Region Level
    UNION ALL 
    SELECT 
           [O4].[USERS],
           [S7].[LD0] + ' - Private' AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S7]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O4]
            ON [O4].[LD0] = [S7].[H2]
    WHERE [S7].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O4].[USERS] IS NOT NULL
          AND [S7].[USERS] IS NOT NULL
    UNION ALL 
    SELECT 
           [O4].[USERS],
           [S7].[LD0] + ' - Public' AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S7]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O4]
            ON [O4].[LD0] = [S7].[H2]
    WHERE [S7].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O4].[USERS] IS NOT NULL
          AND [S7].[USERS] IS NOT NULL

              -- Patch Level
    UNION ALL 
    SELECT 
           [O5].[USERS],
           [S8].[LD0] + ' - Private'  AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S8]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O5]
            ON [O5].[LD0] = [S8].[H1]
    WHERE [S8].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O5].[USERS] IS NOT NULL
          AND [S8].[USERS] IS NOT NULL
    UNION ALL 
    SELECT 
           [O5].[USERS],
           [S8].[LD0] + ' - Public'  AS [GROUP],
           'O365' AS [TYPE],
           'MEMBER' AS [ROLE]
    FROM [SP_Portal_User_OrgHierarchy] [S8]
        INNER JOIN [SP_Portal_User_OrgHierarchy] [O5]
            ON [O5].[LD0] = [S8].[H1]
    WHERE [S8].[H5] IN ( 'Extra Care', 'Retirement Housing', 'Retirement Living' )
          AND [O5].[USERS] IS NOT NULL
          AND [S8].[USERS] IS NOT NULL

		  --- Public & Private for schemes

-- Buddy & Patch Courts  ############# THIS SECTION CURRENTLY DOESN'T WORK FROM DW ###############
    UNION ALL 
SELECT 
       bu.AD_User AS [USERS],
       [HOH].d8 + ' - Private' AS [GROUP],
       'O365' AS [TYPE],
       'MEMBER' AS [ROLE]
FROM TRANSFORM_USER_SCHEMES [BU]
    INNER JOIN dbo.USER_ALL_POST_RL_QLROLE [UR]
        ON [BU].[AD_User] = [UR].[AD_user]
    INNER JOIN dbo.RL_PERS_HIERARCHY [HOH]
        ON [HOH].l8 = [BU].[business_unit]
WHERE [UR].[QL_Role] IN ( 'CM', 'ACM' )
    UNION ALL 
SELECT 
       bu.AD_User AS [USERS],
       [HOH].d8 + ' - Public' AS [GROUP],
       'O365' AS [TYPE],
       'MEMBER' AS [ROLE]
FROM TRANSFORM_USER_SCHEMES [BU]
    INNER JOIN dbo.USER_ALL_POST_RL_QLROLE [UR]
        ON [BU].[AD_User] = [UR].[AD_user]
    INNER JOIN dbo.RL_PERS_HIERARCHY [HOH]
        ON [HOH].l8 = [BU].[business_unit]
WHERE [UR].[QL_Role] IN ( 'CM', 'ACM' )

) [G]
WHERE [G].[USERS] IS NOT NULL
GROUP BY 
[G].[USERS],
       [G].[GROUP],
       [G].[TYPE],
       [G].[ROLE]
)Q
WHERE [Q].[TYPE_RANK] = 1




  




GO


