<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>
<%@ taglib uri="/WEB-INF/zeroio-taglib.tld" prefix="zeroio"%>


<%@page
	import="org.aspcfs.modules.macellazioni.base.Casl_Non_Conformita_Rilevata"%>
<%@page import="org.aspcfs.modules.macellazioni.base.ProvvedimentiCASL"%>
<%@page import="org.aspcfs.modules.macellazioni.base.NonConformita"%>
<%@page import="org.aspcfs.modules.macellazioni.base.Campione"%><%@page
	import="org.aspcfs.modules.macellazioni.base.Organi"%>
<%@page import="org.aspcfs.modules.macellazioni.base.PatologiaRilevata"%>

<%@page import="org.aspcfs.modules.util.imports.ApplicationProperties"%>

<%@page import="org.aspcfs.modules.macellazioni.base.TipoRicerca"%>
<%@page import="javax.imageio.ImageIO"%>
<%@ page import="java.awt.*, java.awt.image.*,  java.util.StringTokenizer, com.itextpdf.text.pdf.*, java.io.*, java.util.*,org.aspcfs.utils.web.*, com.itextpdf.text.pdf.codec.*,
org.aspcfs.modules.campioni.base.SpecieAnimali" %>

<jsp:useBean
	id="Tampone" class="org.aspcfs.modules.macellazioni.base.Tampone"
	scope="request" />


<style>
<!--
.Section1 {
	color: black;
	position: relative;
	border: 0px solid red;
}
-->
</style>

<jsp:useBean id="OrgDetails"
	class="org.aspcfs.modules.sintesis.base.SintesisStabilimento"
	scope="request" />
<jsp:useBean id="Capo" class="org.aspcfs.modules.macellazioninewsintesis.base.GenericBean"
	scope="request" />
<jsp:useBean id="richiestaIstopatologico"
	class="org.aspcfs.modules.macellazioni.base.RichiestaIstopatologico"
	scope="request" />
<jsp:useBean id="lookup_esame_istopatologico_tipo_diagnosi"
	class="org.aspcfs.utils.web.LookupList"
	scope="request" />	
<jsp:useBean id="lookup_associazione_classificazione_tabella_lookup"
	class="org.aspcfs.utils.web.LookupList"
	scope="request" />	
<jsp:useBean id="lookup_who_umana"
	class="org.aspcfs.utils.web.LookupList"
	scope="request" />	
	



<%@ include file="../../initPage.jsp"%>

<link type="text/css" href="css/ui.all.css" rel="stylesheet" />
<link type="text/css" href="css/demos.css" rel="stylesheet" />
<script language="JavaScript" TYPE="text/javascript"
	SRC="javascript/popCalendar.js"></script>
<script type="text/javascript" src="javascript/ui.core.js"></script>
<div>
Identificativo istopatologico: <%=richiestaIstopatologico.getIdentificativoRichiesta() %> <br></br>
Marca auricolare: <%=(Capo)richiestaIstopatologico.getCapo().getCd_matricola() %>

</div>
<br>

<div>
			Data esito: <%=DateUtils.timestamp2string(richiestaIstopatologico.getDataEsito())%>
</div>
<br>
<div>
			Codice Sigla: <%=richiestaIstopatologico.getCodiceSiglaEsito() %>
</div>

<br>
<div>
			Descrizione esito: <%=richiestaIstopatologico.getDescrizioneEsito() %>
</div>


</br></br>

<div>
			Esito: <%=lookup_esame_istopatologico_tipo_diagnosi.getSelectedValue(richiestaIstopatologico.getIdEsito()) %>
</div>
</br></br>
<div id="specificheEsito" >
		Classificazione utilizzata: <%=lookup_associazione_classificazione_tabella_lookup.getSelectedValue(richiestaIstopatologico.getIdClassificazione()) %>
</div>
</br></br>
<div>
Valore classificazione: <%=lookup_who_umana.getSelectedValue(richiestaIstopatologico.getIdValoreClassificazione()) %>

</div>


<br></br>
<div id="classificazione">

</div>

<input type="hidden" name="idIstopatologico" id="idIstopatologico" value="<%=richiestaIstopatologico.getId()%>">


</form>