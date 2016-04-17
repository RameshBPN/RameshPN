<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Account_Set_Competitor_Flag</fullName>
        <field>Competitor__c</field>
        <literalValue>1</literalValue>
        <name>Account Set Competitor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Set_External_Partner_Flag</fullName>
        <field>External_Partner__c</field>
        <literalValue>1</literalValue>
        <name>Account Set External Partner Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_DK_CS_Segment_to_Account</fullName>
        <field>LO_DK_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy LO DK CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_DK_Sales_Mode_to_Account</fullName>
        <field>LO_DK_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy LO DK Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_DK_Sub_Segment_to_Account</fullName>
        <field>LO_DK_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy LO DK Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_DK_Top_Segment_to_Account</fullName>
        <field>LO_DK_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy LO DK Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_CS_Segment_to_Account</fullName>
        <field>LO_FI_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy LO FI CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_DPD_CS_Segment_to_Account</fullName>
        <field>LO_FI_DPD_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy LO FI DPD CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_DPD_Sales_Mode_to_Account</fullName>
        <field>LO_FI_DPD_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI DPD Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_DPD_Sub_Segment_to_Account</fullName>
        <field>LO_FI_DPD_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI DPD Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_DPD_Top_Segment_to_Account</fullName>
        <field>LO_FI_DPD_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI DPD Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_Sales_Mode_to_Account</fullName>
        <field>LO_FI_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_Sub_Segment_to_Account</fullName>
        <field>LO_FI_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_FI_Top_Segment_to_Account</fullName>
        <field>LO_FI_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy LO FI Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_NO_CS_Segment_to_Account</fullName>
        <field>LO_NO_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy LO NO CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_NO_Sales_Mode_to_Account</fullName>
        <field>LO_NO_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy LO NO Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_NO_Sub_Segment_to_Account</fullName>
        <field>LO_NO_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy LO NO Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_NO_Top_Segment_to_Account</fullName>
        <field>LO_NO_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy LO NO Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_SE_CS_Segment_to_Account</fullName>
        <field>LO_SE_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy LO SE CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_SE_Sales_Mode_to_Account</fullName>
        <field>LO_SE_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy LO SE Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_SE_Sub_Segment_to_Account</fullName>
        <field>LO_SE_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy LO SE Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_LO_SE_Top_Segment_to_Account</fullName>
        <field>LO_SE_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy LO SE Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ME_SE_CS_Segment_to_Account</fullName>
        <field>ME_SE_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy ME SE CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ME_SE_Sales_Mode_to_Account</fullName>
        <field>ME_SE_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy ME SE Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ME_SE_Sub_Segment_to_Account</fullName>
        <field>ME_SE_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy ME SE Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_ME_SE_Top_Segment_to_Account</fullName>
        <field>ME_SE_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy ME SE Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_BE_CS_Segment_to_Account</fullName>
        <field>PDK_BE_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy PDK BE CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_BE_Sales_Mode_to_Account</fullName>
        <field>PDK_BE_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK BE Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_BE_Sub_Segment_to_Account</fullName>
        <field>PDK_BE_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK BE Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_BE_Top_Segment_to_Account</fullName>
        <field>PDK_BE_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK BE Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_LO_CS_Segment_to_Account</fullName>
        <field>PDK_LO_Customer_Service_Segment__c</field>
        <formula>IF (LEN( TEXT( Customer_Service_Segment__c)) &gt; 0,
&quot;VIP&quot;,&quot;&quot;)</formula>
        <name>Copy PDK LO CS Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_LO_Sales_Mode_to_Account</fullName>
        <field>PDK_LO_Sales_Mode__c</field>
        <formula>CASE ( Sales_Mode__c ,
&apos;Z01&apos;, &apos;Get&apos;,
&apos;Z02&apos;, &apos;Grow&apos;,
&apos;Z03&apos;, &apos;Keep&apos;,
&apos;Z04&apos;, &apos;React (evaluate)&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK LO Sales Mode to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_LO_Sub_Segment_to_Account</fullName>
        <field>PDK_LO_Sub_Segment__c</field>
        <formula>CASE ( Sub_Segment__c ,
&apos;Z1A&apos;, &apos;1A&apos;,
&apos;Z1B&apos;, &apos;1B&apos;,
&apos;Z1C&apos;, &apos;1C&apos;,                  
&apos;Z1D&apos;, &apos;1D&apos;,
&apos;Z2A&apos;, &apos;2A&apos;,
&apos;Z2B&apos;, &apos;2B&apos;,
&apos;Z2C&apos;, &apos;2C&apos;,
&apos;Z2D&apos;, &apos;2D&apos;,
&apos;Z3A&apos;, &apos;3A&apos;,
&apos;Z3B&apos;, &apos;3B&apos;,
&apos;Z3C&apos;, &apos;3C&apos;,
&apos;Z3D&apos;, &apos;3D&apos;,
&apos;Z4A&apos;, &apos;4A&apos;,
&apos;Z4B&apos;, &apos;4B&apos;,
&apos;Z4C&apos;, &apos;4C&apos;,
&apos;Z4D&apos;, &apos;4D&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK LO Sub Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_PDK_LO_Top_Segment_to_Account</fullName>
        <field>PDK_LO_Top_Segment__c</field>
        <formula>CASE ( Top_Segment__c ,
&apos;Z01&apos;, &apos;KA&apos;,
&apos;Z02&apos;, &apos;LA&apos;,
&apos;Z03&apos;, &apos;SMA&apos;,
&apos;Z04&apos;, &apos;SSA&apos;,
&apos;&apos;)</formula>
        <name>Copy PDK LO Top Segment to Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_LE_Sales_Group_LO_SE</fullName>
        <field>Sales_Group_Name__c</field>
        <literalValue>546</literalValue>
        <name>SAI Create Cust LE - Sales Group LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_LE_Sales_Group_ME_SE</fullName>
        <field>Sales_Group_Name__c</field>
        <literalValue>980</literalValue>
        <name>SAI Create Cust LE - Sales Group ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_LE_Sales_Office_LO_SE</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>FK54</literalValue>
        <name>SAI Create Cust LE - Sales Office LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_WS_Del_Prio_PDK_BE_LO</fullName>
        <field>Delivery_Priority__c</field>
        <literalValue>11</literalValue>
        <name>SAI Create Cust WS - Del Prio PDK BE LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_WS_Ext_Inv_Format_SE</fullName>
        <field>Invoice_Format__c</field>
        <literalValue>Z01</literalValue>
        <name>SAI Create Cust WS Ext - Inv Format SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_WS_Ext_Inv_Freq_SE</fullName>
        <field>Invoice_Frequence__c</field>
        <literalValue>Z2</literalValue>
        <name>SAI Create Cust WS Ext - Inv Freq SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_WS_Ext_Inv_Spec_Fre_SE</fullName>
        <field>Invoice_Specification_Frequency__c</field>
        <literalValue>Z2</literalValue>
        <name>SAI Create Cust WS Ext - Inv Spec Fre SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Cust_WS_Ext_Pay_Terms_SE</fullName>
        <field>Payment_Terms__c</field>
        <literalValue>Z010</literalValue>
        <name>SAI Create Cust WS Ext - Pay Terms SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_LE_Tax_Category</fullName>
        <field>Tax_Category__c</field>
        <literalValue>MWST</literalValue>
        <name>SAI Create Customer WS/LE - Tax Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Set_Default_Inv</fullName>
        <field>Invoice_Frequence__c</field>
        <literalValue>AM</literalValue>
        <name>SAI Create Customer WS - Set Default Inv</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Set_Default_VAT</fullName>
        <field>VAT_Country__c</field>
        <literalValue>SE</literalValue>
        <name>SAI Create Customer WS - Set Default VAT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Set_Inv_Format</fullName>
        <field>Invoice_Format__c</field>
        <literalValue>Z1</literalValue>
        <name>SAI Create Customer WS - Set Inv Format</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Set_VAT_Class</fullName>
        <field>VAT_Classification__c</field>
        <literalValue>1</literalValue>
        <name>SAI Create Customer WS - Set VAT Class</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Set_VAT_Country</fullName>
        <field>VAT_Country__c</field>
        <literalValue>DK</literalValue>
        <name>SAI Create Customer WS - Set VAT Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Customer_WS_Tax_Category</fullName>
        <field>Tax_Category__c</field>
        <literalValue>MWST</literalValue>
        <name>SAI Create Customer WS - Tax Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Extension_Set_Type_to_Custo</fullName>
        <field>Type__c</field>
        <literalValue>Customer</literalValue>
        <name>SAI Create Extension - Set Type to Custo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Prospect_WS_PDK_LO_SOffice</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>4300</literalValue>
        <name>SAI Create Prospect WS - PDK LO SOffice</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Prospect_WS_Set_Default_Inv</fullName>
        <field>Sales_Group_Name__c</field>
        <literalValue>094</literalValue>
        <name>SAI Create Pros WS - Set Def S Group BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Create_Prospect_WS_Set_Default_Sal</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>1900</literalValue>
        <name>SAI Create Prospect WS - Set Default Sal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Competitor_Flag</fullName>
        <field>Competitor__c</field>
        <literalValue>1</literalValue>
        <name>SAI Set Competitor Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Email_Block</fullName>
        <field>Email_Block__c</field>
        <literalValue>1</literalValue>
        <name>SAI Set Email Block</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_External_Partner_Flag</fullName>
        <field>External_Partner__c</field>
        <literalValue>1</literalValue>
        <name>SAI Set External Partner Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Delivery_Priority_DK</fullName>
        <field>Delivery_Priority__c</field>
        <literalValue>10</literalValue>
        <name>SAI Set Priv Pers Delivery Priority DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Invoice_Format_DK</fullName>
        <field>Invoice_Format__c</field>
        <literalValue>Z1</literalValue>
        <name>SAI Set Priv Pers Invoice Format DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Payment_Terms_DK</fullName>
        <field>Payment_Terms__c</field>
        <literalValue>Z001</literalValue>
        <name>SAI Set Priv Pers Payment Terms DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Price_Group_DK</fullName>
        <field>Price_Group_Name__c</field>
        <literalValue>Z1</literalValue>
        <name>SAI Set Priv Pers Price Group DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Sales_Group_PDK_BE</fullName>
        <field>Sales_Group_Name__c</field>
        <literalValue>093</literalValue>
        <name>SAI Set Priv Pers Sales Group PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Sales_Group_PDK_LO</fullName>
        <field>Sales_Group_Name__c</field>
        <literalValue>V07</literalValue>
        <name>SAI Set Priv Pers Sales Group PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Sales_Office_PDK_BE</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>1900</literalValue>
        <name>SAI Set Priv Pers Sales Office PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_Sales_Office_PDK_LO</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>4300</literalValue>
        <name>SAI Set Priv Pers Sales Office PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_VAT_Class_ME_LO_SE</fullName>
        <field>VAT_Classification__c</field>
        <literalValue>1</literalValue>
        <name>SAI Set Priv Pers VAT Class ME LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_VAT_Class_PDK_BE_LO</fullName>
        <field>VAT_Classification__c</field>
        <literalValue>1</literalValue>
        <name>SAI Set Priv Pers VAT Class PDK BE LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_VAT_Country_ME_LO_SE</fullName>
        <field>VAT_Country__c</field>
        <literalValue>SE</literalValue>
        <name>SAI Set Priv Pers VAT Country ME LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Priv_Pers_VAT_Country_PDK_BE_LO</fullName>
        <field>VAT_Country__c</field>
        <literalValue>DK</literalValue>
        <name>SAI Set Priv Pers VAT Country PDKBELODK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Type_as_Competitor</fullName>
        <field>Type__c</field>
        <literalValue>Competitor</literalValue>
        <name>SAI Set Type as Competitor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_Type_as_External_Partner</fullName>
        <field>Type__c</field>
        <literalValue>External Partner</literalValue>
        <name>SAI Set Type as External Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAI_Set_VAT_Country_SE</fullName>
        <field>VAT_Country__c</field>
        <literalValue>SE</literalValue>
        <name>SAI Set VAT Country SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Seat_Update_SAI_Search_for_IDs</fullName>
        <field>Search_for_IDs__c</field>
        <formula>Account__r.Involved_Party_ID__c&amp;&quot;+&quot;&amp;Account__r.Ella_Production_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.DPD_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.Production_Customer_Number__c&amp;&quot;+&quot;&amp;Account__r.DK_SAP_ERP__c&amp;&quot;+&quot;&amp;Account__r.Old_Customer_Number_Ella__c&amp;&quot;+&quot;&amp; Account__r.Old_Customer_Number_Orfa__c</formula>
        <name>Seat/Update SAI Search for IDs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_Active_Order_Registrar</fullName>
        <field>Is_Active_Order_Registrar_Number__c</field>
        <literalValue>1</literalValue>
        <name>Set Account Active Order Registrar</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_as_Customer</fullName>
        <field>Type</field>
        <literalValue>Customer</literalValue>
        <name>Set Account as Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Account_as_Prospect</fullName>
        <field>Type</field>
        <literalValue>Prospect</literalValue>
        <name>Set Account as Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SAI_Type_as_Customer</fullName>
        <field>Type__c</field>
        <literalValue>Customer</literalValue>
        <name>Set SAI Type as Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SAI_WS_Customer_Payment_Terms_PDK</fullName>
        <field>Payment_Terms__c</field>
        <literalValue>Z001</literalValue>
        <name>Set SAI WS Customer Payment Terms PDK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SAI_WS_Customer_Price_Group_PDK_BE</fullName>
        <field>Price_Group_Name__c</field>
        <literalValue>Z3</literalValue>
        <name>Set SAI WS Customer Price Group PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sales_Area_Information_Compound_Key</fullName>
        <description>This field update will set the compound key of the sales area information record.</description>
        <field>Sales_Area_Information_Compound_SFID__c</field>
        <formula>Account__r.Involved_Party_ID__c &amp; &quot;:&quot; &amp; TEXT(Sales_Area__c) &amp; &quot;:&quot; &amp;  TEXT(Distribution_Channel__c) &amp; &quot;:&quot; &amp;  TEXT(Division__c)</formula>
        <name>Set Sales Area Information Compound Key</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_Involved_Party_ID</fullName>
        <field>Involved_Party_ID__c</field>
        <formula>Account__r.Involved_Party_ID__c</formula>
        <name>Set/Update Involved Party ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_Account_Name</fullName>
        <field>Account_Name__c</field>
        <formula>Account__r.Name</formula>
        <name>Set/Update SAI Account Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_Corp_Reg_Nr</fullName>
        <field>Corporate_Registration_Number__c</field>
        <formula>Account__r.Corporate_Registration_Number__c</formula>
        <name>Set/Update SAI Corp Reg Nr</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_ME_SE_Sales_Office</fullName>
        <field>Sales_Office_Name__c</field>
        <literalValue>FK30</literalValue>
        <name>Set/Update SAI ME SE Sales Office</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>1000</literalValue>
        <name>Set/Update SAI PN Company Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_LO_DK</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F054</literalValue>
        <name>Set/Update SAI PN Company Code LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_LO_FI</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F367</literalValue>
        <name>Set/Update SAI PN Company Code LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_LO_FI_DPD</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F063</literalValue>
        <name>Set/Update SAI PN Company Code LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_LO_NO</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F074</literalValue>
        <name>Set/Update SAI PN Company Code LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_LO_SE</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F092</literalValue>
        <name>Set/Update SAI PN Company Code LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_ME_SE</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>F091</literalValue>
        <name>Set/Update SAI PN Company Code ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Update_SAI_PN_Company_Code_PDK_LO</fullName>
        <field>PostNord_Company_Name__c</field>
        <literalValue>4000</literalValue>
        <name>Set/Update SAI PN Company Code PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Account_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Legal_Entity</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Account Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <targetObject>Account__c</targetObject>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Send_New_Sales_Area_Info_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a sales area information is created, information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/CreateSalesforceSalesAreaInformationService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>Is_First_SAI__c</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send New Sales Area Info to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Updated_Sales_Area_Info_to_CINT</fullName>
        <apiVersion>27.0</apiVersion>
        <description>When a sales area information is updated (not created), information about it is sent to CINT.</description>
        <endpointUrl>https://ExternalSalesforceUser:ZpDP6JLfkvb8p78@api1.postnord.com/Soap/Partner/Ba/Customer/UpdateSalesforceSalesAreaInformationService_v0100</endpointUrl>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Last_PN_Synchronized_Date__c</fields>
        <fields>PN_Synchronized__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>integration.obmfromcrm@post.dk</integrationUser>
        <name>Send Updated Sales Area Info to CINT</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Copy LO DK Segments to Account</fullName>
        <actions>
            <name>Copy_LO_DK_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_DK_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_DK_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_DK_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the LO DK Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;0540&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy LO FI DPD Segments to Account</fullName>
        <actions>
            <name>Copy_LO_FI_DPD_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_DPD_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_DPD_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_DPD_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the LO FI DPD Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;0630&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy LO FI Segments to Account</fullName>
        <actions>
            <name>Copy_LO_FI_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_FI_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the LO FI Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;3670&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy LO NO Segments to Account</fullName>
        <actions>
            <name>Copy_LO_NO_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_NO_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_NO_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_NO_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the LO NO Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;LO NO&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy LO SE Segments to Account</fullName>
        <actions>
            <name>Copy_LO_SE_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_SE_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_SE_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_LO_SE_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the LO SE Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO92&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy ME SE Segments to Account</fullName>
        <actions>
            <name>Copy_ME_SE_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_ME_SE_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_ME_SE_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_ME_SE_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the ME SE Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy PDK BE Segments to Account</fullName>
        <actions>
            <name>Copy_PDK_BE_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_BE_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_BE_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_BE_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the PDK BE Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy PDK LO Segments to Account</fullName>
        <actions>
            <name>Copy_PDK_LO_CS_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_LO_Sales_Mode_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_LO_Sub_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Copy_PDK_LO_Top_Segment_to_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Copy the PDK LO Customer and Customer Service Segment Values to the Account object</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;4000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Sales Area Information Created - Send OBM</fullName>
        <actions>
            <name>Send_New_Sales_Area_Info_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a sales area information is created send info to CINT layer.</description>
        <formula>Sales_Area_Information_Compound_SFID__c &lt;&gt; null &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>New Sales Area Information Created Setting the Compound Key</fullName>
        <actions>
            <name>Set_Sales_Area_Information_Compound_Key</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the external ID that is used for integrations.</description>
        <formula>Account__r.Involved_Party_ID__c &lt;&gt; null &amp;&amp;  NOT(ISPICKVAL(Sales_Area__c, &apos;&apos;)) &amp;&amp;  NOT(ISPICKVAL(Distribution_Channel__c, &apos;&apos;)) &amp;&amp;  NOT(ISPICKVAL(Division__c, &apos;&apos;)) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer LE - Set Default Sales Office ME SE</fullName>
        <actions>
            <name>Set_Update_SAI_ME_SE_Sales_Office</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE, if LE SAI is created/updated as Customer and Sales Office has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) &amp;&amp; ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp; ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp; (Account__r.RecordType.DeveloperName  = &apos;Legal_Entity&apos;  || Account__r.RecordType.DeveloperName  = &apos;Work_Site&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer LE - Set Default Sales Office%2FGroup LO SE</fullName>
        <actions>
            <name>SAI_Create_Cust_LE_Sales_Group_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAI_Create_Cust_LE_Sales_Office_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area LO SE, if LE SAI is created/updated as Customer and Sales Group has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO92&apos;) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer LE%2FWS - Set Default Sales Group ME SE</fullName>
        <actions>
            <name>SAI_Create_Cust_LE_Sales_Group_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE, if LE SAI is created/updated as Customer and Sales Group has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;  (Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos; ||  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos;) &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer Private Person - Set Default Delivery Priority PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Delivery_Priority_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Delivery Priority has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Delivery_Priority__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer Private Person - Set Default Invoice Format PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Invoice_Format_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Invoice Format has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Invoice_Format__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer Private Person - Set Default Payment Terms PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Payment_Terms_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Payment Terms has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Payment_Terms__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer Private Person - Set Default Price Group PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Price_Group_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Price Group has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Price_Group_Name__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default Invoice Format PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_Inv_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Invoice Format has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Invoice_Format__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default Payment Terms PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Payment_Terms_PDK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Payment Terms has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Payment_Terms__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default Price Group PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Price_Group_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Price Group has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Price_Group_Name__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default Tax Category PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Tax_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and Tax Category has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;  ISPICKVAL( Tax_Category__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default VAT Country ME SE LO SE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_Default_VAT</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if work site SAI is created as Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) || ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Tax_Category__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; || Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default VAT Country PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS - Set Default VAT Country PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK, if work site SAI is created as Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) ||ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Delivery Priority PDK BE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Del_Prio_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site /extension SAI is created as Customer and Delivery Priority has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Delivery_Priority__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Invoice Format ME SE LO SE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Ext_Inv_Format_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if work site / extension SAI is created as Customer and Invoice Format has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Invoice_Format__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Invoice Frequence ME SE LO SE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Ext_Inv_Freq_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if work site / extension SAI is created as Customer and Invoice Frequence has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Invoice_Frequence__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Invoice Frequence PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_Default_Inv</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site / extension SAI is created as Customer and Invoice Frequence has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;    (ISPICKVAL( Type__c , &apos;Customer&apos;) || ISPICKVAL( Type__c , &apos;Prospect&apos;))&amp;&amp;    ISPICKVAL( Invoice_Frequence__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Invoice Spec Freq ME SE LO SE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Ext_Inv_Spec_Fre_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if work site / extension SAI is created as Customer and Invoice Specification Frequency has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Invoice_Specification_Frequency__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FExt - Set Default Payment Terms ME SE LO SE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Ext_Pay_Terms_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if work site / extension SAI is created as Customer and Payment Terms has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Payment_Terms__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Customer WS%2FLE%2FExt - Set Default Tax Category ME SE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_LE_Tax_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE, if work site/LE SAI is created as Customer and Tax Category has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) &amp;&amp;   ISPICKVAL( Type__c , &apos;Customer&apos;) &amp;&amp;   ISPICKVAL( Tax_Category__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos; ||  Account__r.RecordType.DeveloperName = &apos;Extension&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default Invoice Format PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_Inv_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and Invoice Format has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Invoice_Format__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default Payment Terms PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Payment_Terms_PDK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and Payment Terms has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Payment_Terms__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default Price Group PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Price_Group_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and Price Group has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Price_Group_Name__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default Tax Category PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Tax_Category</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and Tax Category has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( Tax_Category__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default VAT Classification PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default VAT Classification PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK, if Extension is created and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) || ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default VAT Country ME SE LO SE</fullName>
        <actions>
            <name>SAI_Set_VAT_Country_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if Extension is created and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;  ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default VAT Country PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Extension is created and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Default VAT Country PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK, if Extension is created and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) || ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;  ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Extension - Set Type to Customer</fullName>
        <actions>
            <name>SAI_Create_Extension_Set_Type_to_Custo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Extensions are always customers so set type on SAI to Customer when record type = Extension</description>
        <formula>Account__r.RecordType.DeveloperName = &apos;Extension&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Delivery Priority PDK BE</fullName>
        <actions>
            <name>SAI_Create_Cust_WS_Del_Prio_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE , if work site SAI is created as Prospect and Delivery Priority has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;  ISPICKVAL( Type__c , &apos;Prospect&apos;) &amp;&amp;  ISPICKVAL( Delivery_Priority__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Invoice Format PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_Inv_Format</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Prospect and Invoice Format has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;)&amp;&amp;  ISPICKVAL( Type__c , &apos;Prospect&apos;) &amp;&amp;  ISPICKVAL( Invoice_Format__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Payment Terms PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Payment_Terms_PDK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE , if work site SAI is created as Prospect and Payment Terms has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;  ISPICKVAL( Type__c , &apos;Prospect&apos;) &amp;&amp;  ISPICKVAL( Payment_Terms__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Price Group PDK BE</fullName>
        <actions>
            <name>Set_SAI_WS_Customer_Price_Group_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Prospect and Price Group has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;  ISPICKVAL( Type__c , &apos;Prospect&apos;) &amp;&amp;  ISPICKVAL( Price_Group_Name__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Sales Office PDK LO</fullName>
        <actions>
            <name>SAI_Create_Prospect_WS_PDK_LO_SOffice</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>For Sales Area PDK LO, if work site SAI is created as Prospect and Sales Office has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;4000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect WS - Set Default Sales Office and Sales Group PDK BE</fullName>
        <actions>
            <name>SAI_Create_Prospect_WS_Set_Default_Inv</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAI_Create_Prospect_WS_Set_Default_Sal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Prospect and Sales Office has not been populated then populateSales Office and Sales Group with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer LE%2FWS - Set Default VAT Classification PDK BE</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if LE/work site SAI is created as Prospect or Customer and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer LE%2FWS - Set Default VAT Classification PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Create_Customer_WS_Set_VAT_Class</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK, if LE/work site SAI is created as Prospect or Customer and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) || ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;   (Account__r.RecordType.DeveloperName = &apos;Work_Site&apos; ||  Account__r.RecordType.DeveloperName = &apos;Legal_Entity&apos;) &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person  - Set Default Sales Group PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Sales_Group_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Prospect/Customer and Sales Group has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Group_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person  - Set Default Sales Group PDK LO</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Sales_Group_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>For Sales Area PDK LO, if work site SAI is created as Prospect/Customer and Sales Group has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;4000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Group_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person  - Set Default Sales Office PDK LO</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Sales_Office_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>For Sales Area PDK LO, if work site SAI is created as Prospect/Customer and Sales Office has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;4000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default Sales Office PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_Sales_Office_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site SAI is created as Prospect/Customer and Sales Office has not been populated then populate with default value</description>
        <formula>ISPICKVAL( Sales_Area__c , &apos;1000&apos;) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( Sales_Office_Name__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Classification ME SE LO SE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Class_ME_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if Private Person SAI is created as Prospect or Customer and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Classification PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Class_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Private Person SAI is created as Prospect or Customer and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Classification PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Class_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK, if Private Person SAI is created as Prospect or Customer and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) ||ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Country ME SE LO SE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Country_ME_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area ME SE or LO SE, if Private Person SAI is created as Prospect or Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;FO91&apos;) ||  ISPICKVAL( Sales_Area__c , &apos;FO92&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Country PDK BE</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Country_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if Private Person SAI is created as Prospect or Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer Private Person - Set Default VAT Country PDK BE LO DK</fullName>
        <actions>
            <name>SAI_Set_Priv_Pers_VAT_Country_PDK_BE_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE or LO DK , if Private Person SAI is created as Prospect or Customer and VAT Country has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;) ||ISPICKVAL( Sales_Area__c , &apos;1000&apos;)) &amp;&amp;   (ISPICKVAL( Type__c , &apos;Customer&apos;) ||  ISPICKVAL( Type__c , &apos;Prospect&apos;)) &amp;&amp;   ISPICKVAL( VAT_Country__c , &apos;&apos;) &amp;&amp;   Account__r.RecordType.DeveloperName = &apos;PersonAccount&apos; &amp;&amp;   $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create Prospect%2FCustomer WS%2FPrivate Person - Set Default Email Block PDK BE</fullName>
        <actions>
            <name>SAI_Set_Email_Block</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Sales Area PDK BE, if work site/private person SAI is created as Prospect or Customer and populate Email Block with default value</description>
        <formula>(ISPICKVAL (Sales_Area__c, &apos;1000&apos;)) &amp;&amp; (ISPICKVAL (Type__c, &apos;Prospect&apos;) || ISPICKVAL (Type__c, &apos;Customer&apos;)) &amp;&amp; (Account__r.RecordType.Name = &apos;Work Site&apos; || Account__r.RecordType.Name = &apos;Private Person&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create WS - Set Default VAT Classification LO DK</fullName>
        <active>false</active>
        <description>For Sales Area LO DK  if WS is created and VAT Classification has not been populated then populate with default value</description>
        <formula>(ISPICKVAL( Sales_Area__c , &apos;0540&apos;)) &amp;&amp;  ISPICKVAL( VAT_Classification__c , &apos;&apos;) &amp;&amp;  Account__r.RecordType.DeveloperName = &apos;Worksite&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company LO DK</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is LO DK set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;0540&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company LO FI</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is LO FI set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;3670&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company LO FI DPD</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is LO FI DPD set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;0630&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company LO NO</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is LO NO set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;LO NO&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company LO SE</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is LO SE set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;FO92&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company ME SE</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is ME SE set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;FO91&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company PDK BE</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a SAI is created/updated and Sales Area is PDK BE set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;1000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAI Create%2FUpdate - Set PN Company PDK LO</fullName>
        <actions>
            <name>Set_Update_SAI_PN_Company_Code_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When a SAI is created/updated and Sales Area is PDK LO set the PN Company Code.</description>
        <formula>ISPICKVAL ( Sales_Area__c, &apos;4000&apos;) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set B2B Webshop Dummy Type to Customer</fullName>
        <actions>
            <name>Set_Account_as_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SAI_Type_as_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Webshop dummy accounts will always be customers so set type to customer for these accounts</description>
        <formula>Account__r.RecordType.DeveloperName  = &apos;B2B_Webshop_Placeholder&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set B2C Webshop Dummy Type to Customer</fullName>
        <actions>
            <name>Set_Account_as_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_SAI_Type_as_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Webshop dummy accounts will always be customers so set type to customer for these accounts</description>
        <formula>Account__r.RecordType.DeveloperName  = &apos;B2C_Webshop_Placeholder&apos; &amp;&amp;  $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Competitor Flag</fullName>
        <actions>
            <name>Account_Set_Competitor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAI_Set_Competitor_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If account has record type of Competitor or Competitor box checked then check the Competitor checkbox on Sales Area Information and Account</description>
        <formula>(Account__r.RecordType.Name = &apos;Competitor&apos; || Competitor__c = TRUE)&amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set External Partner Flag</fullName>
        <actions>
            <name>Account_Set_External_Partner_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAI_Set_External_Partner_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Parent Account record type has been set as External Partner or SAI External partner flag has been ticked then update the External Partner flag</description>
        <formula>(Account__r.RecordType.Name = &apos;External Partner&apos; || External_Partner__c = TRUE || NOT (ISPICKVAL(External_Partner_Type__c, &apos;&apos;))) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Type as Competitor</fullName>
        <actions>
            <name>SAI_Set_Type_as_Competitor</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Account RT = Competitor on create of SAI then set type field to Competitor on SAI</description>
        <formula>Account__r.No_of_SAI__c = 0 &amp;&amp; Account__r.RecordType.Name = &apos;Competitor&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Type as External Partner</fullName>
        <actions>
            <name>SAI_Set_Type_as_External_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Account RT = External Partner on create of SAI then set type field to External Partner on SAI</description>
        <formula>Account__r.No_of_SAI__c = 0 &amp;&amp; Account__r.RecordType.Name = &apos;External Partner&apos; &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set%2FUpdate IP ID and CVR</fullName>
        <actions>
            <name>Seat_Update_SAI_Search_for_IDs</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_Involved_Party_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_SAI_Account_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Update_SAI_Corp_Reg_Nr</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set and update the Involved Party ID and Corporate Registration Number from the parent account of the Sales Area Information record. This is being done as text fields and not formulas so that the information is searchable via Global Search</description>
        <formula>1=1 &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Account to Customer</fullName>
        <actions>
            <name>Set_Account_Active_Order_Registrar</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Account_as_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a Sales Area for an account is updated to type of customer then update the account it&apos;s associated to customer and set Is Active Order registrar to True</description>
        <formula>ISPICKVAL (Type__c, &apos;Customer&apos;) &amp;&amp; NOT(ISPICKVAL ( Account__r.Type, &apos;Customer&apos;)) &amp;&amp; $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Account to Prospect - Ext Partner%2FComp</fullName>
        <actions>
            <name>Set_Account_as_Prospect</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Account_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If a Sales Area for an account is updated to type of prospect from External Partner or Competitor, set the parent account to Prospect and change parent account record type if parent is not a Legal Entity (rt of ext partner or competitor)</description>
        <formula>AND( OR (CreatedDate &lt;&gt; LastModifiedDate, Account__r.No_of_SAI__c &gt; 0), OR(Account__r.RecordType.Name = &apos;Competitor&apos;, Account__r.RecordType.Name = &apos;External Partner&apos;),  ISPICKVAL(Type__c, &apos;Prospect&apos;), $Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update on Sales Area Information - Send OBM</fullName>
        <actions>
            <name>Send_Updated_Sales_Area_Info_to_CINT</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>When a sales area information is updated (not created) send info to CINT layer.</description>
        <formula>ISNEW()=false &amp;&amp; $Setup.DisableAutomation__c.Disable_All_OBM_Workflows__c = false</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
