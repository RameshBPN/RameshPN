/**
        About
        -----
        Description: Product Whitespace
        Created for: Postnord Get2OneCRM additional feature work
        Create date: Sept 2014
        
        Details / Methods
        -----------------
        TYhe page has two modes, 1) the search criteria and product family selection and 2) the results grid. 
        The controller below is for running that query and creating a wrapper object for the results to be shown in the vf table.
                
        Update History
        --------------
        Created Sept 2014 - M.E.
        27/10/2014 - Change queries and code to ensure that Not started Opportunities and those Lost for being Duplicate or 
        created in error are white spaced
        
        Issues / TODOs
        --------------  
        As mutiple opportunites could be present in the results, the business may want to be able to visualise these to give them an idea of how many opps have been clsoed won/lost in the data.
        To do this, A hover effect can be used in jQuery. To make it responsive, opporuntites should be listed in html div's under the main table inside a hidden div with id's for each opp. compounded from the accountid + product family + stage
        jQuery can then take those and copy the html directly into a mouse over without any callbacks from the page to the server. 
        In progress is a catch all state. Needs a csv field
*/

public with sharing class G2O_ProductWhitespace_VFCx {

    public Account theAccount { get; set; }
    public Account parentAcct { get; set; }
    public Product_Filter_List__c[] productFilterList { get; set; }
    public AccountProducts[] whitespace { get; set; }
    public boolean showResults {get{showResults=showResults==null ? false : showResults; return showResults;}set;}
        
    public String oppStatus_InProgress {get{return 'InProgress';}}
    public String oppStatus_ClosedLost {get{return UTIL_OrgSettings.opportunityStage_ClosedLost();}}
    public String oppStatus_ClosedWon {get{return UTIL_OrgSettings.opportunityStage_ClosedWon();}}

    public boolean debug {get;set;}
    public boolean cannotContinue {get;set;}
    public boolean hasCounted = false;

    public class testException extends Exception {}

    public G2O_ProductWhitespace_VFCx(ApexPages.StandardController controller) {
        cannotContinue = false;
        theAccount = (Account)controller.getRecord();
        theAccount = [SELECT id, name, parentId, Involved_Party_ID__c, Corporate_Registration_Number__c, Whitespace_StartDate__c, Whitespace_EndDate__c, Product_Whitespace_Counter__c
                        FROM Account where id = :theAccount.Id];
        
        System.debug(Logginglevel.ERROR,'### theAccount '+theAccount);

        // This only is to be run on worksites, any other account type or one without a parent will be returned as an error
        if (theAccount.parentID==null)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.Account_Type_Whitespace_error));
            cannotContinue = true;
            if (Test.isRunningtest())
            {
                // If we are running a test, then throw an exception for debugging
                throw new testException('ParentID is null on the account. This can only run for worksites.');
            }
        } else {   

            // Climb tree to ultimate parent ( assuming a reasonable limit of 25, way beyond the PN standard hierachy of 3 LE/WS/EXT )
            parentAcct = [SELECT id, name, parentid FROM Account WHERE id = :theAccount.parentId];
            Integer loopLimiter =0;
            while(parentAcct.parentId !=null && loopLimiter<25)
            {
                loopLimiter++;
                parentAcct = [SELECT id, name, parentid FROM Account WHERE id = :parentAcct.parentId];
            }

            // Set up
            whitespace = new AccountProducts[]{};
            productFilterList = [SELECT Id, ProductFamily__c, Select__c FROM Product_Filter_List__c order by ProductFamily__c asc];
        }

        // Check page params to set debug and show the raw data map in the grid
        if (ApexPages.currentPage().getParameters().get('debug')=='true')
        {
            debug = true;
        } else {
            debug = false;
        }
    }

    // Show the grid
    public PageReference showWhitespace()
    {
        // Check products exist
        if(productFilterList.size() == 0 ) 
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,label.Empty_product_list_error));
            if (Test.isRunningtest())
            {
                // If we are running a test, then throw an exception for debugging
                throw new testException('Product Filter List is empty: productFilterList='+productFilterList);
            }
           return null;
        }
        // Do search
        try
        {
            generateWhitespace();
            showResults = true;

            // Keep count of the number of times whitespace is performed. Once per visit to the page.
            if (!hasCounted)
            {
                theAccount.Product_Whitespace_Counter__c = theAccount.Product_Whitespace_Counter__c == null ? 0 : theAccount.Product_Whitespace_Counter__c+1;
                update theAccount;
                hasCounted = true;
            }
        } catch (exception e) {
            showResults = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage()));
            if (Test.isRunningtest())
            {
                // If we are running a test, then throw an exception for debugging
                throw e;
            }
        }
        return null;
    }

    // Go back to filter
    public Pagereference goBack()
    {
        showResults = false;
        return null;
    }

    // Return to account
    public Pagereference cancel()
    {
        PageReference newpage = new Pagereference('/'+theAccount.Id);
        newpage.setRedirect(true);
        return newpage;
    }

    // Create the whitespace data
    void generateWhitespace() 
    {
        // All product families to filter
        String[] prodFamilies = new String[]{};
        for( Product_Filter_List__c pfl : productFilterList )
        {
            if (pfl.Select__c) prodFamilies.add( pfl.ProductFamily__c );
        }
            
        // Fetch all accounts with the same parentid as the WS selected, these will be searched accross
        Map<Id,Account> siblings = new Map<Id,Account>([select id, name, Involved_Party_ID__c from Account where parentid = :parentAcct.id limit 9999]);
            
        // All opportunities and related line items on those accounts for the product families we're interested in
        // Filters are start and end dates input by user and the Product Families selected

        OpportunityLineItem [] olis = [select Id, Opportunity.AccountId, Opportunity.Id, Opportunity.CloseDate, Opportunity.StageName, Opportunity.IsClosed, Product_Family__c, Opportunity.Reason_Lost__c
                                        FROM OpportunityLineItem 
                                        WHERE 
                                        ( Opportunity.AccountId in :siblings.keySet() 
                                            AND Product_Family__c in :prodFamilies 
                                            AND Opportunity.CloseDate >= :theAccount.Whitespace_StartDate__c 
                                            AND Opportunity.CloseDate <= :theAccount.Whitespace_EndDate__c 
                                            AND Opportunity.StageName != :Label.Opportunity_Stage_Not_Started 
                                        )
                                        ORDER BY Opportunity.CloseDate
                                        LIMIT 9999];
        System.debug(Logginglevel.INFO, '### buildWhitespace: theAccount.Whitespace_StartDate__c '+theAccount.Whitespace_StartDate__c +' theAccount.Whitespace_EndDate__c  '+theAccount.Whitespace_EndDate__c +' olis (opp line items): '+olis);
        
        // Build the table data
        whitespace = new AccountProducts[] {};
        
        for( Account a : siblings.values() ) {
            Map<String,Set<String>> productFamilyStages = new Map<String,Set<String>>();
            // Enter empty stage sets to avoid vf breaking
            for( Product_Filter_List__c pfl : productFilterList )
            {
                productFamilyStages.put(pfl.ProductFamily__c,new Set<String>());
            }
            System.debug(Logginglevel.INFO, '### buildWhitespace: productFamilyStages: '+productFamilyStages);

            // Now update with stage data
            for( OpportunityLineItem oli : olis )
            {
                // For each opportunity line item, take the family it belongs to and record the opportunity status (can be many)
                if (oli.opportunity.accountId == a.id) {
                    
                    Boolean ignoreLostReason = false;
                    if(oli.opportunity.Reason_Lost__c != null &&
                        (
                            (oli.opportunity.Reason_Lost__c).contains(Label.Oppty_Lost_Duplicate) ||
                            (oli.opportunity.Reason_Lost__c).contains(Label.Oppty_Lost_Created_Error)
                        )
                    )
                        ignoreLostReason = true;
                    
                    //This condition is added to ensure that Duplicated and Created in error Opportunities are white spaced
                    if(!(ignoreLostReason)){
                        System.debug(Logginglevel.INFO, '### buildWhitespace: add product family stage: add oli: '+oli);
                        System.debug(Logginglevel.INFO, '### buildWhitespace: oli / opp stage '+oli.Opportunity.StageName+ ' closed date info: '+oli.Opportunity.CloseDate);
                        Set<String> oppStages = new Set<String>();
                        oppStages = productFamilyStages.containsKey(oli.Product_Family__c) ? productFamilyStages.get(oli.Product_Family__c) : new Set<String>();
                        String stage = !oli.Opportunity.IsClosed ? 'InProgress' : oli.Opportunity.StageName; // InProgress represents a group of stages
                        oppStages.add(stage);
                        productFamilyStages.put(oli.Product_Family__c, oppStages);
                        System.debug(Logginglevel.INFO, '### buildWhitespace: add product family stage: productFamilyStages: '+productFamilyStages);
                    }
                }
            }
            whitespace.add(new AccountProducts(a, productFamilyStages));
        }
        System.debug(Logginglevel.INFO, '### buildWhitespace: whitespace: '+whitespace);
    }

    // Account wrapper
    public class AccountProducts {
        public Account acct        { get; set; } //
        public Contact getCon()
        {
            return new Contact(AccountId = this.acct.Id);
        }

        public Map<String,Set<String>> productStatusByFamily  { get; set; } // product family mapped to the corresponding opportunity status
        
        public AccountProducts( Account acct, Map<String,Set<String>> productStatusByFamily ) {
            this.acct = acct;
            this.productStatusByFamily = productStatusByFamily;
        }
    }
}