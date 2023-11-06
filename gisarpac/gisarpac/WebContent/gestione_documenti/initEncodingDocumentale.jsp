  <%! public static String fixEncoding(String parola)
  {
	
	  if (parola==null)
	  return "" ;
		parola = parola.replaceAll("à", "a'");
		parola = parola.replaceAll("è", "e'");
		parola = parola.replaceAll("ì", "i'");
		parola = parola.replaceAll("ò", "o'");
		parola = parola.replaceAll("ù", "u'");
		
		parola=parola.replaceAll("À", "A'");
		parola=parola.replaceAll("È", "E'");
		parola=parola.replaceAll("Ì", "I'");
		parola=parola.replaceAll("Ò", "O'");
		parola=parola.replaceAll("Ù", "U'");
		
		parola=parola.replaceAll("Á", "A'");
		parola=parola.replaceAll("É", "E'");
		parola=parola.replaceAll("í", "I'");
		parola=parola.replaceAll("Ó", "O'");
		parola=parola.replaceAll("Ú", "U'");
			
		
		return parola;
	  
  }%>