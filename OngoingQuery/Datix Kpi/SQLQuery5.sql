USE [QL_Prod]
GO

/****** Object:  StoredProcedure [HC21].[H21_Dataset_Tenancies_Create]    Script Date: 08/07/2022 10:47:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/*
====================================================================================================================
Author:			Andrew Smith
Creation Date:	27/02/2020
Description:	Tenancies Dataset - Generates standard set of data for consistent reporting

Amendment History
------------------

Date		Version		By          		Description
-----     	--			------         		------------
27/02/2020	1.0			Andrew Smith		Initial version
25/11/2021	1.1			Andrew Smith		Replaced DROP and SELECT INTO with TRUNCATE TABLE AND INSERT INTO

====================================================================================================================
*/

CREATE PROCEDURE [HC21].[H21_Dataset_Tenancies_Create]
		  @Report_Date AS DATETIME = NULL
		, @Create_Table AS SMALLINT = 0

AS

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
		
	-- =================================
	--  Set Transaction Isolation Level
	-- =================================
	IF EXISTS(SELECT snapshot_isolation_state FROM sys.databases WHERE database_id = DB_ID() AND snapshot_isolation_state = 1)
		BEGIN
			SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
		END
	ELSE
		BEGIN
			SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
		END


BEGIN TRANSACTION
	/*
	====================================================================================================================================
	Dataset Tenancies

	Pulls together basic data for tenancies

	Database objects associated with the dataset
	[HC21].[H21_Dataset_Tenancies]			- The dataset table
	[HC21].[H21_Dataset_Tenancies_Create]	- Stored procedure to generate the table
	[HC21].[H21_Dataset_Tenancies_Select]	- View to be used to read the table

	@Create_Table 
		0	Returns Select statement
		1	TRUNCATE then INSERT all rows of [HC21].[H21_Dataset_Tenancies]
	--			Two would be used for an incremental update result, which may not be practical with this dataset
	--	3	for future	--	Creates [HC21].[H21_Dataset_Tenancies] and adds any exceptions to [HC21].[H21_Dataset_Exceptions]

	====================================================================================================================================
	*/
	--	When Create Table is chosen: 
	--		The Report Date is defaulted to GETDATE as that's what reports will expect from the table
	--		Property Status is set to All

		SET @Report_Date = 
			CASE 
				WHEN @Create_Table IN (1, 2) THEN GETDATE()
				WHEN @Report_Date IS NOT NULL THEN @Report_Date 
			ELSE GETDATE() END

		SET @Report_Date = DATEADD(DD, DATEDIFF(DD, 0, @Report_Date), 0)

	------------------------------------------------------------------------------------------------------------------------------------------------
	DROP TABLE IF EXISTS #Tenancies

	CREATE TABLE #Tenancies(
		[QL_System] [VARCHAR](3) NOT NULL,
		[Tenancy_Sequence_No] [INT] NOT NULL,
		[Rent_Account_No] [INT] NOT NULL,
		[Rent_Account_Name] [VARCHAR](100) NULL,
		[Number_of_Tenancies] [SMALLINT],
		[Care_Account_Ref] [VARCHAR] (10) NULL,
		[Care_Account_Name] [VARCHAR] (40) NULL,
		[Property_ID] [VARCHAR](30) NULL,
		[Application_Id] [INT] NULL,
		[Tenancy_Status] [VARCHAR](9) NULL,
		[Tenancy_Start_Date] [DATETIME] NULL,
		[Tenancy_End_Date] [DATETIME] NULL,
		[Tenancy_Start_Financial_Period] [INT] NULL,
		[Tenancy_End_Financial_Period] [INT] NULL,
		[Tenure_Type_Code] [VARCHAR](10) NULL,
		[Tenure_Type_Description] [VARCHAR](30) NULL,
		[Tenancy_Type_Code] [VARCHAR](6) NULL,
		[Tenancy_Type_Description] [VARCHAR](30) NULL,
		[Affordable_Rent_Flag] [VARCHAR](1) NULL,
		[Resident_Court_Manager] [VARCHAR](1) NOT NULL,
		[Current_Tenancy_Balance] [DECIMAL](19,4) NULL,
		[Balancing_Frequency_Code] [VARCHAR](6) NULL,
		[Balancing_Frequency_Description] [VARCHAR](30) NULL,
		[HB_Reference] [VARCHAR](20) NULL,
		[Charges_First_Raised_Date] [DATETIME] NULL,
		[Charges_Last_Raised_Date] [DATETIME] NULL,
		[Last_Charge_Amount] [DECIMAL](19,4) NULL,
		[Last_Payment_Date] [DATETIME] NULL,
		[Last_Payment_Amount] [DECIMAL](19,4) NULL,
		[Receipt_Method_Code] [VARCHAR](1) NULL,
		[Receipt_Method_Description] [VARCHAR](60) NULL,
		[Alt_Post_Ref] [VARCHAR](20) NULL,
		[Calculated_Let_Date] [DATETIME] NULL,
		[Estimated_Let_Date] [DATETIME] NULL,
		[Tenancy_End_Notification_Date] [DATETIME] NULL,
		[Notice_Given_Date] [DATETIME] NULL,
		[Tentative_End_Date] [DATETIME] NULL,
		[Vacation_Code] [VARCHAR](10) NULL,
		[Vacation_Code_Description] [VARCHAR](30) NULL,
		[Current_Arrears_Code] [VARCHAR](6) NULL,
		[Current_Arrears_Description] [VARCHAR](30) NULL,
		[Current_Arrears_Date] [DATETIME] NULL,
		[Forwarding_Address_Flag] [VARCHAR](1) NOT NULL,
		[Alt_Correspondence_Address_Id] [VARCHAR](15) NULL,
		[Alt_Correspondence_Full_Address] [VARCHAR](500) NULL,
		[Introductory_Tenancy_End_Date] [DATETIME] NULL,
		[Notes_Flag] [VARCHAR](1) NULL
	) ON [PRIMARY]

	------------------------------------------------------------------------------------------------------------------------------------------------
