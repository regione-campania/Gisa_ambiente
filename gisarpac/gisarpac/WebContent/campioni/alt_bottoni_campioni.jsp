<input type="button" value="<dhv:label name="button.insert">Insert</dhv:label>" id="Save" name="Save" class="Save" onClick="javascript:controllaAnaliti();" />

<dhv:permission name="campioni-campioni-addconpreaccettazione-view">
<input type="button" value="<dhv:label name="">inserisci con preaccettazione sigla</dhv:label>" id="SaveConPreacc" name="SaveConPreacc" class="Save" onClick="javascript:controllaAnalitiConPreacc();" />
</dhv:permission>

<input type="button" value="<dhv:label name="global.button.cancel">Cancel</dhv:label>" 
onClick="window.location.href='<%=OrgDetails.getAction()%>Vigilanza.do?command=TicketDetails&id=<%= request.getAttribute("idC") %>&altId=<%=OrgDetails.getAltId()%>';this.form.dosubmit.value='false';" />