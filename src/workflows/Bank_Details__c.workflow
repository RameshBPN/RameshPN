<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Bank_Details_Compound_Key</fullName>
        <description>This field update will set the compound key of the bank details record.</description>
        <field>Bank_Details_Compound_SFID__c</field>
        <formula>Account__r.Involved_Party_ID__c &amp; &quot;:&quot; &amp; TEXT(Bank_Country__c) &amp; &quot;:&quot; &amp; Bank_Key__r.Name &amp; &quot;:&quot;  &amp; Bank_Account__c</formula>
        <name>Set Bank Details Compound Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_Bank_Details_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a bank detail is created, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceBankDetailsService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New Bank Details to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Bank_Details_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a bank detail is updated (not saved), information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceBankDetailsService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Bank Details to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>New Bank Detail Created - Send OBM</fullName>
        <actions>
            <name>Send_New_Bank_Details_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a bank detail is created send info to CINT layer.</description>
        <formula>Bank_Details_Compound_SFID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Bank Detail Created Setting the Compound Key</fullName>
        <actions>
            <name>Set_Bank_Details_Compound_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the external ID that is used for integrations.</description>
        <formula>Account__r.Involved_Party_ID__c &lt;&gt; null &amp;&amp; NOT(ISPICKVAL(Bank_Country__c, &apos;&apos;)) &amp;&amp; Bank_Key__r.Name &lt;&gt; null &amp;&amp; Bank_Account__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update on Bank Detail - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Bank_Details_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a bank detail is updated (not created) send info to CINT layer.</description>
        <formula>ISNEW()=false &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
