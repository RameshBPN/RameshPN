<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_LO_DK</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0540</literalValue>
        <name>Set Campaign Sales Area - LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_LO_FI</fullName>
        <field>Sales_Area__c</field>
        <literalValue>3670</literalValue>
        <name>Set Campaign Sales Area - LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0630</literalValue>
        <name>Set Campaign Sales Area - LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_LO_NO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set Campaign Sales Area - LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_LO_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO92</literalValue>
        <name>Set Campaign Sales Area - LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_ME_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO91</literalValue>
        <name>Set Campaign Sales Area - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_PDK_BE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>1000</literalValue>
        <name>Set Campaign Sales Area - PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Campaign_Sales_Area_PDK_LO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>4000</literalValue>
        <name>Set Campaign Sales Area - PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Campaign Sales Area - LO DK</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with LO DK set Campaign Sales Area to LO DK (0540). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;LO DK&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - LO FI</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with LO FI DPD set Campaign Sales Area to LO FI (3670). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;LO FI&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - LO FI DPD</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with LO FI DPD set Campaign Sales Area to LO FI DPD (0630). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;LO FI DPD&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - LO NO</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with LO NO set Campaign Sales Area to LO NO (LO NO). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;LO NO&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - LO SE</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with LO SE set Campaign Sales Area to LO SE (FO92). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;LO SE&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - ME SE</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with ME SE set Campaign Sales Area to ME SE (FO91). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;ME SE&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - PDK BE</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If campaign name starts with PDK BE set Campaign Sales Area to PDK BE (1000). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;PDK BE&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Campaign Sales Area - PDK LO</fullName>
        <actions>
            <name>Set_Campaign_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>If campaign name starts with PDK LO set Campaign Sales Area to PDK LO (4000). This rule is required because Marketo cannot update custom fields on Campaign in Salesforce.</description>
        <formula>BEGINS (Name, &apos;PDK LO&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
