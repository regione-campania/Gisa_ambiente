

/**
 * Displays url in a new window
 * @arg1 = filename / url
 * @arg2 = title of window
 * @arg3 = width of window
 * @arg4 = height of window
 * @arg5 = allow resize (yes/no)
 * @arg6 = show scroll bars (yes/no)
 */





function popURL(filename, title, width, height, resize, bars) {
  var posx = (screen.width - width)/2;
  var posy = (screen.height - height)/2;
  var params = 'WIDTH=' + width + ',HEIGHT=' + height + ',RESIZABLE=' + resize + ',SCROLLBARS=' + bars + ',STATUS=0,LEFT=' + posx + ',TOP=' + posy + ',screenX=' + posx + ',screenY=' + posy;
  var newwin=window.open(filename, title, params);
  
  newwin.focus();
  if (newwin != null) {
    if (newwin.opener == null)
      newwin.opener = self;
  }
}
function popURLAllegatoF(filename, title, width, height, resize, bars) {
	  var posx = (screen.width - width)/2;
	  var posy = (screen.height - height)/2;
	  tipoAlimeni = document.getElementById('tipoAlimenti').value;
	  alert(tipoAlimeni)
	 specieAlimeni = document.getElementById('specie_alimenti').value;
	  var params = 'WIDTH=' + width + ',HEIGHT=' + height + ',RESIZABLE=' + resize + ',SCROLLBARS=' + bars + ',STATUS=0,LEFT=' + posx + ',TOP=' + posy + ',screenX=' + posx + ',screenY=' + posy;
	  var newwin=window.open(filename+'&tipoAlimenti='+tipoAlimeni+'&specie_alimenti='+specieAlimeni, title, params);
	  newwin.focus();
	  if (newwin != null) {
	    if (newwin.opener == null)
	      newwin.opener = self;
	  }
	}



function popURLReturn(filename, returnUrl, title, width, height, resize, bars) {
  var posx = (screen.width - width)/2;
  var posy = (screen.height - height)/2;
  var params = 'WIDTH=' + width + ',HEIGHT=' + height + ',RESIZABLE=' + resize + ',SCROLLBARS=' + bars + ',STATUS=0,LEFT=' + posx + ',TOP=' + posy + 'screenX=' + posx + ',screenY=' + posy;
  var newwin=window.open(filename + "&return=" + escape(returnUrl), title, params);
  newwin.focus();
  if (newwin != null) {
    if (newwin.opener == null)
      newwin.opener = self;
  }
}

function f5() {

    if (window.event && window.event.keyCode == 116) { // Capture and remap F5

        window.event.keyCode = 505;
    } 

    if (window.event && window.event.keyCode == 505) { // New action for F5
        return false;
    }
}

function popURLCampaign(filename, title, width, height, resize, bars) {
  var posx = (screen.width - width)/2;
  var posy = (screen.height - height)/2;
  
  var params = 'WIDTH=' + width + ',HEIGHT=' + height + ',RESIZABLE=' + resize + ',SCROLLBARS=' + bars + ',STATUS=0,LEFT=' + posx + ',TOP=' + posy + 'screenX=' + posx + ',screenY=' + posy;
  
  filename = filename + "&source=" + document.searchForm.contactSource.options[document.searchForm.contactSource.selectedIndex].value; 
  
  var newwin=window.open(filename, title, params);
  newwin.focus();
  if (newwin != null) {
    if (newwin.opener == null)
      newwin.opener = self;
  }
}

