package org.aspcfs.utils;

import java.util.StringTokenizer;

public class Utils {
	public static String[] tokenizerToArray(String stringToTokenize, String delimitator){
		StringTokenizer st = new StringTokenizer(stringToTokenize, delimitator);
		String[] array = new String[st.countTokens()]; 
		
		int i = 0;
		while(st.hasMoreTokens()){
			  String s=st.nextToken();
			  array[i] = s;
			  i++;
		}
		return array;
	} 
}
