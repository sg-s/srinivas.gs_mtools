function [Result]=xlwrite(file,data,sheet)
%% Function xlwrite provides almost the same functionality as the function
% xlswrite, non-accessible from MAC Matlab. It writes numeric or cell data to excel. 
% Syntax is the same as for xlswrite, additional
% Java packages need to be loaded in java path : jxl.jar, MXL.jar and
% matlabcontrol-3.1.0.jar.
%  
% Function handles input and transmits
% data to Java methods in order to write to excel files. Pay attention to sheet name,
% it shouldn't be the same as any other in the excel workbook.
%
% Data is written as text (Label) and a simple click in Excel (Convert to
% number) will solve the issue of numbers seen as a text. 
% For further information, please check Documentation of package MXL Java Classes. 
% 
% Input (3): 
%
%    - filename (char)
%    - data (cell or numerical, up to 3-dimensionnal array) 
%    - sheet name *optional* (char)
%
% Output (1) :
%
%    - Result code, 1 if successful, 0 otherwise
%
% Function calls : WriteXL (JAVA method from package MXL.jar ),
% Cell2JavaString
% 
% See also Cell2JavaString
%
%  Copyright 2012 AAAiC 
%  Date: 2012/04/10

%% INPUT HANDLING

import mymxl.*;
import jxl.*;

Result=0;

if nargin < 3
    
    %% use Contructor with no Sheet
    
 % Convert Type of data : 
    
   
    if isnumeric(data) 
        
        data=num2cell(data);
    
    elseif iscell(data)
    
        datacell=1;
    
    else error('Data to write must be cell or numeric type. Please try again...')    
        
        datacell=0;
    
    end   
    
    % Size of the matrix data
    
    m=size(data);
    
    if (max(size(m))==2)
        
        WriteXL(java.lang.String(file),Cell2JavaString(data),m(1),m(2));
        Result=1;
    
    elseif (max(size(m))==3)
        
        WriteXL(java.lang.String(file),Cell2JavaString(data),m(1),m(2),m(3));
        Result=1;
    else
        error('data Matrix too large, must have at most 3 dimensions');
    end
    
    
elseif nargin == 3
    
    %% use Constructor with Sheet name
    
        
 % Type of data
    
   
    if isnumeric(data) 
        
        data=num2cell(data);
    
    elseif iscell(data)
    
        datacell=1;
    
    else error('Data to write must be cell or numeric type. Please try again...')    
        
        datacell=0;
    
    end   
    
    % Size of the matrix data
    
    m=size(data);
    
    if (max(size(m))==2)
        
        WriteXL(java.lang.String(file),Cell2JavaString(data),m(1),m(2),java.lang.String(sheet),exist(file,'file')/2);
        Result=1;
    else
        error('data Matrix too large, when specifying a single sheet, data must have at most 2 dimensions');
    end
    
    
    
else 
    error('Bad number of arguments');
    
    
end

end