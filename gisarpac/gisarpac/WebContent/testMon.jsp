<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<h1 style="text-align:center;background-color:#33FFCC;color:black;border:0px;font:8px Trebuchet MS,Verdana,Helvetica,Arial,san-serif;font-size:1.5em;font-weight:normal;"  >
AMBIENTE DA PROPERTIES: <%=ApplicationProperties.getAmbiente()%><br/>
PROPERTIES CARICATO: <%=ApplicationProperties.getFileProperties()%><br/>
AMBIENTE DA MON: <%=ApplicationProperties.getAmbienteFromMon() %>
</h1>
