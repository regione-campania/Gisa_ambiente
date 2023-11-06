
<%@page import="java.text.SimpleDateFormat"%><html manifest="offline.manifest"><head>
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<meta http-equiv="content-type" content="text/html; charset=UTF-8"><link rel="stylesheet" type="text/css" href="CheckListImprese.do_files/colore_demo.css">	
<link rel="stylesheet" type="text/css" href="css/demo.css">		
<link rel="stylesheet" type="text/css" href="css/custom.css">	
<!-- import necessari al funzionamento della finestra modale di locking -->	
<link rel="stylesheet" type="text/css" href="css/custom.css">
<link rel="stylesheet" type="text/css" href="css/modalWindow.css">
<link rel="stylesheet" type="text/css" href="css/capitalize.css">		
<script src="javascript/modalWindow.js"></script>
<script src="javascript/jquerymini.js"></script>

<script>
			
			//----------------------------------------- CONTROLLA SE IL SERVER E' UP
			
			function ifUp(url,onUp,onDown) 
			{
				var RANDOM_DIGITS = 7; 
				var pow = Math.pow(10,RANDOM_DIGITS);
				var randStr = String(Math.floor(Math.random()*pow)+pow).substr(1 );
				var img = new Image();
				img.onload = onUp;
				img.onerror = onDown;
				img.src = url+"?"+randStr;
			
			}
			

			//----------------------------------------- DATABASE MANAGEMENT
		
			var indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB;
			var IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction;
			var db;
			(
			
			function () 
			{     
           
				//---------------------------------- INIT DB
				function initDb() 
				{
					var request = indexedDB.open("GISA_OFFLINE",1);  
					
					// apertura db: on success
					request.onsuccess = function (evt)
					{
						console.log('DB opened');
						db = request.result;                                                            
					};
	 
					// apertura db: on error
					request.onerror = function (evt) 
					{
						console.log('Error opening DB '+ evt.target.errorCode);
					};
	 
					// apertura db: on upgradeneeded
					request.onupgradeneeded = function (evt) 
					{                   
						var objectStore = evt.currentTarget.result.createObjectStore("databean", { keyPath: "timeStamp", autoIncrement: false });
						objectStore.createIndex("databean", "databean", { unique: false });
					};
				}
 
 
				//---------------------------------- CONTENT LOADING
				function contentLoaded()
				{
		 
					initDb();              

					
					$('#pendenti').click(function()
					{
						
						
						var tab ;
						jQuery('#label').html("<font color = 'red'>CARICAMENTO CHECKLIST IN CORSO. ATTENDERE . . . </font>");	
						
								var idControlloUfficiale = $('#idControlloUfficiale').val();
								tab = "<TABLE cellpadding='4' id ='checklist'  cellspacing='0' border='0' width='100%' class='details'><TR><TH>Tipologia</TH> <TH>Vai alla checkslist</TH></TR>" ;
								var lastpath = 'null';
								var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
								var objectStore = transaction.objectStore("databean");
								var request = objectStore.openCursor();
								var cursRow = 0 ;
								request.onsuccess = function(evt) 
								{

									var cursor = evt.target.result;
											
									if (cursor) 
									{ 
										
										var databean = cursor.value;

										var idChecklist_memorizzato = databean.idChecklist;

										
										console.log('idChecklist_memorizzato '+idChecklist_memorizzato);
										console.log(lastpath);
										console.log(databean.path);
										
										if((lastpath=='null' || databean.path!=lastpath) && idControlloUfficiale == databean.idControllo)
										{
											cursRow++ ;
											lastpath = databean.path;
											tab+="<TR><TD>"+databean.checklistname+"</TD> <TD><A HREF=\'"+lastpath+"\'>VAI</A></TD></TR>" ;
											//jQuery('#checklist').html("<TR><TD>"+databean.timeStamp+"</TD> <TD>"+databean.checklistname+"</TD> <TD><A HREF=\'"+lastpath+"\'>VAI</A></TD></TR>");
										}
												
										cursor.continue();  
									}
									else
									{
										tab += "</TABLE>" ;
										if(cursRow>0)
										{
											jQuery('#label').html("<font color = 'green'>Caricamento Completato</font>");
											jQuery('#elenco').html(tab);
										}
										else
										{
											jQuery('#label').html("<font color = 'green'>Caricamento Completato.Nessuna checklist presente</font>");
										}
									}

									
									
									
								} // fine request onsuccess
								
								}); // fine evento load-on-click
		
					
					//---------------------------------- SAVING salva temp
					
					$('#btnSaveTemp').click(function()
					{
						
						ifUp("http://srv.gisacampania.it/centric_osa/images/centric/logo-centric.gif",
							function()
							{
							
							console.log('Il server e\' UP, la checklist viene inviata a GISA');
							doSubmit('ChecklistUpdateServlet','Temporanea');
								
							},
							
							function()
							{
								console.log('Il server e\' DOWN, la checklist viene salvata in LOCALE');
								alert('Il server di GISA non risponde o e\' stata rilevata assenza di connessione. La checklist verra\' salvata in LOCALE. Attendere la fine del salvataggio, l\'operazione potrebbe richiedere del tempo. Attendere il messaggio di avvenuto salvataggio.');
								var idChecklist = $('#idChecklist').val();

								//console.log('idChecklist '+idChecklist);
								
								// recupero le informazioni iniziali
								var livelloRischio = $('#livelloRischio').val();
								var categoriaRischio = $('#categoriaRischio').val();
								var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();

								var idControllo =  $('#idControllo').val();
								
								// costruisco l'array dei punteggi
								var arrayPunti = $('input[id^=punti]');
								var lenPunti = arrayPunti.size();
								
								// costruisco l'array delle risposte
								var arrayRisp = $('input[id^=risposta]');
								var iRisp = 0;
								var lenRisp = arrayRisp.size(); 
								
								// array delle risposte (escludendo i capitoli)
								var arrayRisp2 = new Array();
								var iRisp2 = 0;
								
								for(iRisp=0;iRisp<lenRisp;iRisp++)
								{
									var tmp = $(arrayRisp[iRisp]).attr('class');
									
									
									if(tmp!='domandaCapitolo')
									{
										arrayRisp2[iRisp2] = arrayRisp[iRisp];
										iRisp2++;
									}
								}
								
								var lenRisp2 = arrayRisp2.length;
								var idSi = 0;
								var idNo = 0;
								var idPunti = 0;
								var databean = null;
								
								var iSi = 0;
								var iNo = 0;
								var iPunti = 0;
								var iIndex = 1;
								
								var path = jQuery('#path').val();
								var checklistname = jQuery('#checklistname').val();
								alert('ci arrivo ');
								
								// scorro le risposte
								for (i=0;i<lenRisp2;i++)
								{
								
									
									iSi = i;
									iNo = i+1;
									iPunti = iNo - iIndex;
							
									idSi = arrayRisp2[iSi].id;
									idNo = arrayRisp2[iNo].id;
									idPunti = arrayPunti[iPunti].id;
									punteggio = $('#'+idPunti).val();
									i++;
									iIndex++;
									
									checkedSi = $('#'+idSi+':checked').val();
									checkedNo = $('#'+idNo+':checked').val();
									
									if(checkedSi==undefined)
										checkedSi = 0
									else
										checkedSi = 1
										
									if(checkedNo==undefined)
										checkedNo = 0
									else
										checkedNo = 1

									// per ogni risposta costruisco un databean
									databean = {
									  "idChecklist": idChecklist,
									  "livelloRischio": livelloRischio,
									  "categoriaRischio":categoriaRischio,
									  "punteggioUltimiAnni":punteggioUltimiAnni,
									  "idSi":idSi,
									  "checkedSi":checkedSi,
									  "idNo":idNo,
									  "checkedNo":checkedNo,
									  "idPunti":idPunti,
									  "punteggio":punteggio,
									  "checklistname":checklistname,
									  "path":path,
									  "timeStamp": idPunti,
									  "idControllo" : idControllo
									};

									alert('prima di transaction '+db);
									//var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
									var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
									alert('dopo transaction');
									var objectStore = transaction.objectStore("databean");                    
									var request = objectStore.put(databean);
									//console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
									
								}
								
								
								alert('La checklist e\' stata salvata con successo in modalita\' OFFLINE');
								return;
							} // fine funzione on-server-down
							
						);	// fine funzione if-server-up
						
					});	// fine evento save-on-click
					
					//---------------------------------- SAVING salva definitiva
					
					$('#btnSave').click(function()
					{
						
						ifUp("http://srv.gisacampania.it/centric_osa/images/centric/logo-centric.gif",
						//ifUp("http://www.google.it",
							function()
							{
								console.log('Il server e\' UP, la checklist viene inviata a GISA');
								var esito = checkForm();
							
								if(esito)
								{
									//console.log('Il server e\' UP, la checklist viene salvata anche in LOCALE');

									
									var idChecklist = $('#idChecklist').val();
									console.log('tipo checklist '+idChecklist);
									//console.log('idChecklist '+idChecklist);
										var idControllo =  $('#idControllo').val();
									// recupero le informazioni iniziali
									var livelloRischio = $('#livelloRischio').val();
									var categoriaRischio = $('#categoriaRischio').val();
									var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();
									
									// costruisco l'array dei punteggi
									var arrayPunti = $('input[id^=punti]');
									var lenPunti = arrayPunti.size();
									
									// costruisco l'array delle risposte
									var arrayRisp = $('input[id^=risposta]');
									var iRisp = 0;
									var lenRisp = arrayRisp.size(); 
									
									// array delle risposte (escludendo i capitoli)
									var arrayRisp2 = new Array();
									var iRisp2 = 0;
									
									for(iRisp=0;iRisp<lenRisp;iRisp++)
									{
										var tmp = $(arrayRisp[iRisp]).attr('class');
										
										
										if(tmp!='domandaCapitolo')
										{
											arrayRisp2[iRisp2] = arrayRisp[iRisp];
											iRisp2++;
										}
									}
									
									var lenRisp2 = arrayRisp2.length;
									var idSi = 0;
									var idNo = 0;
									var idPunti = 0;
									var databean = null;
									
									var iSi = 0;
									var iNo = 0;
									var iPunti = 0;
									var iIndex = 1;
									
									var path = jQuery('#path').val();
									var checklistname = jQuery('#checklistname').val();
									
									
									// scorro le risposte
									for (i=0;i<lenRisp2;i++)
									{
										
										
										iSi = i;
										iNo = i+1;
										iPunti = iNo - iIndex;
								
										idSi = arrayRisp2[iSi].id;
										idNo = arrayRisp2[iNo].id;
										idPunti = arrayPunti[iPunti].id;
										punteggio = $('#'+idPunti).val();
										
										i++;
										iIndex++;
										
										checkedSi = $('#'+idSi+':checked').val();
										checkedNo = $('#'+idNo+':checked').val();
										
										if(checkedSi==undefined)
											checkedSi = 0
										else
											checkedSi = 1
											
										if(checkedNo==undefined)
											checkedNo = 0
										else
											checkedNo = 1

										// per ogni risposta costruisco un databean
										databean = {
										  "idChecklist": idChecklist,
										  "livelloRischio": livelloRischio,
										  "categoriaRischio":categoriaRischio,
										  "punteggioUltimiAnni":punteggioUltimiAnni,
										  "idSi":idSi,
										  "checkedSi":checkedSi,
										  "idNo":idNo,
										  "checkedNo":checkedNo,
										  "idPunti":idPunti,
										  "punteggio":punteggio,
										  "checklistname":checklistname,
										  "path":path,
										  "timeStamp": idPunti,
										  "idControllo" : idControllo
										};

										
										
										var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
										var objectStore = transaction.objectStore("databean");                    
										var request = objectStore.put(databean);
										//console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
										
									}
									
									
										
									document.addAccountAudit.submit();
									//loadModalWindow();
									
								}
								else
								{
									
									return false;
								}
							},
							
							function()
							{
								console.log('Il server e\' DOWN, la checklist viene salvata in LOCALE');
								alert('Il server di GISA non risponde o e\' stata rilevata assenza di connessione. La checklist verra\' salvata in LOCALE. Attendere la fine del salvataggio, l\'operazione potrebbe richiedere del tempo. Attendere il messaggio di avvenuto salvataggio.');
								var idChecklist = $('#idChecklist').val();

								//console.log('idChecklist '+idChecklist);
								
								// recupero le informazioni iniziali
								var livelloRischio = $('#livelloRischio').val();
								var categoriaRischio = $('#categoriaRischio').val();
								var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();
								
								// costruisco l'array dei punteggi
								var arrayPunti = $('input[id^=punti]');
								var lenPunti = arrayPunti.size();
								
								// costruisco l'array delle risposte
								var arrayRisp = $('input[id^=risposta]');
								var iRisp = 0;
								var lenRisp = arrayRisp.size(); 
								
								// array delle risposte (escludendo i capitoli)
								var arrayRisp2 = new Array();
								var iRisp2 = 0;
								
								for(iRisp=0;iRisp<lenRisp;iRisp++)
								{
									var tmp = $(arrayRisp[iRisp]).attr('class');
									
									
									if(tmp!='domandaCapitolo')
									{
										arrayRisp2[iRisp2] = arrayRisp[iRisp];
										iRisp2++;
									}
								}
								
								var lenRisp2 = arrayRisp2.length;
								var idSi = 0;
								var idNo = 0;
								var idPunti = 0;
								var databean = null;
								
								var iSi = 0;
								var iNo = 0;
								var iPunti = 0;
								var iIndex = 1;
								
								var path = jQuery('#path').val();
								var checklistname = jQuery('#checklistname').val();
								var idControllo =  $('#idControllo').val();
								
								// scorro le risposte
								for (i=0;i<lenRisp2;i++)
								{
									
									
									iSi = i;
									iNo = i+1;
									iPunti = iNo - iIndex;
							
									idSi = arrayRisp2[iSi].id;
									idNo = arrayRisp2[iNo].id;
									idPunti = arrayPunti[iPunti].id;
									punteggio = $('#'+idPunti).val();
									
									i++;
									iIndex++;
									
									checkedSi = $('#'+idSi+':checked').val();
									checkedNo = $('#'+idNo+':checked').val();
									
									if(checkedSi==undefined)
										checkedSi = 0
									else
										checkedSi = 1
										
									if(checkedNo==undefined)
										checkedNo = 0
									else
										checkedNo = 1

									// per ogni risposta costruisco un databean
									databean = {
									  "idChecklist": idChecklist,
									  "livelloRischio": livelloRischio,
									  "categoriaRischio":categoriaRischio,
									  "punteggioUltimiAnni":punteggioUltimiAnni,
									  "idSi":idSi,
									  "checkedSi":checkedSi,
									  "idNo":idNo,
									  "checkedNo":checkedNo,
									  "idPunti":idPunti,
									  "punteggio":punteggio,
									  "checklistname":checklistname,
									  "path":path,
									  "timeStamp": idPunti,
									  "idControllo" : idControllo
									};

									
									
									var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
									var objectStore = transaction.objectStore("databean");                    
									var request = objectStore.put(databean);
									
									//console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
									
								}
								
								
								alert('La checklist e\' stata salvata con successo in modalita\' OFFLINE');
								return;
							} // fine funzione on-server-down
							
						);	// fine funzione if-server-up
						
					});	// fine evento save-on-click

					$('#btnSave2').click(function()
							{
								
								ifUp("http://srv.gisacampania.it/centric_osa/images/centric/logo-centric.gif",
									function()
									{
										console.log('Il server e\' UP, la checklist viene inviata a GISA');
										var esito = checkForm();
										
										if(esito)
										{
											 myRequest = CreateXmlHttpReq(myHandler);
											
											console.log('Il server e\' UP, la checklist viene salvata anche in LOCALE');
											var idChecklist = $('#idChecklist').val();
											console.log('tipo checklist '+idChecklist);
											//console.log('idChecklist '+idChecklist);
												var idControllo =  $('#idControllo').val();
											// recupero le informazioni iniziali
											var livelloRischio = $('#livelloRischio').val();
											var categoriaRischio = $('#categoriaRischio').val();
											var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();
											
											// costruisco l'array dei punteggi
											var arrayPunti = $('input[id^=punti]');
											var lenPunti = arrayPunti.size();
											
											// costruisco l'array delle risposte
											var arrayRisp = $('input[id^=risposta]');
											var iRisp = 0;
											var lenRisp = arrayRisp.size(); 
											
											// array delle risposte (escludendo i capitoli)
											var arrayRisp2 = new Array();
											var iRisp2 = 0;
											
											for(iRisp=0;iRisp<lenRisp;iRisp++)
											{
												var tmp = $(arrayRisp[iRisp]).attr('class');
												
												
												if(tmp!='domandaCapitolo')
												{
													arrayRisp2[iRisp2] = arrayRisp[iRisp];
													iRisp2++;
												}
											}
											
											var lenRisp2 = arrayRisp2.length;
											var idSi = 0;
											var idNo = 0;
											var idPunti = 0;
											var databean = null;
											
											var iSi = 0;
											var iNo = 0;
											var iPunti = 0;
											var iIndex = 1;
											
											var path = jQuery('#path').val();
											var checklistname = jQuery('#checklistname').val();
											
											
											// scorro le risposte
											for (i=0;i<lenRisp2;i++)
											{
												
												
												iSi = i;
												iNo = i+1;
												iPunti = iNo - iIndex;
										
												idSi = arrayRisp2[iSi].id;
												idNo = arrayRisp2[iNo].id;
												idPunti = arrayPunti[iPunti].id;
												punteggio = $('#'+idPunti).val();
												
												i++;
												iIndex++;
												
												checkedSi = $('#'+idSi+':checked').val();
												checkedNo = $('#'+idNo+':checked').val();
												
												if(checkedSi==undefined)
													checkedSi = 0
												else
													checkedSi = 1
													
												if(checkedNo==undefined)
													checkedNo = 0
												else
													checkedNo = 1

												// per ogni risposta costruisco un databean
												databean = {
												  "idChecklist": idChecklist,
												  "livelloRischio": livelloRischio,
												  "categoriaRischio":categoriaRischio,
												  "punteggioUltimiAnni":punteggioUltimiAnni,
												  "idSi":idSi,
												  "checkedSi":checkedSi,
												  "idNo":idNo,
												  "checkedNo":checkedNo,
												  "idPunti":idPunti,
												  "punteggio":punteggio,
												  "checklistname":checklistname,
												  "path":path,
												  "timeStamp": idPunti,
												  "idControllo" : idControllo
												};

												
												
												var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
												var objectStore = transaction.objectStore("databean");                    
												var request = objectStore.put(databean);
												//console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
												
											}
											
											
												
											document.addAccountAudit.submit();
										}
										else
										{
											
											return false;
										}
									},
									
									function()
									{
										console.log('Il server e\' DOWN, la checklist viene salvata in LOCALE');
										alert('Il server di GISA non risponde o e\' stata rilevata assenza di connessione. La checklist verra\' salvata in LOCALE. Attendere la fine del salvataggio, l\'operazione potrebbe richiedere del tempo. Attendere il messaggio di avvenuto salvataggio.');
										var idChecklist = $('#idChecklist').val();

										//console.log('idChecklist '+idChecklist);
										
										// recupero le informazioni iniziali
										var livelloRischio = $('#livelloRischio').val();
										var categoriaRischio = $('#categoriaRischio').val();
										var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();
										var idControllo =  $('#idControllo').val();
										// costruisco l'array dei punteggi
										var arrayPunti = $('input[id^=punti]');
										var lenPunti = arrayPunti.size();
										
										// costruisco l'array delle risposte
										var arrayRisp = $('input[id^=risposta]');
										var iRisp = 0;
										var lenRisp = arrayRisp.size(); 
										
										// array delle risposte (escludendo i capitoli)
										var arrayRisp2 = new Array();
										var iRisp2 = 0;
										
										for(iRisp=0;iRisp<lenRisp;iRisp++)
										{
											var tmp = $(arrayRisp[iRisp]).attr('class');
											
											
											if(tmp!='domandaCapitolo')
											{
												arrayRisp2[iRisp2] = arrayRisp[iRisp];
												iRisp2++;
											}
										}
										
										var lenRisp2 = arrayRisp2.length;
										var idSi = 0;
										var idNo = 0;
										var idPunti = 0;
										var databean = null;
										
										var iSi = 0;
										var iNo = 0;
										var iPunti = 0;
										var iIndex = 1;
										
										var path = jQuery('#path').val();
										var checklistname = jQuery('#checklistname').val();
										
										
										// scorro le risposte
										for (i=0;i<lenRisp2;i++)
										{
											
											
											iSi = i;
											iNo = i+1;
											iPunti = iNo - iIndex;
									
											idSi = arrayRisp2[iSi].id;
											idNo = arrayRisp2[iNo].id;
											idPunti = arrayPunti[iPunti].id;
											punteggio = $('#'+idPunti).val();
											
											i++;
											iIndex++;
											
											checkedSi = $('#'+idSi+':checked').val();
											checkedNo = $('#'+idNo+':checked').val();
											
											if(checkedSi==undefined)
												checkedSi = 0
											else
												checkedSi = 1
												
											if(checkedNo==undefined)
												checkedNo = 0
											else
												checkedNo = 1

											// per ogni risposta costruisco un databean
											databean = {
											  "idChecklist": idChecklist,
											  "livelloRischio": livelloRischio,
											  "categoriaRischio":categoriaRischio,
											  "punteggioUltimiAnni":punteggioUltimiAnni,
											  "idSi":idSi,
											  "checkedSi":checkedSi,
											  "idNo":idNo,
											  "checkedNo":checkedNo,
											  "idPunti":idPunti,
											  "punteggio":punteggio,
											  "checklistname":checklistname,
											  "path":path,
											  "timeStamp": idPunti,
											  "idControllo" : idControllo
											};

											
											
											var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
											var objectStore = transaction.objectStore("databean");                    
											var request = objectStore.put(databean);
											//console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
											
										}
										
										
										alert('La checklist e\' stata salvata con successo in modalita\' OFFLINE');
										return;
									} // fine funzione on-server-down
									
								);	// fine funzione if-server-up
								
							});	// fine evento save-on-click
							
							
					
					//---------------------------------- LOADING DATA ENTRIES
					
					$('#load').click(function()
					{
						var count = 0 ;
						
						alert('La Checklist verra\' caricata da LOCALE dallo stato in cui era stata salvata precedentemente. L\'operazione potrebbe richiedere del tempo. Attendere il messaggio di effettuato caricamento.');
						var idChecklist_corrente = $('#idChecklist').val();
						var cursCount = 0;
						
						var idControllo =  $('#idControllo').val();
						var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
						var objectStore = transaction.objectStore("databean");
	 
						var request = objectStore.openCursor();
						request.onsuccess = function(evt) 
						{  
							var cursor = evt.target.result;  
							
							if (cursor) 
							{  
								
								
								var databean = cursor.value;
								//console.log('recupero id checklist da databean');

								
								var idChecklist_memorizzato = databean.idChecklist;
								var idControllo_memorizzato = databean.idControllo;
								
								console.log('idChecklist_memorizzato '+idChecklist_memorizzato);
								console.log('idChecklist_corrente '+idChecklist_corrente);
								
								
								if((idChecklist_memorizzato==idChecklist_corrente) && idControllo_memorizzato == idControllo )
								{
									count++ ;
									cursCount++;
									console.log('caricata');
								
								$('#livelloRischio').val(databean.livelloRischio);
								$('#categoriaRischio').val(databean.categoriaRischio);
								$('#punteggioUltimiAnni').val(databean.punteggioUltimiAnni);
								
							
								
								var currentId = '#'+databean.idPunti;
								$(currentId).val(databean.punteggio);
								
								var idDomanda = databean.idPunti;
									idDomanda = idDomanda.substring(5,idDomanda.length);
								
								var parentId = parentIdList[idDomanda];
								var grandParentId = grandParentIdList[idDomanda];
								var punteggioRisposta = databean.punteggio;
								var siNo = "";
								
								if(databean.checkedSi==1)
								{
									siNo = "si";
									$('input[id='+databean.idSi+']').attr('checked', true);
								}
								
								else if(databean.checkedNo==1)
								{
									siNo = "no";
									$('input[id='+databean.idNo+']').attr('checked', true);
								}
								
								else
									siNo = "";
									
								var stato = "RISPOSTA";
								
								aggiornaListElementModify3(idDomanda,parentId,grandParentId,punteggioRisposta,siNo,stato);
								console.log(databean.path);
								
							}
							else
							{
									console.log('Checklist o CU non corrispondente'); 
									
							}  
								cursor.continue(); 
							}
							else   
							{
								alert(count);
								if(cursCount>0)
									alert('La checklist e\' stata caricata con successo');
								else
									alert('La checklist non contiene dati salvati in modalita\' OFFLINE');
								//console.log('Cursor: no more entries'); 
							}
							  
						};	// fine open-cursor-on-success
					
					}); // fine evento load-on-click
					
					
					$('#delete').click(function()
					{
					
						var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
						var objectStore = transaction.objectStore("databean");
						var idChecklist_corrente = $('#idChecklist').val();
	 
						var request = objectStore.openCursor();
						request.onsuccess = function(evt) 
						{  
							var cursor = evt.target.result;  
							if (cursor) 
							{  
								
								var databean = cursor.value;
								var idChecklist_memorizzato = databean.idChecklist;
					
								if(idChecklist_memorizzato==idChecklist_corrente)
								{
							
								cursor.continue();  
								cursor.delete(); 
								
								}
							}
							else   
								console.log('Cursor: no more entries to delete'); 
							
							  
						};	// fine open-cursor-on-success
					
					}); // fine evento load-on-click
					
				 
				}	// fine contentLoaded
 
            window.addEventListener("DOMContentLoaded", contentLoaded, false); 
			})();  // fine funzione principale DB 
			
