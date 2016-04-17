<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_employeenumber_for_user</fullName>
        <description>Set employeenumber for user to HR ID</description>
        <field>EmployeeNumber</field>
        <formula>HR_ID__c</formula>
        <name>Set employeenumber for user</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set employeenumber for user</fullName>
        <actions>
            <name>Set_employeenumber_for_user</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
