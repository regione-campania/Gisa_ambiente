  <%! public static String fixEncoding(String parola)
  {
	
	  if (parola==null)
	  return "" ;
		parola = parola.replaceAll("�", "a'");
		parola = parola.replaceAll("�", "e'");
		parola = parola.replaceAll("�", "i'");
		parola = parola.replaceAll("�", "o'");
		parola = parola.replaceAll("�", "u'");
		
		parola=parola.replaceAll("�", "A'");
		parola=parola.replaceAll("�", "E'");
		parola=parola.replaceAll("�", "I'");
		parola=parola.replaceAll("�", "O'");
		parola=parola.replaceAll("�", "U'");
		
		parola=parola.replaceAll("�", "A'");
		parola=parola.replaceAll("�", "E'");
		parola=parola.replaceAll("�", "I'");
		parola=parola.replaceAll("�", "O'");
		parola=parola.replaceAll("�", "U'");
			
		
		return parola;
	  
  }%>