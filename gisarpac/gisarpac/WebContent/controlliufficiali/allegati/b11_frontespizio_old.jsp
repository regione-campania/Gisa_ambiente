<div style="border: 1px solid;">
<br>
<!-- Per modello 1 -->

Codice Azienda <input type="text" class="layout" size = "15" readonly value="<%=(Allevamento.getN_reg() != null ? Allevamento.getN_reg() :"") %>"><br>
Ragione Sociale<input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getName() != null ? Allevamento.getName() :"") %>"><br>
Sede Operativa<input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getComune_operativo() != null ? Allevamento.getComune_operativo()+" "+ Allevamento.getIndirizzo_operativo() : Allevamento.getComune()+" "+Allevamento.getIndirizzo())  %>"><br>
Sede legale<input type="text" class="layout" size="100" readonly value="<%=(Allevamento.getIndirizzo_legale() != null && !Allevamento.getIndirizzo_legale().equals("")) ? Allevamento.getIndirizzo_legale() : ""%>"><br>
Responsabile legale<input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getProp() != null ? Allevamento.getProp() :"")  %>"><br>
Proprietario degli Animali<input type="text" class="layout" size="100" readonly value="<%= Allevamento.getProp()  %>"> <br>
Codice fiscale<input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getCodice_fiscale() != null ? Allevamento.getCodice_fiscale() :"") %>"><br>
Conduttore Detentore degli animali<input type="text" class="layout" size="100" readonly value="<%= (Allevamento.getDet() != null ? Allevamento.getDet() :"") %>"><br>
Codice fiscale<input type="text" class="layout" size="100" readonly value="<%= Allevamento.getCodice_fiscale() %>"><br>

 

</div>