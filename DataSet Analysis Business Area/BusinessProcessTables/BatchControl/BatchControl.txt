
SELECT *

FROM
(
SELECT 	--	ACP Batch Control
acpType.ftxt,'ACP Batch Control' btype
	FROM 	[dbo].[acptcont] AS [ab]
		
		LEFT JOIN
			[dbo].[hlplist] AS [acpType]
		ON [ab].[doc_type] = [acpType].[fival]
		AND [acpType].[org_id] = 'GLOBAL' 
		AND [acpType].[form_id] = 'ACPS006A'
		AND [acpType].[list_id] = 1
		AND [acpType].[ledger_id]  = 'ACP'
GROUP BY acpType.ftxt
union
SELECT 	--	Cashbook Batch Control
				[cjt].[desn],'Cashbook Batch Control' FROM 
		[dbo].[cbktcont] AS [cb]
		LEFT JOIN		
			[dbo].[cbkjnltp] AS [cjt]
		ON [cb].[comp_id] = [cjt].[comp_id]
		AND [cb].[jnl_type] = [cjt].[jnl_id]
		GROUP BY [cjt].[desn]
		UNION
        	
			
			SELECT fasType.ftxt 
			
			,'Fixed Asset Batch Control to define Transaction type' btype
			
			 FROM 
			[dbo].[fastcont] AS [fb]
		
		LEFT JOIN
			[dbo].[hlplist] AS [fasType]
		ON [fb].[batch_type] = [fasType].[fival]
		AND [fasType].[org_id] = 'GLOBAL' 
		AND [fasType].[form_id] = 'FASF016A'
		AND [fasType].[list_id] = 1
		GROUP BY fasType.ftxt

		UNION
        
		
		SELECT popType.ftxt,'Purchase Order Batch Control to define transaction types' btype
		FROM 
		[dbo].[poptcont] AS [pb]
		
		LEFT JOIN
			[dbo].[hlplist] AS [popType]
		ON [pb].[batch_type] = [popType].[fival]
		AND [popType].[org_id] = 'GLOBAL' 
		AND [popType].[form_id] = 'POPF004A'
		AND [popType].[list_id] = 1
		GROUP BY popType.ftxt

		UNION ALL

		SELECT
		
		sivType.ftxt,'Sales'btype
		
			--	Sales Invoice Batch Control
		FROM [dbo].[sivtcont] AS [sb]
		
		LEFT JOIN
			[dbo].[hlplist] AS [sivType]
		ON [sb].[bat_type] = [sivType].[fival]
		AND [sivType].[org_id] = 'GLOBAL' 
		AND [sivType].[form_id] = 'SIVF001A'
		AND ledger_id = '1'
		AND [sivType].[list_id] = 1
		

		GROUP BY 	sivType.ftxt


		) r
		ORDER BY r.btype