</script>
<script>
var myRequest = null;
var idTypeList = new Array();

function CreateXmlHttpReq(handler) {
  var xmlhttp = null;
  if (window.XMLHttpRequest)
  {// code for IE7+, Firefox, Chrome, Opera, Safari
  xmlhttp=new XMLHttpRequest();
  }
else
  {// code for IE6, IE5
  xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
  }
  
  xmlhttp.onreadystatechange = handler;
  return xmlhttp;
}

function myHandler() {
	if (myRequest.readyState == 4) {
        // Codice di ritorno del server 200 vuol dire OK 
        
        
        if (myRequest.status == 200) {
            // Lettura  valore di ritorno  in formato XML 
	            
                gestisciRisposta(myRequest.responseXML);
            } 
        }

}



function gestisciRisposta(risposta)
{

	
	 var msg = risposta.getElementsByTagName("valid")[0].firstChild.nodeValue;
	    var mdiv = document.getElementById("salva_temp");

	    
	    if (msg == 'false') {
		  
	       
	        mdiv.innerHTML = "</br><font color = 'red'>Attenzione! Si � verificato un errore durante il salvataggio. La checklist � stata salvata in locale fare Carica per ricaricare le risposte date.</font>";

			var indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB;
			var IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction;
			// il salvataggio non � andato a buon fine salvo la checklist in locale
			var idChecklist = $('#idChecklist').val();
			var idControllo =  $('#idControllo').val();
			//console.log('idChecklist '+idChecklist);
			
			// recupero le informazioni iniziali
			var livelloRischio = $('#livelloRischio').val();
			var categoriaRischio = $('#categoriaRischio').val();
			var punteggioUltimiAnni = $('#punteggioUltimiAnni').val();
			
			// costruisco l'array dei punteggi
			var arrayPunti = $('input[id^=punti]');
			var lenPunti = arrayPunti.size();
			
			// costruisco l'array delle risposte
			var arrayRisp = $('input[id^=risposta]');
			var iRisp = 0;
			var lenRisp = arrayRisp.size(); 
			
			// array delle risposte (escludendo i capitoli)
			var arrayRisp2 = new Array();
			var iRisp2 = 0;
			
			for(iRisp=0;iRisp<lenRisp;iRisp++)
			{
				var tmp = $(arrayRisp[iRisp]).attr('class');
				
				
				if(tmp!='domandaCapitolo')
				{
					arrayRisp2[iRisp2] = arrayRisp[iRisp];
					iRisp2++;
				}
			}
			
			var lenRisp2 = arrayRisp2.length;
			var idSi = 0;
			var idNo = 0;
			var idPunti = 0;
			var databean = null;
			
			var iSi = 0;
			var iNo = 0;
			var iPunti = 0;
			var iIndex = 1;
			
			var path = jQuery('#path').val();
			var checklistname = jQuery('#checklistname').val();
			
			
			// scorro le risposte
			for (i=0;i<lenRisp2;i++)
			{
				
				
				iSi = i;
				iNo = i+1;
				iPunti = iNo - iIndex;
		
				idSi = arrayRisp2[iSi].id;
				idNo = arrayRisp2[iNo].id;
				idPunti = arrayPunti[iPunti].id;
				punteggio = $('#'+idPunti).val();
				
				i++;
				iIndex++;
				
				checkedSi = $('#'+idSi+':checked').val();
				checkedNo = $('#'+idNo+':checked').val();
				
				if(checkedSi==undefined)
					checkedSi = 0
				else
					checkedSi = 1
					
				if(checkedNo==undefined)
					checkedNo = 0
				else
					checkedNo = 1

				// per ogni risposta costruisco un databean
				databean = {
				  "idChecklist": idChecklist,
				  "livelloRischio": livelloRischio,
				  "categoriaRischio":categoriaRischio,
				  "punteggioUltimiAnni":punteggioUltimiAnni,
				  "idSi":idSi,
				  "checkedSi":checkedSi,
				  "idNo":idNo,
				  "checkedNo":checkedNo,
				  "idPunti":idPunti,
				  "punteggio":punteggio,
				  "checklistname":checklistname,
				  "path":path,
				  "timeStamp": idPunti,
				  "idControllo" : idControllo
				};

				
				
				var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
				var objectStore = transaction.objectStore("databean");                    
				var request = objectStore.put(databean);
				console.log('Il server e\' DOWN, la checklist � stata salvata in LOCALE');
				
			}
			//loadModalWindowUnlock() ;
			
		    } else {
		    	
	        mdiv.innerHTML = "</br><font color = 'green'>Il Lavoro � stato salvato Correttamente</font>";

	        //cancello la checklist da locale	
	        var indexedDB = window.indexedDB || window.webkitIndexedDB || window.mozIndexedDB || window.msIndexedDB;
			var IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction;
			var request = indexedDB.open("GISA_OFFLINE",1);  
			// OPENING: on success
			request.onsuccess = function (evt)
			{
				console.log('DB opened');
				db = request.result;  
				console.log(db);
				
				var lastpath = 'null';
				var transaction = db.transaction("databean", IDBTransaction.READ_WRITE);
				var objectStore = transaction.objectStore("databean");
	
				var idChecklist_corrente = $('#idChecklist').val();
				var idControllo =  $('#idControllo').val();
				var requestb = objectStore.openCursor();
				requestb.onsuccess = function(evt) 
				{  
					var cursor = evt.target.result;  
					if (cursor) 
					{  
						
						var databean = cursor.value;
						var idChecklist_memorizzato = databean.idChecklist;
						var idControllo_memorizzato = databean.idControllo;
						console.log('idControllo_memorizzato '+idControllo_memorizzato);

						console.log('idChecklist_corrente '+idChecklist_corrente);
						if(idChecklist_memorizzato==idChecklist_corrente && idControllo ==idControllo_memorizzato  )
						{
					
						 
						cursor.delete(); 
						console.log('Checklist Cancellata da locale ');
						}
						cursor.continue(); 
						 
					}
					else   
						console.log('Cursor: no more entries to delete'); 
				};

			};
			document.getElementById('btnSaveTemp').value = 'Salvataggio Temporaneo' ;
		   	//document.getElementById('btnSaveTemp').disabled=false ;
		   	document.getElementById('btnSaveTemp').style.display="";
		   	//alert('checklist salvata in maniera corretta')
		   	//loadModalWindowUnlock() ;
	        
	    }
		

	    
	   		
	   	 
}

