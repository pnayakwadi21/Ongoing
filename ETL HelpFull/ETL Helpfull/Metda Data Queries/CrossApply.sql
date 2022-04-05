SELECT * FROM (VALUES('emp1','post1'),('emp2','post2'))r(emp,post)


CREATE TABLE #uptest(
EmpName VARCHAR(100),
EmpPost1 VARCHAR(100),
EmpPost2 VARCHAR(100)
)
INSERT INTO #uptest
(
    EmpName,
    EmpPost1,
    EmpPost2
)
VALUES
(   'TestEmp1', -- EmpName - varchar(100)
    'TestE1Post1', -- EmpPost1 - varchar(100)
     'TestE1Post2'  -- EmpPost2 - varchar(100)
    )

	,
(   'TestEmp2', -- EmpName - varchar(100)
    'TestE2Post1', -- EmpPost1 - varchar(100)
     'TestE2Post2'  -- EmpPost2 - varchar(100)
    )




	SELECT U.EmpName,CA.empPOST1,CA.EMPPOST2 FROM #uptest u
	CROSS APPLY(values(EMPpOST1,EMPPOST2)) CA(empPOST1,EMPPOST2)