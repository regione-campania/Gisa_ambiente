<%="File Caricato consuccess : "+request.getAttribute("titolo")+" __ "+request.getAttribute("indice")%>

<script>

window.opener.document.getElementById("fileAllegato<%=request.getAttribute("indice")%>").innerHTML="<a href=\"GestioneAllegatiUploadSuap.do?command=DownloadPDF&codDocumento=<%=request.getAttribute("codDocumento")%>&nomeDocumento=<%=request.getAttribute("titolo")%>\"><b>Scarica File</b></a>  [<a onclick=\"cancellaFile(this,'GestioneAllegatiUploadSuap.do?command=GestisciFile&orgId=-1&stabId=<%=request.getAttribute("stabId") %>&ticketId=-1&folderId=-1&parentId=-1&idHeader=<%=request.getAttribute("codDocumento")%>&operazione=cancella&op=suap',<%=request.getAttribute("indice")%>)\" href=\"#\"><img src=\"gestione_documenti/images/delete_file_icon.png\" width=\"20\"/><b>Cancella</b></a>]";

window.opener.document.getElementById("allegato<%=request.getAttribute("indice")%>").value="1";
window.opener.document.getElementById("documentazione_parziale").value="1";

window.opener.document.getElementById('linkallegato<%=request.getAttribute("indice")%>').style.display="none";



window.close();

</script>