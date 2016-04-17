<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_FO</fullName>
        <field>FO_Sales_group__c</field>
        <formula>text($User.FO_Sales_group__c)</formula>
        <name>Set FO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_PDK_BE_task</fullName>
        <field>Sales_area__c</field>
        <literalValue>1000</literalValue>
        <name>Set sales area PDK BE- task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_task</fullName>
        <field>Sales_area__c</field>
        <literalValue>3670</literalValue>
        <name>Set sales area LO FI - task</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_status_to_cancelled_task_status</fullName>
        <field>Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Set status to cancelled task status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_task_status</fullName>
        <field>Status__c</field>
        <literalValue>Completed</literalValue>
        <name>Set task status</name>
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
        <fullName>Update_Task_Comments</fullName>
        <field>Description</field>
        <name>Update Task Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Subject</fullName>
        <field>Subject</field>
        <name>Update Task Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Task_Type</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Telephone Contact</literalValue>
        <name>Update Task Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_subject</fullName>
        <field>Subject</field>
        <formula>&quot;Follow up 1-1-1 (1) - &quot; &amp; Subject</formula>
        <name>Update subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_LO_DK</fullName>
        <field>Sales_area__c</field>
        <literalValue>0540</literalValue>
        <name>Update task LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_LO_FI_DPD</fullName>
        <field>Sales_area__c</field>
        <literalValue>0630</literalValue>
        <name>Update task LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_LO_NO</fullName>
        <field>Sales_area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Update task LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_LO_SE</fullName>
        <field>Sales_area__c</field>
        <literalValue>F092</literalValue>
        <name>Update task LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_ME_SE</fullName>
        <field>Sales_area__c</field>
        <literalValue>F091</literalValue>
        <name>Update task ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_task_PDK_LO</fullName>
        <field>Sales_area__c</field>
        <literalValue>4000</literalValue>
        <name>Update task PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_type</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Follow up 1-1-1</literalValue>
        <name>Update type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X1_1_1</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Follow up 1-1-1</literalValue>
        <name>1-1-1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X1_1_1_2</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Follow up 1-1-1</literalValue>
        <name>1-1-1 (2)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>X1_1_1_3</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Follow up 1-1-1</literalValue>
        <name>1-1-1 (3)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>XX1_1_1</fullName>
        <field>Activity_Type_std__c</field>
        <literalValue>Follow up 1-1-1</literalValue>
        <name>1-1-1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Follow up 1-1-1 %281%29</fullName>
        <actions>
            <name>XX1_1_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Follow_up_1_1_1_2</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Follow up 1-1-1 (1)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Complete,Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow up 1-1-1 %282%29</fullName>
        <actions>
            <name>X1_1_1_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Follow_up_1_1_1_3</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Follow up 1-1-1 (2)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status</field>
            <operation>equals</operation>
            <value>Complete,Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow up 1-1-1 %283%29</fullName>
        <actions>
            <name>X1_1_1_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>contains</operation>
            <value>Follow up 1-1-1 (3)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Status__c</field>
            <operation>equals</operation>
            <value>Completed</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Follow up 1-1-1 manual</fullName>
        <actions>
            <name>Update_subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Activity_Type_std__c</field>
            <operation>equals</operation>
            <value>Follow up 1-1-1</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set FO and team - task</fullName>
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
        <fullName>Set sales area LO DK - task</fullName>
        <actions>
            <name>Update_task_LO_DK</name>
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
        <fullName>Set sales area LO FI - task</fullName>
        <actions>
            <name>Set_sales_area_task</name>
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
        <fullName>Set sales area LO FI DPD- task</fullName>
        <actions>
            <name>Update_task_LO_FI_DPD</name>
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
        <fullName>Set sales area LO NO - task</fullName>
        <actions>
            <name>Update_task_LO_NO</name>
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
        <fullName>Set sales area LO SE- task</fullName>
        <actions>
            <name>Update_task_LO_SE</name>
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
        <fullName>Set sales area ME SE- task</fullName>
        <actions>
            <name>Update_task_ME_SE</name>
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
        <fullName>Set sales area PDK BE- task</fullName>
        <actions>
            <name>Set_sales_area_PDK_BE_task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR 3</booleanFilter>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Marketo Sync</value>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>PDK BE</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set sales area PDK LO- task</fullName>
        <actions>
            <name>Update_task_PDK_LO</name>
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
    <rules>
        <fullName>Set status to cancelled task status</fullName>
        <actions>
            <name>Set_status_to_cancelled_task_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ispickval(Status,&apos;Cancelled&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set status to task status</fullName>
        <actions>
            <name>Set_task_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ispickval(Status,&apos;Completed&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Task Type</fullName>
        <actions>
            <name>Update_Task_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Activity_Type_std__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>Follow_up_1_1_1_2</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>Follow up 1-1-1 (2)</subject>
    </tasks>
    <tasks>
        <fullName>Follow_up_1_1_1_3</fullName>
        <assignedToType>owner</assignedToType>
        <dueDateOffset>10</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Task.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>Follow up 1-1-1 (3)</subject>
    </tasks>
</Workflow>
