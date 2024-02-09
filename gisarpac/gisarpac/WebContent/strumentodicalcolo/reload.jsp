<jsp:useBean id="SDC" class="org.aspcfs.modules.dpat.base.DpatStrumentoCalcolo" scope="request"/>

<script>
var idAsl = <%=Integer.parseInt(""+ request.getAttribute("idAsl"))%>
location.href="DpatSDC2019.do?command=AddModify&anno=<%=SDC.getAnno()%>&combo_area=<%=SDC.getIdStrutturaAreaSelezionata()%>&idAsl="+idAsl+"&edit=edit";
</script>