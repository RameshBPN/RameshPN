/**
    About
    -----
    Description: Before Delete Trigger on Attachment
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: April 2015
    Prevent deletion of Attachments on cases for the users with profiles - 'CS_Standard_User_PDK_BE'
        
    Update History
    --------------
    Created April 2015 : B.Shridhar


    Issues / TODOs
    --------------  

**/
trigger Attachment_BeforeDelete on Attachment (before delete) {

    if(!UTIL_OrgSettings.isTriggersDisabled()) { 
    
       if(UTIL_Meta.profileName(UserInfo.getProfileId()).equals((String)Get2OneCRM__c.getOrgDefaults().get('CS_Standard_User_PDK_BE_Profile_Name__c'))){
    
           for(Attachment att : Trigger.old){
           
               String caseKeyPrefix = Case.sObjectType.getDescribe().getKeyPrefix();
               String attParentKeyPrefix=String.valueOf(att.ParentId).subString(0,3);
           
               if(caseKeyPrefix.equalsIgnoreCase(attParentKeyPrefix)){
                    att.addError(LABEL.Insufficient_Access_to_delete_the_Attachemnts_on_Cases); 
               }
    
           }
    
       }
    
    }
    
}