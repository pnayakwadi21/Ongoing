SELECT * INTO #er  FROM dbo.compl_main   ------- complaints
WHERE com_dreceived>'2020/01/01'


SELECT com_type,com_subtype,com_outcome,com_curstage,com_subject1 FROM #er


SELECT * FROM #er



SELECT *  FROM dbo.udf_fields uf 
WHERE uf.fld_name LIKE '%ombud%'


SELECT *  FROM dbo.incidents_main ------Incidents 