; WITH
	Tenancy_Dates_CTE AS	--	Only use firm tenancy end dates
		(SELECT DISTINCT
			  tenancy.[comp_id]
			, tenancy.[tency_seq_no]
			, dvp.[Property_ID]
		--	, dvp.[Period_Sequence]
			, CASE 
				WHEN tenancy.[process_comp] = 1 THEN tenancy.[tency_end_dt]
				WHEN dvp.[Void_End_Date] IS NOT NULL THEN tenancy.[tency_end_dt]
				WHEN [dvp].[Current_Void_Code] IN ('VDM001','VDR001','VDS002','VDT001') THEN tenancy.[tency_end_dt]
				ELSE NULL
			END AS [Tenancy_End_Date]

		FROM [dbo].[hratency] AS [tenancy]

		--	process complete is only present after a debit run
		--	A void end date will be present when a new account is added
		--	Tenancy 95777 has no Process Complete Flag and no following tenancy, but looks ended
		--		@30/08/2019 this will process as Tenanted when actually vacant
		--		The further join to analyse disposed Void Codes deals with 95777
		LEFT JOIN
			[HC21].[H21_Dataset_Void_Periods_Select] AS [dvp]
		ON tenancy.[comp_id] = dvp.[QL_System]
		AND tenancy.[prty_ref] = dvp.[Property_ID]
		AND tenancy.[tency_seq_no] = dvp.[Previous_Tenancy_Ref]
		AND dvp.[Reporting_Validity] = 'Valid'

		WHERE tenancy.[tency_st_dt] <= tenancy.[tency_end_dt]
		OR tenancy.[tency_end_dt] IS NULL
			),
 
	--	SELECT * FROM Tenancy_Dates_CTE 
	--	WHERE [Tenancy_Dates_CTE].[tency_seq_no] IN ('100922', '200262', '103972', '51741', '95965', '104401')
	--	WHERE [Tenancy_Dates_CTE].[Property_ID] IN ('BLUEBELLGARD_D019', 'FREESTONE_D034', 'PRIORY_D039', 'MOUNTBATTEN_G009')
	--	ORDER BY comp_id, [Tenancy_Dates_CTE].[Property_ID]

	------------------------------------------------------------------------------------------------------------------------------------------------
	--	The affordable rent date on hgmprty3 is mostly wrong and defaulted to 01/01/2016
	--	The advice from Peter Hodgkinson is where date is 01/01/2016 then any tenancy starting after 01/01/2011 is affordable
	Affordable_Rents_CTE AS
		(SELECT
			  [ht].[comp_id]
			, [ht].[tency_seq_no]
			, [p3].[extra1_b001]

		FROM [dbo].[hratency] AS [ht]

		INNER JOIN
			[dbo].[hgmprty3] AS [p3]
		ON [p3].[comp_id] = [ht].[comp_id]
		AND [p3].[prty_id] = [ht].[prty_ref]
		AND (([p3].[extra1_d001] <= [ht].[tency_st_dt]) 
				OR ([p3].[extra1_d001] = '2016-01-01 00:00:00.000' AND [ht].[tency_st_dt] >= '2011-01-01 00:00:00.000'))

		WHERE [p3].[extra1_b001] = 1 
		OR [p3].[extra1_d001] IS NOT NULL
			),

	------------------------------------------------------------------------------------------------------------------------------------------------
	Tenancy_Count_CTE AS
		(SELECT 
			  [t1].[comp_id]
			, [t1].[rent_acc_no]
			, COUNT([t1].[comp_id]) AS [Tenancy_Count]
		--	* 

		FROM [dbo].[hratency] AS [t1]

		INNER JOIN
			[dbo].[hratncy2] AS [t2]
		ON [t1].[comp_id] = [t2].[comp_id]
		AND [t1].[tency_seq_no] = [t2].[tency_seq_no]

		WHERE [t2].[ignore_tenancy] = 0

		GROUP BY 
			  [t1].[comp_id]
			, [t1].[rent_acc_no]
			)

	------------------------------------------------------------------------------------------------------------------------------------------------
	INSERT INTO #Tenancies

	SELECT
		  LTRIM(RTRIM([tenancy1].[comp_id]))                AS [QL_System]
		, [tenancy1].[tency_seq_no]                         AS [Tenancy_Seq_No]
		, [ra].[rent_acc_no]                                AS [Rent_Account_No]
		, [ra].[rent_acc_nm]                                AS [Rent_Account_Name]
		, [tcCTE].[Tenancy_Count]							AS [Number_of_Tenancies]
		, [ra].[ass_acrcc]									AS [Care_Account_Ref]
		, [acp].[ACP_Full_Name]										AS [Care_Account_Name]
		, LTRIM(RTRIM(COALESCE([tenancy1].[prty_ref], 'Sold / Demolished Property'))) AS [Property_ID]
		, [tenancy2].[app_no]                               AS [Application_Id]

		, CASE	--	Determine status of tenancy using calculated End Date
			WHEN [tenancy2].[ignore_tenancy] = 1 THEN 'Cancelled'
			WHEN @Report_Date < [tenancy1].[tency_st_dt] AND [tdCTE].[Tenancy_End_Date] IS NULL THEN 'Future'
			WHEN [tenancy1].[tency_st_dt] <= @Report_Date 
				AND ([tdCTE].[Tenancy_End_Date] IS NULL OR [tdCTE].[Tenancy_End_Date] > @Report_Date) THEN 'Current'
			WHEN [tdCTE].[Tenancy_End_Date] <= @Report_Date THEN 'Former'
			ELSE NULL
		END													AS [Tenancy_Status]

		, [tenancy1].[tency_st_dt]							AS [Tenancy_Start_Date]
	--	, [tenancy1].[tency_end_dt]							AS [Tenancy_End_Date]
		, [tdCTE].[Tenancy_End_Date]						AS [Tenancy_End_Date]

		, [StartFP].[Financial_Year_Period]                 AS [Tenancy_Start_Financial_Period]
		, [EndFP].[Financial_Year_Period]                   AS [Tenancy_End_Financial_Period]
