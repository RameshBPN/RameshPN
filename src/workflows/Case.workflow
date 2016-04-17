<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Appeal_rejected</fullName>
        <field>Status</field>
        <literalValue>Approval Declined</literalValue>
        <name>Appeal rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Appeal_submission</fullName>
        <field>Status</field>
        <literalValue>For Approval</literalValue>
        <name>Appeal submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ApprovalIntialStatusUpdate</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Not started</literalValue>
        <name>Approval Intial Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Case_Submitted_Time</fullName>
        <field>Submitted_Time__c</field>
        <formula>NOW()</formula>
        <name>Approval Case Submitted Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Intial_Status_Update_Both</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Pending operations</literalValue>
        <name>Approval Intial Status Update Both</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approval_Intial_Status_Update_Operations</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Created</literalValue>
        <name>Approval Intial Status Update Operations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ApprovedStatus</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>ApprovedStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Amount_for_Appeal</fullName>
        <field>Approved_Appeal_Amount__c</field>
        <formula>Appeal_Amount__c</formula>
        <name>Approved Amount for Appeal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Amount_of_compensation</fullName>
        <field>Approved_amount_of_compensation__c</field>
        <formula>Total_payment_of_compensation__c</formula>
        <name>Approved Amount of compensation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_By</fullName>
        <field>Approved_By__c</field>
        <formula>$User.FirstName+&quot; &quot;+ $User.LastName  + &quot; &quot; + TEXT( Now())</formula>
        <name>Approved By</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Approved_Goodwill_Amount</fullName>
        <field>Approved_Goodwill_Amount__c</field>
        <formula>Goodwill_Amount__c</formula>
        <name>Approved Goodwill Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_out_Date_Contract_Sent</fullName>
        <field>Date_Contract_Sent__c</field>
        <name>Blank out Date Contract Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Blank_out_Date_Materials_Delivered</fullName>
        <field>Date_material_delivered__c</field>
        <name>Blank out Date Materials Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>BothToPricegroup</fullName>
        <field>Opportunity_Approval_Type__c</field>
        <literalValue>Price group</literalValue>
        <name>BothToPricegroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Area</fullName>
        <field>Business_Area__c</field>
        <formula>TEXT($User.Sales_Area1__c)</formula>
        <name>Business Area</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Description_is_Blank</fullName>
        <field>Description</field>
        <formula>&quot; &quot;</formula>
        <name>Case Description is Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clone_case_update</fullName>
        <field>Clone_case__c</field>
        <literalValue>1</literalValue>
        <name>Clone_case_update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Close_case_if_final_dec</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Close case if final dec</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DK_Admin_Cases</fullName>
        <field>OwnerId</field>
        <lookupValue>DK_Admin_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>DK Admin Cases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Date_For_Marked_for_Deletion</fullName>
        <field>Date_of_Marked_for_Deletion__c</field>
        <formula>Today ()</formula>
        <name>Date for Marked for Deletion</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktip6@post.dk&quot;</formula>
        <name>Inbound Denmark fktip6@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_Dpd_dpd_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;Dpd@dpd.dk&quot;</formula>
        <name>Inbound Denmark Dpd@dpd.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_brevstregkoder_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;grpds110@post.dk&quot;</formula>
        <name>Inbound Denmark grpds110@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_creditlock_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;creditlock@post.dk&quot;</formula>
        <name>Inbound Denmark creditlock@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_eposthuset_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;eposthuset@post.dk&quot;</formula>
        <name>Inbound Denmark eposthuset@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_erhvervsflyt_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;erhvervsflyt@post.dk&quot;</formula>
        <name>Inbound Denmark erhvervsflyt@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktds17_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktds17@post.dk&quot;</formula>
        <name>Inbound Denmark fktds17@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktekv3_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktekv3@post.dk&quot;</formula>
        <name>Inbound Denmark fktekv3@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktinc23_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktinc23@post.dk&quot;</formula>
        <name>Inbound Denmark fktinc23@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktinc25_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktinc25@post.dk&quot;</formula>
        <name>Inbound Denmark fktinc25@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktinc27_postdk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktinc27@post.dk&quot;</formula>
        <name>Inbound Denmark fktinc27@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktkul17_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktkul17@post.dk&quot;</formula>
        <name>Inbound Denmark fktkul17@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktkul26_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktkul26@post.dk&quot;</formula>
        <name>Inbound Denmark fktkul26@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktkul51_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktkul51@post.dk&quot;</formula>
        <name>Inbound Denmark fktkul51@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktkul52_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktkul52@post.dk&quot;</formula>
        <name>Inbound Denmark fktkul52@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktkul60_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktkul60@post.dk&quot;</formula>
        <name>Inbound Denmark fktkul60@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktprt14_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktprt14@post.dk&quot;</formula>
        <name>Inbound Denmark fktprt14@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck113_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck113@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck113@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck153_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck153@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck153@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck154_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck154@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck154@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck174post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck174@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck174post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck178_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck178@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck178@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck180_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck180@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck180@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck181_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck181@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck181@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck182_postdk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck182@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck182@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck183_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck183@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck183@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck185_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck185@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck185@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck206_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck206@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck206@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck216_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck216@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck216@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck217_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck217@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck217@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck236_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck236@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck236@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck237_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck237@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck237@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck238_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck238@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck238@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck24_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck24@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck24@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck8_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck8@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck8@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck92_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck92@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck92@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktsck96_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktsck96@post.dk&quot;</formula>
        <name>Inbound Denmark fktsck96@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktscr108_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktscr108@post.dk&quot;</formula>
        <name>Inbound Denmark fktscr108@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktscr109_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktscr109@post.dk&quot;</formula>
        <name>Inbound Denmark fktscr109@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktscr110_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktscr110@post.dk&quot;</formula>
        <name>Inbound Denmark fktscr110@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_fktscr86_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktscr86@post.dk&quot;</formula>
        <name>Inbound Denmark fktscr86@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_flyt_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;flyt@post.dk&quot;</formula>
        <name>Inbound Denmark flyt@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_gic_dpd_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;gic@dpd.dk&quot;</formula>
        <name>Inbound Denmark gic@dpd.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_international_dpd_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;international@dpd.dk&quot;</formula>
        <name>Inbound Denmark international@dpd.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_kundeservice_erhverv_pos</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;kundeservice.erhverv@post.dk&quot;</formula>
        <name>Inbound Denmark kundeservice.erhverv@pos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_kundesupport_erhverv</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;kundesupport.erhverv@post.dk&quot;</formula>
        <name>Inbound Denmark kundesupport.erhverv@pos</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_bl_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.bl@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.bl@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_br_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.br@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.br@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_go_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.go@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.go@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_gr_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.gr@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.gr@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_or_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.or@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.or@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_re_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.re@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.re@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_si_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.si@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.si@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_wh_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.wh@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.wh@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_logistik_ye_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;logistik.ye@post.dk&quot;</formula>
        <name>Inbound Denmark logistik.ye@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_modtager_betaler_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;modtager.betaler@post.dk&quot;</formula>
        <name>Inbound Denmark modtager.betaler@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_paragraf9_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;paragraf9@post.dk&quot;</formula>
        <name>Inbound Denmark paragraf9@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_post_levering_til_doren</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;post.levering.til.doren@post.dk&quot;</formula>
        <name>Inbound Denmark post.levering.til.doren</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_salesadministration_post</fullName>
        <field>Origin</field>
        <literalValue>salesadministration@post.dk</literalValue>
        <name>Inbound Denmark salesadministration@post</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_skrivpost_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;skrivpost@post.dk&quot;</formula>
        <name>Inbound Denmark skrivpost@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_stamps_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;stamps@post.dk&quot;</formula>
        <name>Inbound Denmark stamps@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_Denmark_tidlig_post_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;tidlig.post@post.dk&quot;</formula>
        <name>Inbound Denmark tidlig.post@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_LODK_ems_dk_postnord_com</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;ems.dk@postnord.com&quot;</formula>
        <name>Inbound LODK ems.dk@postnord.com</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_LODK_kundservicePN_postnord_com</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;kundservicePN@postnord.com&quot;</formula>
        <name>Inbound LODK kundservicePN@postnord.com</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Inbound_email_for_fktek40_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;fktek40@post.dk&quot;</formula>
        <name>Inbound email for fktek40@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_DS_DK</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_DS_DK</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_CS Online &amp; Opti</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_ERHV_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_ERHV_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_ERHV_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_ERHV_CS_Complaints_inbound2</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LO_VIP_Customer</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_ERHV_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_ERHV_CS_Complaints_inbound_1</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LO_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_ERHV_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_FRM_DK</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_PRIV_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_FRM_DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_PRIV_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_PRIV_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_PRIV_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_PRT_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_PRT_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_PRT_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_BE_SCR_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_SCR_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_BE_SCR_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_LODK_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LODK_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_LODK_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_LODK_Incoming_Cases</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LODK_Inbound_Cases</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK LODK Incoming Cases</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_LO_CS_Complaints_inbound</fullName>
        <description>This rule updates the case owner as the queue mentioned above</description>
        <field>OwnerId</field>
        <lookupValue>PDK_LO_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_LO_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_LO_CS_Complaints_inbound1</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LO_VIP_Customer</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_LO_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDK_LO_VIP_Customer</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_LO_VIP_Customer</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PDK_LO_VIP Customer</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_Invoice_questions</fullName>
        <field>OwnerId</field>
        <lookupValue>PNDK_Invoice_questions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_Invoice questions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_KUL_CCtest_inbound</fullName>
        <description>This field update is for the CC test of queue</description>
        <field>OwnerId</field>
        <lookupValue>Fluido_Test</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_CCtest_inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_KUL_CMA_Salgsl_sninge</fullName>
        <field>OwnerId</field>
        <lookupValue>PNDK_KUL_Major_Acoount_support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_CMA&amp; Salgsløsninge inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_KUL_CS_Private_2_lev</fullName>
        <field>OwnerId</field>
        <lookupValue>PNDK_KUL_CS_Private_2_lev</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_CS_Private 2 lev</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_KUL_Major_Account_support</fullName>
        <field>OwnerId</field>
        <lookupValue>PNDK_KUL_Major_Acoount_support</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_Major Account support</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_KUL_Salgs_Driftsadministration</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_ERHV_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_KUL_Salgs &amp; Driftsadministration</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_Payment_questions</fullName>
        <field>OwnerId</field>
        <lookupValue>PNDK_Payment_questions</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_Payment questions</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PNDK_SSF_CS_Complaints_inbound</fullName>
        <field>OwnerId</field>
        <lookupValue>PDK_BE_SCR_CS_Complaints_inbound</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>PNDK_SSF_CS &amp; Complaints inbound</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Payment_triggered_time</fullName>
        <field>Payment_Triggered_time__c</field>
        <formula>NOW()</formula>
        <name>Payment triggered time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reason</fullName>
        <field>Reason__c</field>
        <literalValue>Postbox</literalValue>
        <name>Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reason_Creditlock</fullName>
        <field>Reason__c</field>
        <literalValue>Credit Lock</literalValue>
        <name>Reason</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RejectionStatus</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>RejectionStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_LO_DK</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>0540</literalValue>
        <name>Set Case Sales Area Owner- LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_LO_FI</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>3670</literalValue>
        <name>Set Case Sales Area Owner - LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_LO_FI_DPD</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>0630</literalValue>
        <name>Set Case Sales Area Owner - LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_LO_NO</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set Case Sales Area Owner- LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_LO_SE</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>FO92</literalValue>
        <name>Set Case Sales Owner Area - LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_ME_SE</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>FO91</literalValue>
        <name>Set Case Sales Owner Area - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_PDK_BE</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>1000</literalValue>
        <name>Set Case Sales Area Owner - PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_PDK_LO</fullName>
        <field>Sales_Area_Owner__c</field>
        <literalValue>4000</literalValue>
        <name>Set Case Sales Area Owner - PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_LO_DK</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>0540</literalValue>
        <name>Set Case Sales Area Product - LO DK</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_LO_FI</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>3670</literalValue>
        <name>Set Case Sales Area Product - LO FI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_LO_FI_DPD</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>0630</literalValue>
        <name>Set Case Sales Area Product - LO FI DPD</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_LO_NO</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>LO NO</literalValue>
        <name>Set Case Sales Area Product - LO NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_LO_SE</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>FO92</literalValue>
        <name>Set Case Sales Area Product - LO SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_ME_SE</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>FO91</literalValue>
        <name>Set Case Sales Area Product - ME SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_PDK_BE</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>1000</literalValue>
        <name>Set Case Sales Area Product - PDK BE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Sales_Area_Product_PDK_LO</fullName>
        <field>Sales_Area_Product__c</field>
        <literalValue>4000</literalValue>
        <name>Set Case Sales Area Product - PDK LO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Created_by_Team</fullName>
        <field>Created_by_Team__c</field>
        <formula>TEXT(CreatedBy.Team__c)</formula>
        <name>Set Created by Team</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Contract_Sent_to_Today</fullName>
        <field>Date_Contract_Sent__c</field>
        <formula>TODAY()</formula>
        <name>Set Date Contract Sent to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Materials_Delivered_to_Today</fullName>
        <field>Date_material_delivered__c</field>
        <formula>TODAY()</formula>
        <name>Set Date Materials Delivered to Today</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_of_Appeal</fullName>
        <field>Date_of_Appeal__c</field>
        <formula>NOW()</formula>
        <name>Set Date of Appeal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Sent_for_investigation_timestamp</fullName>
        <field>Sent_for_Investigation_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Sent for investigation timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Survey_Response_Timestamp_on_Case</fullName>
        <description>Setting the date when the case has been updated with the &quot;Survey Answered&quot; status.</description>
        <field>Survey_Response_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Set Survey Response Timestamp on Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_subject_to_credit_check</fullName>
        <field>Subject</field>
        <formula>&quot;Credit Check&quot;</formula>
        <name>Set subject to credit check</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Reject</fullName>
        <field>Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Status_Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Sub_Type</fullName>
        <field>Sub_Type__c</field>
        <literalValue>Sales</literalValue>
        <name>Sub Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Upadate_Status_Field_on_Approval_Admin</fullName>
        <field>Status</field>
        <literalValue>Sales Approval</literalValue>
        <name>Upadate Status Field on Approval Admin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_status_On_Close</fullName>
        <field>Opportunity_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval status On Close</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_Operations</fullName>
        <field>OwnerId</field>
        <lookupValue>PN_DK_Operations_approval</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner Operations</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Owner_Pricegroup</fullName>
        <field>OwnerId</field>
        <lookupValue>PN_DK_Pricegroup_approval</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Case Owner Pricegroup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_Sales</fullName>
        <field>Status</field>
        <literalValue>Sales Approval Inprogress</literalValue>
        <name>Update Case Status Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_status_to_Request_for_Info</fullName>
        <description>Updating a case to status &quot;request for information&quot;</description>
        <field>Status</field>
        <literalValue>Request for Information</literalValue>
        <name>Update Case status to Request for Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_C_O</fullName>
        <field>Comp_Receiver_C_O__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_C_O__c</formula>
        <name>Update Comp Receiver C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_City</fullName>
        <field>Comp_Receiver_City__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_City__c</formula>
        <name>Update Comp Receiver City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_House_Letter</fullName>
        <field>Comp_Receiver_House_Letter__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_House_Letter__c</formula>
        <name>Update Comp Receiver House Letter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_House_Number</fullName>
        <field>Comp_Receiver_House_Number__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_House_Number__c</formula>
        <name>Update Comp Receiver House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_House_Number_Supp</fullName>
        <field>Comp_Receiver_House_Number_Supplement__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_House_Number_Supplement__c</formula>
        <name>Update Comp Receiver House Number Supp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_PO_Box</fullName>
        <field>Comp_Receiver_PO_Box__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_PO_Box__c</formula>
        <name>Update Comp Receiver PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_Postal_Code</fullName>
        <field>Comp_Receiver_Postal_Code__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_Postal_Code__c</formula>
        <name>Update Comp Receiver Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_Room_Number</fullName>
        <field>Comp_Receiver_Room_Number__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_Room_Number__c</formula>
        <name>Update Comp Receiver Room Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_Street</fullName>
        <field>Comp_Receiver_Street__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_Street__c</formula>
        <name>Update Comp Receiver Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Comp_Receiver_Suburb</fullName>
        <field>Comp_Receiver_Suburb__c</field>
        <formula>Compensation_Receiver__r.Postal_Address_Suburb__c</formula>
        <name>Update Comp Receiver Suburb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_DK_it_kunder_post_dk</fullName>
        <field>Functional_inbox__c</field>
        <formula>&quot;itkunder@post.dk&quot;</formula>
        <name>Update DK it.kunder@post.dk</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Marked_for_Deletion_to_Blank</fullName>
        <field>Date_of_Marked_for_Deletion__c</field>
        <name>Update Date Marked for Deletion to Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_No_of_Times_Contract_Ordered</fullName>
        <field>No_of_times_contract_ordered__c</field>
        <formula>No_of_times_contract_ordered__c + 1</formula>
        <name>Update No of Times Contract Ordered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_No_of_Times_Material_Delivered</fullName>
        <field>No_of_Times_Material_Delivered__c</field>
        <formula>IF (ISBLANK(No_of_Times_Material_Delivered__c) ||  ISNULL(No_of_Times_Material_Delivered__c) || No_of_Times_Material_Delivered__c&lt;1,1,No_of_Times_Material_Delivered__c+1)</formula>
        <name>Update_No of Times Material Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_C_O</fullName>
        <field>Postal_Address_C_O__c</field>
        <formula>Account.Postal_Address_C_O__c</formula>
        <name>Update Postal Address C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_City</fullName>
        <field>Postal_Address_City__c</field>
        <formula>Account.Postal_Address_City__c</formula>
        <name>Update Postal Address City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_House_Letter</fullName>
        <field>Postal_Address_House_Letter__c</field>
        <formula>Account.Postal_Address_House_Letter__c</formula>
        <name>Update Postal Address House Letter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_House_Number</fullName>
        <field>Postal_Address_House_Number__c</field>
        <formula>Account.Postal_Address_House_Number__c</formula>
        <name>Update  	 Postal Address House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_House_Number_Sup</fullName>
        <field>Postal_Address_House_Number_Supplement__c</field>
        <formula>Account.Postal_Address_House_Number_Supplement__c</formula>
        <name>Update 	 Postal Address House Number Sup</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_PO_Box</fullName>
        <field>Postal_Address_PO_Box__c</field>
        <formula>Account.Postal_Address_PO_Box__c</formula>
        <name>Update Postal Address PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_Postal_Code</fullName>
        <field>Postal_Address_Postal_Code__c</field>
        <formula>Account.Postal_Address_Postal_Code__c</formula>
        <name>Update 	 Postal Address Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_Room_Number</fullName>
        <field>Postal_Address_Room_Number__c</field>
        <formula>Account.Postal_Address_Room_Number__c</formula>
        <name>Update Postal Address Room Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Postal_Address_Street</fullName>
        <field>Postal_Address_Street__c</field>
        <formula>Account.Postal_Address_Street__c</formula>
        <name>Update 	 Postal Address Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Address_House_Letter</fullName>
        <field>Receiver_Postal_Address_House_Letter__c</field>
        <formula>Receiver__r.Postal_Address_House_Letter__c</formula>
        <name>Update Receiver Address House Letter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Address_House_Number</fullName>
        <field>Receiver_Postal_Address_House_Number__c</field>
        <formula>Receiver__r.Postal_Address_House_Number__c</formula>
        <name>Update Receiver Address House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Address_PO_Box</fullName>
        <field>Receiver_Postal_Address_PO_Box__c</field>
        <formula>Receiver__r.Postal_Address_PO_Box__c</formula>
        <name>Update Receiver Address PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Address_Room_Number</fullName>
        <field>Receiver_Postal_Address_Room_Number__c</field>
        <formula>Receiver__r.Postal_Address_Room_Number__c</formula>
        <name>Update Receiver Address Room Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Contact_Email</fullName>
        <field>Receiver_contact_email__c</field>
        <formula>IF(Receiver__r.IsPersonAccount, Receiver__r.PersonEmail, Receiver__r.Email_Address__c )</formula>
        <name>Update Receiver Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Contact_Mobile</fullName>
        <field>Receiver_Contact_Mobile__c</field>
        <formula>Receiver__r.Mobile_Phone__c</formula>
        <name>Update Receiver Contact Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Contact_Telephone</fullName>
        <field>Receiver_Contact_Telephone__c</field>
        <formula>Receiver__r.Phone</formula>
        <name>Update Receiver Contact Telephone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_House_Number_Supplement</fullName>
        <field>Receiver_Postal_Address_House_Number_S__c</field>
        <formula>Receiver__r.Postal_Address_House_Number_Supplement__c</formula>
        <name>Update Receiver House Number Supplement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Postal_Address_C_O</fullName>
        <field>Receiver_Postal_Address_C_O__c</field>
        <formula>Receiver__r.Postal_Address_C_O__c</formula>
        <name>Update Receiver Postal Address C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Postal_Address_City</fullName>
        <field>Receiver_Postal_Address_City__c</field>
        <formula>Receiver__r.Postal_Address_City__c</formula>
        <name>Update Receiver Postal Address City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Postal_Address_Street</fullName>
        <field>Receiver_Postal_Address_Street__c</field>
        <formula>Receiver__r.Postal_Address_Street__c</formula>
        <name>Update Receiver Postal Address Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Receiver_Suburb</fullName>
        <field>Receiver_Postal_Address_Suburb__c</field>
        <formula>Receiver__r.Postal_Address_Suburb__c</formula>
        <name>Update Receiver Suburb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_C_O</fullName>
        <field>Regress_Partner_C_O__c</field>
        <formula>Regress_partner__r.Postal_Address_C_O__c</formula>
        <name>Update Regress Partner C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_City</fullName>
        <field>Regress_Partner_City__c</field>
        <formula>Regress_partner__r.Postal_Address_City__c</formula>
        <name>Update Regress Partner City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_House_Letter</fullName>
        <field>Regress_Partner_House_Letter__c</field>
        <formula>Regress_partner__r.Postal_Address_House_Letter__c</formula>
        <name>Update Regress Partner House Letter</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_House_Number</fullName>
        <field>Regress_Partner_House_Number__c</field>
        <formula>Regress_partner__r.Postal_Address_House_Number__c</formula>
        <name>Update Regress Partner House Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_House_Number_Supp</fullName>
        <field>Regress_Partner_House_Number_Supplement__c</field>
        <formula>Regress_partner__r.Postal_Address_House_Number_Supplement__c</formula>
        <name>Update Regress Partner House Number Supp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_PO_Box</fullName>
        <field>Regress_Partner_PO_Box__c</field>
        <formula>Regress_partner__r.Postal_Address_PO_Box__c</formula>
        <name>Update Regress Partner PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_Postal_Code</fullName>
        <field>Regress_Partner_Postal_Code__c</field>
        <formula>Regress_partner__r.Postal_Address_Postal_Code__c</formula>
        <name>Update Regress Partner Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_Room_Number</fullName>
        <field>Regress_Partner_Room_Number__c</field>
        <formula>Regress_partner__r.Postal_Address_Room_Number__c</formula>
        <name>Update Regress Partner Room Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_Street</fullName>
        <field>Regress_Partner_Street__c</field>
        <formula>Regress_partner__r.Postal_Address_Street__c</formula>
        <name>Update Regress Partner Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Regress_Partner_Suburb</fullName>
        <field>Regress_Partner_Suburb__c</field>
        <formula>Regress_partner__r.Postal_Address_Suburb__c</formula>
        <name>Update Regress Partner Suburb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Address_PO_Box</fullName>
        <field>Sender_Postal_Address_PO_Box__c</field>
        <formula>Sender__r.Postal_Address_PO_Box__c</formula>
        <name>Update Sender Address PO Box</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Address_Room_Number</fullName>
        <field>Sender_Postal_Address_Room_Number__c</field>
        <formula>Sender__r.Postal_Address_Room_Number__c</formula>
        <name>Update Sender Postal Address Room Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Contact_Email</fullName>
        <field>Sender_Contact_email__c</field>
        <formula>IF(Sender__r.IsPersonAccount, Sender__r.PersonEmail, Sender__r.Email_Address__c )</formula>
        <name>Update Sender Contact Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Contact_Mobile</fullName>
        <field>Sender_Contact_Mobile__c</field>
        <formula>Sender__r.Mobile_Phone__c</formula>
        <name>Update Sender Contact Mobile</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Contact_Telephone</fullName>
        <field>Sender_Contact_Telephone__c</field>
        <formula>Sender__r.Phone</formula>
        <name>Update Sender Contact Telephone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_House_Number_Supplement</fullName>
        <field>Sender_House_Number_Supplement__c</field>
        <formula>Sender__r.Postal_Address_House_Number_Supplement__c</formula>
        <name>Update Sender House Number Supplement</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_C_O</fullName>
        <field>Sender_Postal_Address_C_O__c</field>
        <formula>Sender__r.Postal_Address_C_O__c</formula>
        <name>Update Sender Postal Address C/O</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_City</fullName>
        <field>Sender_Postal_Address_City__c</field>
        <formula>Sender__r.Postal_Address_City__c</formula>
        <name>Update Sender Postal Address City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_House_Lette</fullName>
        <field>Sender_Postal_Address_House_Letter__c</field>
        <formula>Sender__r.Postal_Address_House_Letter__c</formula>
        <name>Update Sender Postal Address House Lette</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_House_Numbe</fullName>
        <field>Sender_Postal_Address_House_Number__c</field>
        <formula>Sender__r.Postal_Address_House_Number__c</formula>
        <name>Update Sender Postal Address House Numbe</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_Postal_Code</fullName>
        <field>Sender_Postal_Address_Postal_Code__c</field>
        <formula>Sender__r.Postal_Address_Postal_Code__c</formula>
        <name>Update Sender Postal Address Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Postal_Address_Street</fullName>
        <field>Sender_Postal_Address_Street__c</field>
        <formula>Sender__r.Postal_Address_Street__c</formula>
        <name>Update Sender Postal Address Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sender_Suburb</fullName>
        <field>Sender_Postal_Address_Suburb__c</field>
        <formula>Sender__r.Postal_Address_Suburb__c</formula>
        <name>Update Sender Suburb</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_origin</fullName>
        <field>Origin</field>
        <literalValue>Email</literalValue>
        <name>Update case origin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>Update case status as Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_On_going</fullName>
        <field>Status</field>
        <literalValue>On-going</literalValue>
        <name>Update case status as On-going</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_Re_opened</fullName>
        <field>Status</field>
        <literalValue>Re-open</literalValue>
        <name>Update case status as &quot;Re-opened&quot;</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_assigned_to_queue</fullName>
        <field>Status</field>
        <literalValue>Assigned to queue</literalValue>
        <name>Update case status as assigned to queue</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_rejectedl</fullName>
        <field>Status</field>
        <literalValue>Approval Declined</literalValue>
        <name>Update case status as rejectedl</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_case_status_as_sent_for_approval</fullName>
        <field>Status</field>
        <literalValue>For Approval</literalValue>
        <name>Update case status as sent for approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_postal_Address_Suburd</fullName>
        <field>Postal_Address_Suburd__c</field>
        <formula>Account.Postal_Address_Suburb__c</formula>
        <name>Update postal Address Suburd</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_receiver_Postal_Address_Cod</fullName>
        <field>Receiver_Postal_Address_Postal_Code__c</field>
        <formula>Receiver__r.Postal_Address_Postal_Code__c</formula>
        <name>Update receiver Postal Address Cod</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Approval case Status</fullName>
        <actions>
            <name>Update_Case_Status_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Admin_case_type__c</field>
            <operation>equals</operation>
            <value>Opportunity Approval</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Opportunity_Approval_Type__c</field>
            <operation>equals</operation>
            <value>Price group,Operations,Both</value>
        </criteriaItems>
        <description>To change the Status of An approval</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Blank delivered dates on case</fullName>
        <actions>
            <name>Blank_out_Date_Contract_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Blank_out_Date_Materials_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Activity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Materials ordered</value>
        </criteriaItems>
        <description>Every time the Case Status is changed to Contract Ordered on cases of RT Admin Activity,  blank the Date Materials delivered fields</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Close case if final dec</fullName>
        <actions>
            <name>Close_case_if_final_dec</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Final_decision__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy account address to the case</fullName>
        <actions>
            <name>Update_Postal_Address_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_House_Number_Sup</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Postal_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_postal_Address_Suburd</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the customer address to case when a customer is manually selected.</description>
        <formula>AND( LEN(AccountId) &gt; 0, LEN(ParentId) = 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy comp receiver address to the case</fullName>
        <actions>
            <name>Update_Comp_Receiver_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Number_Supp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the comp receiver address to case when a comp receiver is manually selected.</description>
        <formula>AND(  NOT(ISBLANK(Compensation_Receiver__c)),  LEN(ParentId) = 0  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy comp receiver address to the case when comp receiver is changed</fullName>
        <actions>
            <name>Update_Comp_Receiver_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_House_Number_Supp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Comp_Receiver_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the comp receiver address to case when a comp receiver is changed</description>
        <formula>ISCHANGED(Compensation_Receiver__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy receiver address to the case</fullName>
        <actions>
            <name>Update_Receiver_Address_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_House_Number_Supplement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_receiver_Postal_Address_Cod</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the receiver address to case when a receiver is manually selected.</description>
        <formula>AND( LEN(Receiver__r.Id ) &gt; 0, LEN(ParentId) = 0 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy receiver address to the case when receiver is changed</fullName>
        <actions>
            <name>Update_Receiver_Address_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Address_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_House_Number_Supplement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Postal_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_receiver_Postal_Address_Cod</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the receiver address to case when a receiver is changed</description>
        <formula>ISCHANGED(  Receiver__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy receiver contact Email%2C Mobile and Telephone to the case</fullName>
        <actions>
            <name>Update_Receiver_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Contact_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Receiver_Contact_Telephone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the receiver contact email, mobile and telephone to case when a receiver is manually selected or when the receiver is changed.</description>
        <formula>OR(AND( LEN(Receiver__r.Id ) &gt; 0, LEN(ParentId) = 0 ),ISCHANGED( Receiver__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy regress partner address to the case</fullName>
        <actions>
            <name>Update_Regress_Partner_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Number_Supp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the regress partner address to case when a regress partner is manually selected.</description>
        <formula>AND( NOT(ISBLANK(Regress_partner__c)),  LEN(ParentId) = 0  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy regress partner address to the case when regress partner is changed</fullName>
        <actions>
            <name>Update_Regress_Partner_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Letter</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_House_Number_Supp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Regress_Partner_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the regress partner address to case when a regress partner is changed</description>
        <formula>ISCHANGED( Regress_partner__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy sender address to the case</fullName>
        <actions>
            <name>Update_Sender_Address_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Address_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_House_Number_Supplement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_House_Lette</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_House_Numbe</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the sender address to case when a sender is manually selected.</description>
        <formula>AND(  LEN(Sender__r.Id) &gt; 0,  LEN(ParentId) = 0  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Copy sender address to the case when sender is changed</fullName>
        <actions>
            <name>Update_Sender_Address_PO_Box</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Address_Room_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_House_Number_Supplement</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_C_O</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_House_Lette</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_House_Numbe</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Postal_Address_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Suburb</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the sender address to case when a sender is changed</description>
        <formula>ISCHANGED( Sender__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Copy sender contact Email%2C Mobile and Telephone to the case</fullName>
        <actions>
            <name>Update_Sender_Contact_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Contact_Mobile</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sender_Contact_Telephone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule copies the sender contact email, mobile and telephone to case when a sender is manually selected or when the sender is changed.</description>
        <formula>OR(AND( LEN(Sender__r.Id) &gt; 0, LEN(ParentId) = 0 ),ISCHANGED( Sender__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Create credit check case</fullName>
        <actions>
            <name>Set_subject_to_credit_check</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Credit check</value>
        </criteriaItems>
        <description>Set subject to credit check when case is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark Dpd%40dpd%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_Dpd_dpd_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Dpd@dpd.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark claim%40dpd%2Edk</fullName>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>claim@dpd.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark creditlock%40post%2Edk</fullName>
        <actions>
            <name>DK_Admin_Cases</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Inbound_Denmark_creditlock_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reason_Creditlock</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>creditlock@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark eposthuset%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_eposthuset_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>eposthuset@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark erhvervsflyt%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_erhvervsflyt_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>erhvervsflyt@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktds17%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktds17_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_DS_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktds17@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktek40%40post%2Edk</fullName>
        <actions>
            <name>Inbound_email_for_fktek40_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktek40@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktekv3%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktekv3_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRT_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktekv3@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktinc23%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktinc23_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktinc23@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktinc25%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktinc25_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktinc25@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktinc27%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktinc27_postdk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktinc27@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktip6%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktip6@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktkul17%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktkul17_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktkul17@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktkul26%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktkul26_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_Major_Account_support</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktkul26@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktkul51%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktkul51_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktkul51@post.dk</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktkul52%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktkul52_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_Salgs_Driftsadministration</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktkul52@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktkul60%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktkul60_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktkul60@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktprt14%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktprt14_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktprt14@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck113%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck113_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck113@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck15%40post%2Edk</fullName>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck15@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck153%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck153_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck153@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck154%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck154_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck154@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck174%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck174post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck174@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck178%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck178_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck178@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck180%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck180_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck180@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck181%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck181_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck181@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck182%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck182_postdk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck182@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck183%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck183_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck183@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck185%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck185_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck185@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck206%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck206_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck206@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck216%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck216_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck216@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck217%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck217_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck217@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck236%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck236_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck236@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck237%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck237_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck237@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck238%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck238_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck238@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck24%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck24_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck24@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck47%40post%2Edk</fullName>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck47@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck8%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck8_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck8@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktsck96%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktsck96_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktsck96@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktscr108%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktscr108_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_SSF_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktscr108@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as email and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktscr109%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktscr109_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_Payment_questions</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktscr109@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktscr110%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktscr110_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_Invoice_questions</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktscr110@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark fktscr86%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_fktscr86_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_SCR_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>fktscr86@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark gic%40dpd%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_gic_dpd_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>gic@dpd.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark grpds110%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_brevstregkoder_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>grpds110@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark international%40dpd%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_international_dpd_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>international@dpd.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark itkunder%40post%2Edk</fullName>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_DK_it_kunder_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>itkunder@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark kundeservice%2Eerhverv%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_kundeservice_erhverv_pos</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>kundeservice.erhverv@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark kundesupport%2Eerhverv%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_kundesupport_erhverv</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_ERHV_CS_Complaints_inbound_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>kundesupport.erhverv@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Ebl%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_bl_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.bl@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Ebr%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_br_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.br@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Ego%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_go_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.go@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Egr%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_gr_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.gr@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Eor%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_or_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.or@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Ere%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_re_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.re@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Esi%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_si_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.si@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Ewh%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_wh_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_VIP_Customer</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.wh@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark logistik%2Eye%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_logistik_ye_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LO_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>logistik.ye@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark modtager%2Ebetaler%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_modtager_betaler_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PNDK_KUL_CMA_Salgsl_sninge</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>modtager.betaler@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark paragraf9%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_paragraf9_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>paragraf9@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark post%2Elevering%2Etil%2Edoren%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_post_levering_til_doren</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>post.levering.til.doren@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark salesadministration%40post%2Edk</fullName>
        <actions>
            <name>DK_Admin_Cases</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Inbound_Denmark_salesadministration_post</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>salesadministration@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark skrivpost%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_skrivpost_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_PRIV_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>skrivpost@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark stamps%40post%2Edk</fullName>
        <actions>
            <name>Inbound_Denmark_stamps_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_BE_FRM_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>stamps@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound Denmark tidlig%2Epost%40post%2Edk</fullName>
        <actions>
            <name>DK_Admin_Cases</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Inbound_Denmark_tidlig_post_post_dk</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Reason</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Sub_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>tidlig.post@post.dk</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound LODK ems%2Edk%40postnord%2Ecom</fullName>
        <actions>
            <name>Inbound_LODK_ems_dk_postnord_com</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LODK_CS_Complaints_inbound</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>ems.dk@postnord.com</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Inbound LODK kundservicePN%40postnord%2Ecom</fullName>
        <actions>
            <name>Inbound_LODK_kundservicePN_postnord_com</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDK_LODK_Incoming_Cases</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_origin</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>kundservicePN@postnord.com</value>
        </criteriaItems>
        <description>This workflow rule sets the case origin as web and also updates the email id on the case.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - LO DK</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is LO DK set Case Sales Area to LO DK</description>
        <formula>ISPICKVAL(Owner:User.Sales_Area1__c ,&quot;0540&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - LO FI</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is LO FI set Case Sales Area to LO FI</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c ,&quot;3670&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - LO FIDPD</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is LO FIDPD set Case Sales Area to LO FIDPD</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c , &quot;0630&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - LO NO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is LO NO set Case Sales Area to LO NO</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c,&quot;LO NO&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - LO SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is LO SE set Case Sales Area to LO SE</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c ,&quot;FO92&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - ME SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is ME SE set Case Sales Area to ME SE</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c , &quot;FO91&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - PDK BE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When case is created and owner sales area is PDK BE set Case Sales Area to PDK BE</description>
        <formula>AND(ISPICKVAL(Owner:User.Sales_Area1__c,&quot;1000&quot;),$Setup.DisableAutomation__c.Disable_All_Non_OBM_Workflows__c = false)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Case Sales Area - PDK LO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>When case is created and owner sales area is PDK LO set Case Sales Area to PDK LO</description>
        <formula>ISPICKVAL( Owner:User.Sales_Area1__c , &quot;4000&quot;)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Created by Team at Case creation</fullName>
        <actions>
            <name>Set_Created_by_Team</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>when a case is created the value of the creator&apos;s team will be populated in the &quot;Created by Team&quot; text field.</description>
        <formula>TRUE</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Date Contract Sent</fullName>
        <actions>
            <name>Set_Date_Contract_Sent_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_No_of_Times_Contract_Ordered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Activity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Materials Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Deliver_Material_To__c</field>
            <operation>equals</operation>
            <value>Customer</value>
        </criteriaItems>
        <description>For the contract renewals process set Date Contract Sent field when the Case Status is changed to Materials Delivered and Deliver Material to is the customer</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Date Materials Delivered</fullName>
        <actions>
            <name>Set_Date_Materials_Delivered_to_Today</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_No_of_Times_Contract_Ordered</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_No_of_Times_Material_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Admin Activity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Materials Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Deliver_Material_To__c</field>
            <operation>equals</operation>
            <value>Salesperson</value>
        </criteriaItems>
        <description>For the contract renewals process set Date Materials Delivered field when the Case Status is changed to Materials Delivered and Deliver Material to is the Salesperson</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - LO DK</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>0540</value>
        </criteriaItems>
        <description>When case is created and product sales area is LO DK set Sales Area Product to LO DK</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - LO FI</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>3670</value>
        </criteriaItems>
        <description>When case is created and product sales area is LO FI set Sales Area Product to LO FI</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - LO FI DPD</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>0630</value>
        </criteriaItems>
        <description>When case is created and product sales area is LO FI DPD set Sales Area Product to LO FI DPD</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - LO NO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>LO NO</value>
        </criteriaItems>
        <description>When case is created and product sales area is LO NO set Sales Area Product to LO NO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - LO SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>FO92</value>
        </criteriaItems>
        <description>When case is created and product sales area is LO SE set Sales Area Product to LO SE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - ME SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>FO91</value>
        </criteriaItems>
        <description>When case is created and product sales area is ME SE set Sales Area Product to ME SE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - PDK BE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>1000</value>
        </criteriaItems>
        <description>When case is created and product sales area is PDK BE set Sales Area Product to PDK BE</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sales Area Product on case - PDK LO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_Product_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Product_Articles_Sales_Area__c</field>
            <operation>equals</operation>
            <value>4000</value>
        </criteriaItems>
        <description>When case is created and product sales area is PDK LO set Sales Area Product to PDK LO</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Sent Timestamp and Status on Returpost</fullName>
        <actions>
            <name>Set_Sent_for_investigation_timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_status_to_Request_for_Info</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When a sub-case of type &quot;Returpost&quot; has it&apos;s owner changed by a user, the status will change to &quot;Request for Information&quot;, also the &quot;Sent for Investigation timestamp&quot; will be set.</description>
        <formula>AND(  RecordType.DeveloperName == &apos;Returpost&apos;,  ISBLANK(Sent_for_Investigation_Timestamp__c),  Is_Main_Case__c == False,  ISCHANGED(OwnerId)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Sent for investigation timestamp</fullName>
        <actions>
            <name>Set_Sent_for_investigation_timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the user has set the Status = &apos;Request for Information&apos; and the Respondent Org ID is set, the system will set the Timestamp to reflect when the communication was sent out. Excluded is the &quot;Returpost&quot; scenario, which has a separate logic.</description>
        <formula>AND(  RecordType.DeveloperName != &apos;Returpost&apos;,  ISPICKVAL(Status , &apos;Request for Information&apos;),  NOT(ISBLANK(Respondent_Org_ID__c)),  ISBLANK(Sent_for_Investigation_Timestamp__c),  Is_Main_Case__c == False )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Set Survey Response Timestamp on Case</fullName>
        <actions>
            <name>Set_Survey_Response_Timestamp_on_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Is_Main_Case__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Survey_Response_Timestamp__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Response Received</value>
        </criteriaItems>
        <description>Sets the response timestamp for the sub-case given that it is not already set and that the status is changed to &quot;Survey answered&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Date for Marked for Deletion  to Today</fullName>
        <actions>
            <name>Date_For_Marked_for_Deletion</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Date for Marked for Deletion to Blank</fullName>
        <actions>
            <name>Update_Date_Marked_for_Deletion_to_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Marked_for_Deletion__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>If the Marked for the deletion flag gets unchecked, then we will want to blank out the date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Description to Blank When Incoming Email to Case</fullName>
        <actions>
            <name>Case_Description_is_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update case status as %22On-going%22%22</fullName>
        <actions>
            <name>Update_case_status_as_On_going</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule updates the case status as &quot;On-going&quot;&quot; when the case owner is changed from a queue to user.</description>
        <formula>AND(ISPICKVAL(PRIORVALUE( Status ), &quot;Assigned to queue&quot;), (Owner:User.IsActive = true))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update case status on change of ownership</fullName>
        <actions>
            <name>Update_case_status_as_assigned_to_queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case status as &quot;Assigned to queue&quot; when the case owner is a queue</description>
        <formula>AND(Owner:Queue.QueueEmail = &quot;test@postnord.com&quot;, RecordType.DeveloperName   &lt;&gt; &quot;Returpost&quot;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update case status while appealing</fullName>
        <actions>
            <name>Set_Date_of_Appeal</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_case_status_as_Re_opened</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Appeal__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA LO DK</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_DK</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;0540&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA LO FI</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_FI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;3670&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA LO NO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;LO NO&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA LO SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;FO92&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA LOFIDPD</fullName>
        <actions>
            <name>Set_Case_Sales_Area_LO_FI_DPD</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;0630&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA ME SE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_ME_SE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;FO91&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA PDK BE</fullName>
        <actions>
            <name>Set_Case_Sales_Area_PDK_BE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;1000&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>When case owner is system owner and SA PDK LO</fullName>
        <actions>
            <name>Set_Case_Sales_Area_PDK_LO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This workflow rule sets the case owner sales for all inbound cases via email-to-case when the owner is changed</description>
        <formula>AND(ISCHANGED(OwnerId), CreatedBy.Alias ==&quot;thaue&quot;, LastModifiedBy.Alias &lt;&gt; &quot;thaue&quot;,(ISPICKVAL($User.Sales_Area1__c, &quot;4000&quot;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Approval_Rejected</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your approval for payment of compensation has been rejected.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>Approval Rejected</subject>
    </tasks>
    <tasks>
        <fullName>Approval_for_appeal_rejected</fullName>
        <assignedToType>owner</assignedToType>
        <description>Your approval for appeal has been rejected. For further details please see the comments on the case.</description>
        <dueDateOffset>2</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <offsetFromField>Case.CreatedDate</offsetFromField>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Created</status>
        <subject>Approval for appeal rejected</subject>
    </tasks>
</Workflow>
