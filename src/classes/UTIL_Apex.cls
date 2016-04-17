/**
    About
    -----
    Description: Apex programming helper methods
    Created for: Postnord Get2OneCRM Master/DK
    Create date: March 2013
    
    Details / Methods
    -----------------
    - Generic
        empty // Test if an object is null or empty ('' or zero)
        emptyRecycleBin //Empty the recycle bin of list of Ids
    
    - List
        toSet // Convert a List to a Set
        deserializeMultiSelect // Convert a mutiselect staring of values into a string list
        serializeWithQuotes // Convert a string list or set or mutiselect picklist string into a CSV set
        orderList //Sort sObjects (alt do this in dynamic soql if using soql based pagination)
    
    - Decimal
        roundUp // Round a number UP to a set number of decimal places (default round function in salesforce is to round DOWN)
    
    - Map
        mapAppendList // Shortcut code: Add to a list already attached to a map's key
    
    - regEx
        validateEmail // Validate email address
   
    Update History
    --------------
    Created March 2013 - M.Evans
    Updated June 2015 - Madhav Kakani - Fluido Denmark - Contact Center Project
    Issues / TODOs
    --------------
*/
public with sharing class UTIL_Apex
{   
    /**** Generic ****/
    // Test if an object is null or empty ('' or zero)
    public static Boolean empty(Object o)
    {
        return o==null || String.valueOf(o)=='';
    }
    public static Boolean empty(String o)
    {
        return o==null || o.trim()=='';
    }
    public static Boolean empty(Integer o)
    {
        return o==null || o==0;
    }
    public static Boolean empty(Decimal o)
    {
        return o==null || o==0;
    }
    public static Boolean isSet(Object o)
    {
        return !empty(o);
    }
    public static Boolean isSet(Integer o)
    {
        return !empty(o);
    }
    public static Boolean isSet(Decimal o)
    {
        return !empty(o);
    }
    public static Boolean isSet(boolean a)
    {
        return empty(a) ? false : a;
    }
    public static Boolean isSet(String o)
    {
        return !empty(o);
    }
    public static String getStr(Object o)
    {
        return isSet(o) ? String.valueOf(o) : '';
    }
    
    /**** Set ****/
    // Convert a Set to a List
    public static List<ID> toList(Set<ID> s)
    {
        ID[] l = new ID[]{};
        l.addAll(s);
        return l;
    }
    
    public static List<sObject> toList(Set<sObject> s)
    {
        sObject[] l = new sObject[]{};
        l.addAll(s);
        return l;
    }
    
    public static List<String> toList(Set<String> s)
    {
        List<String> l = new List<String>();
        l.addAll(s);
        return l;
    }
    
    /**** List ****/
    // Convert a List to a Set
    public static Set<ID> toSet(List<ID> l)
    {
        Set<ID> s = new Set<ID>();
        s.addAll(l);
        return s;
    }
    public static Set<String> toSet(List<String> l)
    {
        Set<String> s = new Set<String>();
        s.addAll(l);
        return s;
    }
    
    /** Not in use
    // Convert a mutiselect staring of values into a string list
    public static String[] deserializeMultiSelect(String mutiSelectList)
    {
        return mutiSelectList!=null ? mutiSelectList.split(';') : new String[]{};
    }
    */
    
    /** Not in use
    // Convert a string list or set or mutiselect picklist string into a CSV set
    public static String serializeWithQuotes(String[] aList)
    {
        String csv = '';
        for (String s:aList)
        {
            csv += '\''+s+'\',';
        }
        csv = csv.removeEnd(',');
        return csv;
    }
    public static String serializeWithQuotes(String mutiSelectList)
    {
        String[] aList = mutiSelectList!=null ? mutiSelectList.split(';') : new String[]{};
        return serializeWithQuotes(aList);
    }
    public static String serializeWithQuotes(Set<String> aSet)
    {
        String[] aList = new String[]{};
        aList.addAll(aSet);
        return serializeWithQuotes(aList);
    }
    */
    
    //Sort sObjects (alt do this in dynamic soql if using soql based pagination)
    public static void orderList(List<Sobject> items, String sortField, String theOrder)
    {
        theOrder = theOrder.toLowerCase();  
       List<Sobject> resultList = new List<Sobject>();
   
        //Create a map that can be used for sorting 
       Map<object, List<Sobject>> objectMap = new Map<object, List<Sobject>>();
       
       for(Sobject ob : items)
       {
            if(objectMap.get(ob.get(sortField)) == null)
            {
                objectMap.put(ob.get(sortField), new List<Sobject>()); 
            }
            objectMap.get(ob.get(sortField)).add(ob);
        }       
        //Sort the keys
        List<object> keys = new List<object>(objectMap.keySet());
        keys.sort();
       
        for(object key : keys){ 
            resultList.addAll(objectMap.get(key)); 
        }
       
        //Apply the sorted values to the source list
        items.clear();
        if(theOrder == 'asc')
        {
            for(Sobject ob : resultList)
            {
                items.add(ob); 
            }
        }
        else if(theOrder == 'desc')
        {
            for(integer i = resultList.size()-1; i >= 0; i--)
            {
                items.add(resultList[i]);  
            }
        }
    }  
    
    /**** Decimal ****/
    
    /** Not in use
    // Round a number UP to a set number of decimal places (default round function in salesforce is to round DOWN)
    public static Decimal roundUp(decimal aNumber, integer places)
    {
        return aNumber.setScale(places,System.RoundingMode.HALF_UP);
    }
    */
    
    /**** Integer ****/
    public static Integer convertStringToInt(String value)
    {
        if (empty(value)) return 0;
        value = value.replaceAll('[ABCDEFGHLIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxys:-¢€$ ]','');
        value = value.trim();
        try
        {
            return Integer.valueOf(value);
        } catch (Exception e)
        {
            System.debug(logginglevel.error, '@@ COULD NOT CONVERT VALUE TO INTEGER: '+value==null || value == '' ? '(empty)' : '"'+value+'"');
            return 0;
        }
    }
    
    /**** Map ****/
    
    /** Not in use
    // Shortcut code: Add to a list already attached to a map's key
    public static void mapAppendList(Map<Object,Object[]> m, Object key, Object value)
    {
        Object[] theList = new Object[]{};
        if (m.containsKey(key))
        {
            theList = m.get(key);
        }
        theList.add(value);
        m.put(key, theList);
    }
    */
    
    /**** regEx ****/
    
    /** Not in use
    // Validate email address
    public static boolean validateEmail(String emailAddress)
    {
        String emailRegex = '([a-zA-Z0-9_\\-\\.]+)@((\\[a-z]{1,3}\\.[a-z]{1,3}\\.[a-z]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})';
        Pattern emailPattern = Pattern.compile(emailRegex);
        Matcher emailMatch = emailPattern.matcher(emailAddress);
        return emailMatch.matches();
    }
    */
    
    /***** Custom Pagination ****/
    public class Pagination
    {
        //String errorDisplayStr = '';
        public object[] paginatedList {get {paginatedList = paginatedList == null ? new object[]{} : paginatedList; return paginatedList;} set;}
        object[] mainList {get {mainList = mainList==null ? new object[]{} : mainList; return mainList;} set;}
        Integer pageSize {get{pageSize = pageSize==null ? 10 : pageSize; return pageSize;} set;}
        
        public Integer pageNumber {get{pageNumber = pageNumber==null || pageNumber<1 ? 1 : pageNumber>numberOfPages ? numberOfpages : pageNumber; return pageNumber;} set;}
        public Integer numberOfPages {get{numberOfPages=Math.round((mainList.size()/pageSize)+(Math.Mod(mainList.size(),pageSize)>0? 1 : 0)); return numberOfPages;}set;}
        
        public Boolean showPaginationControls {get{return (numberOfPages > 1);}set;}
        public Boolean showPreviousButton {get{return (pageNumber > 1);}set;}
        public Boolean showNextButton {get{return (pageNumber < numberOfPages);}set;}
                
        public Pagination(List<object> mainList, Integer pageSize)
        {
            this.mainList = mainList;
            this.pageSize = pageSize;
            first();
        }
        
        // returns first set of records
        public void first() {
            //errorDisplayStr = '';
            pageNumber = 1;
            paginate();
        }
        
        //returns the last page of records
        public void last() {
            //errorDisplayStr = '';
            pageNumber = numberOfPages;
            paginate();
        }
        
        //returns the previous page of records
        public void previous() {     
            //errorDisplayStr = '';
            pageNumber--;
            paginate();
        }
        
        //returns the next page of records
        public void next() {      
            //errorDisplayStr = '';
            pageNumber++;
            paginate();
        }
        
        void paginate()
        {
            paginatedList = new object[]{};
            Integer startIndex  = (pageNumber-1) * pageSize;
            Integer endIndex    = startIndex + pageSize - 1;
            for(Integer i=startIndex; i <=endIndex && i < mainList.size() && i >=0 && mainList.size()>0; i++){
                paginatedList.add(mainList[i]);
            }
        }
    }
       
    /**** DateTime ****/
    public static DateTime convertISO8601(String iso8601ts) {
    DateTime dt = (DateTime) JSON.deserialize('"' + iso8601ts + '"', DateTime.class);
    // Bug in JSONParser or DateTime object results in a malformed DateTime,
    // so convert to Long and back to DateTime.  Without the conversion,
    // methods that access timeGmt() and its components will actually get
    // local time instead of GMT.
    return DateTime.newInstance( dt.getTime());

    // Once bug is fixed, this return is preferred
    // return dt;
    }
    
    // Empty the recycle bin of the input Ids
    public static void emptyRecycleBin(List<Id> IdsToDelete) {
        System.debug(LoggingLevel.info,'*** START: <UTIL_Apex>.<emptyRecycleBin>');
        if(IdsToDelete.size() > 0) {
            try {
                List<Database.EmptyRecycleBinResult> emptyRecycleBinResults = Database.emptyRecycleBin(IdsToDelete);
                for (Integer i = 0; i < emptyRecycleBinResults.size(); i++) {
                    if (!emptyRecycleBinResults[i].isSuccess()) {
                        System.debug(LoggingLevel.info,'*** emptyRecycleBin not successful');
                        for(Database.Error err : emptyRecycleBinResults[i].getErrors()) {
                            UTIL_Error.report('EmptyRecycleBin', err.getMessage());
                        }
                    }
                }
            } catch(Exception e) {
                system.debug(Logginglevel.INFO,'++++Exception+++'+e);
                UTIL_Error.report('EmptyRecycleBin', e);
            }
            UTIL_Error.writeNow();
        }
        
        System.debug(LoggingLevel.info,'*** END: <UTIL_Apex>.<emptyRecycleBin>');
    }

    // Contact Center project
    // semaphore to avoid multiple trigger updates - used in the Case_BeforeUpdate trigger
    public static Boolean CC_CaseBeforeUpdateProcessing = false;

    // Helper methods
    /* Called from Case_BeforeUpdate trigger
    * Queue the case to the appropriate queue in ClearIT
    */
    public static void CC_CaseBeforeUpdateHandler(List<Case> lstCases) {
        if(System.isBatch() || System.isScheduled()) return; 

        if(UTIL_Apex.CC_CaseBeforeUpdateProcessing) return; // this part of the trigger has already run
        UTIL_Apex.CC_CaseBeforeUpdateProcessing = true; // first time - set the flag to true
        
        Set<Id> ownerIds = new Set<Id>(); // set of case owner ids (queues only)
        for(Case c : lstCases) {
            // All queues start with '00G' so we don't waste SOQL queries
            if(UTIL_Apex.empty(c.CC_Item_Id__c) && c.CC_Queue_Status__c!=Label.Case_Enqueued) { // ClearInteract queue name not yet set
                String owner = c.OwnerId;
                if(owner.startsWith('00G')) ownerIds.add(c.OwnerId);
            }
        }
        
        if(ownerIds.isEmpty()) return; // there are no cases whose owner is a queue
        
        Map<Id, String> queueNames = new Map<Id, String>(); // Map of queue ids and queue names
        for(Group grp : [SELECT Id, Name FROM Group WHERE Type='Queue' AND Id IN :ownerIds]) {
            queueNames.put(grp.Id, grp.Name);
        }
    
        if(queueNames.isEmpty()) return; // there are no cases whose owner is a queue
        
        // Get all Clear IT queues
        Map<String, CC_ClearIT_Queues__c> cc_clearit_queue_by_sf = CC_ClearIT_Queues__c.getAll();

        // Queue the cases in ClearInteract
        for(Case c : lstCases) {
            if(queueNames.containsKey(c.OwnerId)) { // case owner is a queue
                // first check if there is a queue mapped in ClearIT for the functional inbox
                // Get the ClearInteract queue name based on functional inbox
                CC_ClearIT_Queues__c cc_queue = null;
                if(c.Functional_inbox__c != null) cc_queue = cc_clearit_queue_by_sf.get(c.Functional_inbox__c);

                if(UTIL_Apex.empty(cc_queue)) { // no mapping for the functional inbox
                    cc_queue = cc_clearit_queue_by_sf.get(queueNames.get(c.OwnerId)); // get the mapping based on case owner
                }
            
                if(UTIL_Apex.empty(cc_queue)) continue; // No mapping for the case owner either
                            
                UTIL_Apex.EnQueueCase(c.Id, cc_queue.ClearIT_Queue_Name__c); // call the future method
            }
        }
    }
    
    /*
    * Method to normalise a phone number based on the country
    */
    public static String NormalisePhone(String sPhone, String sCountry) {
        String phone = sPhone;
        if(UTIL_Apex.empty(phone)) return phone;

        // Remove spaces, [], (), -, .
        phone = phone.replaceAll('[\\[\\(\\]\\)\\-\\.\\s]','');
        
        if(phone.startsWith('00')) phone = phone.replaceFirst('00', '+');
        if(phone.startsWith('+')) return phone; // assume that the number is already normalised and correct
        
        // All the numbers need to follow international calling code convention (+1, +45 etc..)
        // Get the proper international code from the custom setting     
        if(UTIL_Apex.empty(sCountry)) return phone;
        
        try {
            Country_Calling_Codes__c ccc = Country_Calling_Codes__c.getInstance(sCountry);
            if(!UTIL_Apex.empty(ccc)) phone = '+' + ccc.Code__c + phone;
        } catch(Exception e) {
            UTIL_Error.report('CC_NormalisePhone Error:', e);
            UTIL_Error.write();
        }
        
        return phone;
    }

    /*
    * Method to queue a case in ClearIT system and receive an item id
    * Cannot be called from a batch job
    * Update the case with the returned item id
    */
    @future (callout=true)
    public static void EnQueueCase(String caseId, String clearit_queue) {
        CC_Outbound_WS ws = new CC_Outbound_WS();
       
        String itemId = ws.queueItemMapped(clearit_queue, '1', caseId);
        if(UTIL_Apex.empty(itemId)) return;
        
        try {
            List<Case> c = [SELECT Id, CC_Item_Id__c, CC_Queue_Name__c, CC_Queue_Status__c FROM Case WHERE Id=:caseId];
            if(!c.isEmpty()) {
                c[0].CC_Item_Id__c = String.valueof(itemId); // can we just use itemid?
                c[0].CC_Queue_Name__c = clearit_queue;
                c[0].CC_Queue_Status__c =  Label.Case_Enqueued; // Enqueued
                update c;
            } 
        } catch(DMLException e) {
            UTIL_Error.report('CC_EnQueueCase Error:', e);
            UTIL_Error.write();
        }
    }

    /*
    * Method to remove a closed case in ClearIT system
    * Cannot be called from a batch job
    */
    @future (callout=true)
    public static void DeQueueCase(String caseId, String clearit_itemid) {
        CC_Outbound_WS ws = new CC_Outbound_WS();

        String result = ws.endItem(clearit_itemid, caseId); 
        if(UTIL_Apex.empty(result)) return;

        if(UTIL_Apex.empty(caseId)) return; // not a case record
                
        try {
            List<Case> c = [SELECT Id, CC_Queue_Status__c FROM Case WHERE Id=:caseId];
            if(!c.isEmpty()) {
                c[0].CC_Queue_Status__c = Label.Case_Dequeued; // Dequeued
                update c;
            }
        } catch(DMLException e) {
            UTIL_Error.report('CC_DeQueueCase Error:', e);
            UTIL_Error.write();
        }
    }

}