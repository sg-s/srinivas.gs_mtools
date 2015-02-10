# Manipulate.m

## Known bugs and limitations

1. Manipulate window does not close when manipulating external models. That's because the external model file doesn't know about the existence of Manipulate. 
2. Function manipulation doesn't work yet
3. Manipulate will not work with functions defined as [varargout] = foo(varargin);