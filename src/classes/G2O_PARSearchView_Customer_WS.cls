/**
    About
    -----
    Description: Service for PNCM_PAR_Request:Customer
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Jan 2013
    
    Details / Methods
    -----------------
    Depends on G2O_CINT_SoapIntegration->
    
    Use:
    Set up an integration configuration in HTTP Integration Services (custom setting) called 'PARSearchView_Customer' and call the service 
    
    Code to use the service:
    // Create the connection
    G2O_PARSearchView_Customer_WS parCustomer = new G2O_PARSearchView_Customer_WS(searchAccount);
    
    // Send the callout
    parCustomer.send('some objectID'); ...- case etc. if you want to relate the result back automatically to the log (useful for related lists to show callouts)
    ...or just 
    parCustomer.send() ...if you don't want to relate the result to a record
    
    // Use the result
    parCustomer.result; // Now contains the resulting PAR information in a map of Account and child accounts
    
    // If the result is null or if you need to check, errors can be found here:
    parCustomer.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
    parCustomer.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created Jan 2013 - M.E.
    First Compile March 2013 - M.E.
    Updated April - C.H.F.
    
    Issues / TODOs
    --------------  
*/
public class G2O_PARSearchView_Customer_WS extends G2O_CINT_SoapIntegration {
    
    public Map<Account, List<Account>> result = new Map<Account, List<Account>>();
    
    /***** Constructor *****/
    // Search the PAR database from parameters on an account object
    public G2O_PARSearchView_Customer_WS(Account searchAccount)
    {
        super('G2O_PARSearchView_Customer_WS', 'PAR_Account');
        
        requestParameters.put('MaxRecords',maxRecords);
        
        if(!UTIL_Apex.empty(searchAccount.Corporate_Registration_Number__c))requestParameters.put('CorpRegistrationNumber',searchAccount.Corporate_Registration_Number__c);
        if(!UTIL_Apex.empty(searchAccount.VAT_Number__c))requestParameters.put('VatNumber',searchAccount.VAT_Number__c);
        if(!UTIL_Apex.empty(searchAccount.Name))requestParameters.put('AccountName',searchAccount.Name);
        if(!UTIL_Apex.empty(searchAccount.Work_Site_Name__c))requestParameters.put('WorksiteName',searchAccount.Work_Site_Name__c);
        if(!UTIL_Apex.empty(searchAccount.Postal_Address_Street__c))requestParameters.put('PostalStreet',searchAccount.Postal_Address_Street__c);
        if(!UTIL_Apex.empty(searchAccount.Postal_Address_Postal_Code__c))requestParameters.put('PostalAddressPostalCode',searchAccount.Postal_Address_Postal_Code__c);
        if(!UTIL_Apex.empty(searchAccount.Postal_Address_City__c))requestParameters.put('PostalAddressCity',searchAccount.Postal_Address_City__c);
        if(!UTIL_Apex.empty(searchAccount.Postal_Address_Country__c))requestParameters.put('PostalAddressCountry',searchAccount.Postal_Address_Country__c);
        if(!UTIL_Apex.empty(searchAccount.Work_Site_Registration_Number__c))requestParameters.put('WorkSiteRegistrationNumber',searchAccount.Work_Site_Registration_Number__c);
        if(!UTIL_Apex.empty(searchAccount.External_Provider_Party_ID__c))requestParameters.put('ExternalProviderPartyID',searchAccount.External_Provider_Party_ID__c);
        
    }
    
