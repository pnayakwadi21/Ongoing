SELECT  
Rent_Account_Name,Property_ID,Tenancy_Status ,cl.surname,cl.forename,cl.clnt_name,CONCAT(cl.forename,' ',REPLACE(cl.surname,'(deceased)','')) 'ClientFullName',tn.Rent_Account_No
FROM [HC21].[H21_Dataset_Tenancies] tn 
INNER JOIN  hracracr  cr ON cr.rent_acc_no=tn.Rent_Account_No
INNER JOIN hgmclent cl ON cl.client_no=cr.clnt_no
ORDER BY Tenancy_Sequence_No
