package org.aspcfs.utils;

public class MethodsUtils {
	
	
	public static String getNomeMetodo(Thread t){
		final StackTraceElement[] ste = t.getStackTrace();

		 return  (ste[4].toString().contains("GestoreConnessioni")) ?  ste[5].toString() : ste[4].toString();	}

}
