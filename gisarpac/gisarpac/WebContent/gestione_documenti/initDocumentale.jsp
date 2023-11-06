<!--  VAL_VUOTO: Stringhe di spazi utilizzate per riempire le label nel caso in cui siano nulle 
		z: indice utilizzato per scorrere valoriScelti (array di valori inseribili non presenti nel sorgente html
		salvaForm: memorizza i campi di input in valoriScelti. Se nulli setta ______ per layout di stampa
-->

<%
//String VAL_VUOTO_SHORT = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"; 
//String VAL_VUOTO_LONG = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp"; 
//String VAL_VUOTO_LONG_2 = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
%>
<script> function salva(formDoc){

var inputs, index;
var valori='';
inputs = document.getElementsByTagName('input');
for (index = 0; index < inputs.length; ++index) {

	if (inputs[index].type=='text' && inputs[index].className!='layout'){
	var val = inputs[index].value;
	var id = inputs[index].id;
	//if (val=="")
		//val= "&nbsp";
	//else
		//val=val.toUpperCase();		
     valori = valori.concat(val,';;;');
	}
}

formDoc.listavalori.value = valori;
formDoc.submit();

}

</script>