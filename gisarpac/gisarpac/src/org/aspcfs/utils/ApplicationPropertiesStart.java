package org.aspcfs.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Iterator;
import java.util.Properties;
import java.util.logging.Logger;

public class ApplicationPropertiesStart {
        
        private static Properties applicationProperties = null;
        private transient static Logger logger = Logger.getLogger("MainLogger");
        //costruttore
        public ApplicationPropertiesStart() { }
        

        public static String getProperty ( String property ){
                return ( applicationProperties != null) ? applicationProperties.getProperty( property ) : null;
        }
        public static Iterator<Object> getKeySet (){
            if (applicationProperties != null)
				return applicationProperties.keySet().iterator();
			else
				return null;
    }
        
public ApplicationPropertiesStart(String nomeFile) {
                
                InputStream is = ApplicationPropertiesStart.class.getResourceAsStream( nomeFile);
                applicationProperties = new Properties();
                try{
                        applicationProperties.load( is );
                }catch(IOException e) {
                          logger.severe("[] - EXCEPTION nella classe ApplicationProperties");
                        applicationProperties = null;
                }
                
                
        }
        
        
}