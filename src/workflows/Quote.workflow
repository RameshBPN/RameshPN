<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_LO_DK</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0540</literalValue>
        <name>Set Quote Sales Area - LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_LO_FI</fullName>
        <field>Sales_Area__c</field>
        <literalValue>3670</literalValue>
        <name>Set Quote Sales Area - LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0630</literalValue>
        <name>Set Quote Sales Area - LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_LO_NO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set Quote Sales Area - LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_LO_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO92</literalValue>
        <name>Set Quote Sales Area - LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_ME_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO91</literalValue>
        <name>Set Quote Sales Area - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_PDK_BE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>1000</literalValue>
        <name>Set Quote Sales Area - PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Quote_Sales_Area_PDK_LO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>4000</literalValue>
        <name>Set Quote Sales Area - PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Quote Sales Area - LO DK</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is LO DK then set quote sales area to LO DK</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - LO FI</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>3670</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is LO FI then set quote sales area to LO FI</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - LO FI DPD</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>0630</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is LO FI then set quote sales area to LO FI DPD</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - LO NO</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>LO NO</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is LO NO then set quote sales area to LO NO</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - LO SE</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>FO92</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is LO SE then set quote sales area to LO SE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - ME SE</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>FO91</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is ME SE then set quote sales area to ME SE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - PDK BE</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is PDK BE then set quote sales area to PDK BE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Quote Sales Area - PDK LO</fullName>
        <actions>
            <name>Set_Quote_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Sales_Area__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <description>On create of quote if opportunity sales area is PDK LO then set quote sales area to PDK LO</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
