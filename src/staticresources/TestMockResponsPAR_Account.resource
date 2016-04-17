<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Header />
   <SOAP-ENV:Body>
      <ItemLocation xmlns="http://new.webservice.namespace">
         <UserArea>
            <Body xmlns="" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms">
					<cus:ReadMdmCustomerResponse xmlns:conper="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:ContactPerson:v0002" xmlns:cus="urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002" xmlns:imext="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001" xmlns:p1="urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:CustomerStandardTypes:v0002" xmlns:p7="urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001" xmlns:p8="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:LegalEntity:v0002" xmlns:p81="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:WorkSite:v0002" xmlns:stdTypes="urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:LegalEntity:v0002 ../CustomerGovernedLandscape/CustomerLegalEntity_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:ContactPerson:v0002 ../CustomerGovernedLandscape/CustomerContactPerson_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:CustomerStandardTypes:v0002 ../CustomerGovernedLandscape/MDMCustomerStandardTypes_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:WorkSite:v0002 ../CustomerGovernedLandscape/CustomerWorkSite_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001 urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001">
						<cus:DocStatus HasFault="false" ServiceName="evMdmCustmerCrudService" Version="1"/>
						<cus:ListOfItems MoreItemsAvailable="false">
                     <cus:LegalEntity>
                        <PNCM_ID>111:100357275</PNCM_ID>
                        <VatNumber>VAT1234</VatNumber>
                        <CorporateRegistrationNumber>1234</CorporateRegistrationNumber>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Fosli Severin Andreas</LegalName>
                        <FoundingDate>1995-02-20</FoundingDate>
                        <NumberOfEmployees>200</NumberOfEmployees>
                        <NumberOfOfficeEmployees>100</NumberOfOfficeEmployees>
                        <Turnover>500<currencyCode>DKK</currencyCode></Turnover>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF013</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM02200</Code>
                        </PrimaryIndustryNational>
						<PrimaryIndustryGroup8>
                           <Code>XM02200</Code>
                        </PrimaryIndustryGroup8>
                        <PrimaryIndustryGroup77>
                           <Code>XM02200</Code>
                        </PrimaryIndustryGroup77>
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>Stian Kristensens vei</StreetName>
                           <StreetNumber>21</StreetNumber>
                           <CityName>RYKKINN</CityName>
                           <PostalCode>1348</PostalCode>
                           <Country>NO</Country>
                           <POBox>12345</POBox>
                           <COAddress>COAddress</COAddress>
                        </Address>
                        <Communication>
                           <PhoneNumber>+47 2133453</PhoneNumber>
                        </Communication>
                        <CustomerLegalEntityHierarchy>
                        	<GroupParentCorporateRegistrationNumber>sdfs</GroupParentCorporateRegistrationNumber>
                        	<GroupParentLegalName>sfsf</GroupParentLegalName>
                        	<GroupParentRegistrationCountry>sfsfs</GroupParentRegistrationCountry>
                        	<ParentCorporateRegistrationNumber>dfsdf</ParentCorporateRegistrationNumber>
                        	<ParentLegalName>sfdsf</ParentLegalName>
                        	<ParentRegistrationCountry>dk</ParentRegistrationCountry>
                        	<LevelInHierarchy>1</LevelInHierarchy>
                        </CustomerLegalEntityHierarchy>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:100357275</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:LegalEntity>
                        <PNCM_ID>111:100404074</PNCM_ID>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Foslien Rune</LegalName>
                        <FoundingDate>1995-02-20</FoundingDate>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF013</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM01410</Code>
                        </PrimaryIndustryNational>
                        <PrimaryIndustryGroup8 />
                        <PrimaryIndustryGroup77 />
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>Hofsfossveien</StreetName>
                           <StreetNumber>5</StreetNumber>
                           <CityName>HØNEFOSS</CityName>
                           <PostalCode>3517</PostalCode>
                           <Country>NO</Country>
                        </Address>
                        <Communication>
                           <PhoneNumber>+47 32157287</PhoneNumber>
                        </Communication>
                        <CustomerLegalEntityHierarchy />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:100404074</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:LegalEntity>
                        <PNCM_ID>111:100826851</PNCM_ID>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Fosli Datronics</LegalName>
                        <FoundingDate>2002-09-25</FoundingDate>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF013</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM62010</Code>
                        </PrimaryIndustryNational>
                        <PrimaryIndustryGroup8 />
                        <PrimaryIndustryGroup77 />
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>Barkåkerveien</StreetName>
                           <StreetNumber>51</StreetNumber>
                           <HouseLetter>A</HouseLetter>
                           <CityName>BARKÅKER</CityName>
                           <PostalCode>3157</PostalCode>
                           <Country>NO</Country>
                        </Address>
                        <Communication>
                           <PhoneNumber>+47 92615290</PhoneNumber>
                        </Communication>
                        <CustomerLegalEntityHierarchy />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:100826851</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:LegalEntity>
                        <PNCM_ID>111:101049170</PNCM_ID>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Fosli Invest AS</LegalName>
                        <FoundingDate>2005-06-22</FoundingDate>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF004</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM68100</Code>
                        </PrimaryIndustryNational>
                        <PrimaryIndustryGroup8 />
                        <PrimaryIndustryGroup77 />
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>Tveterveien</StreetName>
                           <StreetNumber>34</StreetNumber>
                           <CityName>HASLUM</CityName>
                           <PostalCode>1344</PostalCode>
                           <Country>NO</Country>
                        </Address>
                        <Communication>
                           <PhoneNumber>+47 90518468</PhoneNumber>
                           <EmailAddress>fosli@online.no</EmailAddress>
                        </Communication>
                        <CustomerLegalEntityHierarchy />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:101049170</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:LegalEntity>
                        <PNCM_ID>111:101589300</PNCM_ID>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Fosli Kunst &amp; Maleri</LegalName>
                        <FoundingDate>2009-05-09</FoundingDate>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF013</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM90031</Code>
                        </PrimaryIndustryNational>
                        <PrimaryIndustryGroup8 />
                        <PrimaryIndustryGroup77 />
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>Frognerveien</StreetName>
                           <StreetNumber>42</StreetNumber>
                           <CityName>OSLO</CityName>
                           <PostalCode>0266</PostalCode>
                           <Country>NO</Country>
                        </Address>
                        <Communication>
                           <WebAddress>www.heidifosli.com</WebAddress>
                           <PhoneNumber>+47 90525324</PhoneNumber>
                           <EmailAddress>heidi_fosli@hotmail.com</EmailAddress>
                        </Communication>
                        <CustomerLegalEntityHierarchy />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:101589300</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:LegalEntity>
                        <PNCM_ID>111:101593096</PNCM_ID>
                        <RegistrationCountry>NO</RegistrationCountry>
                        <LegalName>Fosli Tjenester</LegalName>
                        <FoundingDate>2009-06-03</FoundingDate>
                        <ExternalLegalEntityStatus>
                           <Code>STRL</Code>
                        </ExternalLegalEntityStatus>
                        <CorporateForm>
                           <Code>JF013</Code>
                        </CorporateForm>
                        <PrimaryIndustryNational>
                           <Code>XM82110</Code>
                        </PrimaryIndustryNational>
                        <PrimaryIndustryGroup8 />
                        <PrimaryIndustryGroup77 />
                        <Address>
                           <AddressType>Postal address</AddressType>
                           <StreetName>U 101 Rolf E. Stenersens alle 10</StreetName>
                           <CityName>OSLO</CityName>
                           <PostalCode>0858</PostalCode>
                           <Country>NO</Country>
                        </Address>
                        <Communication />
                        <CustomerLegalEntityHierarchy />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:101593096</SourceID>
                        </AlternativeIDs>
                     </cus:LegalEntity>
                     <cus:WorkSite>
                        <PNCM_ID>111:200364161</PNCM_ID>
                        <LE_PNCM_ID>111:100357275</LE_PNCM_ID>
                        <LegalName>Fosli Severin Andreas</LegalName>
                        <WorkSiteName>Fosli Severin Andreas</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>969338564</WorkSiteRegistrationNumber>
                        <NumberOfEmployees>200</NumberOfEmployees>
                        <NumberOfOfficeEmployees>100</NumberOfOfficeEmployees>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Stian Kristensens vei</StreetName>
                              <StreetNumber>21</StreetNumber>
                              <POBox>12345</POBox>
                              <COAddress>12345</COAddress>
                              <CityName>RYKKINN</CityName>
                              <PostalCode>1348</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Visiting address</AddressType>
                              <StreetName>Stian Kristensens vei</StreetName>
                              <StreetNumber>21</StreetNumber>
                              <HouseLetter>A</HouseLetter>
                              <CityName>RYKKINN</CityName>
                              <PostalCode>1348</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <PhoneNumber>+47 2133453</PhoneNumber>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:200364161</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:200412983</PNCM_ID>
                        <LE_PNCM_ID>111:100404074</LE_PNCM_ID>
                        <LegalName>Foslien Rune</LegalName>
                        <WorkSiteName>Foslien Rune</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>969146371</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Hofsfossveien</StreetName>
                              <StreetNumber>5</StreetNumber>
                              <CityName>HØNEFOSS</CityName>
                              <PostalCode>3517</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <PhoneNumber>+47 32157287</PhoneNumber>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:200412983</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:200856026</PNCM_ID>
                        <LE_PNCM_ID>111:100826851</LE_PNCM_ID>
                        <LegalName>Fosli Datronics</LegalName>
                        <WorkSiteName>Fosli Datronics</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>984836279</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Barkåkerveien</StreetName>
                              <StreetNumber>51</StreetNumber>
                              <HouseLetter>A</HouseLetter>
                              <CityName>BARKÅKER</CityName>
                              <PostalCode>3157</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <PhoneNumber>+47 92615290</PhoneNumber>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:200856026</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:201071712</PNCM_ID>
                        <LE_PNCM_ID>111:101049170</LE_PNCM_ID>
                        <LegalName>Fosli Invest AS</LegalName>
                        <WorkSiteName>Fosli Invest AS</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Tveterveien</StreetName>
                              <StreetNumber>34</StreetNumber>
                              <CityName>HASLUM</CityName>
                              <PostalCode>1344</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <PhoneNumber>+47 90518468</PhoneNumber>
                           <EmailAddress>fosli@online.no</EmailAddress>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:201071712</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite><cus:WorkSite>
                        <PNCM_ID>111:999071999</PNCM_ID>
                        <LE_PNCM_ID>111:101049170</LE_PNCM_ID>
                        <LegalName>Fosli Invest AS Test Branch Office</LegalName>
                        <WorkSiteName>Fosli Invest AS</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <ExternalWorkSiteType>
                           <Code>TY20</Code>
                           <Description>Branch Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Tveterveienenen</StreetName>
                              <StreetNumber>1234</StreetNumber>
                              <CityName>SLUMHA</CityName>
                              <PostalCode>4412</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <PhoneNumber>+47 90518468</PhoneNumber>
                           <EmailAddress>fosli@online.no</EmailAddress>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:999071999</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:201631568</PNCM_ID>
                        <LE_PNCM_ID>111:101589300</LE_PNCM_ID>
                        <LegalName>Fosli Kunst &amp; Maleri</LegalName>
                        <WorkSiteName>Fosli Kunst &amp; Maleri</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>994062182</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Frognerveien</StreetName>
                              <StreetNumber>42</StreetNumber>
                              <CityName>OSLO</CityName>
                              <PostalCode>0266</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <WebAddress>www.heidifosli.com</WebAddress>
                           <PhoneNumber>+47 90525324</PhoneNumber>
                           <EmailAddress>heidi_fosli@hotmail.com</EmailAddress>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:201631568</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:201635376</PNCM_ID>
                        <LE_PNCM_ID>111:101593096</LE_PNCM_ID>
                        <LegalName>Fosli Tjenester</LegalName>
                        <WorkSiteName>Fosli Tjenester</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>894169362</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY10</Code>
                           <Description>Head Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STRL</Code>
                           <Description>Blocked for Direct Marketing</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>U 101 Rolf E. Stenersens alle 10</StreetName>
                              <CityName>OSLO</CityName>
                              <PostalCode>0858</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:201635376</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:201927229</PNCM_ID>
                        <LE_PNCM_ID>111:101593096</LE_PNCM_ID>
                        <LegalName>Fosli Tjenester</LegalName>
                        <WorkSiteName>Fosli Tjenester</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>994177680</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY20</Code>
                           <Description>Branch Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STS</Code>
                           <Description>Ceased Trading</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Edgar B.Schieldrops veg 35-22</StreetName>
                              <CityName>TRONDHEIM</CityName>
                              <PostalCode>7033</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication />
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:201927229</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                     <cus:WorkSite>
                        <PNCM_ID>111:202191331</PNCM_ID>
                        <LE_PNCM_ID>111:101589300</LE_PNCM_ID>
                        <LegalName>Fosli Kunst &amp; Maleri</LegalName>
                        <WorkSiteName>Fosli Kunst &amp; Maleri</WorkSiteName>
                        <CustomerCategory>Organisation</CustomerCategory>
                        <WorkSiteRegistrationNumber>994091514</WorkSiteRegistrationNumber>
                        <ExternalWorkSiteType>
                           <Code>TY20</Code>
                           <Description>Branch Office</Description>
                        </ExternalWorkSiteType>
                        <ExternalWorkSiteStatus>
                           <Code>STS</Code>
                           <Description>Ceased Trading</Description>
                        </ExternalWorkSiteStatus>
                        <CustomerAddress>
                           <Address>
                              <AddressType>Postal address</AddressType>
                              <StreetName>Frognerveien</StreetName>
                              <StreetNumber>42</StreetNumber>
                              <CityName>OSLO</CityName>
                              <PostalCode>0266</PostalCode>
                              <Country>NO</Country>
                           </Address>
                        </CustomerAddress>
                        <Communication>
                           <WebAddress>www.heidifosli.com</WebAddress>
                           <PhoneNumber>+47 90525324</PhoneNumber>
                        </Communication>
                        <AlternativeIDs>
                           <SourceName>PAR</SourceName>
                           <SourceID>111:202191331</SourceID>
                        </AlternativeIDs>
                     </cus:WorkSite>
                  </cus:ListOfItems>
               </cus:ReadMdmCustomerResponse>
            </Body>
         </UserArea>
      </ItemLocation>
   </SOAP-ENV:Body>
</SOAP-ENV:Envelope>