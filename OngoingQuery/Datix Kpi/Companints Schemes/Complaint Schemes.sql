SELECT com_name,LEFT(code_specialty .description,4) Scheme,dbo.code_specialty.cod_parent FROM dbo.compl_main  
INNER JOIN  dbo.code_specialty  
ON code_specialty.code = compl_main.com_specialty
WHERE LEN(RTRIM(LTRIM(compl_main .com_name)))>0 
--GROUP BY com_name
GROUP BY com_name,LEFT(code_specialty .description,4) ,dbo.code_specialty.cod_parent 