function doSubmit(link,stato)
{
   	document.getElementById('salva_temp').innerHTML="<font color='red'>Attendere Salvataggio in Corso</font>";
	document.getElementById('btnSaveTemp').value = 'Salvataggio in Corso' ;
	// document.getElementById('btnSaveTemp').disabled=true ;	
	 myRequest = CreateXmlHttpReq(myHandler);
	  var link = link+'?prova=ok';
	  var parametri = '' ;
	  for(i=0;i<idList.length;i++)
	  {
			if(document.getElementById('risposta'+idList[i]+'1').checked)
			{
				parametri+= '&risposta'+idList[i]+'='+document.getElementById('risposta'+idList[i]+'1').value ;
			}
			else
			{
				if(document.getElementById('risposta'+idList[i]+'2').checked)
				{
					parametri+= '&risposta'+idList[i]+'='+document.getElementById('risposta'+idList[i]+'2').value ;
				}
		     }
	 }

	 
	for (z=1;z<idTypeList.length-1;z++)
	{
		
		parametri+= '&valoreRange'+idTypeList[z]+'='+document.getElementById('valoreRange'+z).value ;
		

	}

	for (i=1;i<idTypeList.length-1;i++)
	{

		parametri+= '&operazione'+i+'='+document.getElementById('operazione'+i).value ;
		

	}

	for (i=1;i<idTypeList.length-1;i++)
	{

		if(document.getElementById("isDisabilitabile"+idTypeList[i]).value=="true")
		{
		
			if(document.getElementById("risposta"+idTypeList[i]+"1").checked==true)
			{
				parametri+= '&disabilita'+idTypeList[i]+'1='+document.getElementById('risposta'+idTypeList[i]+'1').value ;
			}
			else
			{
				if(document.getElementById("risposta"+idTypeList[i]+"2").checked==true)
				{
					
					parametri+= '&disabilita'+idTypeList[i]+'1='+document.getElementById('risposta'+idTypeList[i]+'2').value ;
				}
	     	}

		}
		else
		{
			parametri+= '&disabilita'+idTypeList[i]+'1='+document.getElementById('risposta'+idTypeList[i]+'1').value ;
			
		}

	}
	parametri+='&idLastDomanda='+document.getElementById('last').value ;
	parametri+='&punteggioUltimiAnni='+document.getElementById('punteggioUltimiAnni').value ;
	parametri+='&stato='+stato ;
	parametri+='&id='+document.getElementById('idAudit').value ;
	parametri+='&orgId='+document.getElementById('orgId').value ;
	parametri+='&idC='+document.getElementById('idC').value ;
	parametri+='&idControllo='+document.getElementById('idControllo').value ;

	parametri+='&componentiGruppo='+document.addAccountAudit.componentiGruppo.value ;
	parametri+='&data1='+document.addAccountAudit.data1.value  ;
	parametri+='&livelloRischio='+document.addAccountAudit.livelloRischio.value  ;
	parametri+='&note='+document.addAccountAudit.note.value  ;
	
	
	myRequest.open("GET",link+parametri,true);
	myRequest.send(null);
	
	//loadModalWindow();
	//xmlDoc=xmlhttp.responseXML; 
	
}




