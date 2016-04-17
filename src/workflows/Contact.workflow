<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Copy_Account_Involved_Party_ID_to_Contac</fullName>
        <field>Account_Involved_Party_ID__c</field>
        <formula>Account.Involved_Party_ID__c</formula>
        <name>Copy Account Involved Party ID to Contac</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Campaign_task_field_on_Contact</fullName>
        <field>Campaign_Task__c</field>
        <literalValue>NO TASK</literalValue>
        <name>Reset Campaign task field on Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Language_Danish</fullName>
        <field>Language__c</field>
        <literalValue>da</literalValue>
        <name>Set Contact Language Danish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Language_Finish</fullName>
        <field>Language__c</field>
        <literalValue>fi</literalValue>
        <name>Set Contact Language Finish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Language_Norwegian</fullName>
        <field>Language__c</field>
        <literalValue>no</literalValue>
        <name>Set Contact Language Norwegian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Language_Swedish</fullName>
        <field>Language__c</field>
        <literalValue>sv</literalValue>
        <name>Set Contact Language Swedish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Owner_to_System_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>system.account.owner@postnord.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Contact Owner to System Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contact_Person_ID_From_Counter</fullName>
        <description>This field update will set the Contact Person ID value from the Contact Person ID Counter Auto-Number field, only if the contact is created by a non-integration user.</description>
        <field>Contact_Person_ID__c</field>
        <formula>Contact_Person_ID_Counter__c</formula>
        <name>Set Contact Person ID From Counter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Permission</fullName>
        <description>Set the field Permission to false</description>
        <field>Permission__c</field>
        <literalValue>0</literalValue>
        <name>Set Permission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Permission_channel</fullName>
        <description>Set the field Permission Channel  with blank</description>
        <field>Permission_Channel__c</field>
        <name>Set Permission channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_Contact_Person</fullName>
        <description>This field update will set the B2B record type to contact person.</description>
        <field>RecordTypeId</field>
        <lookupValue>Contact_Person</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to Contact Person</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Verified_to_Y_Contact</fullName>
        <field>Verified__c</field>
        <literalValue>Y</literalValue>
        <name>Set Verified to Y - Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_PostNord_Employee_Account</fullName>
        <description>This field update sets the account of the PN employee on the contact object. This is used on the case as goodwill initiated by unit reference.</description>
        <field>Account_Text__c</field>
        <formula>Account.Name</formula>
        <name>Update PostNord Employee Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_Contact_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When an contact is created, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceContactService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New Contact to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Contact_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When an contact is updated (not created), information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceContactService_v0100</endpointUrl>
        <fields>Deletion_Flag__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Contact to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Copy Account Involved Party ID to Contact</fullName>
        <actions>
            <name>Copy_Account_Involved_Party_ID_to_Contac</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For searching and lookup search filtering purposes, copy the account involved party ID to the contact record</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Contact Created - Send OBM</fullName>
        <actions>
            <name>Send_New_Contact_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a contact is created send info to CINT layer. Only run for record type Contact Person and when the Contact Person Id has been set.</description>
        <formula>RecordType.DeveloperName = &apos;Contact_Person&apos; &amp;&amp;  Contact_Person_ID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Contact Created by a Non-Integration User Profile - Set Contact Person ID</fullName>
        <actions>
            <name>Set_Contact_Person_ID_From_Counter</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will trigger if a new contact is created and user profile creating the contact is not an integration user. This will then copy the value from the Contact Person ID Counter to the Contact Person ID.</description>
        <formula>$Profile.Name !=  $Setup.Get2OneCRM__c.Integration_Profile_Name__c &amp;&amp; $Profile.Name !=  $Setup.Get2OneCRM__c.Integration_CRM_Webservices_Profile_Name__c &amp;&amp;  ISBLANK(Contact_Person_ID__c)&amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Customer Responsible a task from Marketo PDK BE</fullName>
        <actions>
            <name>Reset_Campaign_task_field_on_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_Campaign_Task_Call_Contact</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>If Marketo sets a Campaign task field to PDK BE, assign a task to the PDK Customer Responsible and reset the campaign task field. If the Subject of the Task is changed the Custom setting Get2OneCRM.Call_Contact_Task_Name__c has to be changed to match.</description>
        <formula>ISPICKVAL(Campaign_Task__c,&apos;PDK BE&apos;) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Send Customer Responsible a task from Marketo PDK LO</fullName>
        <actions>
            <name>Reset_Campaign_task_field_on_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Campaign_Task_Call_Contact_PDK_LO</name>
            <type>Task</type>
        </actions>
        <active>false</active>
        <description>If Marketo sets a Campaign task field to PDK LO, assign a task to the PDK Customer Responsible and reset the campaign task field. If the Subject of the Task is changed the Custom setting Get2OneCRM.Call_Contact_Task_Name__c has to be changed to match.</description>
        <formula>ISPICKVAL(Campaign_Task__c,&apos;PDK LO&apos;) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Contact Owner to System Owner</fullName>
        <actions>
            <name>Set_Contact_Owner_to_System_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>All contacts will be owned by the system. On create of a contact record this workflow will set the owner to a system user. The owner field will not be visible on page layouts</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Contact Create DK</fullName>
        <actions>
            <name>Set_Contact_Language_Danish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When contact is created automatically (via PAR for example), some extra mandatory fields must be set so the account can be accepted by SAP</description>
        <formula>AND( ISPICKVAL(Language__c, &apos;&apos;),  OR(Account.RecordType.DeveloperName = &apos;Competitor&apos;, Account.RecordType.DeveloperName = &apos;External_Partner&apos;, Account.RecordType.DeveloperName = &apos;Work_Site&apos;,  Account.RecordType.DeveloperName = &apos;Legal_Entity&apos;) ,  OR( ISPICKVAL(Account.Postal_Address_Country__c,&apos;DK&apos;), ISPICKVAL($User.Sales_Area1__c,&apos;1000&apos;),ISPICKVAL($User.Sales_Area1__c,&apos;0540&apos;),ISPICKVAL($User.Sales_Area1__c,&apos;4000&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Contact Create FI</fullName>
        <actions>
            <name>Set_Contact_Language_Finish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When contact is created automatically (via PAR for example), some extra mandatory fields must be set so the account can be accepted by SAP</description>
        <formula>AND( ISPICKVAL(Language__c, &apos;&apos;),  OR(Account.RecordType.DeveloperName = &apos;Competitor&apos;, Account.RecordType.DeveloperName = &apos;External_Partner&apos;, Account.RecordType.DeveloperName = &apos;Work_Site&apos;,  Account.RecordType.DeveloperName = &apos;Legal_Entity&apos;) ,  OR( ISPICKVAL(Account.Postal_Address_Country__c,&apos;FI&apos;), ISPICKVAL($User.Sales_Area1__c,&apos;3670&apos;),ISPICKVAL($User.Sales_Area1__c,&apos;0630&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Contact Create NO</fullName>
        <actions>
            <name>Set_Contact_Language_Norwegian</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When contact is created automatically (via PAR for example), some extra mandatory fields must be set so the account can be accepted by SAP</description>
        <formula>AND( ISPICKVAL(Language__c, &apos;&apos;),  OR(Account.RecordType.DeveloperName = &apos;Competitor&apos;, Account.RecordType.DeveloperName = &apos;External_Partner&apos;, Account.RecordType.DeveloperName = &apos;Work_Site&apos;,  Account.RecordType.DeveloperName = &apos;Legal_Entity&apos;) ,  OR( ISPICKVAL(Account.Postal_Address_Country__c,&apos;NO&apos;), ISPICKVAL($User.Sales_Area1__c,&apos;LO NO&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Contact Create SE</fullName>
        <actions>
            <name>Set_Contact_Language_Swedish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When contact is created automatically (via PAR for example), some extra mandatory fields must be set so the account can be accepted by SAP</description>
        <formula>AND( ISPICKVAL(Language__c, &apos;&apos;),  OR(Account.RecordType.DeveloperName = &apos;Competitor&apos;, Account.RecordType.DeveloperName = &apos;External_Partner&apos;, Account.RecordType.DeveloperName= &apos;Work_Site&apos;, Account.RecordType.DeveloperName= &apos;Legal_Entity&apos;) , OR( ISPICKVAL(Account.Postal_Address_Country__c,&apos;SE&apos;), ISPICKVAL($User.Sales_Area1__c,&apos;FO91&apos;),ISPICKVAL($User.Sales_Area1__c,&apos;FO92&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Verified to Y - Contact</fullName>
        <actions>
            <name>Set_Verified_to_Y_Contact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If External provider Party ID is populated, set Verified field to Y</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false &amp;&amp; LEN ( External_Provider_Party_ID__c ) &gt; 0</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set blank on Permission Channel field</fullName>
        <actions>
            <name>Set_Permission_channel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the field Email is changed then the workflow must update the field permission channel to blank</description>
        <formula>AND($Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false, NOT(ISBLANK(PRIORVALUE(Email))), ISCHANGED(Email))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set blank on Permission field</fullName>
        <actions>
            <name>Set_Permission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the field Email is changed then the workflow must update the field permission  to blank</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false &amp;&amp; ISCHANGED(Email)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set the PN Account Name on the PN Employees</fullName>
        <actions>
            <name>Update_PostNord_Employee_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the PN account on the PN employee contact. This field is used on case to fetch the goodwill initiated by user.</description>
        <formula>OR( RecordType.DeveloperName = &quot;PostNord_Employee&quot;,  ISCHANGED( AccountId )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Contact - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Contact_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a contact is updated (not created) send info to CINT layer. Only run for Record Type Contact Person.</description>
        <formula>ISNEW()=false &amp;&amp;  RecordType.DeveloperName = &apos;Contact_Person&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Campaign_Task_Call_Contact_PDK_LO</fullName>
        <assignedTo>PDK LO - Customer Responsible</assignedTo>
        <assignedToType>accountTeam</assignedToType>
        <description>{!Contact.MKTO_Campaign_Name__c}</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>Campaign Task - Call Contact - PDK LO</subject>
    </tasks>
    <tasks>
        <fullName>PDK_BE_Campaign_Task_Call_Contact</fullName>
        <assignedTo>PN DK - Customer Responsible</assignedTo>
        <assignedToType>accountTeam</assignedToType>
        <description>{!Contact.MKTO_Campaign_Name__c}</description>
        <dueDateOffset>7</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>PN DK Campaign Task - Call Contact</subject>
    </tasks>
</Workflow>
