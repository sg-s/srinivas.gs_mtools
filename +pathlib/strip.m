function [filepath, name, ext] = strip(varargin)

    %% Description:
    %   Strips the last file part from a filepath n times
    %
    %% Arguments:
    %   this_filepath: character vector, the file path to be stripped
    %       if this argument doesn't exist, the absolute path to the function/script
    %       that called pathlib.strip will be used instead
    %   n: integral scalar, the number of times to strip the file path, default: 1
    %
    %% Outputs:
    %   filepath: character vector, the stripped path
    %   name: character vector, the part stripped
    %   ext: character vector, the extension of the name, if any
    %
    %% Examples:
    %   [filepath, name, ext] = pathlib.strip(this_filepath);
    %   [filepath, name, ext] = pathlib.strip(n);
    %   [filepath, name, ext] = pathlib.strip(this_filepath, n);
    %
    %% Notes:
    %   for best results, use with mfilename('fullpath') or which, e.g.
    %   pathlib.strip(mfilename('fullpath'), n)

    %% Preamble

    switch nargin
    case 0
        % use defaults
        this_stack = dbstack;
        this_filepath = pathlib.rel2abs(this_stack(2).file);
        n = 1;
    case 1
        % determine which argument is specified by argument data type
        if ischar(varargin{1})
            this_filepath = varargin{1};
            n = 1;
        elseif isnumeric(varargin{1})
            this_stack = dbstack;
            this_filepath = pathlib.rel2abs(this_stack(2).file);
            n = varargin{1};
            assert(mod(n, 1) == 0, 'n must be a positive integer');
            assert(n > 0, 'n must be a positive integer')
        else
            error('argument types not recognized')
        end
    case 2
        % assume arguments are in the correct order
        this_filepath = varargin{1};
        n = varargin{2};
    otherwise
        error('too many arguments')
    end

    %% Main

    [filepath, name, ext] = fileparts(this_filepath);

    if n == 1
        return
    end

    for ii = 1:(n-1)
        [filepath, name, ext] = fileparts(filepath);
    end

end % function
