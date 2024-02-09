/*
 *  Copyright(c) 2004 Concursive Corporation (http://www.concursive.com/) All
 *  rights reserved. This material cannot be distributed without written
 *  permission from Concursive Corporation. Permission to use, copy, and modify
 *  this material for internal use is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies. CONCURSIVE
 *  CORPORATION MAKES NO REPRESENTATIONS AND EXTENDS NO WARRANTIES, EXPRESS OR
 *  IMPLIED, WITH RESPECT TO THE SOFTWARE, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY PARTICULAR
 *  PURPOSE, AND THE WARRANTY AGAINST INFRINGEMENT OF PATENTS OR OTHER
 *  INTELLECTUAL PROPERTY RIGHTS. THE SOFTWARE IS PROVIDED "AS IS", AND IN NO
 *  EVENT SHALL CONCURSIVE CORPORATION OR ANY OF ITS AFFILIATES BE LIABLE FOR
 *  ANY DAMAGES, INCLUDING ANY LOST PROFITS OR OTHER INCIDENTAL OR CONSEQUENTIAL
 *  DAMAGES RELATING TO THE SOFTWARE.
 */
package org.aspcfs.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.zip.ZipFile;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;


/**
 * Description of the Class
 *
 * @author     matt rajkowski
 * @version    $Id: ZipUtils.java 12404 2005-08-05 13:37:07 -0400 (Fri, 05 Aug
 *      2005) mrajkowski $
 * @created    January 15, 2003
 */
public class ZipUtils {

  /**
   * Adds a feature to the TextEntry attribute of the ZipUtils class
   *
   * @param  zip            The feature to be added to the TextEntry attribute
   * @param  fileName       The feature to be added to the TextEntry attribute
   * @param  data           The feature to be added to the TextEntry attribute
   * @throws  ZipException  Description of the Exception
   * @throws  IOException   Description of the Exception
   */
  public static void addTextEntry(ZipOutputStream zip, String fileName, String data) throws ZipException, IOException {
    int bytesRead;
    StringReader file = new StringReader(data);
    ZipEntry entry = new ZipEntry(fileName);
    zip.putNextEntry(entry);
    while ((bytesRead = file.read()) != -1) {
      zip.write(bytesRead);
    }
  }


  /**
   * Description of the Method
   *
   * @param  zipFile          Description of the Parameter
   * @param  destination      Description of the Parameter
   * @exception  IOException  Description of the Exception
   */
  public static void extract(File zipFile, String destination) throws IOException {
    ZipInputStream zip = new ZipInputStream(new FileInputStream(zipFile));
    ZipEntry entry = null;
    byte[] buffer = new byte[1024];
    while ((entry = zip.getNextEntry()) != null) {
      if (entry.isDirectory()) {
        File directory = new File(destination + entry.getName());
        directory.mkdirs();
      } else {
        FileOutputStream file = new FileOutputStream(
            destination + entry.getName());
        int count;
        while ((count = zip.read(buffer)) != -1) {
          file.write(buffer, 0, count);
        }
        file.close();
      }
    }
    zip.close();
  }


  /**
   * Extracts the specified zipped file to a destination in the filesystem
   *
   * @param  zipFile          Description of the Parameter
   * @param  entry            Description of the Parameter
   * @param  destination      Description of the Parameter
   * @exception  IOException  Description of the Exception
   */
  public static void extract(ZipFile zipFile, String entry, String destination) throws IOException {
    ZipEntry zipEntry = zipFile.getEntry(entry);
    if (zipEntry == null) {
      zipEntry = zipFile.getEntry(StringUtils.replace(entry, "/", "\\"));
    }
    if (zipEntry == null) {
      zipEntry = zipFile.getEntry(StringUtils.replace(entry, "\\", "/"));
    }
    InputStream inputStream = zipFile.getInputStream(zipEntry);
    byte[] buffer = new byte[inputStream.available()];
    if (zipEntry != null) {
      if (zipEntry.isDirectory()) {
        //do nothing
      } else {
        int offset = 0;
        int numRead = 0;
        while (offset < buffer.length
            && (numRead = inputStream.read(buffer, offset, buffer.length - offset)) >= 0) {
          offset += numRead;
        }
        FileUtils.copyBytesToFile(buffer, new File(destination), true);
      }
    }
    inputStream.close();
  }


  /**
   *  Description of the Method
   *
   * @param  inputFile        Description of the Parameter
   * @param  zipFile          Description of the Parameter
   * @exception  IOException  Description of the Exception
   */
  public static void compress(String inputFile, File zipFile) throws IOException {
    ZipUtils.compress(inputFile, zipFile, inputFile);
  }
  
  /**
   *  Description of the Method
   *
   * @param  inputFile        Description of the Parameter
   * @param  zipFile          Description of the Parameter
   * @param  entryName        Zip entry name
   * @exception  IOException  Description of the Exception
   */
  public static void compress(String inputFile, File zipFile, String entryName) throws IOException {
    byte[] buffer = new byte[1024];

    ZipOutputStream zip = new ZipOutputStream(new FileOutputStream(zipFile));
    FileInputStream fin = new FileInputStream(inputFile);

    zip.putNextEntry(new ZipEntry(entryName));

    int len = -1;
    while ((len = fin.read(buffer)) > 0) {
      zip.write(buffer, 0, len);
    }

    zip.closeEntry();
    fin.close();
    zip.close();
  }
}

