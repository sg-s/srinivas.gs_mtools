#mfile style guideline (v1)

This document contains style guidelines for writing MATLAB m files.

###Naming Conventions

1. All files shall be functions 

2. Function Name shall be the same as mfilenames 

3. Variable names should be as clear as possible. Variable name clarity trumps name brevity. 

###Zero Argument Output

###Variable Argument Numbers

1. Functions should have a help section in the comments with license data. When a function is called with no inputs, unless it can actually do something, it should display the help. So calling FunctionName is the same as help FunctionName 

2. Functions should gracefully handle an incomplete number of arguments. If FunctionName can take up to 6 arguments, but only 2 are essential, then it should gracefully handle anything from 2-6 inputs. 

3. Functions may optionally support Name-Value (MATLAB-style) optional inputs

4. Functions may optionally support the generalised eval option inputs (e.g. FitFilter2Data.m)