</script>
<%
ControlloUfficiale.setActionChecklist();

%>

<script>
//loadModalWindow();
</script>
 
<br> <font color = "red">Attenzione! In caso di salvataggio definitivo o in caso di assenza di connessione durante il salvataggio temporaneo , il sistema chiedera' 
all'utente se desidera salvare il lavoro in locale. Accettare cliccando sul pulsante permetti.Questo messaggio apparir� anche nel caso di carica checklist.
</font>
<br><br>
<input type="hidden" name="aggiorna" value="" />
<input id = "btnSave" type="button" value="Salva checklist">
<input id = "load" type="button" value="Carica checklist">
<!--<input type="submit" id="btnSaveTemp" onclick="document.addAccountAudit.action=document.addAccountAudit.action+'&stato=<%="Temporanea" %>';document.addAccountAudit.submit()" value="<dhv:label name="">Salva Temporanea</dhv:label>">-->
<%if(Audit.getStato().equalsIgnoreCase("temporanea")){ %>
<input type="button" id="btnSaveTemp" disabled="disabled"  value="<dhv:label name="">Salva Temporanea</dhv:label>" >
<br/>
<font color="red">Il Punteggio storico delle non conformit�, non comprende il punteggio dei controlli ufficiali ancora aperti. Questi ultimi verranno conteggiati nella successiva sorveglianza.</font>
<br/>
<br/>

<div id="salva_temp">

<br/>
<br/>
<%
if(request.getAttribute("ErroreChecklist")!=null)
{%>
<font color = "red">Attenzione! Si � verificato un errore durante il salvataggio. Contattare l'Help-Desk</font>
<%
}


%>


</div>
<%} %>
<input type="hidden" name="stato" value="<%="Definitiva" %>" />
<input type="hidden" name="idC" id = "idC"  value="<%=TicketDetails.getId() %>" />
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr class="containerBody">
    <th colspan="2">
      <strong><dhv:label name="audit.Audit">Check List</dhv:label></strong>
    </th>
  </tr>
  <input type="hidden" id="TipoC" name="TipoC" value="<%=ControlloUfficiale.getTipoCampione() %>"/>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="audit.categoriaOsa">Tipo Checklist</dhv:label>
    </td>
    <td>
      <%= toHtml(OrgCategoriaRischioList.getSelectedValue(Audit.getTipoChecklist())) %>
      <input type = "hidden" id = "checklistname" value = " <%= OrgCategoriaRischioList.getSelectedValue(Audit.getTipoChecklist()) %>" />
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="audit.numeroRegistrazione">Progressivo</dhv:label>
    </td>
    <td>
      <%= Audit.getNumeroRegistrazione()%>
      <input type="hidden" size="50" name="numeroRegistrazione" value="<%= Audit.getNumeroRegistrazione()%>"/>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="audit.componentiGruppo">Componenti Gruppo</dhv:label>
    </td>
    <td>
      <input type="text" size="50" name="componentiGruppo" value="<%= toHtml2(Audit.getComponentiGruppo())%>"/>
    </td>
  </tr>
  <input type="hidden" name="dataCK" value="<%=Audit.getData1() %>">
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="audit.livelloRischio">Punteggio Check List</dhv:label>
    </td>
    <td>
      <%= toHtml(String.valueOf(Audit.getLivelloRischio())) %>
      <%-- input type="hidden" name="livelloRischio" value="<%= Audit.getLivelloRischio() %>" /--%>
    </td>
  </tr>
  <tr class="containerBody">
    <td nowrap class="formLabel">
      <dhv:label name="audit.data1">Data</dhv:label>
    </td>
    <td>
      <zeroio:dateSelect form="addAccountAudit" field="data1" showTimeZone="false" timestamp="<%= Audit.getData1()%>" />
      <%= showAttribute(request, "data1Error") %>
    </td>
  </tr>
  
  <%if(Audit.getData2() != null) {%>
  <tr class="containerBody" style="display: none">
    <td nowrap class="formLabel">
      <dhv:label name="audit.data2">Data 2</dhv:label>
    </td>
    <td>
      <zeroio:dateSelect form="addAccountAudit" field="data2" showTimeZone="false" timestamp="<%= Audit.getData2()%>" />
      <%= showAttribute(request, "data2Error") %>
    </td>
  </tr>
  <%} %>
