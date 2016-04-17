<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_FO</fullName>
        <field>FO_Sales_group__c</field>
        <formula>Text($User.FO_Sales_group__c)</formula>
        <name>Set FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_FI_event</fullName>
        <field>Sales_area__c</field>
        <literalValue>3670</literalValue>
        <name>Set sales area LO FI - event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_FI_event2</fullName>
        <field>Sales_area__c</field>
        <literalValue>4000</literalValue>
        <name>Set sales area PDK LO - event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_team</fullName>
        <field>Team__c</field>
        <formula>text($User.Team__c)</formula>
        <name>Set team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Telesales_event_flag</fullName>
        <field>Telesales_flag_trigger__c</field>
        <formula>Telesales_flag_trigger__c +1</formula>
        <name>Telesales event flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_LO_DK</fullName>
        <field>Sales_area__c</field>
        <literalValue>0540</literalValue>
        <name>Update event LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_LO_FI_DPD</fullName>
        <field>Sales_area__c</field>
        <literalValue>0630</literalValue>
        <name>Update event LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_LO_NO</fullName>
        <field>Sales_area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Update event LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_LO_SE</fullName>
        <field>Sales_area__c</field>
        <literalValue>F092</literalValue>
        <name>Update event LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_ME_SE</fullName>
        <field>Sales_area__c</field>
        <literalValue>F091</literalValue>
        <name>Update event ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_event_PDK_BE</fullName>
        <field>Sales_area__c</field>
        <literalValue>1000</literalValue>
        <name>Update event PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Event telesales</fullName>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Telesales_event_flag</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Event.StartDateTime</offsetFromField>
            <timeLength>-30</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Set FO and team</fullName>
        <actions>
            <name>Set_FO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area LO DK - event</fullName>
        <actions>
            <name>Update_event_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area LO FI - event</fullName>
        <actions>
            <name>Set_sales_area_LO_FI_event</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>3670</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area LO FI DPD - event</fullName>
        <actions>
            <name>Update_event_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>0630</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area LO NO - event</fullName>
        <actions>
            <name>Update_event_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>LO NO</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area LO SE - event</fullName>
        <actions>
            <name>Update_event_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>FO92</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area ME SE - event</fullName>
        <actions>
            <name>Update_event_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>FO91</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area PDK BE - event</fullName>
        <actions>
            <name>Update_event_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area PDK LO - event</fullName>
        <actions>
            <name>Set_sales_area_LO_FI_event2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
