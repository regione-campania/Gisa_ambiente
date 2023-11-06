
<br>
<center><b>CGO 4 (ex ATTO B11) e CGO 9 (ex ATTO B12) </b></center>
<center><b>CONTROLLI PER LA SICUREZZA ALIMENTARE IN AZIENDA E PER LA PREVENZIONE,</b></center>
<center><b>IL CONTROLLO E L'ERADICAZIONE DI ALCUNE ENCEFALOPATIE SPONGIFORMI TRASMISSIBILI - CHECK-LIST N _________________ </b></center>
<center>Regolamento (CE) n. 178/2002 - Regolamenti (CE) n. 852/2004, 853/2004, 183/2005 - Regolamento (CE) n. 999/2001</center>
<P text-align="left" style="text-align: left">
	<b>
	REGIONE VALLE D'AOSTA<br>
	<b>ASL AZIENDA SANITARIA LOCALE <%=Allevamento.getAsl() %></b><br/>
	
<!-- Per modello 1 -->
DATA DEL CONTROLLO: <%= toDateasString(Ticket.getAssignedDate())%>
</P>

<div style="border: 1px solid;">
Codice Azienda <input type="text" class="layout" size = "15" readonly value="<%=(Allevamento.getN_reg() != null ? Allevamento.getN_reg() :"") %>"> 
Codice fiscale <input type="text" class="layout" size="50" readonly value="<%= (Allevamento.getCodice_fiscale() != null ? Allevamento.getCodice_fiscale() :"") %>">
Specie <input type="text" class="layout" size="30" readonly value="<%= (Allevamento.getSpecie_allev() != null ? Allevamento.getSpecie_allev() :"")  %>">
<br/>
Ragione Sociale <input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getName() != null ? Allevamento.getName() :"") %>">
<br/>
Sede Allevamento <input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getComune_operativo() != null ? Allevamento.getComune_operativo()+" "+ Allevamento.getIndirizzo_operativo() : Allevamento.getComune()+" "+Allevamento.getIndirizzo())  %>">
<br/>
Sede legale <input type="text" class="layout" size="100" readonly value="<%=(Allevamento.getIndirizzo_legale() != null && !Allevamento.getIndirizzo_legale().equals("")) ? Allevamento.getIndirizzo_legale() : ""%>">
<br/>
Responsabile legale <input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getProp() != null ? Allevamento.getProp() :"")  %>">
<br/>
Codice fiscale proprietario <input type="text" class="layout" size="50" readonly value="<%= (Allevamento.getCf_prop() != null ? Allevamento.getCf_prop() :"")  %>">
Tel. <input type="text" class="layout" size="30" readonly value="">
<br/>
Detentore <input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getDet() != null ? Allevamento.getDet() :"") %>"><br>
Codice fiscale detentore <input type="text" class="layout" size="50" readonly value="<%= Allevamento.getCf_det() %>">
Tel. <input type="text" class="layout" size="30" readonly value="">
<br/>
Data inizio attivita' <input type="text" class="layout" size="15" readonly value="<%= (Allevamento.getData_inizio_attivita() != null ? toDateasStringfromString(Allevamento.getData_inizio_attivita()) :"")  %>">
<br/>
Tipologia struttura <input type="text" class="layout" size="30" readonly value="<%= (Allevamento.getTipologia_struttura() != null ? Allevamento.getTipologia_struttura() :"")  %>">
<br/>
Orientamento produttivo <input type="text" class="layout" size="30" readonly value="<%= (Allevamento.getTipologia_att() != null ? Allevamento.getTipologia_att() :"")  %>">
<br/>
E' stata consegnata una copia della presente check list all'allevatore? <input type="text" class="layout" size="2" readonly value="<%= (Ticket.getFlag_checklist() != null && Ticket.getFlag_checklist().equals("S")) ? "SI" : "NO"  %>"><br/>
</div>

<div class="fine" style="height: 50px;">&nbsp;</div>


<div align="right"><b>In caso di esito "N.A." specificare il motivo in campo note.<br/>
A seguito degli accertamenti condotti dal Servizio Veterinario competente sono state accertate le seguenti evidenze:</b><br/>
<textarea  <%= (ChecklistIstanza!=null && ChecklistIstanza.isBozza()==false ) ? "disabled" : ""%> name ="cgo_note" class="editField" rows="6" cols="80" ><%=(ChecklistIstanzaCGO!=null) ? (ChecklistIstanzaCGO.getNote()) : "" %></textarea>
</div>