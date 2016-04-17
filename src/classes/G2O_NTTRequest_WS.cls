/**
    About
    -----
    Description: Service for Noric Track and Trace
    Created for: Postnord Get2OneCRM Master template/DK
    Create date: Jan 2013
    
    Details / Methods
    -----------------
    Provides a simple way to query nordic track and trace (NTT) with Item ID returning an NTT Result wrapper class
    Depends on G2O_CINT_SoapIntegration->
    
    Use
        Set up an integration configuration in HTTP Integration Services (custom setting) called 'NTT'
        Code to use the service:
        
        // Create the connection
        G2O_NTTRequest_WS ntt = new G2O_NTTRequest_WS('the NTT item Id');
        
        // Send the callout
        ntt.send('some objectID - case etc.'');
        //or just ntt.send() if you don't want to relate the result to a record
        
        // Use the result
        ntt.result; // Now contains the resulting NTT information
        
        // If the result is null then check for errors
        ntt.callout.errors; // Contains a list of ErrorContainer objects which will describe the problems with error codes etc.
        ntt.callout.error; // The latest (Final) error is kept on .error for convenience
    
    Update History
    --------------
    Created Jan 2013 - M.E.
    First Compile March 2013 - M.E.
    Updated on November 2014 - Karthik K.J
    
    Issues / TODOs
    --------------
    
*/
public class G2O_NTTRequest_WS extends G2O_CINT_SoapIntegration
{
    /***** Mandatory values to pass in that NTT needs. These may not be null *****/
    public NTTResult result {get{result = result==null ? new NTTResult():result;return result;}set;}    // Will contain the result
    String itemId;      // The main parameter
    String locale = UserInfo.getLocale();
    
    /***** Constructor *****/
    public G2O_NTTRequest_WS(String itemId)
    {
        super('G2O_NTTRequest_WS', 'NTT');
        this.itemId = itemId.trim();
        
        if (UTIL_Apex.empty(itemId))
        {
            throw new UTIL_HttpIntegration.MappingException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'Item_Id__c',System.Label.Error_Message_ItemId);
        }
        
        requestParameters.put('ItemId',itemId.trim());
        
