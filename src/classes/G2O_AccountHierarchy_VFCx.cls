/**
  About
  -----
  Description: Account Hierarchy showing LE, WS and extentions
  Created for: Postnord Get2OneCRM Master template/DK
  Create date: March 2013
  
  Details / Methods
  -----------------
  Detail Steps:
  -------------
  1. The VF component will start at the current account record (account X), and work its way up to the top of the tree in SFDC. 
     It will do this using the “Parent Account” standard field. Work Sites will be added to the Current Account only.
  2. When it reaches an account that has no parent (Account Y), it will check if there is a reference to a Group Parent. 
     If there is, this will be created as an imaginary node in the tree, with information taken from the orbis mother fields on AccountY. 
  3. If the mother is more than 1 level up from Account Y, an imaginary parent node will be created, based on the Orbis Parent information on Account Y. 
     If the mother is more than 2 levels up, there will also be a gap node created showing the number of levels that are skipped in the tree representation. This calculation will be done like: AccountY.level – 3 

  Methods:
  -------
  1. createNodeBreadCrumb: Create the node trail from current account up to the top mother
  2. getAllAccounts: Get all Accounts that are related to a specific Orbis Mother ID
  3. getAccount: Get Reference to an account
  4. getAccountByOID: Find Account(s) from Orbis ID
  5. getImaginaryNode: Returns a "imaginary" node. This is not connected to any existing SFDC Account
  6. getGapNode: Returns a "Gap" node. This is not connected to any existing SFDC Account and has a separate icon from the imaginary node
  7. childAccounts: Returns the child accounts of a certain Record Type (note: if any Head offices are present, they are placed first in the list)
  8. childNodes: get child nodes
  9. getChildAccountNode: get any children associated with the child account
  10.getChildNode: get values of the children needed to be added
  11.getAccountNode: Returns a node with Account, and the number of child Extension accounts to each WS
  12.getAcronym: Parameter to decide if the acronym should be forced caps
    
  Update History
  --------------
  Created March 2013 - R.T.
  Updated May 2013   - R.M.
  
  Issues / TODOs
  --------------  
*/
public class G2O_AccountHierarchy_VFCx {    
    
    //Declare Variables
    private final Account acct;    
    
    public String masterAccountId {get; set;}            //Top Parent Account ID
    public Account masterAccount {get; set;}             //Top Parent Account     
    public List<Account> allTopRelatedAccts;             //Get all of the accounts related to the Orbis top mother in-memory. To reduce SOQL queries.    
    public G2O_AccountHierarchyNode node {get; set;}                         //Top Level G2O_AccountHierarchyNode
                  
    public String nodeJSON {get; set;}                   //JSON String that stores all the Nodes 
    public Integer index {get; set;}                     //Index for NavigateNodes loop
    
    public G2O_AccountHierarchyNode cNode {get; set;}   
    public G2O_AccountHierarchyNode pNode {get; set;}
    Map<Id, Account> mapTopRelatedAccounts = new Map<Id, Account>();
    
    public G2O_AccountHierarchy_VFCx(ApexPages.StandardController controller) {        
        
        acct = (Account) controller.getRecord();         //Get the record ID from the current page        

        createNodeBreadCrumb();                          //Find the trail up to the top Mother node       
        System.debug(Logginglevel.INFO,'cNode');
        nodeJSON = '['+JSON.serialize(cNode)+']';        //Serialize the node list and assign to String for the Ext JavaScript Library 
       
    }
    
