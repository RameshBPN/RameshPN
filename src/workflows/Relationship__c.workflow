<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Relationship_Compound_Key</fullName>
        <description>This field update will set the compound key of the relationship object.</description>
        <field>Relationship_Compound_SFID__c</field>
        <formula>Account__r.Involved_Party_ID__c &amp; &quot;:&quot; &amp;  TEXT(Relationship_Type__c) &amp; &quot;:&quot; &amp;  TEXT(Sales_Area__c) &amp; &quot;:&quot; &amp; TEXT(Distribution_Channel__c) &amp; &quot;:&quot; &amp; TEXT(Division__c) &amp; &quot;:&quot; &amp; Related_Account__r.Involved_Party_ID__c</formula>
        <name>Set Relationship Compound Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Acc_Corp_Reg_Nr</fullName>
        <field>Account_Corporate_Registration_Number__c</field>
        <formula>Account__r.Corporate_Registration_Number__c</formula>
        <name>Set/Update Acc Corp Reg Nr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Acc_Involved_Party_ID</fullName>
        <field>Account_Involved_Party_ID__c</field>
        <formula>Account__r.Involved_Party_ID__c</formula>
        <name>Set/Update Acc Involved Party ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Acc_Name</fullName>
        <field>Account_Name__c</field>
        <formula>Account__r.Name</formula>
        <name>Set/Update Acc Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Acc_Search_for_IDs</fullName>
        <field>Account_Search_for_IDs__c</field>
        <formula>Account__r.Involved_Party_ID__c&amp;&quot;+&quot;&amp;Account__r.Ella_Production_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.DPD_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.Production_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.DK_SAP_ERP__c&amp;&quot;+&quot;&amp;Account__r.Old_Customer_Number_Ella__c&amp;&quot;+&quot;&amp; Account__r.Old_Customer_Number_Orfa__c</formula>
        <name>Set/Update Acc Search for IDs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Rel_Acc_Corp_Reg_Nr</fullName>
        <field>Rel_Acc_Corporate_Registration_Number__c</field>
        <formula>Related_Account__r.Corporate_Registration_Number__c</formula>
        <name>Set/Update Rel Acc Corp Reg Nr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Rel_Acc_Involved_Party_ID</fullName>
        <field>Rel_Account_Involved_Party_ID__c</field>
        <formula>Related_Account__r.Involved_Party_ID__c</formula>
        <name>Set/Update Rel Acc Involved Party ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Rel_Acc_Name</fullName>
        <field>Related_Account_Name__c</field>
        <formula>Related_Account__r.Name</formula>
        <name>Set/Update Rel Acc Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Rel_Acc_Search_for_IDs</fullName>
        <field>Rel_Acc_Search_for_IDs__c</field>
        <formula>Related_Account__r.Involved_Party_ID__c&amp;&quot;+&quot;&amp;Related_Account__r.Ella_Production_Customer_Number__c&amp;&quot;+&quot;&amp;Related_Account__r.DPD_Customer_Number__c&amp;&quot;+&quot;&amp;Related_Account__r.Production_Customer_Number__c&amp;&quot;+&quot;&amp;Related_Account__r.DK_SAP_ERP__c&amp;&quot;+&quot;&amp;Related_Account__r.Old_Customer_Number_Ella__c&amp;&quot;+&quot;&amp; Related_Account__r.Old_Customer_Number_Orfa__c</formula>
        <name>Set/Update Rel Acc Search for IDs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_Relationship_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a relationship is created, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceRelationshipService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New Relationship to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Relationship_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a relationship is updated (not created), information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceRelationshipService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Relationship to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>New Relationship Created - Send OBM</fullName>
        <actions>
            <name>Send_New_Relationship_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a relationship is created send info to CINT layer.</description>
        <formula>Relationship_Compound_SFID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Relationship Created - Set CRM Compound Key</fullName>
        <actions>
            <name>Set_Relationship_Compound_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the CRM compound key of the relationship object which will be used as an external ID.</description>
        <formula>Account__r.Involved_Party_ID__c &lt;&gt; null &amp;&amp; NOT(ISPICKVAL(Relationship_Type__c, &apos;&apos;)) &amp;&amp; NOT(ISPICKVAL(Sales_Area__c, &apos;&apos;)) &amp;&amp; NOT(ISPICKVAL(Distribution_Channel__c, &apos;&apos;)) &amp;&amp; NOT(ISPICKVAL(Division__c, &apos;&apos;)) &amp;&amp; Related_Account__r.Involved_Party_ID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set%2FUpdate ID%27s for Searching</fullName>
        <actions>
            <name>Set_Update_Acc_Corp_Reg_Nr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Acc_Involved_Party_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Acc_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Acc_Search_for_IDs</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Rel_Acc_Corp_Reg_Nr</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Rel_Acc_Involved_Party_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Rel_Acc_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Rel_Acc_Search_for_IDs</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To allow relationships to appear in global search results, the name, Corp Reg Numbers, Involved Party ID and other IDs of the account related need to be copied into text fields on the relationship object.</description>
        <formula>1=1 &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Relationship - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Relationship_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a relationship is updated (not created) send info to CINT layer.</description>
        <formula>ISNEW()=false &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
