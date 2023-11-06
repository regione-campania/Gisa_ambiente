function callback(top, topId, via, civico, comune, comuneId, cap, prov, provinciaId, addressObj) 
{ 
	
	if (addressObj.provincia!='')
	{
	    document.getElementById(top).value= addressObj.top;       
	    document.getElementById(via).value= addressObj.via;       
	    document.getElementById(civico).value= addressObj.civ;       
	    document.getElementById(comune).value= addressObj.comune;       
	    document.getElementById(cap).value= addressObj.cap;       
	    document.getElementById(prov).value= addressObj.provincia;    
	    document.getElementById(comuneId).value= addressObj.comuneId;     
	    document.getElementById(topId).value= addressObj.topId;     
	    document.getElementById(provinciaId).value= addressObj.provinciaId;  
	}
	loadModalWindowUnlock();

}


function openCapWidget(toponimo,topId, via,civico,comune,comuneId,cap,prov,provinciaId,flag_regione,flag_id_asl) {
  var w=400;
  var h=550;
  var left = (screen.width/2)-(w/2)-200;
  var top = (screen.height/2)-(h/2)-100;
  var stl='location=0,toolbar=0,status=0,menubar=0,scrollbars=0,resizable=0,width='+w+',height='+h+', top='+top+',left='+left;
  loadModalWindowCustom("Attendere Prego...");
  
  //Passo al widget gli id dell'elemento html da riempire
  sessionStorage.setItem("toponimo",toponimo);
  sessionStorage.setItem("via", via);
  sessionStorage.setItem("civico", civico);
  sessionStorage.setItem("comune", comune);
  sessionStorage.setItem("cap", cap);
  sessionStorage.setItem("prov",prov);
  sessionStorage.setItem("comuneId",comuneId);
  sessionStorage.setItem("topId",topId);
  sessionStorage.setItem("provinciaId",provinciaId);

  var win = window.open("javascript/cap_widget/capall.html?flag_regione=" + flag_regione + "&flag_id_asl=" + flag_id_asl, "", stl);

  
  }

function openCapWidgetRidotta(toponimo,topId, via,civico,comune,comuneId,cap,prov,provinciaId,flag_regione,flag_id_asl,idcomunein,idprovinciain){
	var w=400;
	var h=550;
	var left = (screen.width/2)-(w/2)-200;
	var top = (screen.height/2)-(h/2)-100;
	var stl='location=0,toolbar=0,status=0,menubar=0,scrollbars=0,resizable=0,width='+w+',height='+h+', top='+top+',left='+left;
	loadModalWindowCustom("Attendere Prego...");
  
	//Passo al widget gli id dell'elemento html da riempire
	sessionStorage.setItem("toponimo",toponimo);
	sessionStorage.setItem("via", via);
	sessionStorage.setItem("civico", civico);
	sessionStorage.setItem("comune", comune);
	sessionStorage.setItem("cap", cap);
	sessionStorage.setItem("prov",prov);
	sessionStorage.setItem("comuneId",comuneId);
	sessionStorage.setItem("topId",topId);
	sessionStorage.setItem("provinciaId",provinciaId);
	
	var win = window.open("javascript/cap_widget/capallridotta.html?flag_regione=" + flag_regione + "&flag_id_asl=" + flag_id_asl  + 
				"&idcomunein=" + idcomunein + "&idprovinciain=" + idprovinciain, "", stl);
  	
}
