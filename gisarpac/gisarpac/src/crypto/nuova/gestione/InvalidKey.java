package crypto.nuova.gestione;

public class InvalidKey extends Exception{
	 
	
	public InvalidKey(){}
	public InvalidKey(String msg)
	{
		super(msg);
	}
}
