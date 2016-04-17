<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <rules>
        <fullName>Set Product Key</fullName>
        <active>true</active>
        <description>Concatenate Product ID and Sales Area to provide a unique key for records and avoid duplicates</description>
        <formula>1=1</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
