<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_User_when_added_to_Opportunity_team</fullName>
        <description>Email User when added to Opportunity team</description>
        <protected>false</protected>
        <recipients>
            <field>UserId</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Email_Templates/User_added_to_Opportunity_Team</template>
    </alerts>
    <rules>
        <fullName>Email User When Added to Opp Team</fullName>
        <actions>
            <name>Email_User_when_added_to_Opportunity_team</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>PDK BE - Customer Responsible,PDK BE - Sponsor,PDK BE - Operations Responsible,PDK BE - Export Specialist,PDK BE - eCOM Sales Responsible,PDK BE - Business Supporter,PDK BE - Procurement Consultant,PDK BE - Export &amp; Dist Trade Specialist</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>PDK BE - Advertising &amp; Media Specialist,PDK BE - Customer Solution Specialist,PDK BE - E-Commerce Specialist,PDK BE - Sales Manager</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>PDK LO - Customer Responsible,PDK LO - Sponsor,PDK LO - Salessupport Coordinator,PDK LO - Export Specialist,PDK LO - Activity Responsible,PDK LO - Business Supporter,PDK LO - Logistics Consultant,PDK LO - MA Customer Service</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityTeamMember.TeamMemberRole</field>
            <operation>equals</operation>
            <value>PDK LO - Key Accounts Supporter,PDK LO - Sales Manager</value>
        </criteriaItems>
        <description>When a user is added to an Opportunity Team and they aren&apos;t the opportunity owner, send them an email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
