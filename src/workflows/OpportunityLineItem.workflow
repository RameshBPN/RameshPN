<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Opportunity_Product_Family_Update</fullName>
        <field>Product_Family__c</field>
        <formula>Text(Product2.Family)</formula>
        <name>Opportunity Product Family Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_End_Stage_on_Opp_Product</fullName>
        <description>This field update will set the End Stage from on the Opportunity Product.</description>
        <field>End_Stage__c</field>
        <formula>IF (ISNEW(), &quot;&quot;,
IF(ISPICKVAL(Product_Status__c, &apos;In Progress&apos;), &quot;&quot;,
IF(ISPICKVAL(Opportunity.StageName, &apos;Closed Won&apos;) &amp;&amp; ISBLANK(End_Stage__c), Opportunity.Stage_Before_Closed__c,
IF(ISPICKVAL(Opportunity.StageName, &apos;Closed Lost&apos;) &amp;&amp; ISBLANK(End_Stage__c), Opportunity.Stage_Before_Closed__c,
IF(OR(ISPICKVAL(Product_Status__c, &apos;Won&apos;), ISPICKVAL(Product_Status__c, &apos;Lost&apos;)) 
&amp;&amp; NOT(ISPICKVAL(Opportunity.StageName, &apos;Closed Won&apos;)) &amp;&amp; NOT(ISPICKVAL(Opportunity.StageName, &apos;Closed Lost&apos;)), TEXT(Opportunity.StageName),End_Stage__c
)))))</formula>
        <name>Set End Stage on Opp Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Has_4000_product_to_true</fullName>
        <field>Has_4000_Products_or_Last_Mile__c</field>
        <literalValue>1</literalValue>
        <name>Set Has 4000 product to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Initial_Amount_on_Opp_Product</fullName>
        <field>Initial_Amount__c</field>
        <formula>IF (ISNEW(), Opportunity_Value__c,
IF (AND(ISPICKVAL(Product_Status__c, &apos;In Progress&apos;),
NOT(ISPICKVAL(PRIORVALUE(Product_Status__c), &apos;In Progress&apos;))),
Opportunity_Value__c, 
IF (Initial_Amount__c &gt; 0,Initial_Amount__c,  Opportunity_Value__c)))</formula>
        <name>Set Initial Amount on Opp Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Is_4000_Product_to_True</fullName>
        <field>Is_4000_Product__c</field>
        <literalValue>1</literalValue>
        <name>Set Is 4000 Product to True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Start_Stage_on_Opp_Product</fullName>
        <field>Start_Stage__c</field>
        <formula>TEXT(Opportunity.StageName)</formula>
        <name>Set Start Stage on Opp Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Uncheck_K_rsler</fullName>
        <field>Has_Korsler__c</field>
        <literalValue>0</literalValue>
        <name>Uncheck Kørsler</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Has_K_rsler_field_on_Opp</fullName>
        <field>Has_Korsler__c</field>
        <literalValue>1</literalValue>
        <name>Update Has Kørsler field on Opp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Product_Type_Existi</fullName>
        <field>Type__c</field>
        <literalValue>Renegotiation</literalValue>
        <name>Update Opportunity Product Type - Existi</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Product_Type_New</fullName>
        <description>Update to new business if existing value = 0 and business value &gt; 0</description>
        <field>Type__c</field>
        <literalValue>New Business</literalValue>
        <name>Update Opportunity Product Type - New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sales_Price</fullName>
        <description>Set Sales Price on Opp Product to be = Business Value when product is in status Won or In Progress for Open/Closed Won opps and when product is in Status Lost for Closed Lost Opps</description>
        <field>UnitPrice</field>
        <formula>CASE ( Product_Status__c ,
&apos;Lost&apos;,
(CASE( Opportunity.StageName,
&apos;Closed Lost&apos;,  Opportunity_Value__c,
0)),
Opportunity_Value__c)</formula>
        <name>Update Sales Price</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Check for Kørsler</fullName>
        <actions>
            <name>Update_Has_K_rsler_field_on_Opp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>equals</operation>
            <value>Kørsler</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Value__c</field>
            <operation>lessOrEqual</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <description>This rule checks if the product is Kørsler and new business and if so updates a checkbox in the opportunity that is used in the contract renewals opportunity approval process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check for PDK LO</fullName>
        <actions>
            <name>Set_Has_4000_product_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Is_4000_Product_to_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Sales_Area__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <description>This rule checks if the product is PDK LO and if so updates a checkbox in the opportunity that is used in the contract renewals opportunity approval process</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set End Stage on Opp Product</fullName>
        <actions>
            <name>Set_End_Stage_on_Opp_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set the end stage on the opportunity product if opportunity or opportunity product is closed.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Initial Amount on Opp Product</fullName>
        <actions>
            <name>Set_Initial_Amount_on_Opp_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Opportunity_Value__c</field>
            <operation>greaterThan</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <description>Copy the Opportunity Value from the opportunity product to the Initial Amount field on Opportunity Product when the Opportunity Value field is first &gt; 0. To be used by BW for pipeline reporting.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Start Stage on Opp Product</fullName>
        <actions>
            <name>Set_Start_Stage_on_Opp_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy the stage from the opportunity to the Start stage field on Opportunity Product when an opportunity product is created. To be used by BW for pipeline reporting. Runs every time a product is created.</description>
        <formula>$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c != true</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Kørsler</fullName>
        <actions>
            <name>Uncheck_K_rsler</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Sales Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Product2.Name</field>
            <operation>equals</operation>
            <value>Kørsler</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Value__c</field>
            <operation>greaterThan</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <description>This rule checks if the product is Kørsler and existing business and if so updates a checkbox in the opportunity that is used in the contract renewals opportunity approval process to false</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Product Family</fullName>
        <actions>
            <name>Opportunity_Product_Family_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Product_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Update Opportunity Product Family to store the product family from the product list</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Product Type - Existing</fullName>
        <actions>
            <name>Update_Opportunity_Product_Type_Existi</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Value__c</field>
            <operation>greaterThan</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Type__c</field>
            <operation>notEqual</operation>
            <value>Change of Services</value>
        </criteriaItems>
        <description>Set the type of business based on Existing and Business Value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Opportunity Product Type - New</fullName>
        <actions>
            <name>Update_Opportunity_Product_Type_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>OpportunityLineItem.Opportunity_Value__c</field>
            <operation>greaterThan</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Existing_Value__c</field>
            <operation>lessOrEqual</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>OpportunityLineItem.Type__c</field>
            <operation>notEqual</operation>
            <value>Change of Services</value>
        </criteriaItems>
        <description>Set the type of business based on Existing and Business Value</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Sales Price</fullName>
        <actions>
            <name>Update_Sales_Price</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.Opportunity_Value__c</field>
            <operation>greaterThan</operation>
            <value>SEK 0</value>
        </criteriaItems>
        <description>Set Sales price to be the same as the business value of the opportunity product. This will then set the Opportunity Amount correctly for pipeline reporting</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
