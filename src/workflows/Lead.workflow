<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_disqualified_lead_email_to_lead_identifier_DK</fullName>
        <description>Send disqualified lead email to lead identifier DK</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>fktsck229@post.dk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_disqualified_lead_email_to_lead_identifier_DK_PDK_LO</fullName>
        <description>Send disqualified lead email to lead identifier DK - PDK LO</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>fktsck176@post.dk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_disqualified_lead_email_to_lead_identifier_FI</fullName>
        <description>Send disqualified lead email to lead identifier FI</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_FI</template>
    </alerts>
    <alerts>
        <fullName>Send_disqualified_lead_email_to_lead_identifier_LO_DK</fullName>
        <description>Send disqualified lead email to lead identifier LO DK</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_disqualified_lead_email_to_lead_identifier_SE</fullName>
        <description>Send disqualified lead email to lead identifier SE</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_SE</template>
    </alerts>
    <alerts>
        <fullName>Send_qualified_lead_email_to_lead_identifier_DK</fullName>
        <description>Send qualified lead email to lead identifier - DK</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>fktsck229@post.dk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead_Email_Templates/Qualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_qualified_lead_email_to_lead_identifier_DK_PDK_LO</fullName>
        <description>Send qualified lead email to lead identifier - DK - PDK LO</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>fktsck176@post.dk</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Lead_Email_Templates/Qualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_qualified_lead_email_to_lead_identifier_FI</fullName>
        <description>Send qualified lead email to lead identifier - FI</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Qualified_Lead_inform_Lead_identifier_FI</template>
    </alerts>
    <alerts>
        <fullName>Send_qualified_lead_email_to_lead_identifier_LO_DK</fullName>
        <description>Send qualified lead email to lead identifier - LO DK</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Qualified_Lead_inform_Lead_identifier_DK</template>
    </alerts>
    <alerts>
        <fullName>Send_qualified_lead_email_to_lead_identifier_SE</fullName>
        <description>Send qualified lead email to lead identifier - SE</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Qualified_Lead_inform_Lead_identifier_SE</template>
    </alerts>
    <alerts>
        <fullName>Send_unqualified_lead_email_to_lead_identifier_FI</fullName>
        <description>Send unqualified lead email to lead identifier FI</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Identifier__c</field>
            <type>contactLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Lead_Email_Templates/Disqualified_Lead_inform_Lead_identifier_FI</template>
    </alerts>
    <fieldUpdates>
        <fullName>Change_Lead_Owner_LO_SE_Cust</fullName>
        <field>OwnerId</field>
        <lookupValue>Innes_lj_F_rs_ljning_Sverige_Logistik</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Lead Owner - LO SE Cust</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Change_Lead_Owner_ME_SE</fullName>
        <field>OwnerId</field>
        <lookupValue>ME_SE_Indoor_Sales</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Change Lead Owner - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Acc_Postal_Ctry_to_Lead_Ctry_DK</fullName>
        <field>Address_Country__c</field>
        <literalValue>DK</literalValue>
        <name>Copy Acc Postal Ctry to Lead Ctry - DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_C_O_to_Lead_C_O</fullName>
        <field>Address_C_O__c</field>
        <formula>Account__r.Postal_Address_C_O__c</formula>
        <name>Copy Account C/O to Lead C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_City_to_Lead_City</fullName>
        <field>Address_City__c</field>
        <formula>Account__r.Postal_Address_City__c</formula>
        <name>Copy Account City to Lead City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_House_Number_to_Lead_Hse_Nb</fullName>
        <field>Address_House_Number__c</field>
        <formula>Account__r.Postal_Address_House_Number__c</formula>
        <name>Copy Account House Number to Lead Hse Nb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Hse_Nb_Sup_to_Ld_Hse_Nb_Sup</fullName>
        <field>Address_House_Number_Supplement__c</field>
        <formula>Account__r.Postal_Address_House_Number_Supplement__c</formula>
        <name>Copy Account Hse Nb Sup to Ld Hse Nb Sup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Name_to_Lead_Company</fullName>
        <field>Company</field>
        <formula>Account__r.Name</formula>
        <name>Copy Account Name to Lead Company</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_PO_Box_to_Lead_PO_Box</fullName>
        <field>Address_PO_Box__c</field>
        <formula>Account__r.Postal_Address_PO_Box__c</formula>
        <name>Copy Account PO Box to Lead PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Postal_Code_to_Lead_Postal</fullName>
        <field>Address_Postal_Code__c</field>
        <formula>Account__r.Postal_Address_Postal_Code__c</formula>
        <name>Copy Account Postal Code to Lead Postal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Room_Num_to_Lead_Room_Num</fullName>
        <field>Address_Room_Number__c</field>
        <formula>Account__r.Postal_Address_Room_Number__c</formula>
        <name>Copy Account Room Num to Lead Room Num</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Street_to_Lead_Street</fullName>
        <field>Address_Street__c</field>
        <formula>Account__r.Postal_Address_Street__c</formula>
        <name>Copy Account Street to Lead Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Account_Website_to_Lead_Website</fullName>
        <field>Website</field>
        <formula>Account__r.Website</formula>
        <name>Copy Account Website to Lead Website</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Lead_Description</fullName>
        <field>Lead_Description__c</field>
        <formula>Description</formula>
        <name>Copy Lead Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Postal_Addr_Ctry_to_Lead_Ctry_DE</fullName>
        <field>Address_Country__c</field>
        <literalValue>DE</literalValue>
        <name>Copy Postal Addr Ctry to Lead Ctry - DE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Postal_Addr_Ctry_to_Lead_Ctry_FI</fullName>
        <field>Address_Country__c</field>
        <literalValue>FI</literalValue>
        <name>Copy Postal Addr Ctry to Lead Ctry - FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Postal_Addr_Ctry_to_Lead_Ctry_NO</fullName>
        <field>Address_Country__c</field>
        <literalValue>NO</literalValue>
        <name>Copy Postal Addr Ctry to Lead Ctry - NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Postal_Addr_Ctry_to_Lead_Ctry_SE</fullName>
        <field>Address_Country__c</field>
        <literalValue>SE</literalValue>
        <name>Copy Postal Addr Ctry to Lead Ctry - SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Central_Start_Time</fullName>
        <field>LC_Start_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Lead Central Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Central_Stop_Time</fullName>
        <field>LC_Stop_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Lead Central Stop Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_LO_DK</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0540</literalValue>
        <name>Set Lead Sales Area - LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_LO_FI</fullName>
        <field>Sales_Area__c</field>
        <literalValue>3670</literalValue>
        <name>Set Lead Sales Area - LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0630</literalValue>
        <name>Set Lead Sales Area - LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_LO_NO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set Lead Sales Area - LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_LO_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO92</literalValue>
        <name>Set Lead Sales Area - LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_ME_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO91</literalValue>
        <name>Set Lead Sales Area - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_PDK_BE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>1000</literalValue>
        <name>Set Lead Sales Area - PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Sales_Area_PDK_LO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>4000</literalValue>
        <name>Set Lead Sales Area - PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Lead_Source_to_Submitted_by_Employee</fullName>
        <field>LeadSource</field>
        <literalValue>Submitted by Employee</literalValue>
        <name>Set Lead Source to Submitted by Employee</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Failed_Assign_flag</fullName>
        <field>Failed_Allocate_Assign__c</field>
        <literalValue>0</literalValue>
        <name>Update Failed Assign flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Feedback_Disqualified_Date</fullName>
        <field>Date_Feedback_Sent_Disqualified__c</field>
        <formula>TODAY()</formula>
        <name>Update Lead Feedback Disqualified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Feedback_Qualified_Date</fullName>
        <field>Date_Feedback_Sent_Qualifed__c</field>
        <formula>TODAY()</formula>
        <name>Update Lead Feedback Qualified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Identifier_Email</fullName>
        <field>Lead_Identifier_Email__c</field>
        <formula>Lead_Identifier__r.Email</formula>
        <name>Update Lead Identifier Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Allocated</fullName>
        <field>Lead_Phase__c</field>
        <literalValue>Allocated</literalValue>
        <name>Update Lead Phase - Allocated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Allocated_Start_Date</fullName>
        <field>Date_Time_Allocated_Lead_Phase_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Phase Allocated Start Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Closed_Date</fullName>
        <field>Date_Time_Closed_Lead_Phase_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Phase Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Closed_Lead</fullName>
        <field>Lead_Phase__c</field>
        <literalValue>Closed Lead</literalValue>
        <name>Update Lead Phase - Closed Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Created</fullName>
        <field>Lead_Phase__c</field>
        <literalValue>Create Lead</literalValue>
        <name>Update Lead Phase - Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Qualify_Lead</fullName>
        <field>Lead_Phase__c</field>
        <literalValue>Qualify Lead</literalValue>
        <name>Update Lead Phase - Qualify Lead</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Phase_Qualify_Lead_Start_Dat</fullName>
        <field>Date_Time_Qualify_Lead_Phase_Start__c</field>
        <formula>NOW()</formula>
        <name>Update Lead Phase Qualify Lead Start Dat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status_to_Allocated_to_Sales</fullName>
        <field>Status</field>
        <literalValue>Allocated to Sales</literalValue>
        <name>Update Lead Status to Allocated to Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status_to_In_Progress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Update Lead Status to In Progress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_Allocated</fullName>
        <field>Status</field>
        <literalValue>Allocated</literalValue>
        <name>Update Status to Allocated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Copy Account Name and Address to Lead Company and Address</fullName>
        <actions>
            <name>Copy_Account_C_O_to_Lead_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_City_to_Lead_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_House_Number_to_Lead_Hse_Nb</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Hse_Nb_Sup_to_Ld_Hse_Nb_Sup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Name_to_Lead_Company</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_PO_Box_to_Lead_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Postal_Code_to_Lead_Postal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Room_Num_to_Lead_Room_Num</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Street_to_Lead_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_Account_Website_to_Lead_Website</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address to lead address fields and copy account name to company field</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false &amp;&amp; LEN( Account__c ) &gt; 0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Postal Ctry to Lead Address Ctry - DE</fullName>
        <actions>
            <name>Copy_Postal_Addr_Ctry_to_Lead_Ctry_DE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address country to lead address country field if country is DE</description>
        <formula>AND(LEN( Account__c ) &gt; 0, ISPICKVAL( Account__r.Postal_Address_Country__c, &apos;DE&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Postal Ctry to Lead Address Ctry - DK</fullName>
        <actions>
            <name>Copy_Acc_Postal_Ctry_to_Lead_Ctry_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address country to lead address country field if country is DK</description>
        <formula>AND(LEN( Account__c ) &gt; 0, ISPICKVAL( Account__r.Postal_Address_Country__c, &apos;DK&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Postal Ctry to Lead Address Ctry - FI</fullName>
        <actions>
            <name>Copy_Postal_Addr_Ctry_to_Lead_Ctry_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address country to lead address country field if country is FI</description>
        <formula>AND(LEN( Account__c ) &gt; 0, ISPICKVAL( Account__r.Postal_Address_Country__c, &apos;FI&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Postal Ctry to Lead Address Ctry - NO</fullName>
        <actions>
            <name>Copy_Postal_Addr_Ctry_to_Lead_Ctry_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address country to lead address country field if country is NO</description>
        <formula>AND(LEN( Account__c ) &gt; 0, ISPICKVAL( Account__r.Postal_Address_Country__c, &apos;NO&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Account Postal Ctry to Lead Address Ctry - SE</fullName>
        <actions>
            <name>Copy_Postal_Addr_Ctry_to_Lead_Ctry_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If lead is created for en existing company then copy account postal address country to lead address country field if country is SE</description>
        <formula>AND(LEN( Account__c ) &gt; 0, ISPICKVAL( Account__r.Postal_Address_Country__c, &apos;SE&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy Description for Lead Mapping</fullName>
        <actions>
            <name>Copy_Lead_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy standard description field to a custom description field so that it can be  mapped to opportunity</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - DK</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When lead status is set to Disqualified and lead identifier is in DK, email lead identifier to let them know in Danish</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - DK - LO DK</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_LO_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to disqualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is LO DK send from PDK BE email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - DK - PDK BE</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to disqualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is PDK BE send from PDK BE email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - DK - PDK LO</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_DK_PDK_LO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to disqualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is PDK LO send from PDK LO email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - FI</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_FI</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>FI</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When lead status is set to Disqualified and lead identifier is in FI, email lead identifier to let them know in Finnish</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Disqualified Lead - SE</fullName>
        <actions>
            <name>Send_disqualified_lead_email_to_lead_identifier_SE</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Disqualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Disqualified by sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>SE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Disqualified__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>When lead status is set to Unqualified and lead identifier is in SE, email lead identifier to let them know</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - DK</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When lead status is set to Qualified and lead identifier country is DK, email lead identifier to let them know in Danish</description>
        <formula>AND( ISPICKVAL( Status ,&apos;Allocated&apos;) , Lead_Identifier_Country__c =&apos;DK&apos;, Date_Feedback_Sent_Qualifed__c == null, $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - DK - LO DK</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_LO_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Allocated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Qualifed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to Qualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is LO DK send from LO DK email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - DK - PDK BE</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_DK</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Allocated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Qualifed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to Qualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is PDK BE send from PDK BE email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - DK - PDK LO</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_DK_PDK_LO</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Allocated</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Sales_Area__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Date_Feedback_Sent_Qualifed__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Identifier_Country__c</field>
            <operation>equals</operation>
            <value>DK</value>
        </criteriaItems>
        <description>When lead status is set to Qualified and lead identifier country is DK, email lead identifier to let them know in Danish. If Sales Area is PDK LO send from PDK BE email address. SWITCH ON ONCE EMAIL IS VERIFIED</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - FI</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_FI</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead status is set to Qualified and lead identifier country is FI, email lead identifier to let them know in Finnish</description>
        <formula>AND( ISPICKVAL( Status ,&apos;Allocated&apos;), Lead_Identifier_Country__c = &apos;FI&apos;,  Date_Feedback_Sent_Qualifed__c == null, $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notify Lead identifier - Qualified Lead - SE</fullName>
        <actions>
            <name>Send_qualified_lead_email_to_lead_identifier_SE</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Update_Lead_Feedback_Qualified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead status is set to Qualified and lead identifier country is SE, email lead identifier to let them know in Swedish</description>
        <formula>ISPICKVAL(Status,&apos;Allocated&apos;) &amp;&amp;  Lead_Identifier_Country__c = &apos;SE&apos; &amp;&amp;  Date_Feedback_Sent_Qualifed__c == null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Populate Lead Identifier Email</fullName>
        <actions>
            <name>Update_Lead_Identifier_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the email address from the related Lead Identifier contact record to a custom field on lead. To be used to send lead identifier emails</description>
        <formula>LEN( Lead_Identifier__c ) &gt; 0 &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Phase to Allocated</fullName>
        <actions>
            <name>Update_Lead_Phase_Allocated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Phase_Allocated_Start_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Phase will not be shown on the page layout but used to track how long a lead takes in each part of the cycle. A lead phase can be made up of several stages. When the lead status changes to Allocated, it is in Allocated Phase.</description>
        <formula>AND( ISPICKVAL( Status ,&apos;Allocated to Sales&apos;) ,   NOT(ISPICKVAL(Lead_Phase__c,&apos;Allocated&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Phase to Closed Lead</fullName>
        <actions>
            <name>Update_Lead_Phase_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Phase_Closed_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Phase will not be shown on the page layout but used to track how long a lead takes in each part of the cycle. A lead phase can be made up of several stages. Stages Disqualified, Disqualified by sales and Qualified(convert lead) indicate a closed lead</description>
        <formula>AND( OR(ISPICKVAL( Status ,&apos;Disqualified&apos;),  ISPICKVAL( Status ,&apos;Disqualified by sales&apos;) ,  ISPICKVAL( Status ,&apos;Qualified (convert lead)&apos;)) ,  NOT(ISPICKVAL(Lead_Phase__c,&apos;Closed Lead&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Phase to Created</fullName>
        <actions>
            <name>Update_Lead_Phase_Created</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Phase will not be shown on the page layout but used to track how long a lead takes in each part of the cycle. A lead phase can be made up of several stages. Lead status of Created means the lead is in created phase.</description>
        <formula>AND( ISPICKVAL( Status ,&apos;Created&apos;) ,   NOT(ISPICKVAL(Lead_Phase__c,&apos;Create Lead&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Phase to Qualify Lead</fullName>
        <actions>
            <name>Update_Lead_Phase_Qualify_Lead</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Lead_Phase_Qualify_Lead_Start_Dat</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Phase will not be shown on the page layout but used to track how long a lead takes in each part of the cycle. A lead phase can be made up of several stages. Stages Needs Analysis, Qualified by lead data and qualified by customer call indicate qualify</description>
        <formula>AND( OR(ISPICKVAL( Status ,&apos;Qualified by lead data&apos;), ISPICKVAL( Status ,&apos;Qualified by customer call&apos;) ,  ISPICKVAL( Status ,&apos;Needs Analysis&apos;)) ,  NOT(ISPICKVAL(Lead_Phase__c,&apos;Qualify Lead&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - LO DK</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is LO DK set Lead Sales Area to LO DK. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;0540&apos;) &amp;&amp; $Profile.Name !=  $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c    &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - LO FI</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is LO FI set Lead Sales Area to LO FI. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;3670&apos;)&amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - LO FI DPD</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is LO FI DPD set Lead Sales Area to LO FI DPD. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;0630&apos;)&amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - LO NO</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is LO NO set Lead Sales Area to LO NO. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo.</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;LO NO&apos;) &amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - LO SE</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is LO SE set Lead Sales Area to LO SE. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo.</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;FO92&apos;) &amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - ME SE</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is ME SE set Lead Sales Area to ME SE. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo.</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;FO91&apos;) &amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - PDK BE</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When lead is created and user sales area is PDK BE set Lead Sales Area to PDK BE. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo.</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c  , &apos;1000&apos;) &amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Lead Sales Area - PDK LO</fullName>
        <actions>
            <name>Set_Lead_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When lead is created and user sales area is PDK LO set Lead Sales Area to PDK LO. Exclude Marketo sync profile from the entry criteria - leads created from Marketo will have the Sales Area set in Marketo.</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;4000&apos;) &amp;&amp;  $Profile.Name != $Setup.Get2OneCRM__c.Marketo_Sync_Profile_Name__c  &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Start Lead Central time</fullName>
        <actions>
            <name>Set_Lead_Central_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Timestamp when Lead Central takes lead</description>
        <formula>AND( ISPICKVAL(Status ,&apos;Created&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Stop Lead Central time</fullName>
        <actions>
            <name>Set_Lead_Central_Stop_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR (2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Allocated to Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Disqualified,Qualified (convert lead)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>contains</operation>
            <value>LC</value>
        </criteriaItems>
        <description>Timestamp when Lead Central finishes work on lead</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Source</fullName>
        <actions>
            <name>Set_Lead_Source_to_Submitted_by_Employee</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Lead identifier field is not blank then set Lead Source to &quot;Submitted by Employee&quot;</description>
        <formula>NOT ( ISNULL( Lead_Identifier__c)) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Status to Allocated</fullName>
        <actions>
            <name>Update_Failed_Assign_flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Status_to_Allocated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Lead Status to Allocated if lead has been qualified and assigned to a user</description>
        <formula>AND(ISCHANGED( OwnerId ), Failed_Allocate_Assign__c = TRUE, OR(ISPICKVAL ( Status, &apos;Qualified by lead information&apos;), ISPICKVAL ( Status, &apos;Qualified by customer contact&apos;)), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Lead Status to In Progress</fullName>
        <actions>
            <name>Update_Lead_Status_to_In_Progress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Lead Status to In Progress if lead has been assigned to a Lead Central queue</description>
        <formula>AND(CONTAINS(Owner:Queue.QueueName, &apos;LC&apos;), ISPICKVAL ( Status, &apos;Created&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
