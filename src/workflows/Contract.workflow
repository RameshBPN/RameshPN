<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_sales_area_LO_DK</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0540</literalValue>
        <name>Set sales area LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_FI</fullName>
        <field>Sales_Area__c</field>
        <literalValue>3670</literalValue>
        <name>Set sales area LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_FI_DPD</fullName>
        <field>Sales_Area__c</field>
        <literalValue>0630</literalValue>
        <name>Set sales area LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_NO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set sales area LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_LO_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO92</literalValue>
        <name>Set sales area LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_ME_SE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>FO91</literalValue>
        <name>Set sales area ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_PDK_BE</fullName>
        <field>Sales_Area__c</field>
        <literalValue>1000</literalValue>
        <name>Set sales area PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_sales_area_PDK_LO</fullName>
        <field>Sales_Area__c</field>
        <literalValue>4000</literalValue>
        <name>Set sales area PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Sales area LO DK</fullName>
        <actions>
            <name>Set_sales_area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is LO DK set contract Sales Area to LO DK</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;0540&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area LO FI</fullName>
        <actions>
            <name>Set_sales_area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is LO FI set contract Sales Area to LO FI</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;3670&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area LO FI DPD</fullName>
        <actions>
            <name>Set_sales_area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is LO FI DPD set contract Sales Area to LO FI DPD</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;0630&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area LO NO</fullName>
        <actions>
            <name>Set_sales_area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is LO NO set contract Sales Area to LO NO</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;LO NO&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area LO SE</fullName>
        <actions>
            <name>Set_sales_area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is LO SE set contract Sales Area to LO SE</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;FO92&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area ME SE</fullName>
        <actions>
            <name>Set_sales_area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is ME SE set contract Sales Area to ME SE</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;FO91&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area PDK BE</fullName>
        <actions>
            <name>Set_sales_area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is PDK BE set contract Sales Area to PDK BE</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;1000&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sales area PDK LO</fullName>
        <actions>
            <name>Set_sales_area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When contract is created and user sales area is PDK LO set contract Sales Area to PDK LO</description>
        <formula>AND( ISPICKVAL( $User.Sales_Area1__c , &apos;4000&apos;),  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c =false )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
