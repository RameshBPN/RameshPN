<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_weight_on_related_case_if_primary</fullName>
        <field>Weight_from_Primary_Product__c</field>
        <formula>Weight__c</formula>
        <name>Set weight on related case if primary</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Case__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NTT_Details</fullName>
        <field>NTT_Information__c</field>
        <formula>&quot;Product:&quot; &amp;  Service_Name__c &amp; BR() &amp; 
&quot;Code :&quot; &amp;  Service_Code__c &amp; BR() &amp; 
 &quot;Estimated Time of Arrival:&quot;  &amp;TEXT( Estimated_Time_of_Arrival__c ) &amp; BR() &amp; 
 &quot;Drop off date :&quot;  &amp;TEXT( Drop_off_date__c)  &amp; BR() &amp; 
 &quot;Status:&quot; &amp; Status__c &amp; BR() &amp; 
&quot;Status Description:&quot;  &amp; Status_description__c &amp; BR() &amp; 
&quot;Signature Name:&quot;  &amp;Signature_Name__c &amp; BR() &amp;
 &quot;COD Amount:&quot; &amp; COD_Amount__c  &amp; BR() &amp; 
&quot;COD Account Number:&quot;&amp; Account_Number__c &amp; BR() &amp;
&quot;Account Type:&quot;  &amp; TEXT(Account_Type__c) &amp; BR() &amp;
 &quot;Additional Service 1:&quot; &amp; Additional_Service_Name1__c &amp; BR() &amp; 
 &quot;Additional Service Code 1:&quot; &amp; Additional_Service_code1__c &amp; BR() &amp; 
 &quot;Additional Service 2:&quot; &amp; Additional_Service_Name2__c &amp; BR() &amp; 
 &quot;Additional Service Code 2:&quot; &amp; Additional_Service_code2__c &amp; BR() &amp; 
 &quot;Additional Service 3:&quot; &amp; Additional_Service_Name3__c &amp; BR() &amp; 
 &quot;Additional Service Code 3:&quot; &amp; Additional_Service_code3__c &amp; BR() &amp; 
 &quot;Additional Service 4:&quot; &amp; Additional_Service_Name4__c &amp; BR() &amp; 
 &quot;Additional Service Code 4:&quot; &amp; Additional_Service_code4__c &amp; BR() &amp;
&quot;Weight:&quot;  &amp;   Weight__c &amp; BR() &amp; 
&quot;Height:&quot;  &amp;  Height__c  &amp; BR() &amp; 
&quot;Length:&quot;  &amp;  Length__c  &amp; BR() &amp; 
&quot;Volume:&quot;  &amp;  Volume__c  &amp; BR() &amp; 
&quot;Width:&quot;  &amp;  Width__c &amp; BR() &amp;
&quot;Reference Name 1:&quot; &amp;  Reference_Name1__c  &amp; BR() &amp; 
&quot;Reference Type 1:&quot; &amp;  Reference_Type1__c  &amp; BR() &amp; 
&quot;Reference Value 1:&quot; &amp;  Reference_Value1__c</formula>
        <name>Update NTT Details</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_NTT_Details_2</fullName>
        <field>NTT_Information2__c</field>
        <formula>&quot;External Customer Number:&quot; &amp;  externalCustomerNumber__c  &amp; BR() &amp;  
&quot;SAP Customer Number:&quot; &amp;  sapCustomerNumber__c &amp; BR() &amp;  
&quot;Production Customer Number:&quot; &amp;   productionCustomerNumber__c  &amp; BR() &amp;  
&quot;Delivery Point Address 1:&quot; &amp;   DeliverPoint_address1__c &amp; BR() &amp;  
&quot;Delivery Point Address 2:&quot; &amp;   DeliverPoint_address2__c &amp; BR() &amp;  
&quot;Delivery Point City:&quot; &amp;   DeliverPoint_city__c &amp; BR() &amp;  
&quot;Delivery Point Postcode:&quot; &amp;    DeliverPoint_postalcode__c &amp; BR() &amp;  
&quot;Delivery Point Country:&quot; &amp;    Deliverypoint_country__c &amp; BR() &amp; 
&quot;Delivery Point Contact:&quot; &amp;    DeliveryPoint_Contact__c &amp; BR() &amp;  
&quot;Delivery Point Contact Mobile:&quot; &amp;    DeliveryPoint_ContactMobile__c &amp; BR() &amp;  
&quot;Delivery Point Contact Telephone:&quot; &amp;     DeliveryPoint_Contactphone__c &amp; BR() &amp;  
&quot;Delivery Point Contact email:&quot; &amp;  DeliveryPoint_Contactemail__c &amp; BR() &amp;
&quot;Opening Hours:&quot; &amp; BR() &amp;
 Opening_Hours__c &amp; BR() &amp;
&quot;FreightPayerName:&quot; &amp; FreightPayerName__c &amp; BR() &amp;
&quot;FreightPayerAddress1:&quot; &amp; FreightPayerAddress1__c &amp; BR() &amp;
&quot;FreightPayerAddress2:&quot; &amp; FreightPayerAddress2__c &amp; BR() &amp;
&quot;FreightPayerCity:&quot; &amp;  FreightPayerCity__c &amp; BR() &amp;
&quot;FreightPayerCountry:&quot; &amp;  FreightPayerCountry__c &amp; BR() &amp;
&quot;FreightPayerPostalCode:&quot; &amp;  FreightPayerPostalCode__c &amp; BR() &amp;
&quot;Reference Name 2:&quot; &amp;  Reference_Name2__c  &amp; BR() &amp; 
&quot;Reference Type 2:&quot; &amp;  Reference_Type2__c &amp; BR() &amp; 
&quot;Reference Value 2:&quot; &amp;  Reference_Value2__c &amp; BR() &amp;
&quot;Reference Name 3:&quot; &amp;  Reference_Name3__c  &amp; BR() &amp; 
&quot;Reference Type 3:&quot; &amp;  Reference_Type3__c &amp; BR() &amp; 
&quot;Reference Value 3:&quot; &amp;  Reference_Value3__c</formula>
        <name>Update NTT Details 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Concatenate all fields from NTT</fullName>
        <actions>
            <name>Update_NTT_Details</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CaseProduct__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow rule concatenates all fields in one long text area on the case product layout.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Concatenate all fields from NTT 2</fullName>
        <actions>
            <name>Update_NTT_Details_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CaseProduct__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This workflow rule concatenates all fields in one long text area on the case product layout.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set weight on related case if primary</fullName>
        <actions>
            <name>Set_weight_on_related_case_if_primary</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the field &quot;Weight from Primary Product&quot; on the related case, if the product is primary.</description>
        <formula>AND(  IsPrimary__c = TRUE,  NOT(ISBLANK(Case__c)),  NOT(ISBLANK(Weight__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
