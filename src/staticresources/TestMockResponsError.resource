<!-- edited with XMLSpy v2013 sp1 (x64) (http://www.altova.com) by Lars Eriksson (e-man AB) -->
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns="http://www.openapplications.org/oagis/9">
	<soapenv:Header>
		<!--Optional:-->
		<ns:Sender>
			<ns:LogicalID>VAP</ns:LogicalID>
			<ns:ComponentID>BW Cluster</ns:ComponentID>
		</ns:Sender>
		<!--Zero or more repetitions:-->
		<ns:Receiver>
			<!--Optional:-->
			<ns:LogicalID>SFDC</ns:LogicalID>
		</ns:Receiver>
		<ns:CreationDateTime>2013-03-06T00:00:00</ns:CreationDateTime>
		
		<!-- Optional but recommended to set - GUID for the request -->		
		<ns:BODID></ns:BODID>

	</soapenv:Header>
	<soapenv:Body>
		<output>
			<ns:Show>
				<!-- The header from the request -->
				<ns:OriginalApplicationArea>
					<ns:Sender>
						<ns:LogicalID>VAP</ns:LogicalID>
					</ns:Sender>
					<ns:Receiver>
						<ns:LogicalID>SFDC</ns:LogicalID>
						<ns:ComponentID>SFDC</ns:ComponentID>
					</ns:Receiver>
					<ns:CreationDateTime>2013-03-06T00:00:00</ns:CreationDateTime>
						<!-- Optional but recommended to set - GUID for the request -->		
					<ns:BODID></ns:BODID>
				</ns:OriginalApplicationArea>
			</ns:Show>
			
			<!-- One or more errors, mostly one -->
			
			<!-- Echoed id from request -->
			<ns:ItemLocation>
				<ns:ItemID>
					<ns:ID>correlationId</ns:ID>
				</ns:ItemID>
				
				<!-- Description/Note has unique values for type attributes, sigificant are ErrorReason, ErrorCategory-->
				<ns:Description type="ErrorReason">Time out exception</ns:Description>
				<ns:Note type="ErrorCategory">Technical</ns:Note>
				
				<!-- Defines returned error codes -->
				<ns:Classification>
					<ns:Codes>
						<ns:Code>-10</ns:Code>
					</ns:Codes>
				</ns:Classification>
				
				<!-- Is used for Error response -->
				<ns:Type>ErrorResponse</ns:Type>
			</ns:ItemLocation>
			
			<ns:ItemLocation>
				<ns:ItemID>
					<ns:ID>correlationId</ns:ID>
				</ns:ItemID>
				<ns:Description>Error reason 2</ns:Description>
				<ns:Classification>
					<ns:Codes>
						<ns:Code>-10</ns:Code>
					</ns:Codes>
				</ns:Classification>
				<ns:Type>ErrorResponse</ns:Type>
			</ns:ItemLocation>
		</output>
	</soapenv:Body>
</soapenv:Envelope>
