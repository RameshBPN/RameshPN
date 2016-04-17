<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>G2OPlanning_Copy_PUC_Name</fullName>
        <field>Hidden_Name__c</field>
        <formula>Name</formula>
        <name>G2OPlanning Copy PUC Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>G2OPlanning Copy PUC Name</fullName>
        <actions>
            <name>G2OPlanning_Copy_PUC_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>G2OPlanning_PUC__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
