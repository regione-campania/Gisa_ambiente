 function inviaFileExcel(form){
		var errorString = '';
		 
		 
		var fileCaricato = form.file1;
		
		if (fileCaricato.value==''){// || (!fileCaricato.value.endsWith(".pdf") && !fileCaricato.value.endsWith(".csv"))){
			errorString+=' Errore! Selezionare un file!';
			form.file1.value='';
		}
		/*if (oggetto==''){
			errorString+='\nErrore! L\'oggetto è obbligatorio.';
			}
		if (!GetFileSize(form.file1))
			errorString+='\nErrore! Selezionare un file con dimensione inferiore a 3,00 MB'; */
		if (errorString!= '')
			alert(errorString);
		else
		{
		//form.filename.value = fileCaricato.value;	
		 
			loadModalWindow();
			form.submit();
		}
	} 

 
 
 
 
 
 
 $(function(){
	 
	 
	 $("a").filter(function(ind){
		 
		 return /^.*ImportAnagraficheGestoriMassivo.*$/i.test($(this).attr("href")+"");
	 }).css({"color" : "red", "font-weight" : "bold"});
	 
	 
 });