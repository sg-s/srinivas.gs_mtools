function myStruct = setKeyValue(myStruct, varargin)
% set any number of properties of a struct using key-value pair arguments
%
% myStruct = setKeyValue(myStruct, 'PropertyName', PropertyValue, ...)
%
% setKeyValue(myStruct) % prints a list of all the fields/properties
%
%
% Arguments:
%    myStruct: any struct or class with properties
%    varargin: any combination of a property/field name (as a character vector)
%        and an acceptable value
%        must be an even number of inputs
%
% Outputs:
%    myStruct: the struct or class with the changed properties/fields

  if mathlib.iseven(length(varargin))
    for ii = 1:2:length(varargin)-1
      temp = varargin{ii};
      if ischar(temp)
        if ~any(find(strcmp(temp,fieldnames(myStruct))))
          disp(['Unknown option: ' temp])
          disp('The allowed options are:')
          disp(fieldnames(myStruct))
          error('UNKNOWN OPTION')
        else
          options.(temp) = varargin{ii+1};
        end
      end
    end
  else
    error('Inputs need to be name value pairs')
  end

end % function
