% cleans a string of whitespace, leading numbers, etc.
% makes clean variables names in MATLAB

function s = clean(s)

% replace minus signs with underscores
s = strrep(s,'-','_');

% remove other weird signs
s = strrep(s,'+','');
s = strrep(s,'*','');
s = strrep(s,'/','');
s = strrep(s,'\','');
s = strrep(s,'(','');
s = strrep(s,')','');


