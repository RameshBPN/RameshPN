<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Potential_Record_Type_to_BE</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Breve_Potential</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Potential Record Type to BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Potential_Record_Type_to_Converted</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BE_Converted_Potential</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Potential Record Type to Converted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Potential_Record_Type_to_ME_LO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>ME_LO_Potential</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Set Potential Record Type to ME LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Potential Record Type to BE</fullName>
        <actions>
            <name>Set_Potential_Record_Type_to_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Potential__c.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Potential__c.Status__c</field>
            <operation>equals</operation>
            <value>Open,Closed,Rejected</value>
        </criteriaItems>
        <description>If Sales Area is PDK BE and status is not Converted to Opportunity then set record type to BE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Potential Record Type to ME LO</fullName>
        <actions>
            <name>Set_Potential_Record_Type_to_ME_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Potential__c.Sales_Area__c</field>
            <operation>equals</operation>
            <value>LO NO,0540,0630,FO91,FO92,3670</value>
        </criteriaItems>
        <description>If Sales Area is LO NO/LO DK/LO FI DPD/ME SE/LO SE or LO FI,  set record type to ME LO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Record Type on Potential - Converted to Opp</fullName>
        <actions>
            <name>Set_Potential_Record_Type_to_Converted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Potential__c.Status__c</field>
            <operation>equals</operation>
            <value>Converted to Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Potential__c.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <description>When Potential has a status of converted to Opportunity and the sales area is PDK BE update the record type so that the Convert to Opportunity button does not appear on the page layout</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
