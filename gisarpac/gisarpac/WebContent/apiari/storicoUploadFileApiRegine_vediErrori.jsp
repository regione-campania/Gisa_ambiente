<%
	String erroreInsert = (String)request.getAttribute("erroreInsert");
	String erroreParsingFile = (String)request.getAttribute("erroreParsingFile");
	String errori = (erroreInsert!=null && !erroreInsert.equals("")) ? ("Log inserimenti: " + erroreInsert + "<br/>") : "";
	String errori2 = (erroreParsingFile!=null && !erroreParsingFile.equals("")) ? ("Log File: " + erroreParsingFile) : "";
	errori+=errori2;
	out.println(errori);
%>