        String allowedLocales = UTIL_OrgSettings.NTT_locale_values();
        if(allowedLocales != null && allowedLocales.contains(locale)) {
            requestParameters.put('Locale',locale);
        }
        else {
            requestParameters.put('Locale','en');
        }
    }   
    
    /***** Parse Result *****/
    public override void handleResponse()
    {
        // Check for errors
        if (callout.errors.size()==0)
        {
            UTIL_XmlDom.Element[] shipmentElements = callout.xml.getElementsByTagName('shipment');
            UTIL_XmlDom.Element shipmentElement;
            
            UTIL_XmlDom.Element[] itemElements;
            UTIL_XmlDom.Element itemElement;
            String referenceId;
            
            // Only interested in the item with the correct id (and corresponding shipment)
            for(UTIL_XmlDom.Element sE : shipmentElements) {
                
                itemElements = sE.getElementsByTagName('item');
                
                for(UTIL_XmlDom.Element iE : itemElements) {
                    
                    UTIL_XmlDom.Element[] itemRefIdElements = iE.getElementsByTagName('itemRefId');
                    
                    for(UTIL_XmlDom.Element itemRefIdE : itemRefIdElements) {
                        if(itemRefIdE.getElementByTagName('referenceId') != null) {
                            referenceId = itemRefIdE.getElementByTagName('referenceId').nodeValue;
                        }
                    }
                    
                    if(getItemId(iE.getElementByTagName('itemId').nodeValue) == itemId || referenceId == itemId) {
                        itemElement = iE;
                        shipmentElement = sE;
                        break; // Take the first match
                    }
                }
                if(shipmentElement != null) break; // Take the first match
            }
            
            if (UTIL_Apex.empty(itemElement)){
                throw new UTIL_HttpIntegration.ResponseException(UTIL_HttpIntegration.ErrorCode.MAPPING_ERROR,'itemElement',System.Label.Error_Message_Item_Element);
            }
            
            UTIL_XmlDom.Element[] eventElements = itemElement.getElementsByTagName('event');
            UTIL_XmlDom.Element[] additionalServicesElements = shipmentElement.getElementsByTagName('additionalService');
            UTIL_XmlDom.Element receiverElement = shipmentElement.getElementByTagName('consignee');
            UTIL_XmlDom.Element senderElement = shipmentElement.getElementByTagName('consignor');
            
            // Parse Item
            if(itemElement.getElementByTagName('itemId') != null) {
                result.nttCase.Item_Id__c           =   getItemId(itemElement.getElementByTagName('itemId').nodeValue);
                result.nttCaseProduct.Item_Id__c    =   getItemId(itemElement.getElementByTagName('itemId').nodeValue);
            }
            if(itemElement.getElementByTagName('deliveryDate') != null) {
                result.nttCaseProduct.Delivery_date__c  =   UTIL_APEX.convertISO8601(itemElement.getElementByTagName('deliveryDate').nodeValue);
                result.nttCase.Delivery_date__c =   UTIL_APEX.convertISO8601(itemElement.getElementByTagName('deliveryDate').nodeValue).date();
            }
            if(itemElement.getElementByTagName('dropOffDate') != null) {
                result.nttCaseProduct.Drop_off_date__c  =   UTIL_APEX.convertISO8601(itemElement.getElementByTagName('dropOffDate').nodeValue);
                
                // TODO: Will be added later. Ask Bhargavi.
                //result.nttCase.Drop_off_date__c   =   UTIL_APEX.convertISO8601(itemElement.getElementByTagName('dropOffDate').nodeValue.date());
            }
            
            // Parse statusText
            UTIL_XmlDom.Element statusTextElement = itemElement.getElementByTagName('statusText');
            
            if(statusTextElement != null) {
                if(statusTextElement.getElementByTagName('body') != null) {
                    result.nttCaseProduct.Status_Description__c =   statusTextElement.getElementByTagName('body').nodeValue;
                }
            }
            
            result.nttCase.Alternate_Item_Id__c         = referenceId;
            result.nttCaseProduct.Alternate_Item_Id__c  = referenceId;
            
            // Parse NTT History info           
            for(UTIL_XmlDom.Element e : eventElements) {
                NTT_History__c nttHistory = new NTT_History__c();
                
                nttHistory.Item_Id__c               =   itemId;
                
                if(e.getElementByTagName('eventCode') != null) {
                    nttHistory.Event_Code__c            =   e.getElementByTagName('eventCode').nodeValue;
                }
                if(e.getElementByTagName('localEventCode') != null) {
                    nttHistory.Local_Event_Code__c      =   e.getElementByTagName('localEventCode').nodeValue;
                }
                if(e.getElementByTagName('eventDescription') != null) {
                    nttHistory.Event_Description__c     =   e.getElementByTagName('eventDescription').nodeValue;
                }
                if(e.getElementByTagName('eventTime') != null) {
                    nttHistory.Event_Time__c            =   UTIL_APEX.convertISO8601(e.getElementByTagName('eventTime').nodeValue);
                }
                if(e.getElementByTagName('scanUserId') != null) {
                    nttHistory.LastScanUser__c          =   e.getElementByTagName('scanUserId').nodeValue;
                }
                
                UTIL_XmlDom.Element locationElement = e.getElementByTagName('location');
                
                if(locationElement.getElementByTagName('locationId') != null) {
                    nttHistory.Location_Id__c       =   locationElement.getElementByTagName('locationId').nodeValue;
                }
                if(locationElement.getElementByTagName('name') != null) {
                    nttHistory.Location_Name__c     =   locationElement.getElementByTagName('name').nodeValue;
                }
                if(locationElement.getElementByTagName('displayName') != null) {
                    nttHistory.Location__c          =   locationElement.getElementByTagName('displayName').nodeValue;
                }
                if(locationElement.getElementByTagName('locationType') != null) {
                    nttHistory.Location_Type__c     =   locationElement.getElementByTagName('locationType').nodeValue;
                }
                if(locationElement.getElementByTagName('country') != null) {
                    nttHistory.Country__c           =   locationElement.getElementByTagName('country').nodeValue;
                }
                if(locationElement.getElementByTagName('city') != null) {
                    nttHistory.City__c              =   locationElement.getElementByTagName('city').nodeValue;
                }
                if(locationElement.getElementByTagName('postcode') != null) {
                    nttHistory.Postcode__c          =   locationElement.getElementByTagName('postcode').nodeValue;
                }
                
                result.nttHistoryList.add(nttHistory);
            }
            if(result.nttHistoryList != null) {
                UTIL_Apex.orderList(result.nttHistoryList, 'Event_Time__c', 'desc');
            }
            
            // Parse Sender info
            if(senderElement != null) {
                if(senderElement.getElementByTagName('name') != null) {
                    result.nttCase.Sender_Name__c                   =   senderElement.getElementByTagName('name').nodeValue;
                    result.nttCaseProduct.Sender_Company_Name__c    =   senderElement.getElementByTagName('name').nodeValue;
                }
                
                UTIL_XmlDom.Element senderAddressElement = senderElement.getElementByTagName('address');
                UTIL_XmlDom.Element senderContactElement = senderElement.getElementByTagName('contact');
                UTIL_XmlDom.Element senderCustomerElement = senderElement.getElementByTagName('customer');
                
                if(senderAddressElement.getElementByTagName('city') != null) {
                    result.nttCase.Sender_Postal_Address_City__c            =   senderAddressElement.getElementByTagName('city').nodeValue;
                    result.nttCaseProduct.Sender_Postal_Address_City__c     =   senderAddressElement.getElementByTagName('city').nodeValue;
                }
                
                if(senderAddressElement.getElementByTagName('country') != null) {
                    result.nttCase.Sender_Postal_Address_Country__c         =   senderAddressElement.getElementByTagName('country').nodeValue;
                    result.nttCaseProduct.Sender_Postal_Address_Country__c  =   senderAddressElement.getElementByTagName('country').nodeValue;
                }
                
                if(senderAddressElement.getElementByTagName('postCode') != null) {
                    result.nttCase.Sender_Postal_Address_Postal_Code__c         =   senderAddressElement.getElementByTagName('postCode').nodeValue;
                    result.nttCaseProduct.Sender_Postal_Address_Postal_Code__c  =   senderAddressElement.getElementByTagName('postCode').nodeValue;
                }
                
                if(senderAddressElement.getElementByTagName('street1') != null) {
                    result.nttCase.Sender_Postal_Address_Street__c          =   senderAddressElement.getElementByTagName('street1').nodeValue;
                    result.nttCaseProduct.Sender_Postal_Address_Street__c   =   senderAddressElement.getElementByTagName('street1').nodeValue;
                }
                
                if(senderAddressElement.getElementByTagName('street2') != null) {
                    result.nttCase.Sender_Postal_Address_C_O__c             =   senderAddressElement.getElementByTagName('street2').nodeValue;
                    result.nttCaseProduct.Sender_Postal_Address_C_O__c      =   senderAddressElement.getElementByTagName('street2').nodeValue;
                }
                
                if(senderContactElement.getElementByTagName('contactName') != null) {
                    result.nttCase.Sender_Contact_Name__c           =   senderContactElement.getElementByTagName('contactName').nodeValue;
                    result.nttCaseProduct.Sender_Contact_Name__c    =   senderContactElement.getElementByTagName('contactName').nodeValue;
                }
                
                if(senderContactElement.getElementByTagName('email') != null) {
                    result.nttCase.Sender_Contact_email__c          =   senderContactElement.getElementByTagName('email').nodeValue;
                    result.nttCaseProduct.Sender_Contact_email__c   =   senderContactElement.getElementByTagName('email').nodeValue;
                }
                
                if(senderContactElement.getElementByTagName('mobilePhone') != null) {
                    result.nttCase.Sender_Contact_Mobile__c         =   senderContactElement.getElementByTagName('mobilePhone').nodeValue;
                    result.nttCaseProduct.Sender_Contact_Mobile__c  =   senderContactElement.getElementByTagName('mobilePhone').nodeValue;
                }
                
                if(senderContactElement.getElementByTagName('phone') != null) {
                    result.nttCase.Sender_Contact_Telephone__c          =   senderContactElement.getElementByTagName('phone').nodeValue;
                    result.nttCaseProduct.Sender_Contact_Telephone__c   =   senderContactElement.getElementByTagName('phone').nodeValue;
                }
                if(senderCustomerElement != null) {
                	if(senderCustomerElement.getElementByTagName('productionCustomerNumber') != null) {
                    result.nttCaseProduct.productionCustomerNumber__c   =   senderCustomerElement.getElementByTagName('productionCustomerNumber').nodeValue;
	                }
	                
	                if(senderCustomerElement.getElementByTagName('sapCustomerNumber') != null) {
	                    result.nttCaseProduct.sapCustomerNumber__c  =   senderCustomerElement.getElementByTagName('sapCustomerNumber').nodeValue;
	                }
	                
	                if(senderCustomerElement.getElementByTagName('externalCustomerNumber') != null) {
	                    result.nttCaseProduct.externalCustomerNumber__c =   senderCustomerElement.getElementByTagName('externalCustomerNumber').nodeValue;
	                }
                }
            }
            
            // Parse Reciver info
            if(receiverElement != null) {
                if(receiverElement.getElementByTagName('name') != null) {
                    result.nttCase.Receiver_Name__c                 =   receiverElement.getElementByTagName('name').nodeValue;
                    result.nttCaseProduct.Receiver_Company_Name__c  =   receiverElement.getElementByTagName('name').nodeValue;
                }
                
                UTIL_XmlDom.Element receiverAddressElement = receiverElement.getElementByTagName('address');
                UTIL_XmlDom.Element receiverContactElement = receiverElement.getElementByTagName('contact');
                if(receiverAddressElement != null) {
                    if(receiverAddressElement.getElementByTagName('city') != null) {
                        result.nttCase.Receiver_Postal_Address_City__c          =   receiverAddressElement.getElementByTagName('city').nodeValue;
                        result.nttCaseProduct.Receiver_Postal_Address_City__c   =   receiverAddressElement.getElementByTagName('city').nodeValue;
                    }
                    
                    if(receiverAddressElement.getElementByTagName('country') != null) {
                        result.nttCase.Receiver_Postal_Address_Country__c           =   receiverAddressElement.getElementByTagName('country').nodeValue;
                        result.nttCaseProduct.Receiver_Postal_Address_Country__c    =   receiverAddressElement.getElementByTagName('country').nodeValue;
                    }
                    
                    if(receiverAddressElement.getElementByTagName('postCode') != null) {
                        result.nttCase.Receiver_Postal_Address_Postal_Code__c           =   receiverAddressElement.getElementByTagName('postCode').nodeValue;
                        result.nttCaseProduct.Receiver_Postal_Address_Postal_Code__c    =   receiverAddressElement.getElementByTagName('postCode').nodeValue;
                    }
                    
                    if(receiverAddressElement.getElementByTagName('street1') != null) {
                        result.nttCase.Receiver_Postal_Address_Street__c        =   receiverAddressElement.getElementByTagName('street1').nodeValue;
                        result.nttCaseProduct.Receiver_Postal_Address_Street__c =   receiverAddressElement.getElementByTagName('street1').nodeValue;
                    }
                    
                    if(receiverAddressElement.getElementByTagName('street2') != null) {
                        result.nttCase.Receiver_Postal_Address_C_O__c               =   receiverAddressElement.getElementByTagName('street2').nodeValue;
                        result.nttCaseProduct.Receiver_Postal_Address_C_O__c        =   receiverAddressElement.getElementByTagName('street2').nodeValue;
                    }
                }
                
                if(receiverContactElement != null) {
                    if(receiverContactElement.getElementByTagName('contactName') != null) {
                        result.nttCase.Receiver_Contact_Name__c         =   receiverContactElement.getElementByTagName('contactName').nodeValue;
                        result.nttCaseProduct.Receiver_Contact_Name__c  =   receiverContactElement.getElementByTagName('contactName').nodeValue;
                    }
                    
                    if(receiverContactElement.getElementByTagName('email') != null) {
                        result.nttCase.Receiver_contact_email__c            =   receiverContactElement.getElementByTagName('email').nodeValue;
                        result.nttCaseProduct.Receiver_contact_email__c     =   receiverContactElement.getElementByTagName('email').nodeValue;
                    }
                    
                    if(receiverContactElement.getElementByTagName('mobilePhone') != null) {
                        result.nttCase.Receiver_Contact_Mobile__c           =   receiverContactElement.getElementByTagName('mobilePhone').nodeValue;
                        result.nttCaseProduct.Receiver_Contact_Mobile__c    =   receiverContactElement.getElementByTagName('mobilePhone').nodeValue;
                    }
                    
                    if(receiverContactElement.getElementByTagName('phone') != null) {
                        result.nttCase.Receiver_Contact_Telephone__c            =   receiverContactElement.getElementByTagName('phone').nodeValue;
                        result.nttCaseProduct.Receiver_Contact_Telephone__c     =   receiverContactElement.getElementByTagName('phone').nodeValue;
                    }
                }
            }
            
            // Parse Additional Services
            if(additionalServicesElements.size() > 0) {
                result.nttCaseProduct.Additional_Service_code1__c   =   additionalServicesElements[0].getElementByTagName('code').nodeValue;
                result.nttCaseProduct.Additional_Service_Name1__c   =   additionalServicesElements[0].getElementByTagName('name').nodeValue;
            }
            if(additionalServicesElements.size() > 1) {
                result.nttCaseProduct.Additional_Service_code2__c   =   additionalServicesElements[1].getElementByTagName('code').nodeValue;
                result.nttCaseProduct.Additional_Service_Name2__c   =   additionalServicesElements[1].getElementByTagName('name').nodeValue;
            }
            if(additionalServicesElements.size() > 2) {
                result.nttCaseProduct.Additional_Service_code3__c   =   additionalServicesElements[2].getElementByTagName('code').nodeValue;
                result.nttCaseProduct.Additional_Service_Name3__c   =   additionalServicesElements[2].getElementByTagName('name').nodeValue;
            }
            if(additionalServicesElements.size() > 3) {
                result.nttCaseProduct.Additional_Service_code4__c   =   additionalServicesElements[3].getElementByTagName('code').nodeValue;
                result.nttCaseProduct.Additional_Service_Name4__c   =   additionalServicesElements[3].getElementByTagName('name').nodeValue;
            }
            
            // Parse References
            UTIL_XmlDom.Element[] referenceElements = itemElement.getElementsByTagName('Reference');
            
            if(referenceElements.size() > 0) {
                if(referenceElements[0].getElementByTagName('type') != null)    result.nttCaseProduct.Reference_Type1__c    =   referenceElements[0].getElementByTagName('type').nodeValue;
                if(referenceElements[0].getElementByTagName('name') != null)    result.nttCaseProduct.Reference_Name1__c    =   referenceElements[0].getElementByTagName('name').nodeValue;
                if(referenceElements[0].getElementByTagName('value') != null)   result.nttCaseProduct.Reference_Value1__c   =   referenceElements[0].getElementByTagName('value').nodeValue;
                
                if(result.nttCaseProduct.Reference_Type1__c == 'FLW') {
                    result.nttCase.Retailer__c      =   result.nttCaseProduct.Reference_Name1__c;
                }
            }
            if(referenceElements.size() > 1) {
                if(referenceElements[1].getElementByTagName('type') != null)    result.nttCaseProduct.Reference_Type2__c    =   referenceElements[1].getElementByTagName('type').nodeValue;
                if(referenceElements[1].getElementByTagName('name') != null)    result.nttCaseProduct.Reference_Name2__c    =   referenceElements[1].getElementByTagName('name').nodeValue;
                if(referenceElements[1].getElementByTagName('value') != null)   result.nttCaseProduct.Reference_Value2__c   =   referenceElements[1].getElementByTagName('value').nodeValue;
                
                if(result.nttCaseProduct.Reference_Type2__c == 'FLW') {
                    result.nttCase.Retailer__c      =   result.nttCaseProduct.Reference_Name2__c;
                }
            }
            if(referenceElements.size() > 2) {
                if(referenceElements[2].getElementByTagName('type') != null)    result.nttCaseProduct.Reference_Type3__c    =   referenceElements[2].getElementByTagName('type').nodeValue;
                if(referenceElements[2].getElementByTagName('name') != null)    result.nttCaseProduct.Reference_Name3__c    =   referenceElements[2].getElementByTagName('name').nodeValue;
                if(referenceElements[2].getElementByTagName('value') != null)   result.nttCaseProduct.Reference_Value3__c   =   referenceElements[2].getElementByTagName('value').nodeValue;
                
                if(result.nttCaseProduct.Reference_Type2__c == 'FLW') {
                    result.nttCase.Retailer__c      =   result.nttCaseProduct.Reference_Name3__c;
                }
            }
            
            
            // Parse smsNotification
            
            UTIL_XmlDom.Element smsNotificationElement = shipmentElement.getElementByTagName('notificationPhoneNumber');
            
            if(smsNotificationElement != null) {
                
                result.nttCaseProduct.SMS__c = true;                
                
                
                    result.nttCaseProduct.Notification_Phone_No__c  =   smsNotificationElement.getElementByTagName('notificationPhoneNumber').nodeValue;
                
            }
            
            // Parse emailNotification
            
            UTIL_XmlDom.Element emailNotificationElement = shipmentElement.getElementByTagName('emailNotification');
            
            if(emailNotificationElement != null) {
                
                result.nttCaseProduct.Email__c = true;              
                
                if(emailNotificationElement.getElementByTagName('email') != null) {
                    result.nttCaseProduct.Notification_email__c =   emailNotificationElement.getElementByTagName('email').nodeValue;
                }
            }
            
            // Parse freightPayer
            UTIL_XmlDom.Element freightPayerElement = shipmentElement.getElementByTagName('freightPayer');
            
            if(freightPayerElement != null) {       
                
                if(freightPayerElement.getElementByTagName('name') != null) {
                    result.nttCaseProduct.FreightPayerName__c   =   freightPayerElement.getElementByTagName('name').nodeValue;
                }
                
                UTIL_XmlDom.Element freightPayerAdressElement = freightPayerElement.getElementByTagName('address');
                if(freightPayerAdressElement != null) {
                    
                    if(freightPayerAdressElement.getElementByTagName('city') != null) {
                        result.nttCaseProduct.FreightPayerCity__c       =   freightPayerAdressElement.getElementByTagName('city').nodeValue;
                    }
                    if(freightPayerAdressElement.getElementByTagName('country') != null) {
                        result.nttCaseProduct.FreightPayerCountry__c    =   freightPayerAdressElement.getElementByTagName('country').nodeValue;
                    }
                    if(freightPayerAdressElement.getElementByTagName('postCode') != null) {
                        result.nttCaseProduct.FreightPayerPostalCode__c =   freightPayerAdressElement.getElementByTagName('postCode').nodeValue;
                    }
                    if(freightPayerAdressElement.getElementByTagName('street1') != null) {
                        result.nttCaseProduct.FreightPayerAddress1__c   =   freightPayerAdressElement.getElementByTagName('street1').nodeValue;
                    }
                    if(freightPayerAdressElement.getElementByTagName('street2') != null) {
                        result.nttCaseProduct.FreightPayerAddress2__c   =   freightPayerAdressElement.getElementByTagName('street2').nodeValue;
                    }
                }
            }
            
            // Parse pickupParty
            UTIL_XmlDom.Element pickupPartyElement = shipmentElement.getElementByTagName('pickupParty');
            
            if(pickupPartyElement != null) {
                
                UTIL_XmlDom.Element pickupPartyAdressElement = pickupPartyElement.getElementByTagName('address');
                if(pickupPartyAdressElement != null) {
                    
                    if(pickupPartyAdressElement.getElementByTagName('city') != null) {
                        result.nttCaseProduct.Pick_up_party_city__c     =   pickupPartyAdressElement.getElementByTagName('city').nodeValue;
                    }
                    if(pickupPartyAdressElement.getElementByTagName('country') != null) {
                        result.nttCaseProduct.Pick_up_party_country__c  =   pickupPartyAdressElement.getElementByTagName('country').nodeValue;
                    }
                    if(pickupPartyAdressElement.getElementByTagName('postCode') != null) {
                        result.nttCaseProduct.Pick_up_party_postalcode__c   =   pickupPartyAdressElement.getElementByTagName('postCode').nodeValue;
                    }
                    if(pickupPartyAdressElement.getElementByTagName('street1') != null) {
                        result.nttCaseProduct.Pick_up_party_address1__c =   pickupPartyAdressElement.getElementByTagName('street1').nodeValue;
                    }
                    if(pickupPartyAdressElement.getElementByTagName('street2') != null) {
                        result.nttCaseProduct.Pick_up_party_address2__c =   pickupPartyAdressElement.getElementByTagName('street2').nodeValue;
                    }
                }
            }
            
            // Parse Shipment
            
            if(shipmentElement.getElementByTagName('estimatedTimeOfArrival') != null) {
                result.nttCaseProduct.Estimated_Time_of_Arrival__c  =   UTIL_APEX.convertISO8601(shipmentElement.getElementByTagName('estimatedTimeOfArrival').nodeValue);
            }
            if(shipmentElement.getElementByTagName('status') != null) {
                result.nttCaseProduct.Status__c =   shipmentElement.getElementByTagName('status').nodeValue;
            }
                    
            // Parse deliveryPoint
            UTIL_XmlDom.Element deliveryPointElement = shipmentElement.getElementByTagName('requestedDeliveryPoint');
            if(deliveryPointElement == null) deliveryPointElement = shipmentElement.getElementByTagName('deliveryPoint');
            
            if(deliveryPointElement != null) {      
                
                if(deliveryPointElement.getElementByTagName('name') != null) {
                    result.nttCaseProduct.DeliveryPoint_Name__c =   deliveryPointElement.getElementByTagName('name').nodeValue;
                }
                
                UTIL_XmlDom.Element deliveryPointAdressElement = deliveryPointElement.getElementByTagName('address');
                if(deliveryPointAdressElement != null) {
                    
                    if(deliveryPointAdressElement.getElementByTagName('city') != null) {
                        result.nttCaseProduct.DeliverPoint_city__c      =   deliveryPointAdressElement.getElementByTagName('city').nodeValue;
                    }
                    if(deliveryPointAdressElement.getElementByTagName('country') != null) {
                        result.nttCaseProduct.Deliverypoint_country__c  =   deliveryPointAdressElement.getElementByTagName('country').nodeValue;
                    }
                    if(deliveryPointAdressElement.getElementByTagName('postCode') != null) {
                        result.nttCaseProduct.DeliverPoint_postalcode__c    =   deliveryPointAdressElement.getElementByTagName('postCode').nodeValue;
                    }
                    if(deliveryPointAdressElement.getElementByTagName('street1') != null) {
                        result.nttCaseProduct.DeliverPoint_address1__c  =   deliveryPointAdressElement.getElementByTagName('street1').nodeValue;
                    }
                    if(deliveryPointAdressElement.getElementByTagName('street2') != null) {
                        result.nttCaseProduct.DeliverPoint_address2__c  =   deliveryPointAdressElement.getElementByTagName('street2').nodeValue;
                    }
                }
                
                UTIL_XmlDom.Element deliveryPointContactElement = deliveryPointElement.getElementByTagName('contact');
                if(deliveryPointContactElement != null) {
                    
                    if(deliveryPointContactElement.getElementByTagName('contactName') != null) {
                        result.nttCaseProduct.DeliveryPoint_Contact__c      =   deliveryPointContactElement.getElementByTagName('contactName').nodeValue;
                    }
                    if(deliveryPointContactElement.getElementByTagName('email') != null) {
                        result.nttCaseProduct.DeliveryPoint_Contactemail__c =   deliveryPointContactElement.getElementByTagName('email').nodeValue;
                    }
                    if(deliveryPointContactElement.getElementByTagName('mobilePhone') != null) {
                        result.nttCaseProduct.DeliveryPoint_ContactMobile__c    =   deliveryPointContactElement.getElementByTagName('mobilePhone').nodeValue;
                    }
                    if(deliveryPointContactElement.getElementByTagName('phone') != null) {
                        result.nttCaseProduct.DeliveryPoint_Contactphone__c =   deliveryPointContactElement.getElementByTagName('phone').nodeValue;
                    }
                }
                
                UTIL_XmlDom.Element[] openingHourElements = deliveryPointElement.getElementsByTagName('openingHour');
                
                String monday = 'Closed', tuesday = 'Closed', wednesday = 'Closed', thursday = 'Closed', friday = 'Closed', saturday = 'Closed', sunday = 'Closed';
                
                for(UTIL_XmlDom.Element e : openingHourElements) {
                    if(e.getElementByTagName('monday') != null && e.getElementByTagName('monday').nodeValue == 'true') {
                        monday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('tuesday') != null && e.getElementByTagName('tuesday').nodeValue == 'true') {
                        tuesday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('wednesday') != null && e.getElementByTagName('wednesday').nodeValue == 'true') {
                        wednesday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('thursday') != null && e.getElementByTagName('thursday').nodeValue == 'true') {
                        thursday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('friday') != null && e.getElementByTagName('friday').nodeValue == 'true') {
                        friday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('saturday') != null && e.getElementByTagName('saturday').nodeValue == 'true') {
                        saturday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                    if(e.getElementByTagName('sunday') != null && e.getElementByTagName('sunday').nodeValue == 'true') {
                        sunday = e.getElementByTagName('openFrom').nodeValue + ' - ' + e.getElementByTagName('openTo').nodeValue;
                    }
                }
                if(openingHourElements.size() == 0) {
                    result.nttCaseProduct.Opening_Hours__c = System.Label.Open_24_7;
                } else {
                    result.nttCaseProduct.Opening_Hours__c = 'Monday: ' + monday + '\n' + 
                                                             'Tuesday: ' + tuesday + '\n' +
                                                             'Wednesday: ' + wednesday + '\n' +
                                                             'Thursday: ' + thursday + '\n' +
                                                             'Friday: ' + friday + '\n' +
                                                             'Saturday: ' + saturday + '\n' +
                                                             'Sunday: ' + sunday;
                }
            }
            
            // Parse acceptor
            UTIL_XmlDom.Element acceptorElement = itemElement.getElementByTagName('acceptor');
                if(acceptorElement != null) {
                    
                    if(acceptorElement.getElementByTagName('name') != null) {
                        result.nttCaseProduct.Signature_Name__c     =   acceptorElement.getElementByTagName('name').nodeValue;
                    }
                }
            
            // Parse statedMeasurement
            UTIL_XmlDom.Element statedMeasurementElement = itemElement.getElementByTagName('statedMeasurement');
            
            if(statedMeasurementElement != null) {
                
                UTIL_XmlDom.Element heightElement = statedMeasurementElement.getElementByTagName('height');
                if(heightElement != null) {
                    if(heightElement.getElementByTagName('unit') != null) {
                        result.nttCaseProduct.Height_Unit__c    =   heightElement.getElementByTagName('unit').nodeValue;
                    }
                    if(heightElement.getElementByTagName('value') != null) {
                        result.nttCaseProduct.Height_Value__c   =   heightElement.getElementByTagName('value').nodeValue;
                    }
                    
                    result.nttCaseProduct.Height__c = result.nttCaseProduct.Height_Value__c + ' ' + result.nttCaseProduct.Height_Unit__c;
                }
                
                UTIL_XmlDom.Element lengthElement = statedMeasurementElement.getElementByTagName('length');
                if(lengthElement != null) {
                    if(lengthElement.getElementByTagName('unit') != null) {
                        result.nttCaseProduct.Length_Unit__c    =   lengthElement.getElementByTagName('unit').nodeValue;
                    }
                    if(lengthElement.getElementByTagName('value') != null) {
                        result.nttCaseProduct.Length_Value__c   =   lengthElement.getElementByTagName('value').nodeValue;
                    }
                    
                    result.nttCaseProduct.Length__c = result.nttCaseProduct.Length_Value__c + ' ' + result.nttCaseProduct.Length_Unit__c;
                }
                
                UTIL_XmlDom.Element volumeElement = statedMeasurementElement.getElementByTagName('volume');
                if(volumeElement != null) {
                    if(volumeElement.getElementByTagName('unit') != null) {
                        result.nttCaseProduct.Volume_Unit__c    =   volumeElement.getElementByTagName('unit').nodeValue;
                    }
                    if(volumeElement.getElementByTagName('value') != null) {
                        result.nttCaseProduct.Volume_Value__c   =   volumeElement.getElementByTagName('value').nodeValue;
                    }
                    
                    result.nttCaseProduct.Volume__c = result.nttCaseProduct.Volume_Value__c +  + result.nttCaseProduct.Volume_Unit__c;
                }
                
                UTIL_XmlDom.Element weightElement = statedMeasurementElement.getElementByTagName('weight');
                if(weightElement != null) {
                    if(weightElement.getElementByTagName('unit') != null) {
                        result.nttCaseProduct.Weight_Unit__c    =   weightElement.getElementByTagName('unit').nodeValue;
                    }
                    if(weightElement.getElementByTagName('value') != null) {
                        result.nttCaseProduct.Weight_Value__c = Decimal.valueOf(weightElement.getElementByTagName('value').nodeValue);
                    }
				}
                
                UTIL_XmlDom.Element widthElement = statedMeasurementElement.getElementByTagName('width');
                if(widthElement != null) {
                    if(widthElement.getElementByTagName('unit') != null) {
                        result.nttCaseProduct.Width_Unit__c =   widthElement.getElementByTagName('unit').nodeValue;
                    }
                    if(widthElement.getElementByTagName('value') != null) {
                        result.nttCaseProduct.Width_Value__c    =   widthElement.getElementByTagName('value').nodeValue;
                    }
                    
                    result.nttCaseProduct.Width__c = result.nttCaseProduct.Width_Value__c + ' ' + result.nttCaseProduct.Width_Unit__c;
                }
            }
            
            // Parse service
            UTIL_XmlDom.Element serviceElement = shipmentElement.getElementByTagName('service');
            
            if(serviceElement != null) {
                if(serviceElement.getElementByTagName('code') != null) {
                    result.nttCaseProduct.Service_Code__c   =   serviceElement.getElementByTagName('code').nodeValue;
                }
                if(serviceElement.getElementByTagName('name') != null) {
                    result.nttCaseProduct.Service_Name__c   =   serviceElement.getElementByTagName('name').nodeValue;
                }
            }
            
            
            // Parse cashOnDelivery
            UTIL_XmlDom.Element cashOnDeliveryElement = shipmentElement.getElementByTagName('cashOnDelivery');
            
            if(cashOnDeliveryElement != null) {
                if(cashOnDeliveryElement.getElementByTagName('currency') != null && cashOnDeliveryElement.getElementByTagName('value') != null) {
                    result.nttCase.COD_Amount__c        =   cashOnDeliveryElement.getElementByTagName('value').nodeValue + ' ' + cashOnDeliveryElement.getElementByTagName('currency').nodeValue;
                    
                    result.nttCaseProduct.COD_Amount__c     =   result.nttCase.COD_Amount__c;
                }
            }
            
            // Parse paymentAccount
            UTIL_XmlDom.Element paymentAccountElement = shipmentElement.getElementByTagName('paymentAccount');
            
            if(paymentAccountElement != null) {
                if(paymentAccountElement.getElementByTagName('accountNumber') != null) {
                    result.nttCase.Account_Number__c            =   paymentAccountElement.getElementByTagName('accountNumber').nodeValue;
                    result.nttCaseProduct.Account_Number__c     =   result.nttCase.Account_Number__c;
                }
                if(paymentAccountElement.getElementByTagName('accountType') != null) {
                    result.nttCase.Account_Type__c              =   paymentAccountElement.getElementByTagName('accountType').nodeValue;
                    result.nttCaseProduct.Account_Type__c       =   result.nttCase.Account_Number__c;
                }
            }
            
            // If there is a match for the sender account in the system; overwrite the Sender Postal Address fields and Name.
            // First check for sapCustomerNumber__ == Involved_Party_ID__c, if nor found check for 
            // productionCustomerNumber__c == GTT_Customer_Number__c
            
            List<Account> senderAccountList = new List<Account>();
            
            if(!UTIL_Apex.empty(result.nttCaseProduct.sapCustomerNumber__c)) {
                senderAccountList = [SELECT Id, Involved_Party_ID__c , Name, Postal_Address_C_O__c, Postal_Address_Street__c, Postal_Address_Postal_Code__c, Postal_Address_City__c, Postal_Address_Country__c
                                     FROM Account
                                     WHERE Involved_Party_ID__c = :result.nttCaseProduct.sapCustomerNumber__c];
            } 
            if((senderAccountList == null || senderAccountList.size() == 0) && !UTIL_Apex.empty(result.nttCaseProduct.productionCustomerNumber__c)) {
                senderAccountList = [SELECT Id, Involved_Party_ID__c , Name, Postal_Address_C_O__c, Postal_Address_Street__c, Postal_Address_Postal_Code__c, Postal_Address_City__c, Postal_Address_Country__c
                                     FROM Account
                                     WHERE GTT_Customer_Number__c = :result.nttCaseProduct.productionCustomerNumber__c];
            }
            
            // If there are more results, take the first one.
            if(senderAccountList.size() > 0 ) {
                result.nttCase.Sender__c                                    =   senderAccountList[0].Id;
                result.nttCase.Sender_Name__c                               =   senderAccountList[0].Name;
                result.nttCase.Sender_Postal_Address_C_O__c                 =   senderAccountList[0].Postal_Address_C_O__c;
                result.nttCase.Sender_Postal_Address_Street__c              =   senderAccountList[0].Postal_Address_Street__c;
                result.nttCase.Sender_Postal_Address_Postal_Code__c         =   senderAccountList[0].Postal_Address_Postal_Code__c;
                result.nttCase.Sender_Postal_Address_City__c                =   senderAccountList[0].Postal_Address_City__c;
                result.nttCase.Sender_Postal_Address_Country__c             =   senderAccountList[0].Postal_Address_Country__c;
                
                result.nttCaseProduct.Sender_Postal_Address_C_O__c          =   senderAccountList[0].Postal_Address_C_O__c;
                result.nttCaseProduct.Sender_Postal_Address_Street__c       =   senderAccountList[0].Postal_Address_Street__c;
                result.nttCaseProduct.Sender_Postal_Address_Postal_Code__c  =   senderAccountList[0].Postal_Address_Postal_Code__c;
                result.nttCaseProduct.Sender_Postal_Address_City__c         =   senderAccountList[0].Postal_Address_City__c;
                result.nttCaseProduct.Sender_Postal_Address_Country__c      =   senderAccountList[0].Postal_Address_Country__c;
            }
            
        } else {
        
            // Set itemId. Needs to be set even if errors, so the user can save the case with the itemId.
            result.nttCase.Item_Id__c = itemId;
            result.nttCaseProduct.Item_Id__c = itemId;
        }
    }
    
    // Some item ids come in the format XXXX / YYYY and we want to extract the last numer, YYYY.
    private string getItemId(String itemId) {
        if(itemId.contains('/')) {
            return itemId.split('/')[1].trim();
        } else {
            return itemId;
        }
    }
    
    /***** Result Wrapper(s) *****/
    public class NTTResult
    {
        public Case nttCase = new Case();
        public List<NTT_History__c> nttHistoryList = new List<NTT_History__c>();
        public CaseProduct__c nttCaseProduct = new CaseProduct__c();
    }
}