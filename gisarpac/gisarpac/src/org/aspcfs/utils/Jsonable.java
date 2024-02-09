package org.aspcfs.utils;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public abstract class Jsonable {
	public abstract JSONObject toJsonObject();
	public abstract String toJsonString();

	@Override
	public String toString() {
		return toJsonString();
	}
	
	public static String getListAsJsonArrayString(List toTransform)
	{
		JSONArray toRet = new JSONArray();
		for(Object o : toTransform)
		{
			toRet.put(((Jsonable)o).toJsonObject());
		}
		return toRet.toString();
	}
	
	public static String sanityString(String s)
	{
		if(s != null )
			return s.replace("'", " ");
		
		return s;
	}
}