    // Create the node trail from current account up to the top mother
    public void createNodeBreadCrumb(){

        Account currentAcct = getAccount(acct.id);             //Set a reference to the current SFDC record
        Account motherAcct;                                    //Declare a mother reference
        List<Account> childAccts;                              //Child accounts reference        
        Integer gapLevels = 0;                                 //Initialize the gap levels to 0.
        
        System.debug(Logginglevel.INFO,'@@ currentAcct @@ ' +currentAcct);
        //Get all of the accounts related to the Orbis top mother in-memory. To reduce SOQL queries later on.
        if(currentAcct.Group_Parent_Corporate_Registration_Nr__c != null && currentAcct.Group_Parent_Corporate_Registration_Nr__c != '' && currentAcct.Group_Parent_Registration_Country__c != null && currentAcct.Group_Parent_Registration_Country__c != '') {
            allTopRelatedAccts = getAllAccounts(currentAcct.Group_Parent_Corporate_Registration_Nr__c, currentAcct.Group_Parent_Registration_Country__c);
            System.debug(Logginglevel.INFO,'@@ allTopRelatedAccts @@' +allTopRelatedAccts);
            if(allTopRelatedAccts != null && !allTopRelatedAccts.isEmpty()){
                for(Account acc: allTopRelatedAccts){
                    mapTopRelatedAccounts.put(acc.Id, acc);
                }
            }
        }
        
        
        cNode = getAccountNode(currentAcct.id);                //Get Account node info for the current node    
        // prob heree....
        childAccts = childAccounts(currentAcct.id, System.Label.RecordType_Account_WS);    //Get the children accounts of type WS
        System.debug(Logginglevel.INFO,'@@ childAccts @@' +childAccts);
        if(childAccts != null && !childAccts.isEmpty()) {
            childNodes(childAccts, cNode);        
        }                                             //Add those accounts as child nodes
        System.debug(Logginglevel.INFO,'@@ currentAcct @@' +currentAcct);
        while(currentAcct.Parent != null) {
            pNode = getAccountNode(currentAcct.Parent.id);     //Add account info to parent node
            
            //Currently removed on business' request
            //childAccts = childAccounts(currentAcct.Parent.id, System.Label.RecordType_Account_WS);  //Get the children of type WS, for the parent account
            //childNodes(childAccts, pNode);                                                          //Add those accounts as child nodes to the parent
           
            pNode.addChildNode(cNode);                         //Connect the current account node lastly to the parent                   
                        
            cNode = pNode;                                     //Move up in the tree, set the reference to the parent
            currentAcct = getAccount(currentAcct.Parent.id);   //Move reference up in the SFDC record tree as well                      
        }
        
        //Check if we have reached the mother node, i.e. Orbis Mother reference is null
        if (currentAcct.Group_Parent_Corporate_Registration_Nr__c == null || currentAcct.Group_Parent_Corporate_Registration_Nr__c == '') {
            //Yes: print the tree
        } else {
            //No: Is the orbis 'parent' and 'mother' different IDs?
            System.debug(Logginglevel.INFO,'@@ currentAcct.Group_Parent_Corporate_Registration_Nr__c @@' +currentAcct.Group_Parent_Corporate_Registration_Nr__c);
            motherAcct = getAccountByOID(currentAcct.Id, currentAcct.Group_Parent_Corporate_Registration_Nr__c);        //Get the account with Mother Orbis ID
            System.debug(Logginglevel.INFO,'@@ motherAcct @@ ' +motherAcct);           
            
            if(currentAcct.Level_in_Group__c !=null) {                               //Calculate number of levels left out in the gap
                gapLevels = (Integer) currentAcct.Level_in_Group__c - 2;    
            }
            
            //If the current account is NOT directly below the mother
            if(currentAcct.Group_Parent_Corporate_Registration_Nr__c != currentAcct.Parent_Corporate_Registration_Number__c) {
                //Create imaginary Parent
                //TODO: handle case where there's no orbis parent info (note that gap node will have one more level)
                pNode = getImaginaryNode(currentAcct.Parent_Legal_Name__c, currentAcct.Parent_Registration_Country__c);
                pNode.addChildNode(cNode);
                cNode = pNode;
                
                //Create gap node if necessary 
                if(gapLevels > 1) {
                    pNode = getGapNode(gapLevels-1);        //Since an imaginary parent has been added, there will be one less level in the gap
                    pNode.addChildNode(cNode);
                    cNode = pNode;
                }
            } else {
                //If the account IS directly below the mother, just proceed with creating the mother
            }
            
            //Does the Group Parent exist in SFDC?
            if(motherAcct != null) {
                //Yes: Create mother node from existing record. Print tree             
                pNode = getAccountNode(motherAcct.id);
                pNode.addChildNode(cNode);
                cNode = pNode;
            } else {    
                //NO: Create imaginary mother node above gap. Print tree
                pNode = getImaginaryNode(currentAcct.Group_Parent_Legal_Name__c, currentAcct.Group_Parent_Registration_Country__c);
                pNode.addChildNode(cNode);
                cNode = pNode;
            }    
        }   
    }
    
