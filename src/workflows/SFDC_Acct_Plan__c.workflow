<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_email_when_account_plan_has_been_approved</fullName>
        <description>Send email when account plan has been approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Approved</template>
    </alerts>
    <alerts>
        <fullName>Send_email_when_account_plan_has_been_rejected</fullName>
        <description>Send email when account plan has been rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Plan_Rejected</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_LO_DK</fullName>
        <field>Sales_area2__c</field>
        <literalValue>0540</literalValue>
        <name>Account Plan Set Sales Area LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_LO_FI</fullName>
        <field>Sales_area2__c</field>
        <literalValue>3670</literalValue>
        <name>Account Plan Set Sales Area LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_area2__c</field>
        <literalValue>0630</literalValue>
        <name>Account Plan Set Sales Area LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_LO_NO</fullName>
        <field>Sales_area2__c</field>
        <literalValue>LO NO</literalValue>
        <name>Account Plan Set Sales Area LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_LO_SE</fullName>
        <field>Sales_area2__c</field>
        <literalValue>FO92</literalValue>
        <name>Account Plan Set Sales Area LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_ME_SE</fullName>
        <field>Sales_area2__c</field>
        <literalValue>FO91</literalValue>
        <name>Account Plan Set Sales Area ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_PDK_BE</fullName>
        <field>Sales_area2__c</field>
        <literalValue>1000</literalValue>
        <name>Account Plan Set Sales Area PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Plan_Set_Sales_Area_PDK_LO</fullName>
        <field>Sales_area2__c</field>
        <literalValue>4000</literalValue>
        <name>Account Plan Set Sales Area PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_account_plan_status</fullName>
        <field>Plan_Status__c</field>
        <literalValue>In progress</literalValue>
        <name>Update account plan status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Set Account Plan Sales Area - LO DK</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to LO DK if user creating Account Plan has Sales Area of LO DK</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - LO FI</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>3670</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to LO FI if user creating Account Plan has Sales Area of LO FI</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - LO FI DPD</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>0630</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to LO FI DPD if user creating Account Plan has Sales Area of LO FI DPD</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - LO NO</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>LO NO</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to LO NO if user creating Account Plan has Sales Area of LO NO</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - LO SE</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>FO92</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to LO SE if user creating Account Plan has Sales Area of LO SE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - ME SE</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>FO91</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to ME SE if user creating Account Plan has Sales Area of ME SE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - PDK BE</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to PDK BE if user creating Account Plan has Sales Area of PDK BE</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Account Plan Sales Area - PDK LO</fullName>
        <actions>
            <name>Account_Plan_Set_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>User.Sales_Area1__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <description>Set Sales Area of Account Plan on create to PDK LO if user creating Account Plan has Sales Area of PDK LO</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set status to in progress</fullName>
        <actions>
            <name>Update_account_plan_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>SFDC_Acct_Plan__c.Account_Plan_ID__c</field>
            <operation>greaterThan</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
