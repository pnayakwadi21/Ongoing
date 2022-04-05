USE [H21_STAGING]
GO

/****** Object:  View [dbo].[Employee_Absence_View]    Script Date: 07/02/2022 13:41:53 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[Employee_Absence_View]
	AS
	
	SELECT		
			A2.EMPLOYEE_NUMBER								EMPLOYEE_NUMBER,
			A1.PERSON_REF										PERSON_REF,
			A1.START_DATE										ABSENCE_START_DATE,
			a1.END_DATE,
			A1.R_TYPE												ABSENCE_TYPE,
			A3.LONG_DESC										ABSENCE_TYPE_DESCRIPTION,
			A4.REASON												ABSENCE_REASON,
			A5.LONG_DESC										ABSENCE_REASON_DESCRIPTION
		
	FROM
			RAW_D570M A1
	INNER JOIN
			RAW_D550M A2
	ON
			A2.PERSON_REF = A1.PERSON_REF
	LEFT OUTER JOIN 
			RAW_D800M A3
	ON
			A3. NARRATIVE_CATEGORY='ATDTYP'
	AND
			A3.NARRATIVE_CODE = A1.R_TYPE
	LEFT OUTER JOIN
			RAW_D571M A4
	ON
			A4.PERSON_REF = A1.PERSON_REF
	AND
			A4.EMP_ATT_START_COMPDATE = A1.START_COMPDATE
	LEFT OUTER JOIN	
			RAW_D800M A5
			ON
			A5.NARRATIVE_CATEGORY='ABSRSN'
	AND
			A5.NARRATIVE_CODE = A4.REASON
GO







SELECT * FROM 		RAW_D800M A3
	
WHERE  NARRATIVE_CATEGORY='ATDTYP'