    // Get all Accounts that are related to a specific Orbis Mother ID
    public List<Account> getAllAccounts(String orbisMotherID, String orbisMotherCountry) {
        return [select id, Name, Parent.Name, Parent.Id, RecordType.Name, Level_in_Group__c, Corporate_Registration_Number__c, 
                       Group_Parent_Legal_Name__c, Group_Parent_Registration_Country__c, Group_Parent_Corporate_Registration_Nr__c,
                       Parent_Corporate_Registration_Number__c, Parent_Legal_Name__c, Parent_Registration_Country__c,
                       Registration_Country__c, Org_ID__c, Work_Site_Name__c, Work_Site_Type__c, Visiting_Address_Street__c,
                       Visiting_Address_Postal_Code__c, Visiting_Address_City__c, Ownership from Account 
                       where (Group_Parent_Corporate_Registration_Nr__c =:orbisMotherID OR Corporate_Registration_Number__c =:orbisMotherID)
                       AND Group_Parent_Registration_Country__c =:orbisMotherCountry LIMIT 50000];
    }
    
    // Get reference to an Account
    public Account getAccount(String accountId) {                
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {
            if(mapTopRelatedAccounts.get(accountId) != null) {
                if(mapTopRelatedAccounts.get(accountId).Id == accountId) {
                    return mapTopRelatedAccounts.get(accountId);
                }
            }
        }
        return [select id, Name, Parent.Name, Parent.Id, Level_in_Group__c, Corporate_Registration_Number__c, 
                       Group_Parent_Legal_Name__c, Group_Parent_Registration_Country__c, Group_Parent_Corporate_Registration_Nr__c,
                       Parent_Corporate_Registration_Number__c, Parent_Legal_Name__c, Parent_Registration_Country__c from Account where id =:accountId LIMIT 1];
    }
    
    // Find Account(s) from Orbis ID
    public Account getAccountByOID(String accountId, String orbisId) {
        System.debug(Logginglevel.INFO,'@@ mapTopRelatedAccounts @@' +mapTopRelatedAccounts);
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {                         // checking the top related map is empty
            if(mapTopRelatedAccounts.get(accountId) != null) {                                          // check if the account id exists
                System.debug(Logginglevel.INFO,'@@ mapTopRelatedAccounts.get(accountId).Corporate_Registration_Number__c @@' +mapTopRelatedAccounts.get(accountId).Corporate_Registration_Number__c);
                System.debug(Logginglevel.INFO,'@@ orbisId@@' +orbisId);
                if(mapTopRelatedAccounts.get(accountId).Corporate_Registration_Number__c == orbisId) {  // if top related account's Corporate Regisration number matches the orbis id 
                    return mapTopRelatedAccounts.get(accountId);                                        // return related account
                }
            }
        }
        
        Account[] accountList = [select id, Name, Parent.Name, Parent.Id, Group_Parent_Corporate_Registration_Nr__c, Corporate_Registration_Number__c, Group_Parent_Legal_Name__c, Group_Parent_Registration_Country__c from Account where Corporate_Registration_Number__c =:orbisId LIMIT 50000];
        System.debug(Logginglevel.INFO,'@@ accountList @@' +accountList);
        if (accountList.size() > 1) {
            System.Debug(Logginglevel.ERROR, 'Multiple Accounts with same Orbis ID found. No Account will be used in the legal hierarchy VF rendering.');
            return null;
        } else if(accountList.size() < 1) {
            //no results to return
            return null;
        } else {
            system.debug(Logginglevel.INFO,'@@returning Acc by OID w select');
            return accountList[0];
        }
    }

