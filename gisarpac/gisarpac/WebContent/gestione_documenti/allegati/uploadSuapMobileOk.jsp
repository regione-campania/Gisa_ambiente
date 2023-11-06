<%="File Caricato consuccess : "+request.getAttribute("titolo")+" __ "+request.getAttribute("indice")%>

<script>

window.opener.document.getElementById("carta_circolazione").value = '<%=request.getAttribute("codDocumento")%>';




window.close();

</script>