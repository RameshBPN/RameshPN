/**
    About
    -----
    Description: Service class for Lead triggers
    Created for: Post nord Get2OneCRM Master template/DK
    Create date: April 2013
    
    Details / Methods
    -----------------
    Detail Steps:
    -------------

    Methods:
    -------
        1. updateLeadReceiver       : Sets the lead owner field based on the account team members on the related account
        
    Update History
    --------------
    Created April 2013 - C.H.F.
    
    Issues / TODOs
    --------------  
    
*/
public with sharing class G2O_Lead_SVC {

    public static void updateLeadReceiver (List<Lead> leadsToUpdate) {
        System.debug(logginglevel.Info, '### START Lead_SVC.updateLeadReceiver ('+leadsToUpdate+',)');
        
        List<Id> accountIds = new List<Id>();
        Map<Id, List<AccountTeamMember>> acctTeamMemberMap = new Map<Id, List<AccountTeamMember>>();
        
        // Loads the Custom Settings used
        String accountTeamRole = UTIL_OrgSettings.Lead_Receiver_Account_Team_Role();
        String leadStatus = UTIL_OrgSettings.Lead_Allocated_to_Sales();
        
        // Loops through the leads and add the Account Id to a list
        for(Lead lead : leadsToUpdate) {
                accountIds.add(lead.Account__c);
        }
        
        // Loads the AccountTeamMembers into a map with the AccountId as key
        for(AccountTeamMember accountTeamMember : [SELECT AccountId, UserId, TeamMemberRole FROM AccountTeamMember WHERE AccountId IN :accountIds ORDER BY AccountId LIMIT 9999]) {
            if(acctTeamMemberMap.containsKey(accountTeamMember.AccountId)) {
                acctTeamMemberMap.get(accountTeamMember.AccountId).add(accountTeamMember);
            } else {
                acctTeamMemberMap.put(accountTeamMember.AccountId, new List <AccountTeamMember> { accountTeamMember });
            }   
                
        }                                                
                                                                                                     
        // Loops through the leads and the related  AccountTeamMember to fint a match, and assigns the lead to a AccountTeamMember                               
        for(Lead lead : leadsToUpdate) {
            if(acctTeamMemberMap.get(lead.Account__c) != null){
                for(AccountTeamMember accountTeamMember : acctTeamMemberMap.get(lead.Account__c)) {
                    if(accountTeamMember.TeamMemberRole.contains(accountTeamRole)
                        && accountTeamMember.TeamMemberRole.contains(UTIL_OrgSettings.getSalesAreaTextValue(lead.Sales_Area__c))
                        && UTIL_OrgSettings.getSalesAreaTextValue(lead.Sales_Area__c) != '') {
                            
                            lead.OwnerId = accountTeamMember.UserId;
                            lead.Lead_Qualifier_Status__c = lead.Status;
                            lead.Status = leadStatus;
                            lead.Failed_Allocate_Assign__c = false;
                            break; // It takes the first match
                    } else {
                        lead.Failed_Allocate_Assign__c = true;
                        lead.Lead_Qualifier_Status__c = lead.Status;
                    }
                }
            }
            else{
                lead.Failed_Allocate_Assign__c = true;
                lead.Lead_Qualifier_Status__c = lead.Status;
            }
        }
        System.debug(logginglevel.Info, '### END Lead_SVC.updateLeadReceiver');
    }
}