    // Returns a "imaginary" node. This is not connected to any existing SFDC Account.
    public G2O_AccountHierarchyNode getImaginaryNode(String name, String country) {             
        G2O_AccountHierarchyNode imaginaryNode = new G2O_AccountHierarchyNode(); //Create an imaginaryNode and add an icon, name, url, leaf and isRoot.

        imaginaryNode.text = '<nonclickable>'+name+', '+country+'</nonclickable>'; //Format the non-clickable node acording to style
           
        imaginaryNode.url = null;
        imaginaryNode.leaf = false;
        imaginaryNode.isRoot = true;
        imaginaryNode.icon = '/img/func_icons/util/lock12.gif';
                                       
        return imaginaryNode; 
    }
    
    // Returns a "Gap" node. This is not connected to any existing SFDC Account and has a separate icon from the imaginary node.
    public G2O_AccountHierarchyNode getGapNode(Integer gapLevels) {
        G2O_AccountHierarchyNode gapNode = new G2O_AccountHierarchyNode();                                                     //Create a gapNode and add an icon, name, url, leaf and isRoot.      
        String gapLevelsStr = (gapLevels == 0) ? '?' : string.valueof(gapLevels);      //Set level to '?' if the gap parameter provided is 0. (It can never be 0.)
        
        gapNode.text = '<nonclickable><abstract>....['+gapLevelsStr+' levels]</abstract></nonclickable>'; //Format the non-clickable node acording to style
           
        gapNode.url = null;
        gapNode.leaf = false;
        gapNode.isRoot = true;
        gapNode.icon = '/img/func_icons/util/lock12.gif'; 
                                       
        return gapNode; 
    }   
    
    // get all the child accounts related to its parent
    /*public List<Account> childAccounts(String parentId) {
        List<Account> childAccountsList; 

        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {             // checking the top related map is empty
            if(mapTopRelatedAccounts.get(parentId) != null) {                               // if the map contains the parent id, it is a child
                if(mapTopRelatedAccounts.get(parentId).ParentId == parentId) {
                    childAccountsList.add(mapTopRelatedAccounts.get(parentId));             // add the child to the list
                }
            }
            if(childAccountsList != null && childAccountsList.size()>0) return childAccountsList;
        }
        return [select id, Name from Account where ParentId =:parentId];
    }*/

    // overloaded method 
    //Returns the child accounts of a certain Record Type
    public List<Account> childAccounts(String parentId, String recordType) {
        List<Account> childAccountsList = new List<Account>(); 

        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {         // checking the top related map is empty
            if(mapTopRelatedAccounts.get(parentId) != null) {                           // if the map contains the parent id, it is a child
                if(mapTopRelatedAccounts.get(parentId).ParentId == parentId && mapTopRelatedAccounts.get(parentId).RecordType.Name == recordType) {
                    childAccountsList.add(mapTopRelatedAccounts.get(parentId));         // add the child to the list
                }
            }
            if(childAccountsList != null && childAccountsList.size()>0) return childAccountsList;
        }
        return [select id, Name, RecordType.Name, ParentId from Account where ParentId =:parentId AND RecordType.Name =: recordType];
        //Note: This will generate a SOQL query for each node that has NO children accounts, since above 'if' will be false. 
        //Note that this will only kick in if NONE of the child accounts are in-memory (i.e. has incomplete orbis group parent references). 
       
    }
    
