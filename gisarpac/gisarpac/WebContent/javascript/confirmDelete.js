function trim(stringa){
	
	if(stringa!='')
	{
    while (stringa.substring(0,1) == ' '){
        stringa = stringa.substring(1, stringa.length);
    }
    while (stringa.substring(stringa.length-1, stringa.length) == ' '){
        stringa = stringa.substring(0,stringa.length-1);
    }
    while (stringa.substring(stringa.length-1, stringa.length) == '\n'){
        stringa = stringa.substring(0,stringa.length-1);
    }
	}
    return stringa;
}
/**
 * Displays a confirmation to the user
 * @arg1 = URL to forward to if confirmation returns true
 */
function confirmDelete(url) {
  if (confirm(label("are.you.sure", "Are you sure?"))) {
    window.location = url;
  }
}

function confirmForward(url) {
  if (confirm(label("are.you.sure", "Are you sure?"))) {
    window.location = url;
  }
}

function confirmUpdate(url) {
  if (confirm(label("are.you.sure1", "Sei sicuro di voler aggiornare definitivamente il livello di rischio?"))) 
  {
   
    window.location = url;
  }
}

function confirmCodiciIstat(url) {
  
}


function confirmAction(msg) {
  if (confirm(msg)) {
    return true;
  } else {
    return false;
  }
}

function confirmSubmit(theForm) {
  if (confirm(label("are.you.sure", "Are you sure?"))) {
    theForm.submit();
  } else {
    return false;
  }
}
