<jsp:useBean id="idControlloUfficiale" class="java.lang.String" scope="request"/>
<jsp:useBean id="esito" class="java.lang.String" scope="request"/>
<jsp:useBean id="faultString" class="java.lang.String" scope="request"/>
<jsp:useBean id="idDocumento" class="java.lang.String" scope="request"/>
<jsp:useBean id="annoProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="numeroProtocollo" class="java.lang.String" scope="request"/>
<jsp:useBean id="dataProtocollo" class="java.lang.String" scope="request"/>

<table class="details">
<tr><th colspan="2">INVIO SICRA</th></tr>
<tr><td class="formLabel">Esito</td> <td><%= esito%></td></tr>
<tr><td class="formLabel">Descrizione errore</td> <td><%=faultString %></td></tr>
<tr><td class="formLabel">Anno protocollo</td> <td><%=annoProtocollo %></td></tr>
<tr><td class="formLabel">Numero protocollo</td> <td><%=numeroProtocollo %></td></tr>
<tr><td class="formLabel">Data protocollo</td> <td><%=dataProtocollo %></td></tr>
<tr><td class="formLabel">Id documento</td> <td><%=idDocumento %></td></tr>

</table>