    // get child nodes 
    public List<G2O_AccountHierarchyNode> childNodes(List<Account>  childAccounts, G2O_AccountHierarchyNode parentNode) {        
        List<G2O_AccountHierarchyNode> nodes = new List<G2O_AccountHierarchyNode>();
        Map<Id, Account> mapChildAccount = new Map<Id, Account>();

        for(Account a: childAccounts) {                                             // put all child accounts in a map
            mapChildAccount.put(a.Id, a);
        }
        System.debug(Logginglevel.INFO,'@@ mapChildAccount @@' +mapChildAccount);
        if(mapChildAccount != null && !mapChildAccount.isEmpty()) {
            List<G2O_AccountHierarchyNode> lstChildNode = getChildAccountNode(mapChildAccount);         // get all the account nodes of the child and assign it to G2O_AccountHierarchyNode list
            if(lstChildNode != null && !lstChildNode.isEmpty()) {                   // iterate over the G2O_AccountHierarchyNode list
                map <String, G2O_AccountHierarchyNode> sortedList = new map<String, G2O_AccountHierarchyNode>();
                
                for(G2O_AccountHierarchyNode n: lstChildNode) {
                    parentNode.addChildNode(n);                                     // add the child to the parent node
                    nodes.add(n);                                                   // put the whole node in the list
                }
            }
        }
        return nodes;                                                               // return the whole children list
    }
    
