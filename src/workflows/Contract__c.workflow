<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_LO_DK</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0540</literalValue>
        <name>Contract Set Sales Area LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_LO_FI</fullName>
        <field>Sales_Area__c</field>
        <literalValue>3670</literalValue>
        <name>Contract Set Sales Area LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0630</literalValue>
        <name>Contract Set Sales Area LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_LO_NO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Contract Set Sales Area LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_LO_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO92</literalValue>
        <name>Contract Set Sales Area LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_ME_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO91</literalValue>
        <name>Contract Set Sales Area ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_PDK_BE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>1000</literalValue>
        <name>Contract Set Sales Area PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contract_Set_Sales_Area_PDK_LO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>4000</literalValue>
        <name>Contract Set Sales Area PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Contract_End_Date</fullName>
        <description>Set contract end date to 31.12.2099</description>
        <field>Contract_End_Date__c</field>
        <formula>DATE(2099,12,31)</formula>
        <name>Set Contract End Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Contract Set Sales Area LO DK</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is 0540 set sales area on contract to LODK</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;0540&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area LO FI</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is 3670 set sales area on contract to LO FI</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;3670&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area LO FI DPD</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is 0630 set sales area on contract to LO FI DPD</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;0630&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area LO NO</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is LO NO set sales area on contract to LO NO</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;LO NO&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area LO SE</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is FO92 set sales area on contract to LO SE</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;FO92&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area ME SE</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is FO91 set sales area on contract to ME SE</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;FO91&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area PDK BE</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On create of contract if users sales area is 1000 set sales area on contract to PDK BE</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;1000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Contract Set Sales Area PDK LO</fullName>
        <actions>
            <name>Contract_Set_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>On create of contract if users sales area is 4000 set sales area on contract to PDK LO</description>
        <formula>ISPICKVAL( $User.Sales_Area1__c , &apos;4000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c !=true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set the Contract as Ongoing</fullName>
        <actions>
            <name>Set_Contract_End_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contract__c.Ongoing_contract__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Set the Contract as Ongoing by setting the Contract End Date as &apos;31.12.2099&apos;</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
