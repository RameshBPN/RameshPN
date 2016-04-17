<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Ignore_Validation_Rule_flag</fullName>
        <field>Ignore_ACR_Validation_Rules__c</field>
        <literalValue>0</literalValue>
        <name>Clear Ignore Validation Rule flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACRT_Compound_Key</fullName>
        <description>This field update will set the compound key on the ACRT object.</description>
        <field>Account_Contact_Role_SFID__c</field>
        <formula>Account__r.Involved_Party_ID__c &amp; &quot;:&quot; &amp;  Contact__r.Contact_Person_ID__c</formula>
        <name>Set ACRT Compound Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Account_Name_Text</fullName>
        <field>Account_Name__c</field>
        <formula>Account__r.Name</formula>
        <name>Set ACR Account Name Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Account_Parent_Account</fullName>
        <field>Account_Parent_Account__c</field>
        <formula>Account__r.Parent.Name</formula>
        <name>Set ACR Account Parent Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Contact_Email</fullName>
        <field>Contact_Email__c</field>
        <formula>Contact__r.Email</formula>
        <name>Set ACR Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Contact_Mobile</fullName>
        <field>Contact_Mobile__c</field>
        <formula>Contact__r.MobilePhone</formula>
        <name>Set ACR Contact Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Contact_Name_Text</fullName>
        <field>Contact_Name__c</field>
        <formula>Contact__r.FirstName&amp;&quot; &quot;&amp; Contact__r.LastName</formula>
        <name>Set ACR Contact Name Text</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Contact_Phone</fullName>
        <field>Contact_Phone__c</field>
        <formula>Contact__r.Phone</formula>
        <name>Set ACR Contact Phone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_Contact_Record_Type</fullName>
        <field>Contact_Record_Type__c</field>
        <formula>Contact__r.RecordType.Name</formula>
        <name>Set ACR Contact Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_ACR_WS_Popular_Name</fullName>
        <field>Work_Site_Popular_Name__c</field>
        <formula>Account__r.Work_Site_Name__c</formula>
        <name>Set ACR WS Popular Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_ACRT_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When an account contact role transaction is created, information about the record is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceAccountContactRoleTransactionService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New ACRT to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_ACRT_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When an account contact role transaction is updated (not saved), information about the record is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceAccountContactRoleTransactionService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated ACRT to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Clear Ignore Validation Rule flag</fullName>
        <actions>
            <name>Clear_Ignore_Validation_Rule_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The Ignore Validation Rule flag gets set by code so that Positions on the ACR can be updated without flagging a validation rule. This rule clears that flag.</description>
        <formula>Ignore_ACR_Validation_Rules__c  = true &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>New Account Contact Role Transaction Created - Send OBM</fullName>
        <actions>
            <name>Send_New_ACRT_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When an existing account contact role transaction is created send info to CINT layer.</description>
        <formula>Account_Contact_Role_SFID__c &lt;&gt; null &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp; Contact__r.RecordType.DeveloperName = &apos;Contact_Person&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Account Contact Role Transaction Created - Setting the Compound Key</fullName>
        <actions>
            <name>Set_ACRT_Compound_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This worklow will set the compound key of the ACRT which will be used as an external ID when upserts are done in the integrations.</description>
        <formula>Account__r.Involved_Party_ID__c &lt;&gt; null &amp;&amp; Contact__r.Contact_Person_ID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Name fields for Searching</fullName>
        <actions>
            <name>Set_ACR_Account_Name_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Account_Parent_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Contact_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Contact_Name_Text</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Contact_Phone</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_Contact_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_ACR_WS_Popular_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of an ACR, populate text fields with Account and Contact Name so that the ACRs appear in global search</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update on Account Contact Role Transaction - Send OBM</fullName>
        <actions>
            <name>Send_Updated_ACRT_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When an existing account contact role transaction record is updated (not created) send info to the CINT layer.</description>
        <formula>ISNEW()=false &amp;&amp; Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  Contact__r.RecordType.DeveloperName = &apos;Contact_Person&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
