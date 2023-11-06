<jsp:useBean id="messaggio" class="java.lang.String" scope="request"/>
<%@ taglib uri="/WEB-INF/dhv-taglib.tld" prefix="dhv"%>


<dhv:permission name="messaggio_mod4-add">
<center>
<a href="DpatSDC2019.do?command=MessaggioModifica">Modifica</a>
</center>
</dhv:permission>

<font color="green" size="4px"">
<%=(messaggio!=null) ? messaggio  : "" %>
</font>
   
    

