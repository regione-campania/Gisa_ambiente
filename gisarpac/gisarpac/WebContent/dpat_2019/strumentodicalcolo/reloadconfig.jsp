
<script>
var idAsl = <%=Integer.parseInt(""+ request.getAttribute("idAsl"))%>
location.href='DpatSDCConfig.do?command=AddModify&idAsl='+idAsl+'&edit=edit';
</script>	