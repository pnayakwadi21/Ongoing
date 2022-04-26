  SELECT PERSON_REF,
       
        
         FIRST_FORNAME,
         SURNAME,
       

         EMP_CONTROL_GROUP,
         EMP_PAY_GROUP,
         POST_NUMBER,
         POST_LONG_DESC,
      
         MAIN_FLAG,
         POST_TYPE,
      
       
         CONDITION_TYPE,
 
      
         JOB_LONG_DESC,
         CURRENT_GRADE,
       
         LOC_LONG_DESC,
        
         SERVICE_CON_ID,
         SERV_CON_LONG_DESC,
   
         POSITION_STATUS,
         POSN_STATUS_DESC,
     
   
         CONT_HR,
         HR_FTE_HOURS,

  
         POST_SHORT_DESC,
         ETHNIC,
         CONTROL_GROUP_DESC,
         PAY_GROUP_DESC,
         EMP_CONT_HR_WPY,
         EMP_CONT_HOURS,
         PAYPOINT,
         POST_ROLE_ID FROM raw_d580v 
		 WHERE POST_END_DATE IS null