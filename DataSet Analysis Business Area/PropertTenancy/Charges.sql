USE [QL_Test]
GO

/****** Object:  View [HC21].[H21_AllPropertyTenancyCharges]    Script Date: 04/05/2020 09:42:18 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO









/*
====================================================================================================================
Author:			Roy Casey
Creation Date:	17/12/2018
Description:	Get a list of active users and workgroup membership

Amendment History
------------------

Date      		By            		Description
-----     		---           		------------
17/12/2018		Roy Casey			Initial version
04/01/2019		Roy Casey			Added inner join to hgmprty1 from hraptych to exclude charges with no property (all target rents)
07/04/2018		Roy Casey			Amended case statement for tenancy charges - charge status, 
									to take account of tenancy charges that run on past the tenancy end date
====================================================================================================================
*/


CREATE VIEW [HC21].[H21_AllPropertyTenancyCharges]
AS

(
	SELECT 
		'Property' AS ChargeType,
		chg.comp_id AS CompanyID,
		chg.prty_ref AS PropertyRef,
		t.tency_seq_no AS TenancyRef,
		chg.charge_seqno AS ChargeSeqNo,
		chg.charge_cd AS ChargeCode,
		cdesc.desn AS ChargeName,
		cdesc.db_type AS DebitType,
		chg.st_date AS StartDate,
		chg.end_date AS EndDate,
		CASE WHEN chg.end_date < GETDATE() THEN 'Historic' WHEN chg.st_date > GETDATE() THEN 'Future' ELSE 'Current' END AS ChargeStatus,
		chg.value AS ChargeValue,
		chg.proc_cmpltd AS ProcessComplete,
		CASE WHEN chg.value = 0 THEN 1 ELSE 0 END AS ZeroValue,
		chg.frequency AS ChargeFrequency,
		chg.first_rdt AS FirstRaisedDate,
		chg.last_rdt AS LastRaisedDate,
		chg.created_dt AS CreatedDate,
		chg.created_by AS CreatedBy,
		chg.amended_dt AS AmendedDate,
		chg.amended_by AS AmendedBy,
		cdesc.rece_gen_cd AS ReceivableTemplate,
		cdesc.void_gen_cd AS VoidTemplate
	FROM 
		dbo.hraptych chg
	INNER JOIN dbo.hgmprty1 p1 ON 
		p1.comp_id = chg.comp_id 
		AND p1.prty_id = chg.prty_ref
	LEFT OUTER JOIN  dbo.hrachrge AS cdesc ON 
		cdesc.comp_id = chg.comp_id 
		AND cdesc.charge_cd = chg.charge_cd
	LEFT OUTER JOIN hratency t ON 
		t.comp_id = chg.comp_id AND t.prty_ref = chg.prty_ref 
		AND GETDATE() BETWEEN t.tency_st_dt AND ISNULL(t.tency_end_dt,'9999-12-31')

	UNION ALL

	SELECT
		'Tenancy' AS ChargeType,
		tc.comp_id,
		ten.prty_ref,
		tc.tency_seq_no,
		tc.charge_seqno AS ChargeSeqNo,
		tc.charge_cd,
		cdesc.desn,
		cdesc.db_type,
		tc.st_date,
		tc.end_date,
		--case when tc.end_date < getdate() then 'Historic' when tc.st_date > getdate() then 'Future' else 'Current' end as ChargeStatus,
		CASE 
			WHEN (tc.end_date < GETDATE() OR ten.tency_end_dt < GETDATE()) THEN 'Historic' 
			WHEN tc.st_date > GETDATE() THEN 'Future' 
			ELSE 'Current' 
		END AS ChargeStatus,
		tc.value,
		tc.proc_cmpltd,
		CASE WHEN tc.value = 0 THEN 1 ELSE 0 END AS ZeroValue,
		tc.frequency AS ChargeFrequency,
		tc.first_rdt AS FirstRaisedDate,
		tc.last_rdt AS LastRaisedDate,
		tc.created_dt AS CreatedDate,
		tc.created_by AS CreatedBy,
		tc.amended_dt AS AmendedDate,
		tc.amended_by AS AmendedBy,
		cdesc.rece_gen_cd AS ReceivableTemplate,
		cdesc.void_gen_cd AS VoidTemplate
	FROM
		hratcchg tc
	INNER JOIN hratency ten	ON 
		ten.comp_id = tc.comp_id 
		AND ten.tency_seq_no = tc.tency_seq_no 
	LEFT OUTER JOIN  dbo.hrachrge AS cdesc ON 
		cdesc.comp_id = tc.comp_id 
		AND cdesc.charge_cd = tc.charge_cd

)
GO


