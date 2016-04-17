<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Potential_Product_Line_Set_DK_page</fullName>
        <field>RecordTypeId</field>
        <lookupValue>BE_DK_Potential_Product_Line</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Potential Product Line - Set DK page</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Page Layout DK</fullName>
        <actions>
            <name>Potential_Product_Line_Set_DK_page</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Potential__c.Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <description>Set page layout to DK (read only) if parent record has Sales Area PDK BE</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
