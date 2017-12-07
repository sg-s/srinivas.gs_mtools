% flstring
% fixed length string
% forces a string to be a fixed length

function s = flstring(s,str_len)

if length(s) < str_len
	s = [s repmat(' ', 1, str_len - length(s))];
	return

end

if length(s) > str_len
	s = s(1:str_len);
	return
end