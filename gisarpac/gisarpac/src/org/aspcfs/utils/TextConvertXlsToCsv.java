package org.aspcfs.utils;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.util.Locale;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.WorkbookSettings;

public class TextConvertXlsToCsv {

	/**
	 * @param args
	 */

		public static void convert(File f_xls,String path_file_csv) 
		{
		    try
		    {
		      //File to store data in form of CSV
		      File f = new File(path_file_csv + File.separator + "input.csv");

		      OutputStream os = (OutputStream)new FileOutputStream(f);
		      String encoding = "UTF8";
		      OutputStreamWriter osw = new OutputStreamWriter(os, encoding);
		      BufferedWriter bw = new BufferedWriter(osw);

		      //Excel document to be imported
		     
		      WorkbookSettings ws = new WorkbookSettings();
		      ws.setLocale(new Locale("en", "EN"));
		      Workbook w = Workbook.getWorkbook(f_xls,ws);

		      // Gets the sheets from workbook
		      for (int sheet = 0; sheet < w.getNumberOfSheets(); sheet++)
		      {
		        Sheet s = w.getSheet(sheet);
		        Cell[] row = null;
		        
		        // Gets the cells from sheet
		        for (int i = 1 ; i < s.getRows() ; i++)
		        {
		          row = s.getRow(i);

		          if (row.length > 0)
		          {
		            bw.write(row[0].getContents());
		            for (int j = 1; j < row.length; j++)
		            {
		              bw.write(';');
		              bw.write(row[j].getContents());
		            }
		          }
		          bw.newLine();
		        }
		      }
		      bw.flush();
		      bw.close();
		    }
		    catch (UnsupportedEncodingException e)
		    {
		      System.err.println(e.toString());
		    }
		    catch (IOException e)
		    {
		      System.err.println(e.toString());
		    }
		    catch (Exception e)
		    {
		      System.err.println(e.toString());
		    }
		  }

	

}
