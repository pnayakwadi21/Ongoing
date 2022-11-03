SELECT * FROM dbo.RL_Meta
WHERE COLUMN_NAME LIKE '%grade%' AND COLUMN_NAME LIKE '%default%'

SELECT * FROM dbo.REC_RESOURCELINK_ACTIVE_DIRECTORY_ALL_POSTS
WHERE  EMPLOYEE_USER_NAME LIKE '%nayak%'

SELECT  TOP 2 p.emp_mp_home_address1, p.emp_mp_home_address2 , p.emp_mp_home_address3 , p.emp_mp_home_address4 , p.emp_mp_home_address5  FROM raw_D2060m p
inner join raw_d550m m on p.person_ref=m.person_ref
where 

emp_ph_tax_year=2022
and m.end_date is null
and emp_mp_address5  LIKE ''

SELECT   TOP 2 p.emp_mp_home_address1, p.emp_mp_home_address2 , p.emp_mp_home_address3 , p.emp_mp_home_address4 , p.emp_mp_home_address5 FROM raw_D2060m p
inner join raw_d550m m on p.person_ref=m.person_ref
where 

emp_ph_tax_year=2022
and m.end_date is null
and emp_mp_address4  LIKE ''
GROUP BY m.PERSON_REF, p.emp_mp_home_address1, p.emp_mp_home_address2 , p.emp_mp_home_address3 , p.emp_mp_home_address4 , p.emp_mp_home_address5

SELECT   TOP 2 p.emp_mp_home_address1, p.emp_mp_home_address2 , p.emp_mp_home_address3 , p.emp_mp_home_address4 , p.emp_mp_home_address5 FROM raw_D2060m p
inner join raw_d550m m on p.person_ref=m.person_ref
where 

emp_ph_tax_year=2022
and m.end_date is null
and emp_mp_address3  LIKE ''
GROUP BY m.PERSON_REF, p.emp_mp_home_address1, p.emp_mp_home_address2 , p.emp_mp_home_address3 , p.emp_mp_home_address4 , p.emp_mp_home_address5

SELECT MAX(m.WORK_TEL_NO) WORK_TEL_NO

FROM raw_d500m m
INNER JOIN raw_d550m t ON m.PERSON_REF=t.PERSON_REF
WHERE t.END_DATE IS NULL
--AND m.SURNAME LIKE '%naya%'


GROUP BY LEN(m.WORK_TEL_NO)


SELECT * FROM raw_d970m
WHERE SCREEN_REF='MD47L3'


SELECT CURRENT_GRADE FROM dbo.RAW_D580v
GROUP BY CURRENT_GRADE



---CWSTDZ
---ANCZ



SELECT POST_NUMBER,COUNT(DISTINCT REF),CURRENT_GRADE FROM  dbo.RAW_D580v
WHERE CURRENT_GRADE<>'CWZERO' 
AND POST_END_DATE IS null
GROUP BY POST_NUMBER
HAVING COUNT(DISTINCT CURRENT_GRADE)>1


SELECT CURRENT_GRADE FROM dbo.RAW_D580v
WHERE POST_NUMBER=0802
 AND POST_END_DATE IS null