/*
 * WriteXL is capable of writing excel files
 */
package mymxl;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.IOException;
 
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.logging.Level;
import java.util.logging.Logger;
 
import jxl.read.biff.BiffException;
import jxl.write.*;
import jxl.write.biff.*;

import jxl.Workbook;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;


import java.io.File; 
import java.util.Date; 
import jxl.*; 
import jxl.CellView;
import jxl.Workbook;
import jxl.WorkbookSettings;
import jxl.format.UnderlineStyle;
import jxl.write.Formula;
import jxl.write.Label;
import jxl.write.Number;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;


/**
 *
 * @author Marin Deresco (AAAiC)
 */
public class WriteXL {
    public static String file;
    private WritableCellFormat timesBoldUnderline;
	private WritableCellFormat times;
	private String inputFile;
        String JavaGlob1;
        Label label1;
        Number number1;
        WritableSheet  excelSheet;
        Workbook excelWorkbook;
        WritableSheet [] excelSheet3D;
    
    // CONSTRUCTOR INPUT : FILE LOCATION XLS, Java Array of Strings converted in Matlab, Sheet,  dimension 1, dimension 2, Starting Position
        
        
        // 2 OPTIONAL CONTSTRUCTORS TO CODE
//public WriteXL(String file,String[][] JavaGlob,int dim1, int dim2, String Sheet, int[][] StartPosition) throws WriteException {}
//public WriteXL(String file, String[][] JavaGlob, int dim1, int dim2, int[][] StartPosition) throws WriteException 



public WriteXL(String file, String[][] JavaGlob, int dim1, int dim2, String Sheet, int FileExists) throws WriteException, BiffException 
{
try {
            //Workbook workbook=new Workbook();
            //excelSheet=new WritableSheet[0];
            // SHEET CHECK, DON'T ERASE PREVIOUS FILE IF SHEET SPECIFIED, ERASE IT OTHERWISE
            
    
    if (FileExists==1)
    {
        excelWorkbook=Workbook.getWorkbook(new File(file));
        WritableWorkbook w = Workbook.createWorkbook(new File(file),excelWorkbook);
         int NumberSheets=w.getNumberOfSheets();
        w.createSheet(Sheet,  NumberSheets);
                
         excelSheet = w.getSheet(NumberSheets);//w.getNumberOfSheets()-1); 
           
                        for(int i=0; i<dim1; i++)
                        {
                        for(int j=0; j<dim2; j++)
                        {
                         label1=new Label(j,i,JavaGlob[i][j]); 
                         excelSheet.addCell(label1);
                        }
                        }
           
            
            w.write();
            w.close();        
        
        
    }
        
        else
    {   // New File     
           
    
    // if not FileExists
    //else
   // Workbook w = Workbook.getWorkbook() 
        WritableWorkbook w = Workbook.createWorkbook(new File(file));
           
            w.createSheet(Sheet, 0);
            
           excelSheet = w.getSheet(0); 
           
                        for(int i=0; i<dim1; i++)
                        {
                        for(int j=0; j<dim2; j++)
                        {
                         label1=new Label(j,i,JavaGlob[i][j]); 
                         excelSheet.addCell(label1);
                        }
                        }
           
            
            w.write();
            w.close();    
      
    }              
             }
        
        catch (IOException ex) 
            
            {
            Logger.getLogger(WriteXL.class.getName()).log(Level.SEVERE, null, ex);
            }

}




public WriteXL(String file, String[][] JavaGlob, int dim1, int dim2) throws WriteException 
{
  
        
        try {
            //Workbook workbook=new Workbook();
            //excelSheet=new WritableSheet[0];
            
            
            WritableWorkbook w = Workbook.createWorkbook(new File(file));
           
            w.createSheet("MATLAB", 0);
           excelSheet = w.getSheet(0); 
                        for(int i=0; i<dim1; i++)
                        {
                        for(int j=0; j<dim2; j++)
                        {
                         label1=new Label(j,i,JavaGlob[i][j]); 
                         excelSheet.addCell(label1);
                        }
                        }
           
            
            w.write();
            w.close();    
           
             }
        
        catch (IOException ex) 
            
            {
            Logger.getLogger(WriteXL.class.getName()).log(Level.SEVERE, null, ex);
            }


}
public WriteXL(String file, String[][][] JavaGlob, int dim1, int dim2, int dim3) throws WriteException 
{
  
        
        try {
            //Workbook workbook=new Workbook();
          excelSheet3D=new WritableSheet[dim3];
            
            WritableWorkbook w = Workbook.createWorkbook(new File(file));
            
            for (int k=0;k<dim3;k++)

            {
                      
                       w.createSheet("dimension="+(k+1), k);
                       excelSheet3D[k] = w.getSheet(k); 

                       for(int i=0; i<dim1; i++)
                           
                       {
                                    for(int j=0; j<dim2; j++)
                                    {
                                     label1=new Label(j,i,JavaGlob[i][j][k]); 
                                     excelSheet3D[k].addCell(label1);
                                    }
                        }
            }
            
            
            
        
            
            w.write();
            w.close();    
           
             }
        
        catch (IOException ex) 
            
            {
            Logger.getLogger(WriteXL.class.getName()).log(Level.SEVERE, null, ex);
            }


}

	
}