    // get any children associated with the child account
    public List<G2O_AccountHierarchyNode> getChildAccountNode(Map<Id, Account> mapChildNode){
        List<G2O_AccountHierarchyNode> lstNewNode = new List<G2O_AccountHierarchyNode>();
        Account a;
        set<Account> extSet = new set<Account>();
        
        //fetch record type to steer icon usage
        System.debug(Logginglevel.INFO,'@@ mapTopRelatedAccounts @@' +mapTopRelatedAccounts);
        System.debug(Logginglevel.INFO,'@@ mapChildNode @@' +mapChildNode);
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty() && mapChildNode != null && !mapChildNode.isEmpty()) {  // checking the top related map is empty
            if(mapChildNode.get(acct.Id) != null && mapChildNode.get(acct.Id).Id != null) {                                         // check child map contains account id
                if(mapTopRelatedAccounts.get(mapChildNode.get(acct.Id).Id) != null) {   
                    System.debug(Logginglevel.INFO,'@@ mapTopRelatedAccounts.get(mapChildNode.get(acct.Id).Id).Id @@' +mapTopRelatedAccounts.get(mapChildNode.get(acct.Id).Id).Id);
                    System.debug(Logginglevel.INFO,'@@ mapChildNode.get(acct.Id).Id @@' +mapChildNode.get(acct.Id).Id);                                         
                    if(mapTopRelatedAccounts.get(mapChildNode.get(acct.Id).Id).Id == mapChildNode.get(acct.Id).Id) {
                        a = mapTopRelatedAccounts.get(mapChildNode.get(acct.Id).Id);                                                // assigns the related account.
                    }
                }
            }
        }
        if(a != null) {
     		System.debug(Logginglevel.INFO,'@@ a wasnt null @@');
            G2O_AccountHierarchyNode accountNode = getChildNode(a, mapChildNode, extSet);               // gets the child node
            lstNewNode.add(accountNode);                                            // add to the list
        } else {
     		System.debug(Logginglevel.INFO,'@@ a was null @@');
            List<Account> lstAcc = [Select a.RecordType.Name, a.Name, a.Id, a.Type, a.RecordTypeId, a.Corporate_Registration_Number__c, a.ParentId, 
                            a.Registration_Country__c, a.Org_ID__c, a.Work_Site_Name__c, a.Work_Site_Type__c, a.Visiting_Address_Street__c,
                            a.Visiting_Address_Postal_Code__c, a.Visiting_Address_City__c, a.Ownership From Account a where id IN: mapChildNode.keySet()]; // query to get child records associated to its parent
            
            // Break apart and then order the list so that worksites of type HQ come first
            Set<Account> accountSet = new Set<Account>();
            accountSet.addAll(lstAcc);
            
            List<Account> orderedList = new Account[]{};
            List<Account> headQuaters = new Account[]{};
            List<Account> otherWorksites = new Account[]{};
            
            for (Account acc: accountSet)                                           // separate out the HQ's
            {
                if (acc.Work_Site_Type__c!=null && acc.Work_Site_Type__c.equalsIgnoreCase( UTIL_OrgSettings.WorkSiteTypeHQ() ))
                {
                    headQuaters.add(acc);
                    accountSet.remove(acc);
                }
            }
            otherWorksites.addAll(accountSet);                                      // compile the remaining list
            
            UTIL_Apex.orderList(headQuaters, 'Name', 'asc');                        // order by name
            UTIL_Apex.orderList(otherWorkSites, 'Name', 'asc');
            
            orderedList.addAll(headQuaters);                                        // compile the ordered list
            orderedList.addAll(otherWorksites);
            
            for(Account acc: orderedList) {
                G2O_AccountHierarchyNode accountNode = getChildNode(acc, mapChildNode, extSet);         // gets the child node
                lstNewNode.add(accountNode);                                        // add to the list
            }
        }
        return lstNewNode;                                                          // return node lists
    }
    
    // get values of the children needed to be added
    public G2O_AccountHierarchyNode getChildNode(Account a, Map<Id, Account> mapChildNode, set<Account> extSet) {
        extSet = new set<Account>();
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {
            if(mapTopRelatedAccounts.get(a.Id) != null) {
                for(Id accId : mapTopRelatedAccounts.keySet()){
	                if(mapTopRelatedAccounts.get(accId).ParentId == a.Id) {
	                     extSet.add(mapTopRelatedAccounts.get(accId));
	                }            		
            	}
            }
        }
        String rtAcronym = getAcronym(a.RecordType.Name, true);                     // get the acronym for the node
        
        G2O_AccountHierarchyNode accountNode = new G2O_AccountHierarchyNode(); //Create an accountNode and add an icon, name, url, leaf and isRoot.
        
        //Highlights the Account of the current page to allow user to see the position of the Account in the Company Hierarchy.Pt1
        if(mapChildNode.get(a.Id).Id == acct.id) {
            accountNode.text = '<strong>';
        } else {
            accountNode.text = '';
        }
            
        //Print different text depending on the Record Type. Use different styling on the Current Account.
        if (a.RecordType.Name == System.Label.RecordType_Account_LE) {
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Corporate_Registration_Number__c != null) {
                accountNode.text += ', '+a.Corporate_Registration_Number__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            if(a.Ownership != null) {
                +accountNode.text += ', '+a.Ownership;
            }
        } else if(a.RecordType.Name == System.Label.RecordType_Account_WS) {
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Work_Site_Name__c != null) {
                accountNode.text += ', '+a.Work_Site_Name__c;
            }
            if(a.Work_Site_Type__c != null && a.Work_Site_Type__c != '') {
            	// Worksite types are codes, we cannot map labels dynamically
            	// As the custom setting workSiteTypeHQ gives us a code we can check, we can hard code a mapping to a label here, but not for other worksite types
            	if (a.Work_Site_Type__c == UTIL_OrgSettings.workSiteTypeHQ())
            	{
            		accountNode.text += ', '+Label.Work_Site_Type_TY10;
            	}
            }
            if(a.Visiting_Address_Street__c != null) {
                accountNode.text += ', '+a.Visiting_Address_Street__c;
            }
            if(a.Visiting_Address_Postal_Code__c != null) {
                accountNode.text += ', '+a.Visiting_Address_Postal_Code__c;
            }
            if(a.Visiting_Address_City__c != null) {
                accountNode.text += ', '+a.Visiting_Address_City__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            accountNode.text += '- [<abstract>'+extSet.Size()+' Extensions</abstract>]';
        } else {
            //If there is no Record Type for the account, display a generic sequence of fields.
            //accountNode.text += '('+rtAcronym+') - '+a.Name+', '+a.Corporate_Registration_Number__c+', '+a.Registration_Country__c+', '+a.Ownership;
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Corporate_Registration_Number__c != null) {
                accountNode.text += ', '+a.Corporate_Registration_Number__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            if(a.Ownership != null) {
                +accountNode.text += ', '+a.Ownership;
            }
        }
    
        //Highlight current, pt2
        if (mapChildNode.get(a.Id).Id == acct.id) accountNode.text += '</strong>';
           
        accountNode.url = '/' + a.Id;
        accountNode.leaf = false;
        accountNode.isRoot = true;                
        //RT: Setting the icon depending on the record type
        if(a.RecordType.Name == System.Label.RecordType_Account_LE) {
            accountNode.icon = '/img/icon/documents16.png';  
        } else if(a.RecordType.Name == System.Label.RecordType_Account_WS) {
            accountNode.icon = '/img/icon/home16.png';  
        } else if(a.RecordType.Name == System.Label.RecordType_Account_Ext) {
            accountNode.icon = '/img/icon/custom51_100/buildingBlock16.png';  
        } else {
            accountNode.icon = '/s.gif" style="background:url(/img/sprites/master.png); background-position: 0px -2px; width: 16px; height: 16px;"'; //Uses the SFDC master sprites and displays the required icon by setting it's background position
        }
        return accountNode;
    }
    //Returns a node with Account, and the number of child Extension accounts to each WS.
    public G2O_AccountHierarchyNode getAccountNode(String accountId) {
        Account a;
        set<Account> extSet = new set<Account>();
        
        //fetch record type to steer icon usage
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {
            if(mapTopRelatedAccounts.get(accountId) != null) {
                if(mapTopRelatedAccounts.get(accountId).Id == accountId) {
                     a = mapTopRelatedAccounts.get(accountId);
                }
            }
        }
        System.debug(Logginglevel.INFO,'@@  a @@' + a);
        //If account for node not available in-memory, fetch from DB
        if(a == null) a = [Select a.RecordType.Name, a.Name, a.Id, a.Type, a.RecordTypeId, a.Corporate_Registration_Number__c,
                            a.Registration_Country__c, a.Org_ID__c, a.Work_Site_Name__c, a.Work_Site_Type__c, a.Visiting_Address_Street__c,
                            a.Visiting_Address_Postal_Code__c, a.Visiting_Address_City__c, a.Ownership From Account a where id =: accountId];
        
        //Get the list of children extensions to the account - from memory if possible 
        //(WILL THE EXTENSIONS HAVE THE TOP MOTHER LINK FROM ORBIS??) 
        System.debug(Logginglevel.INFO,'@@  a @@' + a);
        System.debug(Logginglevel.INFO,'@@ mapTopRelatedAccounts @@' +mapTopRelatedAccounts);
        if(mapTopRelatedAccounts != null && !mapTopRelatedAccounts.isEmpty()) {
            if(mapTopRelatedAccounts.get(a.Id) != null) {
            	for(Id accId : mapTopRelatedAccounts.keySet()){
	                if(mapTopRelatedAccounts.get(accId).ParentId == a.Id) {
	                     extSet.add(mapTopRelatedAccounts.get(accId));
	                }            		
            	}
            }
        }

        String rtAcronym = getAcronym(a.RecordType.Name, true);
        
        G2O_AccountHierarchyNode accountNode = new G2O_AccountHierarchyNode(); //Create an accountNode and add an icon, name, url, leaf and isRoot.
        
        //Highlights the Account of the current page to allow user to see the position of the Account in the Company Hierarchy.Pt1
        if(accountId == acct.id) {
            accountNode.text = '<strong>';
        } else {
            accountNode.text = '';
        }
                
        //Print different text depending on the Record Type. Use different styling on the Current Account.
        if(a.RecordType.Name == System.Label.RecordType_Account_LE) {
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Corporate_Registration_Number__c != null) {
                accountNode.text += ', '+a.Corporate_Registration_Number__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            if(a.Ownership != null) {
                +accountNode.text += ', '+a.Ownership;
            }
        } else if(a.RecordType.Name == System.Label.RecordType_Account_WS) {
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Work_Site_Name__c != null) {
                accountNode.text += ', '+a.Work_Site_Name__c;
            }
            if(a.Work_Site_Type__c != null && a.Work_Site_Type__c != '') {
            	// Worksite types are codes, we cannot map labels dynamically
            	// As the custom setting workSiteTypeHQ gives us a code we can check, we can hard code a mapping to a label here, but not for other worksite types
            	if (a.Work_Site_Type__c == UTIL_OrgSettings.workSiteTypeHQ())
            	{
            		accountNode.text += ', '+Label.Work_Site_Type_TY10;
            	}
            }
            if(a.Visiting_Address_Street__c != null) {
                accountNode.text += ', '+a.Visiting_Address_Street__c;
            }
            if(a.Visiting_Address_Postal_Code__c != null) {
                accountNode.text += ', '+a.Visiting_Address_Postal_Code__c;
            }
            if(a.Visiting_Address_City__c != null) {
                accountNode.text += ', '+a.Visiting_Address_City__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            accountNode.text += '- [<abstract>'+extSet.Size()+' Extensions</abstract>]';
        } else {
            //If there is no Record Type for the account, display a generic sequence of fields
            accountNode.text += '('+rtAcronym+') - '+a.Name;
            if(a.Corporate_Registration_Number__c != null) {
                accountNode.text += ', '+a.Corporate_Registration_Number__c;
            }
            if(a.Registration_Country__c != null && a.Registration_Country__c != '' && a.Registration_Country__c != 'NULL') {
                accountNode.text += ', '+a.Registration_Country__c;
            }
            if(a.Ownership != null) {
                +accountNode.text += ', '+a.Ownership;
            }
        }
        
        //Highlight current, pt2
        if (accountId == acct.id) accountNode.text += '</strong>';
           
        accountNode.url = '/' + a.Id;
        accountNode.leaf = false;
        accountNode.isRoot = true;
        
        //Setting the icon depending on the record type
        if(a.RecordType.Name == System.Label.RecordType_Account_LE) {
            accountNode.icon = '/img/icon/documents16.png';  
        } else if(a.RecordType.Name == System.Label.RecordType_Account_WS) {
            accountNode.icon = '/img/icon/home16.png';  
        } else if(a.RecordType.Name == System.Label.RecordType_Account_Ext) {
            accountNode.icon = '/img/icon/custom51_100/buildingBlock16.png';  
        } else {
            accountNode.icon = '/s.gif" style="background:url(/img/sprites/master.png); background-position: 0px -2px; width: 16px; height: 16px;"'; //Uses the SFDC master sprites and displays the required icon by setting it's background position
        }
        return accountNode; 
    }
        
    //Private method to return the acronym of a string where each word is separated by blanks. 
    //Parameter to decide if the acronym should be forced caps
    private String getAcronym(String s, Boolean forceCaps) {
        String acronym = '';       
        String[] wordArray;

        if(s != null) {
            wordArray = s.split(' ',0);
        } else {
            return 'n/a';
        }
              
        if(wordArray.size()>1) {  
            for(String word : wordArray) {
                acronym += word.substring(0,1);
            }
            if(forceCaps) acronym.toUpperCase();
        } else if(wordArray.size()==1) {                 //if the string is only one word, the first three letters will be used instead
            acronym = wordArray[0].substring(0,3);
            acronym.capitalize();
        } else {
            //if there is no word in the string, return an empty string
        }                   
        return acronym;
    }
 
}