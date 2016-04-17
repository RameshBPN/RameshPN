/**
	About
	-----
	Description: Custom lookup for Accounts for Contact Creation 
	Created for: Postnord Get2OneCRM Master template/DK
	Create date: June 2013

	Methods
	-------
	1. search(): performs the keyword search
	2. displayFilters(): this method is called when the User Clicks Show Filters and displays all the fields where the User can further apply filters on
	3. hideFilters(): this method is called when the User Clicks Hide Filters so that all the related filters are hidden from the user
	4. clearSearchFilters(): This method is used to Clear all the information a user enters in Search Filters and performs Search again with or without Name filter
	5. runSearch(): prepare the query and issue the search command
	6. performSearch(): run the search and return the records found. 
	7. chkAccountFieldSetValues(): this method checks if there are any values inputted by the user on Filters and returns true if no values are inputted or else false
	8. applyFilters() : this method is called when the user hits Apply filters and dynamic query is used to form the query for searching accounts
	9. getFormTag(): used by the visualforce page to send the link to the right dom element
	10.getTextBox(): used by the visualforce page to send the link to the right dom element for the text box
		
	Update History
	--------------  
	Created June 2013 - R.M.
	Refactored Aug 2013 - M.E.
**/
public with sharing class G2O_CustomAccountLookup_VFC {
	
	public List<Account> results{get;set;} 			// search results
	public List<Account> accountResults{get;set;} 	// display results
	public string searchString{get;set;} 			// search keyword
	public Account account{get;set;}				// this is used for the field set for Filter section
	public Boolean showSearchFilterButton{get;set;}	// to rerender Show Filter Button
	public Boolean showHideFilterButton{get;set;}	// to rerender Hide Filter Button
	public Boolean showSearchFilter{get;set;}		// to display the filter fields
	public Boolean clearSearchFilter{get;set;}		// remove all the values inputted by the user in show filter
	public Boolean checkAccountValuesInFieldSet{get;set;}	// used for checking if any value is entered by the user in show filters
	public String filteredByInformation{get;set;}		// filtered description given to the user on which basis Account is filtered
	private enum workSiteTypes {TY10, BR}					// enum for storing work sites types
	public G2O_CustomAccountLookup_VFC() {
		
		account = new Account();
		// get the current search string
		searchString = System.currentPageReference().getParameters().get('lksrch');
		showSearchFilterButton = true;		// Show Filter button is defaulted to true when a user 1st clicks the lookup
		showHideFilterButton = false;		// Hide Fliter button is defaulted to false and is only visible once a user clicks Show Filter
		showSearchFilter = false;			// The filters for Account are set to false and are only visible once the User clicks Show Filter	
		clearSearchFilter = false;			// This is defaulted to false and is used when Clear Filters is clicked by the User
		filteredByInformation = null;		// The description of filtered criteria is set to null 
		runSearch();  						// performs default search when the account lookup is clicked
	}
 
	// performs the keyword search
	public PageReference search() {
		
		clearSearchFilter = false;	//	sets the Clear filters to false
	    runSearch();				// calls the method when the user hits Go 
	    return null;
	    
  	}
  	
  	// this method is called when the User Clicks Show Filters and displays all the fields where the User can further apply filters on 
  	public void displayFilters() {
  		
  		// Altering various parameters like setting the Hide Filter/ Showing the Filter Section to true and setting the Show Filter button to false
  		showSearchFilterButton = false;
		showHideFilterButton = true;
		showSearchFilter = true;
		clearSearchFilter = false;
		
		// Checks if there are any values inputted by the user on Filters and returns true if no values are inputted or else false
		checkAccountValuesInFieldSet = chkAccountFieldSetValues();
		
		if(checkAccountValuesInFieldSet == true) {
			filteredByInformation = null;
		}
  	}
  	
  	
  	// this method is called when the User Clicks Hide Filters so that all the related filters are hidden from the user
  	public void hideFilters() {
  		
  		// Altering various parameters like setting the Show Filter button to true and setting the Hide Filter/ Showing the Filter Section to false
  		showSearchFilterButton = true;
		showHideFilterButton = false;
		showSearchFilter = false;
		clearSearchFilter = false;
		
		// Checks if there are any values inputted by the user on Filters and returns true if no values are inputted or else false
		checkAccountValuesInFieldSet = chkAccountFieldSetValues();
		
		if(checkAccountValuesInFieldSet == true) {
			filteredByInformation = null;
		}
  	}
  	
  	// This method is used to Clear all the information a user enters in Search Filters and performs Search again with or without Name filter
  	public void clearSearchFilters() {
  		
  		// Clears all the account input values
  		account.clear();
  		
  		// sets the Filtered description to null
  		filteredByInformation = null;
  		
  		// sets the clear filter to true
  		clearSearchFilter = true;
  		
  		// performs search based on cleared filters and search string if inputted
  		runSearch();
  	}
 
  	// prepare the query and issue the search command
	private void runSearch() {

    	results = performSearch(searchString);      
    	accountResults = sortAccountsHQ();   
  	} 
  	
  	// sorting of account records based on work site type HQ
  	private List<Account> sortAccountsHQ() {
  		
  		List<Account> workSiteTypeHQ = new List<Account>();
  		List<Account> workSiteTypeNotHQ = new List<Account>();
  		List<Account> workSiteTypeBlank = new List<Account>();
  		
  		for(Account accountHQ: results) {
  			system.debug(logginglevel.warn, 'worksite type is:' + accountHQ.Work_Site_Type__c);
  			// fetch all work sites with Type HQ and put them on the top followed by worksite type not blank and finally with blanks
  			if(accountHQ.Work_Site_Type__c == String.valueof(workSiteTypes.TY10)) {
  				workSiteTypeHQ.add(accountHQ);
  			} else {
  				if(accountHQ.Work_Site_Type__c == String.valueof(workSiteTypes.BR) || (accountHQ.Work_Site_Type__c != null && accountHQ.Work_Site_Type__c != '')) {
  					workSiteTypeNotHQ.add(accountHQ);
  				} else {
  					workSiteTypeBlank.add(accountHQ);
  				}
  			}
  		}
  		
		// adding it to the list 
  		if(workSiteTypeNotHQ != null && !workSiteTypeNotHQ.isEmpty()) {
  			workSiteTypeHQ.addAll(workSiteTypeNotHQ);
  		}
  		if(workSiteTypeBlank != null && !workSiteTypeBlank.isEmpty()) {
  			workSiteTypeHQ.addAll(workSiteTypeBlank);
  		}
  		
  		// return the list with sorting order
  		return workSiteTypeHQ;
  	}
 
	// run the search and return the records found. 
  	private List<Account> performSearch(string searchString) {
  		
  		// Checks if there are any values inputted by the user on Filters and returns true if no values are inputted or else false
  		checkAccountValuesInFieldSet = chkAccountFieldSetValues();
  		
  		// Creates dynamic query based on User inputs and also applied filters if any
    	String soql = 'SELECT Id, Name, Type, IsPersonAccount, Corporate_Registration_Number__c, Old_Customer_Number__c, Ella_Production_Customer_Number__c, Postal_Address_City__c, Postal_Address_Postal_Code__c, Involved_Party_ID__c, RecordType.Name, Work_Site_Type__c from Account ';
    	
    	// If the user has inputted the Name or not on which basis the account should be searched
    	if(searchString != '' && searchString != null) {
    		
      		soql = soql +  ' WHERE Name LIKE \'' + String.escapeSingleQuotes(searchString.replace('*','%')) +'%\'';
      		soql += ' AND RecordTypeId =\''+UTIL_Meta.getAccountWorksiteRT()+'\'';
			
      		if(showSearchFilter == true && clearSearchFilter == false && checkAccountValuesInFieldSet == false) {
      			soql = applyFilters(soql);
      		} else {
      			soql += ' AND Corporate_Registration_Number__c !=NULL';
      		}
      		
    	} else {
    		
    		soql += ' WHERE RecordTypeId =\''+UTIL_Meta.getAccountWorksiteRT()+'\'';

    		if(showSearchFilter == true && clearSearchFilter == false && checkAccountValuesInFieldSet == false) {
      			soql = applyFilters(soql);
      		} else {
      			soql += ' AND Corporate_Registration_Number__c !=NULL';
      		}
      		
    	}
    	
    	// adding limit to the query
    	soql = soql + ' limit 100';
    	System.debug(Logginglevel.INFO,soql);
    	return database.query(soql); 
    	
  	}
  		
  	// this method checks if there are any values inputted by the user on Filters and returns true if no values are inputted or else false
  	private Boolean chkAccountFieldSetValues() {
  		
  		Boolean accountNull;
  		for(Schema.FieldSetMember f: SObjectType.Account.FieldSets.AccountLookupFilters.getFields()) {
  			if(String.valueof(account.get(f.getFieldPath())) != null && String.valueof(account.get(f.getFieldPath())) != '') { 
  				accountNull = false;
  				break;
  			} else {
  				accountNull = true;
  			}			
  		}
  		return accountNull;
  	}
  	
  	// this method is called when the user hits Apply filters and dynamic query is used to form the query for searching accounts
  	private String applyFilters(String soql) {

		// NOTE: Have used a custom label below as this is used to display information on the VF page
  		filteredByInformation = System.label.Filtered_By;

 		Integer i = 0;
  		for(Schema.FieldSetMember f: SObjectType.Account.FieldSets.AccountLookupFilters.getFields()) {
  			i++;
  			if(account.get(f.getFieldPath()) != null && account.get(f.getFieldPath()) != '') { 
  				soql += ' AND ';
  				soql += f.getFieldPath() +' LIKE \'%'+String.escapeSingleQuotes(String.valueof(account.get(f.getFieldPath())))+'%\'';
  				if(i == 1) {
  					filteredByInformation += f.getLabel() + '(' + account.get(f.getFieldPath())+ ')';
  				} else {
  					filteredByInformation += ',' + f.getLabel() + '(' + account.get(f.getFieldPath())+ ')';
  				}
  			}			
  		}
  		return soql;
  	}
	
	
	// used by the visualforce page to send the link to the right dom element
	public string getFormTag() {
    	return System.currentPageReference().getParameters().get('frm');
  	}
 
	// used by the visualforce page to send the link to the right dom element for the text box
  	public string getTextBox() {
    	return System.currentPageReference().getParameters().get('txt');
  	}

}