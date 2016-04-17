<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Process_as_Integration_User_flag</fullName>
        <description>Clear Process as Integration User flag. Flag is to allow custom code force triggers (where set) to process an Account update as an integration user, ex. when enriching an account from PAR.</description>
        <field>Process_as_Integration_User__c</field>
        <literalValue>0</literalValue>
        <name>Clear Process as Integration User flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Corp_Reg_Nr_fr_Parent_Acc</fullName>
        <field>Corporate_Registration_Number__c</field>
        <formula>Parent.Corporate_Registration_Number__c</formula>
        <name>Copy Corp Reg Nr fr Parent Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Postal_C_O_fr_Parent_Acc</fullName>
        <field>Postal_Address_C_O__c</field>
        <formula>Parent.Postal_Address_C_O__c</formula>
        <name>Copy Postal C/O fr Parent Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_VAT_Number_fr_Parent_Acc</fullName>
        <field>VAT_Number__c</field>
        <formula>Parent.VAT_Number__c</formula>
        <name>Copy VAT Number fr Parent Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_group_parent_Reg_Nr_fr_Parent_Acc</fullName>
        <field>Group_Parent_Corporate_Registration_Nr__c</field>
        <formula>Parent.Group_Parent_Corporate_Registration_Nr__c</formula>
        <name>Copy group parent Reg Nr fr Parent Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_group_parent_country_fr_Parent_Acc</fullName>
        <field>Group_Parent_Registration_Country__c</field>
        <formula>Parent.Group_Parent_Registration_Country__c</formula>
        <name>Copy group parent country fr Parent Acc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Source_Field_Update_to_CS</fullName>
        <description>Update Data Source Field as - Customer Services</description>
        <field>DataSource__c</field>
        <literalValue>Customer services</literalValue>
        <name>Data Source Field Update_to_CS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Source_Field_Update_to_Webshop</fullName>
        <description>Update Data Source Field as - Webshop</description>
        <field>DataSource__c</field>
        <literalValue>Webshop</literalValue>
        <name>Data Source Field Update_to_Webshop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reformat_Postal_Address_Postal_Code</fullName>
        <description>If the Swedish Postal Address Postal Code is 5 numbers it has to be reformatted to 6 chars with a space between the 3rd and 4rth number. Example: 12345 -&gt; 123 45 or 12 345 -&gt; 123 45</description>
        <field>Postal_Address_Postal_Code__c</field>
        <formula>LEFT(SUBSTITUTE(Postal_Address_Postal_Code__c, &quot; &quot;, &quot;&quot;), 3) + &quot; &quot; + RIGHT(SUBSTITUTE(Postal_Address_Postal_Code__c, &quot; &quot;, &quot;&quot;), 2)</formula>
        <name>Reformat Postal Address Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reformat_Visiting_Address_Postal_Code</fullName>
        <description>If the Swedish Visiting Address Postal Code is 5 chars it has to be reformatted to 6 chars with a space between the 3rd and 4rth number. Example: 12345 -&gt; 123 45</description>
        <field>Visiting_Address_Postal_Code__c</field>
        <formula>LEFT(SUBSTITUTE(Visiting_Address_Postal_Code__c, &quot; &quot;, &quot;&quot;), 3) + &quot; &quot; + RIGHT(SUBSTITUTE(Visiting_Address_Postal_Code__c, &quot; &quot;, &quot;&quot;), 2)</formula>
        <name>Reformat Visiting Address Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Owner_to_System_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>system.account.owner@postnord.com</lookupValue>
        <lookupValueType>User</lookupValueType>
        <name>Set Account Owner to System Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Competitor_Checkbox_True</fullName>
        <field>Competitor__c</field>
        <literalValue>1</literalValue>
        <name>Set Competitor Checkbox True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Converted_From_Webshop_Dummy_Checked</fullName>
        <description>This field update will check the converted from webshop checkbox.</description>
        <field>Converted_From_Webshop_Dummy__c</field>
        <literalValue>1</literalValue>
        <name>Set Converted From Webshop Dummy Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Extension_to_Active_Order_Registrar</fullName>
        <field>Is_Active_Order_Registrar_Number__c</field>
        <literalValue>1</literalValue>
        <name>Set Extension to Active Order Registrar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Extension_to_Customer</fullName>
        <field>Type</field>
        <literalValue>Customer</literalValue>
        <name>Set Extension to Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Is_MOD_Validated_Flag_to_True</fullName>
        <field>Is_MOD_Validated__c</field>
        <literalValue>1</literalValue>
        <name>Set Is MOD Validated Flag to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Language_Danish</fullName>
        <field>Language__c</field>
        <literalValue>da</literalValue>
        <name>Set Language Danish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Language_Finnish</fullName>
        <field>Language__c</field>
        <literalValue>fi</literalValue>
        <name>Set Language Finnish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Language_Norwegian</fullName>
        <field>Language__c</field>
        <literalValue>no</literalValue>
        <name>Set Language Norwegian</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Language_Swedish</fullName>
        <field>Language__c</field>
        <literalValue>sv</literalValue>
        <name>Set Language Swedish</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_PN_Mark_as_Synced_to_True</fullName>
        <description>This will set the PN Mark as Synced to true. This is usually done by CINT but when the Webshop customers are created this is done by the field update.</description>
        <field>PN_Mark_As_Synced__c</field>
        <literalValue>1</literalValue>
        <name>Set PN Mark as Synced to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Permission</fullName>
        <description>Set the field Permission with blank</description>
        <field>Permission__pc</field>
        <literalValue>0</literalValue>
        <name>Set Permission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Permission_channel</fullName>
        <description>Set the field Permission Channel with blank</description>
        <field>Permission_Channel__pc</field>
        <name>Set Permission channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_Private_Person</fullName>
        <description>This field update will set the record type to Private Person.</description>
        <field>RecordTypeId</field>
        <lookupValue>PersonAccount</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to Private Person</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Record_Type_to_WS</fullName>
        <description>This field update will set the B2B record type to worksite.</description>
        <field>RecordTypeId</field>
        <lookupValue>Work_Site</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Record Type to WS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reg_Country_DE</fullName>
        <field>Registration_Country__c</field>
        <literalValue>DE</literalValue>
        <name>Set Reg Country DE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reg_Country_DK</fullName>
        <field>Registration_Country__c</field>
        <literalValue>DK</literalValue>
        <name>Set Reg Country DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reg_Country_FI</fullName>
        <field>Registration_Country__c</field>
        <literalValue>FI</literalValue>
        <name>Set Reg Country FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reg_Country_NO</fullName>
        <field>Registration_Country__c</field>
        <literalValue>NO</literalValue>
        <name>Set Reg Country NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Reg_Country_SE</fullName>
        <field>Registration_Country__c</field>
        <literalValue>SE</literalValue>
        <name>Set Reg Country SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Account_Old_Customer_Number</fullName>
        <field>Old_Customer_Number__c</field>
        <formula>IF (LEN(Old_Customer_Number_Ella__c) &gt; 0,  Old_Customer_Number_Ella__c,
Old_Customer_Number_Orfa__c)</formula>
        <name>Set/Update Account Old Customer Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Verified_to_Y_Account</fullName>
        <field>Verified__c</field>
        <literalValue>Y</literalValue>
        <name>Set Verified to Y - Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Webshop_B2B_Name</fullName>
        <description>This field update will set the Webshop B2B Name from a custom setting.</description>
        <field>Name</field>
        <formula>$Setup.Get2OneCRM__c.Webshop_B2B_Name__c</formula>
        <name>Set Webshop B2B Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Webshop_B2C_Name</fullName>
        <description>This field update will set the Webshop B2B Name from a custom setting.</description>
        <field>LastName</field>
        <formula>$Setup.Get2OneCRM__c.Webshop_B2C_Name__c</formula>
        <name>Set Webshop B2C Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Webshop_Origin</fullName>
        <description>This field update will set the origin value on the account to Netbutikken.</description>
        <field>Origin__c</field>
        <formula>$Setup.Get2OneCRM__c.Webshop_Origin__c</formula>
        <name>Set Webshop Origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Webshop_Unverified</fullName>
        <description>This field update will set the account to unverified. This is done for both B2B and B2C.</description>
        <field>Verified__c</field>
        <literalValue>N</literalValue>
        <name>Set Webshop Unverified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Work_Site_Type</fullName>
        <field>Work_Site_Type__c</field>
        <literalValue>TY99</literalValue>
        <name>Set Work Site Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_the_standard_email_on_private_person</fullName>
        <field>PersonEmail</field>
        <formula>Email_Address__c</formula>
        <name>Set the standard email on private person</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Is_Active_Order_Registrar</fullName>
        <field>Is_Active_Order_Registrar_Number__c</field>
        <literalValue>1</literalValue>
        <name>Update Is Active Order Registrar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Seach_IDs_field</fullName>
        <field>Search_for_IDs__c</field>
        <formula>Involved_Party_ID__c&amp;&quot;+&quot;&amp;Ella_Production_Customer_Number__c&amp;&quot;+&quot;&amp;DPD_Customer_Number__c&amp;&quot;+&quot;&amp;Production_Customer_Number__c&amp;&quot;+&quot;&amp;DK_SAP_ERP__c&amp;&quot;+&quot;&amp;Old_Customer_Number_Ella__c&amp;&quot;+&quot;&amp; Old_Customer_Number_Orfa__c</formula>
        <name>Update Seach IDs field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_email_as_blank</fullName>
        <field>PersonEmail</field>
        <name>Update email as blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_Account_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When an account is created, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceAccountService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <fields>Record_Type_Developer_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New Account to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Account_to_CINT</fullName>
        <apiVersion>26.0</apiVersion>
        <description>When an account is updated (not created), information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceAccountService_v0100</endpointUrl>
        <fields>Deletion_Flag__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <fields>Record_Type_Developer_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Account to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Parent_Account_to_CINT</fullName>
        <apiVersion>28.0</apiVersion>
        <description>When an account is updated (not created) and one of the fields that is updated is the Parent lookup, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/ChangeParentSalesforceAccountService_v0100</endpointUrl>
        <fields>Deletion_Flag__c</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <fields>Record_Type_Developer_Name__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Parent Account to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Clear code flags</fullName>
        <actions>
            <name>Clear_Process_as_Integration_User_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears flags set by custom code that should not persist</description>
        <formula>Process_as_Integration_User__c = true &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy email address to the standard email field</fullName>
        <actions>
            <name>Set_the_standard_email_on_private_person</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the email address entered on the private person to the standard email field</description>
        <formula>Record_Type_Developer_Name__c  = &apos;PersonAccount&apos; &amp;&amp; Email_Address__c &lt;&gt; &apos;&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Delete email address on the standard email field</fullName>
        <actions>
            <name>Update_email_as_blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule deletes the email address in the standard email field on PP when the custom email address is deleted.</description>
        <formula>Record_Type_Developer_Name__c  = &apos;PersonAccount&apos; &amp;&amp; Email_Address__c = &apos;&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Get LE data on WS create</fullName>
        <actions>
            <name>Copy_group_parent_Reg_Nr_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_group_parent_country_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the WS is created it will be updated with information that is fetched from the parent LE.</description>
        <formula>RecordType.Name == $Label.RecordType_Account_WS &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Get WS data on Extension create</fullName>
        <actions>
            <name>Copy_Corp_Reg_Nr_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_VAT_Number_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_group_parent_Reg_Nr_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_group_parent_country_fr_Parent_Acc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Extension_to_Active_Order_Registrar</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Extension_to_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the Extension is created it will be updated with information that is fetched from the parent WS.</description>
        <formula>RecordType.Name == $Label.RecordType_Account_Ext &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Account Created - Send OBM</fullName>
        <actions>
            <name>Send_New_Account_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When an account is created send info to CINT layer. Not fired if record type is PostNord Ord Structure.</description>
        <formula>RecordType.DeveloperName != &apos;PostNord_Org_Structure&apos; &amp;&amp; Involved_Party_ID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate ID Search Text</fullName>
        <actions>
            <name>Set_Update_Account_Old_Customer_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Seach_IDs_field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate text field on Account with various IDs to allow for searching above the 6 filters allowed on lookup searches</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Source Filed for B2C Customers</fullName>
        <actions>
            <name>Data_Source_Field_Update_to_Webshop</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Source Filed for B2C Webshop Placeholder created by Netbutikken</description>
        <formula>AND(RecordType.DeveloperName = &apos;B2C_Webshop_Placeholder&apos; ,  OR(  $Profile.Name=$Setup.Get2OneCRM__c.Integration_Profile_Name__c,  $Profile.Name=$Setup.Get2OneCRM__c.Integration_Read_Only_Profile_Name__c,  $Profile.Name=$Setup.Get2OneCRM__c.Integration_CRM_Webservices_Profile_Name__c),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Source Filed for Private PersonCustomers</fullName>
        <actions>
            <name>Data_Source_Field_Update_to_CS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate Source Filed for Private Person Accounts created by Customer Service Employees</description>
        <formula>AND(RecordType.DeveloperName = &apos;PersonAccount&apos;,  $Profile.Name=$Setup.Get2OneCRM__c.CS_Standard_User_PDK_BE_Profile_Name__c,  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Record Type set to Competitor</fullName>
        <actions>
            <name>Set_Competitor_Checkbox_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the record type is set to Competitor set the competitor checkbox.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false &amp;&amp; RecordType.DeveloperName = &apos;Competitor&apos;</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Reformat Postal Address Postal Code</fullName>
        <actions>
            <name>Reformat_Postal_Address_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Swedish Postal Address Postal Code is 5 chars it has to be reformatted to 6 chars with a space between the 3rd and 4th number. Example: 12345 -&gt; 123 45</description>
        <formula>AND( ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;), (LEN( Postal_Address_Postal_Code__c ) = 5 || LEN( Postal_Address_Postal_Code__c ) = 6) ) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reformat Visiting Address Postal Code</fullName>
        <actions>
            <name>Reformat_Visiting_Address_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the Swedish Visiting Address Postal Code is 5 chars it has to be reformatted to 6 chars with a space between the 3rd and 4th number. Example: 12345 -&gt; 123 45</description>
        <formula>AND(  ISPICKVAL(Visiting_Address_Country__c, &apos;SE&apos;),  (LEN( Visiting_Address_Postal_Code__c ) = 5 || LEN( Visiting_Address_Postal_Code__c ) = 6)  ) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Owner to System Owner</fullName>
        <actions>
            <name>Set_Account_Owner_to_System_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>No accounts should be owned by end users. This workflow sets the owner of an account to a system user on create. The owner field will not be visible on any account page layouts.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Is MOD Validated flag</fullName>
        <actions>
            <name>Set_Is_MOD_Validated_Flag_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a private person or account is created through the customer create process, check the Is MOD Validated flag if the MODtager number is not blank</description>
        <formula>LEN( MOD_Modtager_Number__c ) &gt; 0 &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Account Create DK</fullName>
        <actions>
            <name>Set_Language_Danish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When account is created automatically (via PAR for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private person and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;, RecordType.DeveloperName = &apos;External_Partner&apos;, RecordType.DeveloperName = &apos;Legal_Entity&apos;, RecordType.DeveloperName = &apos;Work_Site&apos;, RecordType.DeveloperName = &apos;PersonAccount&apos;) &amp;&amp; ISPICKVAL(Language__c, &apos;&apos;)  &amp;&amp; OR(ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;), ISPICKVAL($User.Sales_Area1__c, &apos;1000&apos;), ISPICKVAL($User.Sales_Area1__c, &apos;4000&apos;), ISPICKVAL($User.Sales_Area1__c, &apos;0540&apos;))  &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Account Create FI</fullName>
        <actions>
            <name>Set_Language_Finnish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When account is created automatically (via PAR for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Language__c, &apos;&apos;)  &amp;&amp;  OR(ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;),  ISPICKVAL($User.Sales_Area1__c, &apos;3670&apos;),  ISPICKVAL($User.Sales_Area1__c, &apos;0630&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Account Create NO</fullName>
        <actions>
            <name>Set_Language_Norwegian</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When account is created automatically (via PAR for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Language__c, &apos;&apos;)  &amp;&amp;  OR(ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;), ISPICKVAL($User.Sales_Area1__c, &apos;LO NO&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Language on Account Create SE</fullName>
        <actions>
            <name>Set_Language_Swedish</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When account is created automatically (via PAR for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Language__c, &apos;&apos;)  &amp;&amp;  OR(ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;),  ISPICKVAL($User.Sales_Area1__c, &apos;FO91&apos;),  ISPICKVAL($User.Sales_Area1__c, &apos;FO92&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create DE</fullName>
        <actions>
            <name>Set_Reg_Country_DE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  ISPICKVAL(Postal_Address_Country__c, &apos;DE&apos;) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create DK</fullName>
        <actions>
            <name>Set_Reg_Country_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;)  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create DK - User SA based</fullName>
        <actions>
            <name>Set_Reg_Country_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner.</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DE&apos;)) &amp;&amp;  OR(ISPICKVAL( $User.Sales_Area1__c , &apos;1000&apos;), ISPICKVAL( $User.Sales_Area1__c , &apos;0540&apos;), ISPICKVAL( $User.Sales_Area1__c , &apos;4000&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create FI</fullName>
        <actions>
            <name>Set_Reg_Country_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;)  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create FI - User SA based</fullName>
        <actions>
            <name>Set_Reg_Country_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner.</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DE&apos;)) &amp;&amp;  OR(ISPICKVAL( $User.Sales_Area1__c , &apos;3670&apos;), ISPICKVAL( $User.Sales_Area1__c , &apos;0630&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create NO</fullName>
        <actions>
            <name>Set_Reg_Country_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;)  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create NO - User SA based</fullName>
        <actions>
            <name>Set_Reg_Country_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner.</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DE&apos;)) &amp;&amp;  ISPICKVAL( $User.Sales_Area1__c , &apos;LO NO&apos;) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create SE</fullName>
        <actions>
            <name>Set_Reg_Country_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner.</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;)  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Mandatory Field Registration Country on Account Create SE - User SA based</fullName>
        <actions>
            <name>Set_Reg_Country_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When account is created automatically (via PAR/Lead Convert for example, some extra mandatory fields must be set so the account can be accepted by SAP. Applies to Record Types Legal Entity, Work Site, Competitor, Private Person and External Partner.</description>
        <formula>OR(RecordType.DeveloperName = &apos;Competitor&apos;,  RecordType.DeveloperName = &apos;External_Partner&apos;,  RecordType.DeveloperName = &apos;Legal_Entity&apos;,  RecordType.DeveloperName = &apos;Work_Site&apos;,  RecordType.DeveloperName = &apos;PersonAccount&apos;)  &amp;&amp;  ISPICKVAL(Registration_Country__c, &apos;&apos;)  &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;SE&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DK&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;FI&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;NO&apos;)) &amp;&amp;  NOT(ISPICKVAL(Postal_Address_Country__c, &apos;DE&apos;)) &amp;&amp;  OR(ISPICKVAL( $User.Sales_Area1__c , &apos;FO91&apos;), ISPICKVAL( $User.Sales_Area1__c , &apos;FO92&apos;))  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Verified to Y - Account</fullName>
        <actions>
            <name>Set_Verified_to_Y_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When External Provider Party ID is populated on Account, set Verified field to Y</description>
        <formula>LEN ( External_Provider_Party_ID__c ) &gt; 0 &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Work Site Type on Work Site if blank</fullName>
        <actions>
            <name>Set_Work_Site_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Work Site Type is mandatory and if it&apos;s blank pre-fill it with &apos;Unknown&apos;</description>
        <formula>ISPICKVAL(Work_Site_Type__c, &apos;&apos;) &amp;&amp; RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
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
        <formula>AND($Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false, RecordType.DeveloperName = &apos;PersonAccount&apos;, NOT(ISBLANK(PRIORVALUE(Email_Address__c))), ISCHANGED(Email_Address__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set blank on Permission field</fullName>
        <actions>
            <name>Set_Permission</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If the field Email is changed then the workflow must update the field permission channel to blank</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false &amp;&amp; RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp; ISCHANGED(Email_Address__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Account - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Account_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When an account is updated (not created) send info to CINT layer. Not fired if record type is PostNord Ord Structure. This is also not fired if the Parent field has changed. If the Parent field has changed another OBM is fired.</description>
        <formula>ISNEW()=false &amp;&amp;  RecordType.DeveloperName &lt;&gt; &apos;PostNord_Org_Structure&apos; &amp;&amp; NOT(ISCHANGED( ParentId )) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update on Account ParentId - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Parent_Account_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When an account is updated (not created) and ParentId has been updated send info to CINT layer. Not fired if record type is PostNord Ord Structure.</description>
        <formula>ISNEW()=false &amp;&amp;  RecordType.DeveloperName &lt;&gt; &apos;PostNord_Org_Structure&apos; &amp;&amp;  ISCHANGED( ParentId ) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Webshop B2B Account Conversion</fullName>
        <actions>
            <name>Set_Converted_From_Webshop_Dummy_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Record_Type_to_WS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will react on a update on the Netbutikken Dummy &quot;name&quot; of the Account and convert it to a &quot;real&quot; customer. This is done when an integration user is updating dummy customer.</description>
        <formula>PRIORVALUE(Name) = $Setup.Get2OneCRM__c.Webshop_B2B_Name__c &amp;&amp;  RecordType.DeveloperName = &apos;B2B_Webshop_Placeholder&apos; &amp;&amp;($Profile.Name = $Setup.Get2OneCRM__c.Integration_Profile_Name__c || $Profile.Name = $Setup.Get2OneCRM__c.Integration_User_RealtimeUpsert_User__c ) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Webshop B2B New Account</fullName>
        <actions>
            <name>Set_PN_Mark_as_Synced_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_B2B_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_Origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_Unverified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set default values on the created B2B Webshop Account.</description>
        <formula>RecordType.DeveloperName = &apos;B2B_Webshop_Placeholder&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Webshop B2C Account Conversion</fullName>
        <actions>
            <name>Set_Converted_From_Webshop_Dummy_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Record_Type_to_Private_Person</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will react on the B2C dummy &quot;name&quot; of the Account and convert it ti a &quot;real&quot; customer. This is done when an integration user is updating dummy customer.</description>
        <formula>PRIORVALUE(LastName) = $Setup.Get2OneCRM__c.Webshop_B2C_Name__c  &amp;&amp;  RecordType.DeveloperName = &apos;B2C_Webshop_Placeholder&apos; &amp;&amp;  ( $Profile.Name = $Setup.Get2OneCRM__c.Integration_Profile_Name__c || $Profile.Name = $Setup.Get2OneCRM__c.Integration_User_RealtimeUpsert_User__c ) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Webshop B2C New Account</fullName>
        <actions>
            <name>Set_PN_Mark_as_Synced_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_B2C_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_Origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Webshop_Unverified</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set default values on the created B2C Webshop Account.</description>
        <formula>RecordType.DeveloperName = &apos;B2C_Webshop_Placeholder&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
