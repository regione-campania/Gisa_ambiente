package org.aspcfs.modules.vigilanza.base;

import java.io.IOException;
import java.util.HashMap;

import org.apache.xerces.parsers.DOMParser;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class RuoliUtentiParser {
	
	public static HashMap<String,Integer> getListaServiziVeterinari() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_VETERINARI"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	public static HashMap<String,Integer> getListaReferenteAllerte() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_REFERENTE_ALLERTE_ASL"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	public static HashMap<String,Integer> getListaAministrativiAsl() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_AMMINISTRATIVI_ASL"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	
	public static HashMap<String,Integer>  getListaMedici() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_MEDICI"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	
	public static HashMap<String,Integer>  getListaCriuv() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_CRIWV"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	public static HashMap<String,Integer>  getListaReferentiAllerteAsl() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_REFERENTI_ALLERTE_ASL"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	public static HashMap<String,Integer>  getListaAmministrativiAsl() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_AMMINISTRATIVI_ASL"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	}
	
	public static HashMap<String,Integer>  getListaNurecu() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_NURECU"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	   
	}
	
	public static HashMap<String,Integer>  getListaTpal() {

		HashMap<String,Integer> lista = new HashMap<String, Integer>();
		DOMParser parser = new DOMParser();
		try 
		{
			parser.parse(RuoliUtentiParser.class.getResource( "RuoliNucleoIspettivo.xml" ).getPath());
		} catch (SAXException s)
		{
			s.printStackTrace();
		} catch (IOException i) {
			i.printStackTrace();
		}

		Document doc =  parser.getDocument();
		Element E = doc.getDocumentElement();
		NodeList d = E.getChildNodes();
		for (int y = 0; y<d.getLength(); y++)
		{
			if (d.item(y).getNodeName().equals("LISTA_TPAL"))
			{
				NodeList dd = d.item(y).getChildNodes();
				for (int x = 0; x<dd.getLength(); x++)
				{
					if (!dd.item(x).getTextContent().trim().equals(""))
					{
						lista.put(dd.item(x).getAttributes().item(0).getTextContent(), Integer.parseInt(dd.item(x).getTextContent()));

					}
				}
			}

		}
		return lista;
	   
	}
	
	public static void main(String arg[])
	{
		getListaReferentiAllerteAsl();
	}

}
