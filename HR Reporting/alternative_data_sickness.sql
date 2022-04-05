SELECT 


--SUBSTRING(form_description,CHARINDEX('-',form_description,2)-10,10) stdt,
--SUBSTRING(form_description,CHARINDEX('-',form_description)+2,10) edst





ROW_NUMBER() OVER (PARTITION BY form_person_ref ORDER BY  form_number)
,SUBSTRING(RTRIM(form_description),LEN(RTRIM(form_description))-23,10) St_Dt
--,*
,SUBSTRING(RTRIM(form_description),LEN(RTRIM(form_description))-10,10) End_Dt
,form_person_ref,form_post_ref		
FROM raw_d1870m
WHERE form_event_id='WTMABS'

AND form_description LIKE '%sickness%'
AND form_raised_Date>'2020/01/01'
--AND form_person_ref=01072174
ORDER BY form_raised_date desc
