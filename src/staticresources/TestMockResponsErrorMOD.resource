<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/">
   <SOAP-ENV:Header/>
   <SOAP-ENV:Body>
      <ns1:ItemLocation xmlns:ns1="http://new.webservice.namespace">
         <ns1:UserArea>
            <parameters xmlns="http://www.postdanmark.dk/WSTuxWrapper/WSTuxWrapper/">
               <callResponse xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
                  <ns1:tuxresults xmlns:ns1="java:dk.post.tuxwswrapper.model">
                     <ns1:TuxResult>
                        <ns1:recordcount>0</ns1:recordcount>
                        <ns1:servicename>msmFModSap</ns1:servicename>
                        <ns1:fields xsi:nil="true"/>
                        <ns1:resultincomplete>false</ns1:resultincomplete>
                        <ns1:error>
                           <ns1:rowcount>0</ns1:rowcount>
                           <ns1:category>USR</ns1:category>
                           <ns1:fieldName/>
                           <ns1:sourceline>345</ns1:sourceline>
                           <ns1:sourcefile>/global/udvl/home/pdi/u-krh/fmp/source/proc/msmFModtGadeAdrSapPC.pc</ns1:sourcefile>
                           <ns1:function/>
                           <ns1:explanation>Ingen modtagere matcher de indtastede kriterier.</ns1:explanation>
                           <ns1:id>0</ns1:id>
                        </ns1:error>
                        <ns1:recordcontext xsi:nil="true"/>
                     </ns1:TuxResult>
                  </ns1:tuxresults>
               </callResponse>
            </parameters>
         </ns1:UserArea>
      </ns1:ItemLocation>
   </SOAP-ENV:Body>
</SOAP-ENV:Envelope>