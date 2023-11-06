function controllaTipoAnaliti(n_v){
	var flag = 0;
	var numA = document.getElementById("numeroAnaliti").value;
	var str = "";
	
	//controllo tra num verbale ed analiti	 
	if (numA>0){
		if (n_v.match("vpb$") ){ //BATTERIOLOGICO
			for(i=1;i<=numA;i++){
				str = document.getElementById("An"+i).textContent;
				if(str.match('BATTERIOLOGICO')){ 
					flag=1;
				}
			}
		} else {
			if (n_v.match("vpc$") ){ //CHIMICO
				for(i=1;i<=numA;i++){
					str = document.getElementById("An"+i).textContent;
					if(str.match('CHIMICO')){ 
						flag=1;
					}
				}
			}
		} 
	} else {
		flag=1;
	}
	return flag;
}