<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.aspcfs.modules.util.imports.ApplicationProperties" %>


<%
  File file ;
  int maxFileSize = 5000 * 1024;
  int maxMemSize = 5000 * 1024;
  String filePath = ApplicationProperties.getProperty("FIRMA_UPLOAD_CARTELLA");

  String contentType = request.getContentType();
  if ((contentType.indexOf("multipart/form-data") >= 0)) {

     DiskFileItemFactory factory = new DiskFileItemFactory();
     factory.setSizeThreshold(maxMemSize);
     factory.setRepository(new File("c:\\temp"));
     ServletFileUpload upload = new ServletFileUpload(factory);
     upload.setSizeMax( maxFileSize );
     try{ 
        List fileItems = upload.parseRequest(request);
        Iterator i = fileItems.iterator();
        while ( i.hasNext () ) 
        {
           FileItem fi = (FileItem)i.next();
           if ( !fi.isFormField () )  {
               String fieldName = fi.getFieldName();
               String fileName = fi.getName();
               boolean isInMemory = fi.isInMemory();
               long sizeInBytes = fi.getSize();
               file = new File( filePath + fileName) ;
               fi.write( file ) ;
               System.out.println("Uploaded Filename: " + filePath + fileName + "<br>");
           }
        }
        }catch(Exception ex) {
        System.out.println(ex);
     }
  }else{
     out.println("Error in file upload.");
     
  }
%>