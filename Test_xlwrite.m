%% Test script for excel write (xlwrite in OS X)


 javaaddpath('jxl.jar');
 javaaddpath('MXL.jar');

 import mymxl.*;
 import jxl.*;   

 mat1=randn(20,150,5);
 
 xlwrite('mat1_excel.xls',mat1)