    /***** Parse Result *****/
    public override void handleResponse()
    {
        // Check the errors in callout.errors
        if (callout.errors.size()==0) {
            System.debug(Logginglevel.Error,'### Start handleResponse(): CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
            List<Dom.XMLNode> legalEntityNodes = new List<Dom.XMLNode>();
            List<Dom.XMLNode> workSiteNodes = new List<Dom.XMLNode>();
            
            // Parse the xml reponse and get hold of WorkSites and LegalEntities
            Dom.Document doc = new Dom.Document();
            doc.load(UTIL_Apex.empty(callout.response.getBody()) ? '' : callout.response.getBody());
            
            Dom.XMLNode root = doc.getRootElement();
            
            Dom.XMLNode Body = root.getChildElement('Body', 'http://schemas.xmlsoap.org/soap/envelope/');
            
            Dom.XMLNode ItemLocation = Body.getChildElement('ItemLocation', 'http://new.webservice.namespace');
            
            Dom.XMLNode UserArea = ItemLocation.getChildElement('UserArea', 'http://new.webservice.namespace');
            
            Dom.XMLNode Body2 = UserArea.getChildElement('Body', '');
            
            Dom.XMLNode ReadMdmCustomerResponse = Body2.getChildElement('ReadMdmCustomerResponse', 'urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002');
            
            Dom.XMLNode ListOfItems = ReadMdmCustomerResponse.getChildElement('ListOfItems', 'urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002');
            
            Dom.XMLNode[] children = ListOfItems.getChildElements();
            
            for (Dom.XMLNode node : children) {
                if(node.getName() == 'WorkSite' && workSiteNodes.size() <= Integer.valueOf(maxRecords)) {
                    workSiteNodes.add(node);
                }
                if(node.getName() == 'LegalEntity' && legalEntityNodes.size() <= Integer.valueOf(maxRecords)) {
                    legalEntityNodes.add(node);
                }
            }
            
            List<Account> legalEntities = new List<Account>();
            List<Account> workSites = new List<Account>();
			
			System.debug(Logginglevel.Error,'### Before parsing: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
			
            //Parse the Legel Entities - new
            for(Dom.XMLNode accountNode : legalEntityNodes) {
                Account account = new Account();
                account.RecordTypeId = UTIL_Meta.getAccountLegalEntityRT();
                
                parseCommonFields(accountNode,account);
                parseLegalEntityFields(accountNode,account);
                legalEntities.add(account);
            }
            
            //Parse the Work Sites - new
            for(Dom.XMLNode accountNode : workSiteNodes) {
                Account account = new Account();
                account.RecordTypeId = UTIL_Meta.getAccountWorkSiteRT();
                
                parseCommonFields(accountNode,account);
                parseWorkSiteFields(accountNode,account);
                workSites.add(account);
            }
            
            System.debug(Logginglevel.Error,'### After parsing: CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
            
            //Link LE and WS together
            for(Account LE : legalEntities) {
                
                List<Account> workSitesForLE = new List<Account>();
                for(Account WS : workSites) {
                    if(LE.External_Provider_Party_ID__c == WS.PNCM_Account_Relationship_ID__c) {
                        
                        // Filter out the WS without External_Provider_Party_ID__c set
                        if(WS.External_Provider_Party_ID__c != null) {
                            workSitesForLE.add(WS);
                            
                            // All accounts need RegistrationCountry, so if there are no RegistrationCountry on WS, copy from LE.
                            if(WS.Registration_Country__c == null) {
                            	WS.Registration_Country__c = LE.Registration_Country__c;
                            }
                            
                        } else {
                            callout.error = new ErrorContainer(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'No External_Provider_Party_ID__c in the response for the work site');
                        }
                    }
                }
                
                // Filter out the LE without External_Provider_Party_ID__c and Registration_Country__c set, also removes related worksites (by not putting the LE in the map)
                if(LE.External_Provider_Party_ID__c != null && LE.Registration_Country__c != null) {
                    result.put(LE, workSitesForLE);
                } else if(LE.External_Provider_Party_ID__c == null) {
                    callout.error = new ErrorContainer(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'No External_Provider_Party_ID__c in the response for the Legial Entity');
                } else if(LE.Registration_Country__c == null) {
                    callout.error = new ErrorContainer(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'No Registration_Country__c in the response for the Legial Entity');
                }
            }
            System.debug(Logginglevel.Error,'### End handleResponse(): CPU limits: '+Limits.getCPUTime()+' of '+Limits.getLimitCpuTime());
        }
    }
    void parseCommonFields(Dom.XMLNode accountNode, Account account) {
        
        Dom.XMLNode[] nodes = accountNode.getChildElements();
        
        for(Dom.XMLNode node : nodes) {
        	
        	if(node.getName() == 'PNCM_ID') {
                account.External_Provider_Party_ID__c = node.getText();
            }
            if(node.getName() == 'VatNumber') {
                account.VAT_Number__c = node.getText();
            }
            if(node.getName() == 'CorporateRegistrationNumber') {
                account.Corporate_Registration_Number__c = node.getText();
            }
            if(node.getName() == 'RegistrationCountry') {
                account.Registration_Country__c = node.getText();
            }
            if(node.getName() == 'LegalName') {
                account.Name = node.getText();
            }
            if(node.getName() == 'Communication') {
                for(Dom.XMLNode communicationNode : node.getChildElements()) {
                    if(communicationNode.getName() == 'PhoneNumber') {
                        account.Phone = communicationNode.getText();
                    }
                    if(communicationNode.getName() == 'EmailAddress') {
                        account.Email_Address__c = communicationNode.getText();
                    }
                    if(communicationNode.getName() == 'WebAddress') {
                        account.Website = communicationNode.getText();
                    }
                }
            }
        }
    }
    
    void parseLegalEntityFields(Dom.XMLNode accountNode, Account account) {
        
        Dom.XMLNode[] nodes = accountNode.getChildElements();

        for(Dom.XMLNode node : nodes) {
            
            if(node.getName() == 'FoundingDate') {
                account.Founding_Date__c = UTIL_Apex.convertISO8601(node.getText()).date();
            }
            if(node.getName() == 'NumberOfEmployees') {
                account.Number_of_Employees_at_Legal_Entity__c = node.getText();
            }
            if(node.getName() == 'NumberOfOfficeEmployees') {
                account.Number_of_Office_Employees_at_LE__c = node.getText();
            }
            if(node.getName() == 'Turnover') {
                account.Turnover__c = Integer.valueOf(node.getText());
                account.CurrencyIsoCode = node.getChildElement('currencyCode', null).getText();
            }
            if(node.getName() == 'ExternalLegalEntityStatus') {
                if(node.getChildElement('Code', null) != null) {
                    account.External_Legal_Entity_Status__c = node.getChildElement('Code', null).getText();
                }
            }
            if(node.getName() == 'PrimaryIndustryGroup8') {
                if(node.getChildElement('Code', null) != null) {
                    account.Legal_Entity_Primary_Ind_Group_8__c = node.getChildElement('Code', null).getText();
                }
            }
            if(node.getName() == 'PrimaryIndustryGroup77') {
                if(node.getChildElement('Code', null) != null) {
                    account.Legal_Entity_Primary_Ind_Group_77__c = node.getChildElement('Code', null).getText();
                }
            }
            if(node.getName() == 'PrimaryIndustryNational') {
                if(node.getChildElement('Code', null) != null) {
                    account.Legal_Entity_Primary_Industry__c = node.getChildElement('Code', null).getText();
                }
            }
            if(node.getName() == 'CorporateForm') {
            	if(node.getChildElement('Code', null) != null) {
                	account.Corporate_Form__c = node.getChildElement('Code', null).getText();
            	}
            }
            if(node.getName() == 'CustomerLegalEntityHierarchy') {
                if(node.getChildElement('GroupParentCorporateRegistrationNumber', null) != null) {
                    account.Group_Parent_Corporate_Registration_Nr__c = node.getChildElement('GroupParentCorporateRegistrationNumber', null).getText();
                }
                if(node.getChildElement('GroupParentLegalName', null) != null) {
                    account.Group_Parent_Legal_Name__c = node.getChildElement('GroupParentLegalName', null).getText();
                }
                if(node.getChildElement('GroupParentRegistrationCountry', null) != null) {
                    account.Group_Parent_Registration_Country__c = node.getChildElement('GroupParentRegistrationCountry', null).getText();
                }
                if(node.getChildElement('ParentCorporateRegistrationNumber', null) != null) {
                    account.Parent_Corporate_Registration_Number__c = node.getChildElement('ParentCorporateRegistrationNumber', null).getText();
                }
                if(node.getChildElement('ParentLegalName', null) != null) {
                    account.Parent_Legal_Name__c = node.getChildElement('ParentLegalName', null).getText();
                }
                if(node.getChildElement('ParentRegistrationCountry', null) != null) {
                    account.Parent_Registration_Country__c = node.getChildElement('ParentRegistrationCountry', null).getText();
                }
                if(node.getChildElement('LevelInHierarchy', null) != null) {
                    account.Level_in_Group__c = Decimal.valueOf(node.getChildElement('LevelInHierarchy', null).getText());
                }
            }
            
            if(node.getName() == 'Address') {
            	for(Dom.XMLNode addressNode : node.getChildElements()) {
                    if(addressNode.getName() == 'Country') {
                        account.Postal_Address_Country__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'CityName') {
                        account.Postal_Address_City__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'StreetName') {
                        account.Postal_Address_Street__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'StreetNumber') {
                        account.Postal_Address_House_Number__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'HouseLetter') {
                        account.Postal_Address_House_Letter__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'POBox') {
                        account.Postal_Address_PO_Box__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'PostalCode') {
                        account.Postal_Address_Postal_Code__c = addressNode.getText();
                    }
                    if(addressNode.getName() == 'COAddress') {
                        account.Postal_Address_C_O__c = addressNode.getText();
                    }
                }
            }
        }
    }
    
    void parseWorkSiteFields(Dom.XMLNode accountNode, Account account) {
        
        Dom.XMLNode[] nodes = accountNode.getChildElements();
        
        for(Dom.XMLNode node : nodes) {
            
            if(node.getName() == 'LE_PNCM_ID') {
                account.PNCM_Account_Relationship_ID__c = node.getText();
            }
            if(node.getName() == 'NumberOfEmployees') {
                account.Number_of_Employees_at_Work_Site__c = node.getText();
            }
            if(node.getName() == 'NumberOfOfficeEmployees') {
                account.Number_of_Office_Employees_at_WS__c = node.getText();
            }
            if(node.getName() == 'WorkSiteRegistrationNumber') {
                account.Work_Site_Registration_Number__c = node.getText();
            }
            if(node.getName() == 'WorkSiteName') {
                account.Work_Site_Name__c = node.getText();
            }
            if(node.getName() == 'CustomerAddress') {
            	Dom.XMLNode addressNode = node.getChildElement('Address', null);
            	if(addressNode != null && addressNode.getChildElement('AddressType', null) != null && addressNode.getChildElement('AddressType', null).getText() == 'Visiting address') {
            		if(addressNode.getChildElement('Country', null) != null) {
                        account.Visiting_Address_Country__c = addressNode.getChildElement('Country', null).getText();
                    }
                    if(addressNode.getChildElement('CityName', null) != null) {
                        account.Visiting_Address_City__c = addressNode.getChildElement('CityName', null).getText();
                    }
                    if(addressNode.getChildElement('StreetName', null) != null) {
                        account.Visiting_Address_Street__c = addressNode.getChildElement('StreetName', null).getText();
                    }
                    if(addressNode.getChildElement('StreetNumber', null) != null) {
                        account.Visiting_Address_House_Number__c = addressNode.getChildElement('StreetNumber', null).getText();
                    }
                    if(addressNode.getChildElement('HouseLetter', null) != null) {
                        account.Visiting_Address_House_Letter__c = addressNode.getChildElement('HouseLetter', null).getText();
                    }
                    if(addressNode.getChildElement('PostalCode', null) != null) {
                        account.Visiting_Address_Postal_Code__c = addressNode.getChildElement('PostalCode', null).getText();
                    }
            	}
            	if(addressNode != null && addressNode.getChildElement('AddressType', null) != null && addressNode.getChildElement('AddressType', null).getText() == 'Postal address') {
            		if(addressNode.getChildElement('Country', null) != null) {
                        account.Postal_Address_Country__c = addressNode.getChildElement('Country', null).getText();
                    }
                    if(addressNode.getChildElement('CityName', null) != null) {
                        account.Postal_Address_City__c = addressNode.getChildElement('CityName', null).getText();
                    }
                    if(addressNode.getChildElement('StreetName', null) != null) {
                        account.Postal_Address_Street__c = addressNode.getChildElement('StreetName', null).getText();
                    }
                    if(addressNode.getChildElement('StreetNumber', null) != null) {
                        account.Postal_Address_House_Number__c = addressNode.getChildElement('StreetNumber', null).getText();
                    }
                    if(addressNode.getChildElement('HouseLetter', null) != null) {
                        account.Postal_Address_House_Letter__c = addressNode.getChildElement('HouseLetter', null).getText();
                    }
                    if(addressNode.getChildElement('PostalCode', null) != null) {
                        account.Postal_Address_Postal_Code__c = addressNode.getChildElement('PostalCode', null).getText();
                    }
                    if(addressNode.getChildElement('POBox', null) != null) {
                        account.Postal_Address_PO_Box__c = addressNode.getChildElement('POBox', null).getText();
                    }
                    if(addressNode.getChildElement('COAddress', null) != null) {
                        account.Postal_Address_C_O__c = addressNode.getChildElement('COAddress', null).getText();
                    }
            	}
            }
            if(node.getName() == 'ExternalWorkSiteStatus') {
                if(node.getChildElement('Code', null) != null) {
                    account.External_Work_Site_Status__c = node.getChildElement('Code', null).getText();
                }
            }
            if(node.getName() == 'ExternalWorkSiteType') {
                account.Work_Site_Type__c = node.getChildElement('Code', null).getText();
            }
        }
        
        if(account.PNCM_Account_Relationship_ID__c == null) {
            throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'LE_PNCM_ID','No ID to link WS and LE was found in the respons');
        }
    }
}