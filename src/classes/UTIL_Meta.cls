/**
    About
    -----
    Description: Apex meta data (describes, record type maps etc.) calls. Cached to reduce repeted calls.
    Created for: Postnord Get2OneCRM Master/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    - Profiles
        profileId // Get profile ID by Name
        isIntegrationUser // Determins if the user is an integraion user
    
    - Record Types
        short methods to access record types and ids by developer name etc.
    
    - Describe Info
        globalDescibe_Map // Get global describe (cached)
        getFieldMap // Get map of fields for an object by object type name
        getFieldDescribe // Get field describe
        getFieldDescribe // Get field describe by object type name and field name
        getFieldLabel // Get field label for object and field. Uses context of executing user
    
    - Org Wide Info
        getOrgInfo // return the DML select from the Organisation record (there is only one per org)

    - Environment
        isEnvironmentSndbox // Bool if the current env is a sandbox or not

    Update History
    --------------
    Created March 2013 - M.Evans
    Updated Sept 2014 - M.Evans
    
    Issues / TODOs
    --------------
*/
public without sharing class UTIL_Meta
{
    /**** Profiles ****/
    // Get profile ID by Name
    static Map<String,String>profileIds = new Map<String,String>();
    public static ID profileId(String profileName)
    {
        if (profileIds.containsKey(profileName))
        {
            return profileIds.get(profileName);
        } else
        {
            ID profileID = [select id,Name from Profile where name = :profileName  limit 1].id;
            profileIds.put(profileName,profileID);
        }
        return profileIds.get(profileName);
    }
    
    // Get profile Name by Id
    static Map<String,String>profileNames = new Map<String,String>();
    public static String profileName(Id profileID)
    {
        if (profileNames.containsKey(profileID))
        {
            return profileNames.get(profileID);
        } else
        {
            String profileName = [select id,Name from Profile where Id = :profileId  limit 1].Name;
            profileNames.put(profileID,profileName);
        }
            return profileNames.get(profileID);
    }
    
    // Determines if the user is an integration user
    public static Boolean isIntegrationUser(Id profileId) {
        Boolean result = false;
        if (profileId == profileId(UTIL_OrgSettings.integration_Profile_Name())) result = true;
        if (profileId == profileId(UTIL_OrgSettings.integration_CRM_Webservices_Profile_Name())) result = true;
        
        return result;
    }
    // Determines if the user is an Sales Admin User
    public static Boolean isSalesAdminUser(Id profileId) {
        Boolean result = false;
        if (profileId == profileId(UTIL_OrgSettings.salesAdmin_Profile_Name())) result = true;
        return result;
    }
    /**** Record Types ****/
    // Get a Record Type Name from the Id on Account
    static Map<ID, Schema.RecordTypeInfo> accountRecordTypesByID = new Map<ID, Schema.RecordTypeInfo>();
    public static String getRecordTypeNameAccount(Id id) {
        
        if(accountRecordTypesByID.containsKey(id)) {
            return accountRecordTypesByID.get(id).getName();        
        } else {
            accountRecordTypesByID = Account.SObjectType.getDescribe().getRecordTypeInfosByID();
        }
        return accountRecordTypesByID.get(id).getName();
    }
    
    // RT for default person account
    static String personAccountRT; 
    public static String getPersonAccountRT()
    {
        if (UTIL_Apex.empty(personAccountRT)) 
        {
            personAccountRT = [Select Id from RecordType where DeveloperName='PersonAccount' and sObjectType = 'Account'].Id;
        }
        return personAccountRT;
    }
    
    
    // RT for WorkSite account
    static String accountWorkSiteRT;
    public static String getAccountWorkSiteRT()
    {
        if (UTIL_Apex.empty(accountWorkSiteRT)) 
        {
            accountWorkSiteRT = [Select Id from RecordType where DeveloperName='Work_Site' and sObjectType = 'Account' limit 1].Id; 
        }
        return accountWorkSiteRT;
    }
    
    // RT for Legal Entity account
    static String accountLegalEntityRT;
    public static String getAccountLegalEntityRT()
    {
        if (UTIL_Apex.empty(accountLegalEntityRT)) 
        {
            accountLegalEntityRT = [Select Id from RecordType where DeveloperName='Legal_Entity' and sObjectType = 'Account' limit 1].Id;
        }
        return accountLegalEntityRT;
    }
    
    // RT for Extension account
    static String accountExtensionRT;
    public static String getAccountExtensionRT()
    {
        if (UTIL_Apex.empty(accountExtensionRT)) 
        {
            accountExtensionRT = [Select Id from RecordType where DeveloperName='Extension' and sObjectType = 'Account' limit 1].Id;
        }
        return accountExtensionRT;
    }
    
    // RT for B2B_Webshop_Placeholder account
    static String accountB2BWebshopPlaceHolderRT;
    public static String getAccountB2BWebshopPlaceHolderRT()
    {
        if (UTIL_Apex.empty(accountB2BWebshopPlaceHolderRT)) 
        {
            accountB2BWebshopPlaceHolderRT = [Select Id from RecordType where DeveloperName='B2B_Webshop_Placeholder' and sObjectType = 'Account' limit 1].Id;
        }
        return accountB2BWebshopPlaceHolderRT;
    }
    
    // RT for B2C_Webshop_Placeholder account
    static String accountB2CWebshopPlaceHolder;
    public static String getAccountB2CWebshopPlaceHolderRT()
    {
        if (UTIL_Apex.empty(accountB2CWebshopPlaceHolder)) 
        {
            accountB2CWebshopPlaceHolder = [Select Id from RecordType where DeveloperName='B2C_Webshop_Placeholder' and sObjectType = 'Account' limit 1].Id;
        }
        return accountB2CWebshopPlaceHolder;
    }
    
    // RT for PostNord_Org_Structure account
    static String accountPostNordOrgStructureRT;
    public static String getAccountPostNordOrgStructureRT()
    {
        if (UTIL_Apex.empty(accountPostNordOrgStructureRT)) 
        {
            accountPostNordOrgStructureRT = [Select Id from RecordType where DeveloperName='PostNord_Org_Structure' and sObjectType = 'Account' limit 1].Id;
        }
        return accountPostNordOrgStructureRT;
    }
    
    // RT for Invoice Recipient account
    static String accountInvoiceRecipientRT;
    public static String getAccountInvoiceRecipientRT()
    {
        if (UTIL_Apex.empty(accountInvoiceRecipientRT)) 
        {
            accountInvoiceRecipientRT = [Select Id from RecordType where DeveloperName='Invoice_Recipient' and sObjectType = 'Account' limit 1].Id;
        }
        return accountInvoiceRecipientRT;
    }
    
    // RT for External Partner account
    static String accountExternalPartnerRT;
    public static String getAccountExternalPartnerRT()
    {
        if (UTIL_Apex.empty(accountExternalPartnerRT)) 
        {
            accountExternalPartnerRT = [Select Id from RecordType where DeveloperName='External_Partner' and sObjectType = 'Account' limit 1].Id;
        }
        return accountExternalPartnerRT;
    }
    
    // RT for Competitor account
    static String accountCompetitorRT;
    public static String getAccountCompetitorRT()
    {
        if (UTIL_Apex.empty(accountCompetitorRT)) 
        {
            accountCompetitorRT = [Select Id from RecordType where DeveloperName='Competitor' and sObjectType = 'Account' limit 1].Id;
        }
        return accountCompetitorRT;
    }
    
    // RT for PostNord_Employee contact
    static String contactPostNordEmployeeRT;
    public static String getContactPostNordEmployeeRT()
    {
        if (UTIL_Apex.empty(contactPostNordEmployeeRT)) 
        {
            contactPostNordEmployeeRT = [Select Id from RecordType where DeveloperName='PostNord_Employee' and sObjectType = 'Contact' limit 1].Id;
        }
        return contactPostNordEmployeeRT;
    }
    
    // RT for Contact_Person Contact
    static String contactPersonRT;
    public static String getContactPersonRT()
    {
        if (UTIL_Apex.empty(contactPersonRT)) 
        {
            contactPersonRT = [Select Id from RecordType where DeveloperName='Contact_Person' and sObjectType = 'Contact' limit 1].Id;
        }
        return contactPersonRT;
    }
    
    // RT for Breve_Potential on Potential
    static String brevePotentialRT;
    public static String getBrevePotentialRT()
    {
        if (UTIL_Apex.empty(brevePotentialRT)) 
        {
            brevePotentialRT = [Select Id from RecordType where DeveloperName='Breve_Potential' and sObjectType = 'Potential__c' limit 1].Id;
        }
        return brevePotentialRT;
    }
    
    // RT for Item_Search on Case
    static String caseItemSearchRT;
    public static String getCaseItemSearchRT()
    {
        if (UTIL_Apex.empty(caseItemSearchRT)) 
        {
            caseItemSearchRT = [Select Id from RecordType where DeveloperName='Item_Search' and sObjectType = 'Case' limit 1].Id;
        }
        return caseItemSearchRT;
    }
    
    // RT for Customer_Assignment on case
    static String caseCustomerAssignmentRT;
    public static String getCustomerAssignmentRT()
    {
        if (UTIL_Apex.empty(caseCustomerAssignmentRT)) 
        {
            caseCustomerAssignmentRT = [Select Id from RecordType where DeveloperName='Customer_Assignment' and sObjectType = 'Case' limit 1].Id;
        }
        return caseCustomerAssignmentRT;
    }
    
    // RT for Credit Check on case.
    static String caseCreditCheckRT;
    public static String getcaseCreditCheckRT()
    {
        if (UTIL_Apex.empty(caseCreditCheckRT)) 
        {
            caseCreditCheckRT = [Select Id from RecordType where DeveloperName='Credit_Check' and sObjectType = 'Case' limit 1].Id;
        }
        return caseCreditCheckRT;
    }
    // RT for Approval Admin Activity on case.
    static String caseApprovalAdminActivityRT;
    public static String getcaseApprovalAdminActivityRT()
    {
        if (UTIL_Apex.empty(caseApprovalAdminActivityRT)) 
        {
            String adminRecType=System.Label.Opportunity_Approval_RecordType;
            caseApprovalAdminActivityRT = [Select Id from RecordType where DeveloperName=:adminRecType and sObjectType = 'Case' limit 1].Id;
        }
        return caseApprovalAdminActivityRT;
    }
     // RT for DK Admin Activity on case.
    static String DKAdminCaseRT;
    public static String getDKAdminCaseRT()
    {
        if (UTIL_Apex.empty(DKAdminCaseRT)) 
        {
            String dkAdminRecType=System.Label.Case_DK_Admin_RecordType;
            DKAdminCaseRT = [Select Id from RecordType where DeveloperName=:dkAdminRecType and sObjectType = 'Case' limit 1].Id;
        }
        return DKAdminCaseRT;
    }
    // RT for Returpost on case.
    static String caseReturpostRT;
    public static String getcaseReturpostRT()
    {
        if (UTIL_Apex.empty(caseReturpostRT)) 
        {
            caseReturpostRT = [Select Id From RecordType r where r.DeveloperName='Returpost' AND r.SobjectType ='Case' Limit 1].Id;
        }
        return caseReturpostRT;
    }
        
    /**** Describe Info ****/
    // Get global describe (cached)
    public static Map<String, Schema.SObjectType> globalDescibe_Map
    {
        get
        {
            if (globalDescibe_Map==null)
            {
                globalDescibe_Map = Schema.getGlobalDescribe();
            }
            return globalDescibe_Map;
        }
        set;
    }
    
    // Get field map for object
    static map<String, Map<String, Schema.SObjectField>> objectField_Map = new map<String, Map<String, Schema.SObjectField>>(); // map: object API name >> <field API name, describe info>
    public static Map<String, Schema.SObjectField> getFieldMap(String typeName)
    {
        if (objectField_Map.containsKey(typeName))
        {
            return objectField_Map.get(typeName);
        } else if (globalDescibe_Map.containsKey(typeName))
        {
            Schema.SObjectType productSchema = globalDescibe_Map.get(typeName);
            Map<String, Schema.SObjectField> fieldMap = productSchema.getDescribe().fields.getMap();
            objectField_Map.put(typeName,fieldMap);
            return fieldMap;
        }
        return null;
    }
    
    // Get field describe
    static map<Schema.SObjectField, Schema.DescribeFieldResult> objectFieldDescribe_Map = new map<Schema.SObjectField, Schema.DescribeFieldResult>(); // map: SObjectField >> DescribeFieldResult - used to reduce repeated describe calls in loops
    public static Schema.DescribeFieldResult getFieldDescribe(Schema.SObjectField field)
    {
        if (objectFieldDescribe_Map.containsKey(field))
        {
            return objectFieldDescribe_Map.get(field);
        } else if (field!=null)
        {
            Schema.DescribeFieldResult describeResult = field.getDescribe();
            objectFieldDescribe_Map.put(field,describeResult);
            return describeResult;
        }
        return null;
    }
    
    // Get field describe by object type name and field name
    public static Schema.DescribeFieldResult getFieldDescribe(String typeName, String fieldName)
    {
        Map<String, Schema.SObjectField> fieldMap = getFieldMap(typeName);
        if (fieldMap.containsKey(fieldName)!=null) 
        {
            Schema.DescribeFieldResult fieldResult = getFieldDescribe(fieldMap.get(fieldName));
            if (fieldResult!=null) return fieldResult;
        }
        return null;
    }
    
    // Get field label for object and field. Uses context of executing user
    public static String getFieldLabel(String typeName, String fieldName)
    {
        Schema.DescribeFieldResult field = getFieldDescribe( typeName,  fieldName);
        if (field!=null) return field.getLabel();
        return '';
    }
    // Get picklist field values map(value,label).Uses context of executing user
    //Parmeters(object api name,picklist field api name,only active values)
    public static Map<String,String> getPicklistFieldValuesMap(String typeName, String fieldName,boolean onlyActive)
    {
        Schema.DescribeFieldResult field = getFieldDescribe( typeName,  fieldName);
        if (field !=null){              
             try{
                Map<String,String> picklistVauesAndLabels=new Map<String,String>();
                for(Schema.PicklistEntry entry:field.getPicklistValues()){
                  if(onlyActive){
                    if(entry.isActive()) picklistVauesAndLabels.put(entry.getValue(),entry.getLabel());
                  }
                  else{
                      picklistVauesAndLabels.put(entry.getValue(),entry.getLabel());
                  }       
                }      
                return picklistVauesAndLabels;
             }
             catch(Exception e){
                return null;
             }
        }
        return null;
    }
    public static Map<String, String> getRelationshipSalesAreaValuesWiseLabel(){
    	Map<String, String> mapFieldValueWiseFieldLabel = new Map<String, String>(); 
        for(Schema.PicklistEntry ple : Relationship__c.Sales_Area__c.getDescribe().getPicklistValues()){
            mapFieldValueWiseFieldLabel.put(ple.getValue(), ple.getLabel());
        }
        return mapFieldValueWiseFieldLabel;
    }
    // Get Record Type name by ID
    static map<String, String> recordTypeNames_Map = new map<String, String>();
    public static String getRTName(ID recordTypeId)
    {
        String name = '';
        if (recordTypeNames_Map.containsKey(recordTypeId))
        {
            name =  recordTypeNames_Map.get(recordTypeId);
        } else
        {
            try
            {
                RecordType r = [select id, toLabel(Name) from RecordType where id=:recordTypeId];
                name = r.Name;
                recordTypeNames_Map.put(recordTypeId,name);
            } catch (exception e){}
        }
        return name;
    }
    
    // get the sobject type by id
    static map<String, Schema.SObjectType> prefixType_Map = new map<String, Schema.SObjectType>(); // map: SObjectField >> DescribeFieldResult - used to reduce repeated describe calls in loops
    public static Schema.SObjectType getObjectType(String whatId) {
        
        if(whatId == null) return null;
        
        for(String keyPrefix : prefixType_Map.keySet())
        {
            if (keyPrefix != null && whatId.startsWith(keyPrefix)){
                return prefixType_Map.get(keyPrefix);
            }
        }
        for(Schema.SObjectType describe: globalDescibe_Map.values()) {
            String keyPrefix = describe.getDescribe().getKeyPrefix();
            prefixType_Map.put(keyPrefix, describe);
            if(keyPrefix != null && whatId.startsWith(keyPrefix)){
                return describe;
            }
        }
        return null;
    }
    
    /**** ORG Wide Info ****/
    static Organization org;
    public static Organization getOrgInfo() {
        if (org==null) org = [Select Id, DefaultAccountAccess, DefaultCaseAccess, DefaultOpportunityAccess from Organization limit 1];
        return org;
    }

    /**** Environment Info ****/
    //Return if the running environment is a sandbox
    public static Boolean isEnvironmentSandbox() {
        String s  =  System.URL.getSalesforceBaseUrl().getHost();
        return (Pattern.matches('(.*\\.)?cs[0-9]*(-api)?\\..*force.com',s));
    }
    
}