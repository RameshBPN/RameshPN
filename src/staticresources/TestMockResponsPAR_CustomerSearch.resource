<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
<SOAP-ENV:Header/>
<SOAP-ENV:Body>
<ItemLocation xmlns="http://new.webservice.namespace">
<UserArea>
<Body xmlns="" xmlns:jms1="http://www.tibco.com/namespaces/tnt/plugins/jms">
<cus:ReadMdmCustomerResponse xmlns:conper="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:ContactPerson:v0002" xmlns:cus="urn:Namespaces.PostNord.Com:Cint:Mdm:Customer:CrudScenarios:v0002" xmlns:imext="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001" xmlns:p1="urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:CustomerStandardTypes:v0002" xmlns:p7="urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001" xmlns:p8="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:LegalEntity:v0002" xmlns:p81="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:WorkSite:v0002" xmlns:stdTypes="urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:LegalEntity:v0002 ../CustomerGovernedLandscape/CustomerLegalEntity_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:ContactPerson:v0002 ../CustomerGovernedLandscape/CustomerContactPerson_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:StandardTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:Crud:Cint:Mdm:Customer:StdTypes:v0001 urn:Namespaces.PostNord.Com:Cmf:CoreTypes:Mdm:CustomerStandardTypes:v0002 ../CustomerGovernedLandscape/MDMCustomerStandardTypes_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Mdm:Customer:WorkSite:v0002 ../CustomerGovernedLandscape/CustomerWorkSite_v0002.xsd urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001 urn:Namespaces.PostNord.Com:Cmf:InfoModel:Cint:Mdm:Customer:ExtensionObject:v0001">
<cus:DocStatus HasFault="false" ServiceName="evMdmCustmerCrudService" Version="1"/>
<cus:ListOfItems MoreItemsAvailable="false">
<cus:LegalEntity>
<PNCM_ID>111:100357275</PNCM_ID>
<RegistrationCountry>DK</RegistrationCountry>
<CorporateRegistrationNumber>14247238</CorporateRegistrationNumber>
<LegalName>PARTestLECompany1</LegalName>
<FoundingDate>2000-01-01</FoundingDate>
<ExternalLegalEntityStatus>
<Code>STRL</Code>
</ExternalLegalEntityStatus>
<CorporateForm>
<Code>JF013</Code>
</CorporateForm>
<PrimaryIndustryNational>
<Code>XM02200</Code> 
</PrimaryIndustryNational>
<PrimaryIndustryGroup8/>
<PrimaryIndustryGroup77/>
<Address>
<AddressType>Postal address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>20</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
<Communication>
<PhoneNumber>+45 22334455</PhoneNumber>
</Communication>
<CustomerLegalEntityHierarchy/>
<AlternativeIDs>
<SourceName>PAR</SourceName>
<SourceID>111:100357275</SourceID>
</AlternativeIDs>
</cus:LegalEntity>
<cus:LegalEntity>
<PNCM_ID>111:100404074</PNCM_ID>
<RegistrationCountry>DK</RegistrationCountry>
<CorporateRegistrationNumber>14247238</CorporateRegistrationNumber>
<LegalName>PARTestLECompany2</LegalName>
<FoundingDate>2010-10-10</FoundingDate>
<ExternalLegalEntityStatus>
<Code>STRL</Code>
</ExternalLegalEntityStatus>
<CorporateForm>
<Code>JF013</Code>
</CorporateForm>
<PrimaryIndustryNational>
<Code>XM01410</Code>
</PrimaryIndustryNational>
<PrimaryIndustryGroup8/>
<PrimaryIndustryGroup77/>
<Address>
<AddressType>Postal address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>40</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
<Communication>
<PhoneNumber>+45 33445566</PhoneNumber>
</Communication>
<CustomerLegalEntityHierarchy/>
<AlternativeIDs>
<SourceName>PAR</SourceName>
<SourceID>111:100404074</SourceID>
</AlternativeIDs>
</cus:LegalEntity>
<cus:WorkSite>
<PNCM_ID>NO200364161</PNCM_ID>
<LE_PNCM_ID>111:100357275</LE_PNCM_ID>
<CorporateRegistrationNumber>14247238</CorporateRegistrationNumber>
<LegalName>PARTestLECompany1</LegalName>
<WorkSiteName>PARTestWSCompany1</WorkSiteName>
<CustomerCategory>Organisation</CustomerCategory>
<WorkSiteRegistrationNumber>969338564</WorkSiteRegistrationNumber>
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
<AddressType>Visiting address</AddressType>
<StreetName>TestStreet 21</StreetName>
<StreetNumber>21</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<CustomerAddress>
<Address>
<AddressType>Postal address</AddressType>
<StreetName>TestStreet 21</StreetName>
<StreetNumber>21</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<Communication>
<PhoneNumber>+45 22334455</PhoneNumber>
</Communication>
<AlternativeIDs>
<SourceName>PAR</SourceName>
<SourceID>NO200364161</SourceID>
</AlternativeIDs>
</cus:WorkSite>
<cus:WorkSite>
<PNCM_ID>NO200412983</PNCM_ID>
<LE_PNCM_ID>111:100404074</LE_PNCM_ID>
<CorporateRegistrationNumber>14247238</CorporateRegistrationNumber>
<LegalName>PARTestLECompany2</LegalName>
<WorkSiteName>PARTestWSCompany2</WorkSiteName>
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
<AddressType>Visiting address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>41</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<CustomerAddress>
<Address>
<AddressType>Postal address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>41</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<Communication>
<PhoneNumber>+45 33445566</PhoneNumber>
</Communication>
<AlternativeIDs>
<SourceName>PAR</SourceName>
<SourceID>NO200412983</SourceID>
</AlternativeIDs>
</cus:WorkSite>
<cus:WorkSite>
<PNCM_ID>NO200412985</PNCM_ID>
<LE_PNCM_ID>111:100404074</LE_PNCM_ID>
<CorporateRegistrationNumber>14247238</CorporateRegistrationNumber>
<LegalName>PARTestLECompany2</LegalName>
<WorkSiteName>PARTestWSCompany3</WorkSiteName>
<CustomerCategory>Organisation</CustomerCategory>
<WorkSiteRegistrationNumber>969146371</WorkSiteRegistrationNumber>
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
<AddressType>Visiting address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>41</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<CustomerAddress>
<Address>
<AddressType>Postal address</AddressType>
<StreetName>TestStreet</StreetName>
<StreetNumber>41</StreetNumber>
<CityName>GREVE</CityName>
<PostalCode>2670</PostalCode>
<Country>DK</Country>
</Address>
</CustomerAddress>
<Communication>
<PhoneNumber>+45 33445566</PhoneNumber>
</Communication>
<AlternativeIDs>
<SourceName>PAR</SourceName>
<SourceID>NO200412985</SourceID>
</AlternativeIDs>
</cus:WorkSite>
</cus:ListOfItems>
</cus:ReadMdmCustomerResponse>
</Body>
</UserArea>
</ItemLocation>
</SOAP-ENV:Body>
</SOAP-ENV:Envelope>