/*
		, CASE	-- Do I need this if Tenancy End Date Calc works?
			WHEN [tenancy1].[process_comp] = 1 THEN 'Yes'
			WHEN [tenancy1].[process_comp] = 0 THEN 'No'
		END AS [Process_Complete_Flag]

		, CASE	-- Do I need this if Tenancy status works?
			WHEN [tenancy2].[ignore_tenancy] = 1 THEN 'Yes'
			WHEN [tenancy2].[ignore_tenancy] = 0 THEN 'No'
		END AS [Ignore_Tenancy_Flag]
*/
		, LTRIM(RTRIM([tenancy1].[tenure_type]))            AS [Tenure_Type_Code]
		, LTRIM(RTRIM([tenureType].[desn]))                 AS [Tenure_Type_Description]
		, CASE
			WHEN [tenancy2].[tency_type] = ' ' THEN NULL
			ELSE LTRIM(RTRIM([tenancy2].[tency_type]))
		END													AS [Tenancy_Type_Code]
		, LTRIM(RTRIM([tenancyType].[desn]))                AS [Tenancy_Type_Description]
		, CASE 
					WHEN [arCTE].[extra1_b001] = 1 THEN 'Y'
					ELSE 'N'
		END AS [Affordable_Rent_Flag]
		, CASE
			WHEN [tenancy1].[tenure_type] = 'CMN' THEN 'Y'
			WHEN [tenancy1].[tenure_type] = 'CMO' THEN 'Y'
			ELSE 'N'
		END													AS [Resident_Court_Manager]
		, [tenancy1].[cur_tncy_bal]                         AS [Current_Tenancy_Balance]
		, LTRIM(RTRIM([tenancy1].[bal_freq]))				AS [Balancing_Frequency_Code]
		, LTRIM(RTRIM([bf].[desn]))							AS [Balancing_Frequency_Description]
		, LTRIM(RTRIM([tenancy1].[hb_ref]))                 AS [HB_Reference]
		, [tenancy1].[chgs_first]                           AS [Charges_First_Raised_Date]
		, [tenancy1].[chgs_last]                            AS [Charges_Last_Raised_Date]
		, [tenancy1].[last_chg]                             AS [Last_Charge_Amount]
		, [tenancy1].[paymt_last]                           AS [Last_Payment_Date]
		, [tenancy1].[last_paymt]                           AS [Last_Payment_Amount]
		, LTRIM(RTRIM([tenancy1].[recpt_meth]))             AS [Receipt_Method_Code]
		, LTRIM(RTRIM([ReceiptMethod].[ftxt]))				AS [Receipt_Method_Description]
		, LTRIM(RTRIM([tenancy1].[alt_post_ref]))           AS [Alt_Post_Ref]
		, [tenancy1].[cal_let_dt]                           AS [Calculated_Let_Date]          
		, [tenancy1].[est_let_dt]                           AS [Estimated_Let_Date]    
		, [tenancy2].[tenancy_end_crea]                     AS [Tenancy_End_Notification_Date] 
		, [tenancy2].[tnt_end_date]							AS [Notice_Given_Date]
		, [tenancy2].[prov_end_date]						AS [Tentative_End_Date]
		, LTRIM(RTRIM([tenancy1].[res_vacn]))               AS [Vacation_Code]
		, LTRIM(RTRIM([VacationReason].[desn]))             AS [Vacation_Code_Description]
		--	have arrears code, but should there be some form of arrears status/level/grouping related to entitlements etc?
		--	more importantly payment status
		--	also what's the status of stuff shown on tablets for tenancy/property
		, LTRIM(RTRIM([tenancy1].[cur_arr_act]))            AS [Current_Arrears_Code]
		, LTRIM(RTRIM([arrearsActionName].[desr]))          AS [Current_Arrears_Description]
		, [tenancy1].[cur_act_dt]                           AS [Current_Arrears_Date]
		, CASE
			WHEN [ra].[corr_add] IS NULL THEN 'N'
			ELSE 'Y'
		END													AS [Forwarding_Address_Flag]
		, [ra].[corr_add]
		, COALESCE([altAddr].[add_1] + CHAR(13) + CHAR(10), '') + COALESCE([altAddr].[add_2] + CHAR(13) + CHAR(10), '')
		+ COALESCE([altAddr].[add_3] + CHAR(13) + CHAR(10), '') + COALESCE([altAddr].[add_4] + CHAR(13) + CHAR(10), '')
		+ COALESCE([altAddr].[add_5] + CHAR(13) + CHAR(10), '') + COALESCE([altAddr].[post_code], '') AS [Alt_Correspondence_Full_Address]
		, [tenancy2].[date_1]                               AS [Introductory_Tenancy_End_Date]
		, CASE
			WHEN [tenancy1].[notes_yn] = 1 THEN 'Y'
			WHEN [tenancy1].[notes_yn] = 0 THEN 'N'
		END													AS [Notes_Flag]

	FROM [dbo].[hratency] AS [tenancy1]

	--	match to 'actual' end dates
	LEFT JOIN
		[Tenancy_Dates_CTE] AS [tdCTE]
	ON [tenancy1].[comp_id] = [tdCTE].[comp_id]
	AND [tenancy1].[tency_seq_no] = [tdCTE].[tency_seq_no]

    INNER JOIN
        [dbo].[hratncy2] AS [tenancy2]
    ON [tenancy1].[comp_id] = [tenancy2].[comp_id]
    AND [tenancy1].[tency_seq_no] = [tenancy2].[tency_seq_no]
 
    --	Rent Account
    INNER JOIN
        [dbo].[hrartamt] AS [ra]

		LEFT JOIN
			Tenancy_Count_CTE AS [tcCTE]
		ON [ra].[comp_id] = [tcCTE].[comp_id]
		AND [ra].[rent_acc_no] = [tcCTE].[rent_acc_no]

		--	Care Accounts -- Risk of row duplicates no guarantee one to one
		LEFT JOIN
			[HC21].[H21_Dataset_ACP_Master_Details_Select] AS [acp]
		ON [ra].[comp_id] = [acp].[QL_System]
		AND [ra].[ass_acrcc] = [acp].[ACP_Reference]

		--	alternative correspondence address details
		LEFT JOIN
			[dbo].[cmpadd] AS [altAddr]
		ON [ra].[corr_add] = [altAddr].[add_id]

    ON [tenancy1].[comp_id] = [ra].[comp_id]
    AND [tenancy1].[rent_acc_no] = [ra].[rent_acc_no]

	--	Match Affordable Rent Flag
	LEFT JOIN
		[Affordable_Rents_CTE] AS [arCTE]
	ON [tenancy1].[comp_id] = [arCTE].[comp_id]
	AND [tenancy1].[tency_seq_no] = [arCTE].[tency_seq_no]

	--	match tenancy start to monthly financial period
	LEFT JOIN
		[HC21].[H21_Dataset_Financial_Periods_Select] AS [StartFP]
	ON [tenancy1].[tency_st_dt] >= [StartFP].[Period_Start_Date] 
	AND [tenancy1].[tency_st_dt] < [StartFP].[Next_Period_Start_Date]
	AND [StartFP].[QL_System] = 'H21'
	AND [StartFP].[Frequency_Code] = 'M'

	--	match tenancy end to monthly financial period
	LEFT JOIN
		[HC21].[H21_Dataset_Financial_Periods_Select] AS [EndFP]
	ON [tenancy1].[tency_end_dt] >= [EndFP].[Period_Start_Date] 
	AND [tenancy1].[tency_end_dt] < [EndFP].[Next_Period_Start_Date]
	AND [EndFP].[QL_System] = 'H21'
	AND [EndFP].[Frequency_Code] = 'M'	

	--	Lookups tenancy.tenure_type
    LEFT JOIN
        [dbo].[cmpgencd] AS [tenureType]
    ON [tenancy1].[tenure_type] = [tenureType].[code_id]
	AND [tenureType].[mod_id] = 'HSG'
    AND [tenureType].[category_id] = 'TENUR_TYPE'

	--	Lookups tenancy.tenancy_type
    LEFT JOIN
        [dbo].[cmpgencd] AS [tenancyType]
    ON [tenancy2].[tency_type] = [tenancyType].[code_id]
	AND [tenancyType].[mod_id] = 'HSG'
    AND [tenancyType].[category_id] = 'TENCY_TYPE'

	--	Lookup frequency
	LEFT JOIN
		[dbo].[hrafrqcy] AS [bf]
	ON [tenancy1].[comp_id] = [bf].[comp_id]
	AND [tenancy1].[bal_freq] = [bf].[freq_cd]

    --	arrears code lookup
    LEFT JOIN
        [dbo].[hraaracd] AS [arrearsActionName]
    ON [tenancy1].[comp_id] = [arrearsActionName].[comp_id]
    AND [tenancy1].[cur_arr_act] = [arrearsActionName].[arr_act_cd]

	--	Vacation reason lookup
    LEFT JOIN
        [dbo].[cmpgencd] AS [VacationReason]
    ON [tenancy1].[res_vacn] = [VacationReason].[code_id]
	AND [VacationReason].[mod_id] = 'HSG'
	AND [VacationReason].[category_id] = 'VACATION'

	--	Receipt Method look up
	LEFT JOIN
		[dbo].[hlplist] AS [ReceiptMethod]
	ON [tenancy1].[recpt_meth] = [ReceiptMethod].[fival]
	AND [ReceiptMethod].[list_id] = 1
	AND [ReceiptMethod].[form_id] = 'HRAF017B'


	------------------------------------------------------------------------------------------------------------------------------------------------
	--	Determine if result set is returned or put into HC21 Table
	IF @Create_Table IN (1, 3)	--	Truncate table and insert all rows 
	
		BEGIN
		--	DROP TABLE IF EXISTS [HC21].[H21_Dataset_Tenancies]

			TRUNCATE TABLE [HC21].[H21_Dataset_Tenancies]
			INSERT INTO [HC21].[H21_Dataset_Tenancies]
			SELECT *			
			FROM #Tenancies

			/*
			--	Create index	-- Dev data quality prevents this at present
			IF ((SELECT CONSTRAINT_NAME FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE CONSTRAINT_NAME='H21_Dataset_Tenancies_PK') IS NULL)
				BEGIN
					ALTER TABLE [HC21].[H21_Dataset_Tenancies]
					ADD CONSTRAINT H21_Dataset_Tenancies_PK PRIMARY KEY CLUSTERED ([QL_System], [Tenancy_Sequence_No]) 
				END
			*/ 
		END
	ELSE
		BEGIN
			SELECT * FROM [#Tenancies]
		END

/*
	--	Determine if any exceptions are required to be added to exception reporting
	IF @Create_Table = 3
		BEGIN
			
			INSERT INTO  [HC21].[H21_Dataset_Exceptions]
				([Exception_Type],
				[comp_id],
				[prty_ref],
				[Code_Type],
				[Code_Value]
					)

			--	SELECT statement of exceptions if required
		END
*/


COMMIT TRANSACTION

END TRY


BEGIN CATCH
	IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
	
	EXEC [HC21].[H21_UpdateErrorLog];
	
	THROW;
END CATCH;
GO

EXEC sys.sp_addextendedproperty @name=N'H21_Description', @value=N'Tenancies Dataset - Generates standard set of data for consistent reporting' , @level0type=N'SCHEMA',@level0name=N'HC21', @level1type=N'PROCEDURE',@level1name=N'H21_Dataset_Tenancies_Create'
GO







SELECT  
Rent_Account_Name,Property_ID,Tenancy_Status ,cl.surname,cl.forename,cl.clnt_name,CONCAT(cl.forename,' ',REPLACE(cl.surname,'(deceased)','')) 'ClientFullName',tn.Rent_Account_No,cr.clnt_no

FROM [HC21].[H21_Dataset_Tenancies] tn 
INNER JOIN  hracracr  cr ON cr.rent_acc_no=tn.Rent_Account_No
INNER JOIN hgmclent cl ON cl.client_no=cr.clnt_no
--WHERE cl.forename LIKE '%french%'
ORDER BY Tenancy_Sequence_No



--SELECT TOP 10 * FROM [HC21].[H21_Dataset_Clients]

-----

-----Mr RJ Power (deceased)
----- [dbo].[hgmclent]

--SELECT * FROM [dbo].[hgmclent]

--SELECT DISTINCT clnt_no,rent_acc_no FROM hracracr   

--SELECT *  FROM [HC21].[H21_Dataset_Tenancies] tn 
--WHERE tn.Rent_Account_No=116551
-----102671



		SELECT TOP 100 * FROM ACPMAST A1 WITH (NOLOCK)
		WHERE 
		A1.LEDGER_ID = 'SL1'
		AND name LIKE '%Hickey%'