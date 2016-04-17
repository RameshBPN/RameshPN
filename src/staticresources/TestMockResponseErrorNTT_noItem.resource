<?xml version="1.0" encoding="UTF-8"?>
<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
	<SOAP-ENV:Header/>
	<SOAP-ENV:Body>
		<ns1:ItemLocation xmlns:ns1="http://new.webservice.namespace">
			<ns1:Type>Type</ns1:Type>
			<ns1:UserArea>
				<ns2:findTrackingInformationByIdentifierResponse xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns2="http://serviceapi.trackinginfo.nttservice.lisp.loab.posten.se/">
					<return>
						<shipments>
							<shipment>
								<paymentAccount>
									<accountNumber>8310039</accountNumber>
									<accountType>PLUSGIRO</accountType>
								</paymentAccount>
								<cashOnDelivery>
									<currency>SEK</currency>
									<value>419.4</value>
								</cashOnDelivery>
								<cashOnDeliveryText>Det finns en kostnad förknippad med försändelsen som betalas i samband med uthämtning av försändelsen</cashOnDeliveryText>
								<pickupParty>
									<address>
										<city>Solna</city>
										<country>Sverige</country>
										<countryCode>SWE</countryCode>
										<postCode>17173</postCode>
										<street1>XXX</street1>
									</address>
									<contact/>
									<name>Mr Pickup</name>
								</pickupParty>
								<freightPayer>
									<customer>
										<productionCustomerNumber>0205290067</productionCustomerNumber>
										<sapCustomerNumber>20529006</sapCustomerNumber>
									</customer>
									<name>Glitter International AB</name>
									<address>
										<city>NORSBORG</city>
										<country>Sweden</country>
										<countryCode>SWE</countryCode>
										<postCode>14551</postCode>
										<street1>NIKITIDOU</street1>
										<street2>FORVÄGEN 9</street2>
									</address>
								</freightPayer>
								<smsNotification>
									<phoneNo>004798765432</phoneNo>
								</smsNotification>
								<emailNotification>
									<email>a@b.c</email>
								</emailNotification>
								<additionalServices>
									<additionalService>
										<code>68</code>
										<name>Notification by SMS</name>
										<sourceSystem>ELLA</sourceSystem>
									</additionalService>
									<additionalService>
										<code>7</code>
										<name>Extended retention period</name>
										<sourceSystem>ELLA</sourceSystem>
									</additionalService>
									<additionalService>
										<code>77</code>
										<name>Optional Service Point</name>
										<sourceSystem>ELLA</sourceSystem>
									</additionalService>
									<additionalService>
										<code>67</code>
										<name>Optional Service Point</name>
										<sourceSystem>ELLA</sourceSystem>
									</additionalService>
								</additionalServices>
								<assessedNumberOfItems>1</assessedNumberOfItems>
								<assessedVolume>
									<unit>m3</unit>
									<value>0.015</value>
								</assessedVolume>
								<consignee>
									<address>
										<city>NORSBORG</city>
										<country>Sweden</country>
										<countryCode>SWE</countryCode>
										<postCode>14551</postCode>
										<street1>NIKITIDOU</street1>
										<street2>FORVÄGEN 9</street2>
									</address>
									<contact>
										<contactName>ANASTASIA NIKITIDOU</contactName>
										<mobilePhone>46760571896</mobilePhone>
										<email>a@b.c</email>
										<phone>XXX</phone>
									</contact>
									<name>ANASTASIA NIKITIDOU</name>
								</consignee>
								<consignor>
									<address>
										<city>BORÅS</city>
										<street1>XXX</street1>
										<street2>XXX</street2>
										<country>Sweden</country>
										<countryCode>SWE</countryCode>
										<postCode>50186</postCode>
									</address>
									<contact>
										<contactName>XXX</contactName>
										<email>a@b.c</email>
										<mobilePhone>XXX</mobilePhone>
										<phone>XXX</phone>
									</contact>
									<customer>
										<productionCustomerNumber>5001285203</productionCustomerNumber>
										<sapCustomerNumber>20308191</sapCustomerNumber>
										<externalCustomerNumber>XXX</externalCustomerNumber>
									</customer>
									<name>ELLOS AB</name>
								</consignor>
								<deliveryDate>2012-06-04T17:29:00+02:00</deliveryDate>
								<estimatedTimeOfArrival>2012-06-04T18:00:00+02:00</estimatedTimeOfArrival>
								</items>
								<originEstimatedTimeOfArrival>2012-06-04T18:00:00+02:00</originEstimatedTimeOfArrival>
								<requestedDeliveryPoint>
									<city>Norsborg</city>
									<country>Sweden</country>
									<countryCode>SWE</countryCode>
									<displayName>Direkten Hallunda</displayName>
									<locationId>564478</locationId>
									<locationType>SERVICE_POINT</locationType>
									<name>Direkten Hallunda</name>
									<postcode>14568</postcode>
									<address>
										<city>NORSBORG</city>
										<country>Sweden</country>
										<countryCode>SWE</countryCode>
										<postCode>14568</postCode>
										<street1>Hallunda Centrum</street1>
									</address>
									<contact>
										<contactName>Kassa</contactName>
										<phone>08-53171320</phone>
									</contact>
									<openingHours>
										<openingHour>
											<friday>true</friday>
											<monday>true</monday>
											<openFrom>08:00</openFrom>
											<openTo>20:45</openTo>
											<thursday>true</thursday>
											<tuesday>true</tuesday>
											<wednesday>true</wednesday>
										</openingHour>
										<openingHour>
											<openFrom>09:00</openFrom>
											<openTo>17:00</openTo>
											<saturday>true</saturday>
										</openingHour>
										<openingHour>
											<openFrom>10:00</openFrom>
											<openTo>17:00</openTo>
											<sunday>true</sunday>
										</openingHour>
									</openingHours>
								</requestedDeliveryPoint>
								<service>
									<articleNumber>1001001</articleNumber>
									<code>13</code>
									<name>Postpaket</name>
									<sourceSystem>ELLA</sourceSystem>
								</service>
								<shipmentId>85829178741SE</shipmentId>
								<shipmentReferences/>
								<splitStatuses/>
								<status>DELIVERED</status>
								<statusText>
									<body>The shipment was delivered on 6/4/2012 at 17:29 PM</body>
									<header>The shipment has been delivered to the recipient</header>
								</statusText>
								<totalVolume>
									<unit>m3</unit>
									<value>0.012</value>
								</totalVolume>
								<totalWeight>
									<unit>kg</unit>
									<value>1.4</value>
								</totalWeight>
							</shipment>
						</shipments>
					</return>
				</ns2:findTrackingInformationByIdentifierResponse>
			</ns1:UserArea>
		</ns1:ItemLocation>
	</SOAP-ENV:Body>
</SOAP-ENV:Envelope>