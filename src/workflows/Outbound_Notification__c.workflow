<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>Send_Create_Notification_to_CINT</fullName>
        <apiVersion>29.0</apiVersion>
        <description>This is a general OBM that will send notifications to CINT letting them know a record has been inserted.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceObjectService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>Object_API_Name__c</fields>
        <fields>Object_External_ID__c</fields>
        <fields>Object_SFDC_ID__c</fields>
        <fields>Operation__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Create Notification to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Delete_Notification_to_CINT</fullName>
        <apiVersion>29.0</apiVersion>
        <description>This is a general OBM thtat will send notifications to CINT letting them know a record has been physically deleted.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/DeleteSalesforceObjectService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>Object_API_Name__c</fields>
        <fields>Object_External_ID__c</fields>
        <fields>Operation__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Delete Notification to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Update_Notification_to_CINT</fullName>
        <apiVersion>29.0</apiVersion>
        <description>This is a general OBM that will send notifications to CINT letting them know a record has been updated.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceObjectService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>Object_API_Name__c</fields>
        <fields>Object_External_ID__c</fields>
        <fields>Object_SFDC_ID__c</fields>
        <fields>Operation__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Update Notification to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Create Operation Updated - Send OBM</fullName>
        <actions>
            <name>Send_Create_Notification_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a record with the Operation set to INSERT is updated this workflow will fire and send an OBM to CINT to let them know about this.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false &amp;&amp; ISPICKVAL(Operation__c, &apos;INSERT&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Delete Operation Updated - Send OBM</fullName>
        <actions>
            <name>Send_Delete_Notification_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a record with the Operation set to deleted this workflow will fire and send a OBM to CINT to let them know about this.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false &amp;&amp; ISPICKVAL(Operation__c, &apos;DELETE&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Operation Updated - Send OBM</fullName>
        <actions>
            <name>Send_Update_Notification_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a record with the Operation set to UPDATE is updated this workflow will fire and send an OBM to CINT to let them know about this.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false &amp;&amp; ISPICKVAL(Operation__c, &apos;UPDATE&apos;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
