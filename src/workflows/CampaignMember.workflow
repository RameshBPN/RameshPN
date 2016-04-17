<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Customer_Responsible</fullName>
        <description>Email Customer Responsible</description>
        <protected>false</protected>
        <recipients>
            <recipient>ME SE - Customer Responsible</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Campaign_Customer_Responsible_Request_Contact</template>
    </alerts>
    <alerts>
        <fullName>Send_email_to_Lead_Owner_on_register_at_event</fullName>
        <description>Send email to Lead Owner on register at event</description>
        <protected>false</protected>
        <recipients>
            <type>campaignMemberDerivedOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Lead_has_registered_for_event</template>
    </alerts>
    <rules>
        <fullName>Assign Task to Customer Responsible</fullName>
        <actions>
            <name>Email_Customer_Responsible</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Test workflow</description>
        <formula>ISPICKVAL(Status  , &apos;Requested Contact&apos;)  &amp;&amp;  Campaign.Name  = &apos;ME SE - Inbound Contact Me1&apos;  &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
