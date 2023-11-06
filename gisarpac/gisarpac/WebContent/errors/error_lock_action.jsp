<% String message = (String)request.getAttribute("alertMsg");%>

<script type="text/javascript">
    var msg = "<%=message%>";
    alert(msg);
</script>