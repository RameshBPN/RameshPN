<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Case_Status_to_Survey_Answered</fullName>
        <description>When for example an email response to a survey (sub-case) comes in to the system, the status will be updated to reflect that answer.</description>
        <field>Status</field>
        <literalValue>Response Received</literalValue>
        <name>Set Case Status to Survey Answered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Email_Response_Timestamp_on_Case</fullName>
        <field>Survey_Response_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Email Response Timestamp on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_New_Email_Flag</fullName>
        <field>New_Email_Flag__c</field>
        <literalValue>1</literalValue>
        <name>Set New Email Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Set Case New Email Flag</fullName>
        <actions>
            <name>Set_New_Email_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.New_Email_Flag__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <description>When an inbound email is connected to a case, the &quot;New Email Flag&quot; field will be set to true.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Email Response Timestamp on Case</fullName>
        <actions>
            <name>Set_Case_Status_to_Survey_Answered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Email_Response_Timestamp_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Case.Is_Main_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Incoming</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Sets the Response Timestamp when an email is received OR when the status is changed to &quot;Survey answered&quot;, given that it has not been set before and that it&apos;s a sub-case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
