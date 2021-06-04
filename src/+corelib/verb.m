function verb(bool, header, message)
  % one-liner to display a message if a logical expression evaluates to `true`
  % great for verbosity/debugging
  %
  % corelib.verb(bool, header, message)
  %
  % Examples:
  %   corelib.verb(verbose, 'INFO', 'beginning simulation')
  %   evaluates to: if verbose == true, then display '[INFO] beginning simulation'
  %
  % Arguments:
  %    bool: a logical or scalar evaluating to true or false
  %     if bool is true, display the expression, otherwise don't
  %    header: a character vector
  %    message: a character vector
  
  if bool
    disp(['[' header '] ' message])
  end
  
end % function
