package com.aspcfs.crono;

public class Crono {
	
	long time = -1;
	public Crono()
	{
		this.time = System.currentTimeMillis();
	}
	
	public String stopString(String msg)
	{
		return msg+", tempo: "+(System.currentTimeMillis() - time);
	}
	public void stopPrint(String msg)
	{
		msg = msg +", tempo: "+(System.currentTimeMillis() - time);
		System.out.println(msg);
	}
}
