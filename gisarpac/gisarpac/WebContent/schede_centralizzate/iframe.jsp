<%-- <iframe src="ServletServiziScheda?object_id=<%=request.getParameter("objectId") %>&tipo_dettaglio=<%=request.getParameter("tipo_dettaglio") %>&visualizzazione=screen" name="dettaglio" id="dettaglio" style="width:90%; height: 80%"></iframe> 
 --%>
<%-- Decommentare per lo sviluppo sul codice di preaccettazione.
object_id contiene il riferimento_id dell'anagrafica
tipo_dettaglio contiene l'id della tipologia di operatore secondo la scheda centralizzata
 --%>

 
 
<br>
<br>
 <jsp:include page="/ServletServiziScheda">
  <jsp:param name="object_id" value="<%=request.getParameter("objectId") %>" />
    <jsp:param name="object_id_name" value="<%=request.getParameter("objectIdName") %>" />
  <jsp:param name="tipo_dettaglio" value="<%=request.getParameter("tipo_dettaglio") %>" />
  <jsp:param name="visualizzazione" value="screen" />
 </jsp:include>
 