</table>
</br>

<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
<%
int domandaElementId = 0;
String scriptDichiar = " operazioneList = new Array(); notaList = new Array(); valoreRangeList = new Array();"; 
scriptDichiar += " idList = new Array(); parentIdList = new Array();grandParentIdList= new Array(); rispostaList = new Array(); puntiList = new Array(); requiredList = new Array();";
String scriptFunc = "";
int indexChecklistList = 0;

Iterator itrTypeList = typeList.iterator();
Iterator auditCkList=auditChecklist.iterator();
Iterator auditCkListType=auditChecklistType.iterator();
int numcapitolodisabilitati = 0;
boolean abilitato=false;

if ( itrTypeList.hasNext() ) {
	
	
	int progressivoCapitolo = 0;
	int i=0;
	Iterator auditCkListType1=auditChecklistType.iterator();
	while (itrTypeList.hasNext()) {
		
	CustomLookupElement thisTypeList = (CustomLookupElement) itrTypeList.next();
	 progressivoCapitolo =  progressivoCapitolo +1;
	int checklistTypeId = Integer.valueOf(thisTypeList.getValue("code"));
    String checklistDescription = thisTypeList.getValue("description");
    String checklistRange = thisTypeList.getValue("range");
   
    AuditChecklistType a =null;
   
    if( auditCkListType1.hasNext())
    {
    	 
   		 a =	(AuditChecklistType)auditCkListType1.next();
   		
    }

    //String is_disabilitato_solo_xlaprima = (String) thisTypeList.getValue("is_disabilitato_solo_xlaprima");
    if(a!=null)
    {
    	abilitato = a.isIs_abilitato();
    }
    CustomLookupList checklist = (CustomLookupList) checklistList.get(indexChecklistList);
    indexChecklistList++;
    scriptDichiar += "idTypeList[\""+ (indexChecklistList) +"\"] = " + checklistTypeId + ";";
    //scriptDichiar += "aggiornaChecklistType("+indexChecklistList+",'x','','');";

%>

<script>

domandePerCapitolo[<%=checklistTypeId %> ] = new Array();
sottoDomandePerCapitolo[<%=checklistTypeId %> ] = new Array();

</script>
  <tr class="containerBody">
    <th colspan="7" style="background-color: #ccff99; padding: 5px;"><%= checklistDescription%></th>
  </tr>
  <tr class="containerBody">
    <th>&nbsp;</th>
    <th width="50%">Domanda</th>
    <th width="50%">Ulteriore quesito in caso di risposta affermativa</th>
    <th>Modalit� di controllo</th>
    <th>SI</th>
    <th>NO</th>
    <th>Punti</th>
  </tr>
  
   
<%
// abilitato indica se il capitolo salvato � stato risposto o no 

if(abilitato == false)
{
	
	  %>
	  <script>
	  capitolidadisabilitare[<%=numcapitolodisabilitati %>] = <%=checklistTypeId%>
	  progressiviCapitoli[<%=numcapitolodisabilitati %>] = <%=progressivoCapitolo%>
	
	  </script>
	  
	  <%		
	  numcapitolodisabilitati+=1;
	  
	 
}

		  
		  if(thisTypeList.isDisabilitabile()==true)
		  {
			  %>
			  
			  <tr  class="row4" id = "">
  
  <td width="50%" colspan="4" align="center">  QUESTO CAPITOLO DEVE ESSERE COMPILATO ?</td>
  
  <td align="center"><input type="radio" id ="risposta<%=checklistTypeId%>1" <%if(abilitato == true){%>checked="checked" <%} %> value ="1" class='domandaCapitolo' name = "disabilita<%=checklistTypeId%>1" onclick="disabilitaCapitolo('<%=checklistTypeId %>','si',<%=i %>,'<%=progressivoCapitolo %>')"/></td> 
	     <td align="center">
  	 	<input	type="radio" value = "2" id ="risposta<%=checklistTypeId%>2" <%if(abilitato == false){%>checked="checked" <%} %> class='domandaCapitolo' name = "disabilita<%=checklistTypeId%>1" onclick="disabilitaCapitolo('<%=checklistTypeId %>','no',<%=i %>,'<%=progressivoCapitolo %>')" />
  	 			
  	 </td>
  <td>&nbsp;</td>
</tr>
			  
			  <%
			  
		  }
		  else
		  {
			  %>
			  <input type = "hidden" id ="risposta<%=checklistTypeId %>1" class='domandaCapitolo' name = "disabilita<%=checklistTypeId %>1" value ="3">
			  <%
		  }
		

%>
<input type="hidden" name="isDisabilitabile" id="isDisabilitabile<%=checklistTypeId %>" value="<%=thisTypeList.isDisabilitabile() %>">

<input type="hidden" name="idLastDomanda" id="last" value="<%=Audit.getIdLastDomanda() %>">

  <%
  Iterator itrChecklist = checklist.iterator();
  if ( itrChecklist.hasNext() ) {
		
	String descrizione=null;
    String level = null;
    int rowid = 0;
    int rowid2 = 5;
    int rowidcurr = 0 ;
    String last_gp = "" ;
    int numDomanda =0;
    
    while (itrChecklist.hasNext()) {
    	i++; 
      rowid = (rowid != 1?1:2);
      CustomLookupElement thisChecklist = (CustomLookupElement) itrChecklist.next();
      boolean enabled = thisChecklist.getValue("enabled") == "true" ? true : false;
      boolean defaultItem = thisChecklist.getValue("default_item") == "true" ? true : false;
      String id = thisChecklist.getValue("id");
      String grandParentId = thisChecklist.getValue("grand_parents_id");
      String super_domanda = thisChecklist.getValue("super_domanda");
      String parentId = thisChecklist.getValue("parent_id");
      String domanda = thisChecklist.getValue("domanda");
      descrizione = thisChecklist.getValue("descrizione");
      String puntiNo = thisChecklist.getValue("punti_no");
      String puntiSi = thisChecklist.getValue("punti_si");
      level = thisChecklist.getValue("level");
      int code = id.startsWith("--") ? -1 : Integer.parseInt(id);
      //Iterator auditCkList=auditChecklist.iterator();
      //Iterator auditCkListType=auditChecklistType.iterator();
      
     
      
    boolean risposto	= false;
    Boolean risposta	= false;
    int punti			= 0;
   	String stato = "" ;
	AuditChecklist audiCkListTemp	= null;
	Iterator array					= auditChecklist.iterator();
	while( array.hasNext() && !risposto )
	{ 
		audiCkListTemp = (AuditChecklist)array.next();
		risposto = ( Integer.parseInt(id) == audiCkListTemp.getChecklistId() );
	}
	
	if( risposto )
	{
		
		risposta	= audiCkListTemp.getRisposta();
		code		= id.startsWith("--") ? -1 : Integer.parseInt(id);
		punti		= audiCkListTemp.getPunti();
		stato = audiCkListTemp.getStato();
	}
	
	scriptDichiar 	+= "rispostaList["+id+"]="+risposta+";";
	  scriptDichiar += "grandParentIdList["+id+"]="+grandParentId+";";
	  scriptDichiar += "parentIdList["+id+"]="+parentId+";";
      scriptDichiar += "idList[\""+ (domandaElementId++) +"\"] = " + code + ";";
      scriptDichiar += "aggiornaListElementModify3("+code+","+parentId+","+grandParentId+"," + ( (!stato.equalsIgnoreCase("non risposta"))?(risposto) ? ( (risposta) ? (puntiSi) : (puntiNo) ) : ("0") : "0" ) + ",'" + ((stato.equalsIgnoreCase("risposta"))?(risposto) ? ( (risposta) ? ("si") : ("no") ) : (""):("") ) + "','"+stato+"');";
      scriptFunc += "function func"+code+"(risp){";
      scriptFunc += "  if(risp == 'si') {";
      scriptFunc += "    document.getElementById(\"punti"+code+"\").value = " + puntiSi + ";";
      scriptFunc += "    aggiornaListElement2("+code+","+parentId+","+grandParentId+","+puntiSi+",risp,"+puntiNo+");";
      scriptFunc += "  }";
      scriptFunc += "  if(risp == 'no') {";
      scriptFunc += "    document.getElementById(\"punti"+code+"\").value = " + puntiNo + ";";
      scriptFunc += "    aggiornaListElement2("+code+","+parentId+","+grandParentId+","+puntiNo+",risp,"+puntiSi+");";
      scriptFunc += "  }";
      scriptFunc += "}";
      %>
      <script>
           
           <%if(parentId.equals("-1"))
       {
       %>
      

       	domandePerCapitolo[<%=checklistTypeId %> ][<%=numDomanda%> ]  = <%=code%>;
     <%

           }
       else
       {
     %>
     	
       	sottoDomandePerCapitolo[<%=checklistTypeId %> ][<%=numDomanda%> ]  = <%=code%>;
     <%
           }
           
           %>
          
           </script>
           <%
      
      
      
           if ((!grandParentId.equals("-1") && !grandParentId.equals(last_gp) ) )
           {
          	 
          	 if (rowid2==5)
          		 rowid2 = 6;
          	 else
          		 rowid2 = 5;
          	 rowidcurr = rowid2;
          	 last_gp = grandParentId ;
           }
           else
            if (parentId != null && !parentId.equals("-1") && grandParentId.equals("-1")) { 
              rowid = (rowid != 1?1:2);
              rowidcurr = rowid;
            } else {
          	  if (grandParentId.equals("-1"))
          	  {
          		  if(super_domanda!=null && super_domanda.equalsIgnoreCase("true")){
          			  if (rowid2==5)
          				  rowidcurr = 6;
          		    	 else
          		    		 rowidcurr = 5;
          		  }
          		  else
          		  {
          		  //rowid = (rowid != 1?1:2);
          	        rowidcurr =rowid;
          		  }
          	  }
            }
     
      
     
     
      auditCkList=auditChecklist.iterator();
      
     
        		  
        		  %>
        		  
        		  <%
        		  
        	
        		  %>
        		  
        		   <tr class="row<%= rowidcurr %>" id="<%=i %>">
	    <td valign="center"><%= level %></td>
  <%if (parentId == null || parentId.equals("-1")) {%>
        <td valign="center" <%if(super_domanda!=null && super_domanda.equalsIgnoreCase("true")){%>colspan="2"<%} %>><%= toHtml(domanda) %></td>
    	<%if(super_domanda ==null || super_domanda.equalsIgnoreCase("false")){%>
        <td>&nbsp;</td>
        <%} %>    
	
  <%} else {%>
        <td>&nbsp;</td><td valign="center"><%= toHtml(domanda) %></td>
  <%}%>
        <td valign="center"><%= toHtml(descrizione) %></td>
        
	       	        
        	  <%//}
        	  
        	String siChecked="";
         	String noChecked="";
         	
          scriptFunc += "function func2"+code+"(risp){";
  	      scriptFunc += "  if(risp == 'si') {";
  	      scriptFunc += "    document.getElementById(\"punti"+code+"\").value = " + puntiSi + ";";
  	      scriptFunc += "    aggiornaListElement2("+code+","+parentId+","+grandParentId+","+puntiSi+",risp,"+puntiNo+");";
  	      scriptFunc += "  }";
  	      scriptFunc += "  if(risp == 'no') {";
  	      scriptFunc += "    document.getElementById(\"punti"+code+"\").value = " + puntiNo + ";";
  	      scriptFunc += "    aggiornaListElement2("+code+","+parentId+","+grandParentId+","+puntiNo+",risp,"+puntiSi+");";
  	      scriptFunc += "  }";
  	      scriptFunc += "}"; 

     %>
     
     <%
     
     
     %>
     
     
     
    	 <td align="center">
    	 	<input	type="radio"
    	 			id="risposta<%= code%>1"
    	 			name="risposta<%= code%>"
    	 			value="1"
    	 			onclick="javascript:func<%= code%>('si'); lastDomanda(<%=i %>,<%=rowid %>);"
    	 			<%=(! stato.equalsIgnoreCase("non risposta"))?(risposto && risposta) ? ("checked=\"checked\"") : (""):("") %> />
    	 </td>
    	 
    	 <td align="center">
    	 	<input	type="radio"
    	 			id="risposta<%= code%>2"
    	 			name="risposta<%= code%>" 
    	 		
    	 			value="0"
    	 			onclick="javascript:func<%= code%>('no'); lastDomanda(<%=i %>,<%=rowid %>);"
    	 			<%=(! stato.equalsIgnoreCase("non risposta"))?(risposto && !risposta) ? ("checked=\"checked\"") : (""):("") %>/>
    	 </td>
    	 
         <td align="center"><%if(puntiNo.equals(puntiSi) && puntiNo.equals("0")){ %>&nbsp; <input style="width: 30px; background-color: #cccccc"  type="hidden" id="punti<%= code%>" name="punti<%= code%>" /><%}else{ %><input style="width: 30px; background-color: #cccccc" readonly type="text" id="punti<%= code%>" name="punti<%= code%>" value = "<%=punti %>" /> <%} %></td>  
	   
  	 </tr>
 <%
 numDomanda++;  	
  %>    
<%}//}//}}fine ciclo secondo while
%> 
<%
String nota = "";
String add="";
String sub="";
String operazione= "";
String numero="";
if(auditCkListType.hasNext())
{
	
	AuditChecklistType act=(AuditChecklistType)auditCkListType.next();
	operazione=act.getOperazione();
	if(operazione.equals("+")||operazione.equals("-"))
	{	
		nota=act.getNota();
		numero=Integer.toString(act.getValoreRange());
		String oper = act.getOperazione(); 
		String nt = act.getNota();
		//scriptDichiar += "\naggiornaChecklistType(" + indexChecklistList + ",'x','" + numero + "','');";
		scriptDichiar += "\naggiornaChecklistType(" + indexChecklistList + ",'"+oper+"','" + numero + "','');";
	}
}
if(operazione!=null)
{
	String color2= null;
	String color = null;
	if(operazione.equals("+"))
		add="checked";
	    
	if(operazione.equals("-"))
		sub="checked";
	    
	
} %>


<%if(indexChecklistList != typeList.size())  {%>

<tr class="row<%= rowid+1%>">
  <td><%= Integer.parseInt(level)+1%></td>
    <td colspan="3"><30 rischio basso - tra 30 e 42 rischio medio - > 42 rischio elevato</td>
  <td>
    <input type="button"  <%= (operazione.equals("+")? ("style='background:#66ff00'"): ("style = 'background:#ffffff'")) %> id="btnAggiungiPunti<%= indexChecklistList%>" value="+" onclick="javascript:aggiornaChecklistType(<%= indexChecklistList%>,'+',valoreRange<%= indexChecklistList%>.value, '',<%= checklistRange%>);" checked="<%= add %>" disabled="disabled" />
  </td>
  <td>
    <input type="button" <%= (operazione.equals("-")? ("style'background:#66ff00'"): ("style = 'background:#ffffff'")) %> id="btnSottraiPunti<%= indexChecklistList%>" value="-" onclick="javascript:aggiornaChecklistType(<%= indexChecklistList%>,'-',valoreRange<%= indexChecklistList%>.value, '',<%= checklistRange%>);" checked="<%= sub %>" disabled="disabled"/>
  </td>
  <td>
    <input type="text" style="width: 30px;" id="valoreRange<%= indexChecklistList%>"  name="valoreRange<%= checklistTypeId%>" value="<%= numero %>" onmouseout="abilitaPulsanti(<%= indexChecklistList%>)"/>
    <input type="hidden" id="operazione<%= indexChecklistList%>" name="operazione<%= indexChecklistList%>"/>
  </td>
</tr>

<%}  } else {%>
<tr class="containerBody">
<td colspan="7"><dhv:label name="">Nessuna domanda presente.</dhv:label></td>
</tr>
<%}%>


<%-- prova --%>
<% 
	int indice = 1 + indexChecklistList;%>

<%if((ControlloUfficiale.getNumeroAudit()==0 || ControlloUfficiale.getNumeroAudit()==1) && Audit.isPrincipale()==true){
	  
	  if((ControlloUfficiale.getTipoCampione()!=3)&&((checklistDescription.equalsIgnoreCase("CAPITOLO IX: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)"))||(checklistDescription.equals("CAPITOLO X: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)"))||(checklistDescription.equals("CAPITOLO VIII: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)")) ||(checklistDescription.equals("CAPITOLO IX:DATI STORICI")))){%>
	<tr >
	  <td colspan="1">&nbsp;</td>
	  <td colspan="3">Punteggio storico delle non conformit� (N.B. tale punteggio corrisponde alla somma dei punteggi delle non conformit� rilevate durante i controlli ufficiali degli ultimi 5 anni dalla data di oggi, ovviamente con l'esclusione dei punteggi delle check list compilate nell'ambito della sorveglianza).</br></td>
	  <td colspan="2">
	    <%--<input type="button" id="btnAggiungiPunti<%= indice%>" value="      +      " onclick="javascript:aggiornaTot(<%= indice%>, '+',punteggioUltimiAnni.value);"/>--%>
	  </td>
	  <td>
	    <input type="text" style="width: 80px; background-color: #cccccc" readonly id="punteggioUltimiAnni" name="punteggioUltimiAnni" value="<%=(Audit.isPrincipale())? Audit.getPunteggioUltimiAnni()+"" : "0"%>"/>
	    </td>
	</tr>

	<%} 
	}else{
	
		  if((ControlloUfficiale.getTipoCampione()!=3)&&((checklistDescription.equalsIgnoreCase("CAPITOLO IX: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)"))||(checklistDescription.equals("CAPITOLO X: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)"))||(checklistDescription.equals("CAPITOLO VIII: DATI STORICI (DA ESTRAPOLARE PREVENTIVAMENTE DALLA SCHEDA DELL'IMPRESA PRESENTE SUL SITO DELL'O.R.S.A.)")) ||(checklistDescription.equals("CAPITOLO IX:DATI STORICI")))){%>

	<tr>
	  <td colspan="1">&nbsp;</td>
	  <td colspan="3">Punteggio delle Check List gi� Compilate nello Stesso Controllo</br></td>
	  <td colspan="2">
	      </td>
	  <td>
	    <input type="text" style="width: 80px; background-color: #cccccc" readonly <%if (request.getAttribute("punteggioCheckList")!=null){ %> value="<%= request.getAttribute("punteggioCheckList") %><%} %>"/>
	    </td>
	</tr>

	<input type="hidden" style="width: 80px; background-color: #cccccc"  id="punteggioUltimiAnni" name="punteggioUltimiAnni" value="0"/>
	    
	<%} } } 

} else {%>
<tr class="containerBody">
<td colspan="7"><dhv:label name="">Nessuna Check List presente.</dhv:label></td>
</tr>
<%}%>


<%-- fine prova --%>


<tr class="containerBody" style="background-color: #ffff66; font-weight: bolder;">
  <td colspan="3">&nbsp;</td>
  <td nowrap>Punteggio Totale di Questa Check List</td>
  <%--if(Audit.getLivelloRischioFinale()== -1){ --%>
  <td colspan="3"><input style="width: 80px; background-color: #cccccc" type="text" readonly id="livelloRischio" name="livelloRischio" value="<%= Audit.getLivelloRischio() %>">
 <input type="hidden" id="livelloRischioFinale" name="livelloRischioFinale" value= "<%= Audit.getLivelloRischio() %>"/>
 
</tr>

<tr class="containerBody" style="background-color: #ffff66; font-weight: bolder;">
  <td colspan="3">&nbsp;</td>
  <td nowrap>Categoria Rischio con il nuovo punteggio</td>
  <td colspan="3"><input style="width: 80px; background-color: #cccccc" type="text" readonly id="categoriaRischio" name="categoriaRischio" value=""/>
  <%-- <input style="width: 80px; background-color: #cccccc" type="hidden" readonly id="livelloRischioFinale" name="livelloRischioFinale" value=<%= Audit.getLivelloRischioFinale() %>>--%>
  </td>
</tr>

</table>
<br />
<table cellpadding="4" cellspacing="0" border="0" width="100%" class="details">
  <tr>
    <th colspan="2">
	    <strong><dhv:label name="accounts.accounts_add.AdditionalDetails">Additional Details</dhv:label></strong>
	  </th>
  </tr>
  <tr class="containerBody">
    <td valign="top" nowrap class="formLabel">
      <dhv:label name="audit.note">Note</dhv:label>
    </td>
    <td>
      <TEXTAREA name="note" ROWS="3" COLS="50"><%= toHtml(Audit.getNote())%></TEXTAREA>
    </td>
  </tr>
</table>
<br/>

<!-- SALVATAGGIO CHECKLIST OFFLINE -->

<%
if (request.getAttribute("isSalvata")!=null)
{
	
	
	ControlloUfficiale.setActionChecklist();
	String isSalvata = (String)request.getAttribute("isSalvata") ;
	if (isSalvata.equals("true") )
	{

		
		%>
		<input type = "hidden" id = "path" value = "<%=ControlloUfficiale.getUrl_checklist()%>.do?command=Modify&aggiorna=true&idControllo=<%= Audit.getIdControllo()%>&idC=<%=TicketDetails.getId()%>&id=<%= Audit.getId() %>&orgId=<%= OrgDetails.getOrgId() %>">
		<%
	
	}
	else
	{
		%>
				<input type = "hidden"  id = "path" name = "path" value = "<%=ControlloUfficiale.getUrl_checklist()%>.do?command=Add&orgId=<%= OrgDetails.getOrgId() %>&idC=<%=TicketDetails.getId()%>&isPrincipale=false&idControllo=<%= Audit.getIdControllo()%>&accountSize=<%=Audit.getTipoChecklist() %>">
		
		
		<%
	}


}

%>

<input id = "btnSave2" type="button" value="Salva checklist">




<input type = "hidden" id = "idChecklist" value = "<%=Audit.getTipoChecklist() %>">
<input type="hidden" name="dosubmit" value="true" />
<input type="hidden" name="rowcount" value="0">
<input type="hidden" name="return" value="<%= request.getParameter("return") %>" />
<input type="hidden" name="idControllo" id = "idControllo" value="<%= Audit.getIdControllo()%>" />

<input type="hidden" name="id" id = "idAudit" value="<%= Audit.getId() %>" />
<input type="hidden" name="orgId" id = "orgId" value="<%= OrgDetails.getOrgId() %>" />
<script language="JavaScript">
<%= scriptDichiar %>
<%= scriptFunc %>


for(z=0; z<capitolidadisabilitare.length;z++)
{
	
	 disabilitaCapitolo(capitolidadisabilitare[z],'no',-1,progressiviCapitoli[z]);
}
//loadModalWindowUnlock() ;
</script>