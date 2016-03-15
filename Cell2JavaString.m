function[JavaString]=Cell2JavaString(Glob)
%% Function Cell2JavaString converts  a cell array to a Java String array
% Input (1): 
%
%    - Glob (cell, up to 3-dimensions)
%
% Output (1) :
%
%    - Java String Array of Glob
%
% Function calls : javaArray (JAVA method)
%
% Called by : xlwrite.m
% 
% See also xlwrite
%
%  Copyright 2012 AAAiC 
%  Date: 2012/04/10

sGlob=size(Glob); % size of each dimension

dimGlob=max(size(sGlob)); % number of dimensions of Glob

%% Initialize Java Array of Strings
  if (dimGlob==3) % 3-D Array
    JavaString=javaArray('java.lang.String',sGlob(1),sGlob(2),sGlob(3));
    %% Element-wise define
        for i=1:sGlob(3)
            for j=1:sGlob(2)
                for k=1:sGlob(1)
                    
                    
                    JavaString(k,j,i)=java.lang.String(cell2char(Glob(k,j,i)));
                    
                end   
            end

        end
         

elseif (dimGlob==2) % 2-D Array
    JavaString=javaArray('java.lang.String',sGlob(1),sGlob(2));
    
            for j=1:sGlob(2)
                for k=1:sGlob(1)
                    
                    JavaString(k,j)=java.lang.String(cell2char(Glob(k,j)));
                    
                end
            end

 
   end





end