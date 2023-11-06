<jsp:useBean id="Capo"				class="org.aspcfs.modules.macellazioni.base.Capo"			scope="request" />

<%if (Capo.getStato_macellazione().equals("Incompleto: Presenti campioni senza esito.") && (Capo.isArticolo17() || Capo.isModello10())) {%>
<jsp:include page="include_capo_add_modify_esito.jsp" /><%}
else
{
%>
<jsp:include page="include_capo_add_modify.jsp" />

<%	
}
%>
