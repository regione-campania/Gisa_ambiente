<%@ page import="org.json.*" %>

<%!
private String createTableFromJson(String json) throws ParseException{
	String output = "";
	String jsonString = "["+json.replaceAll("<br/><br/>", ",")+"]";
	HashMap<Integer, String> hash = new HashMap<Integer, String>();
	Map<Integer, String> treeMap = null;
	JSONArray topArray = new JSONArray(jsonString); 
	
	ArrayList<String> headers = new ArrayList<String>();
	ArrayList<String> body = new ArrayList<String>();
		
	for(int i = 0; i < topArray.length(); i++){
		JSONObject c = topArray.getJSONObject(i);

		if (treeMap==null){
		for (int j = 0; j<c.names().length();j++){
			int index = jsonString.indexOf(c.names().getString(j));
			hash.put(index, c.names().getString(j));
		}
		treeMap = new TreeMap<Integer, String>(hash);
		}
		
		
		
		for(int k = 0; k<treeMap.size(); k++){
			int key = (int) treeMap.keySet().toArray()[k];
			String nome = treeMap.get(key); 
			String value = (String) c.get(nome);
			if (nome.equals("info")){
				if (!headers.contains(value))
					headers.add(value);
			}
			else if (nome.equals("valore"))
				body.add(value);
		} 
	}
	
	output= "<table style=\"border-collapse: collapse\" border=\"1px solid black\" >";
	
	//headers
	output+="<tr>";
	for (int i = 0; i<headers.size(); i++)
		output+= "<th>"+headers.get(i)+"</th>";
	output+="</tr>";
	
	//corpo
	int indiceCol = 0;
	output+="<tr>";
	for (int i = 0; i<body.size(); i++) {
		indiceCol++;
		output+= "<td>"+body.get(i)+"</td>";
		
		if (i==(body.size()-1))
			output+="</tr>";
		else if (indiceCol == headers.size()){
			indiceCol = 0;
			output+="</tr><tr>";
		}
	}
	
	output+="</table>";
	return output;
}
%>

