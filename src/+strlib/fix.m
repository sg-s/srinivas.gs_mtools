% force a string to have a fixed length
% fixed length string
% forces a string to be a fixed length

function s = fix(s,str_len, left_pad)

arguments
	s 
	str_len (1,1) double 
	left_pad (1,1) logical = false
end


if left_pad
	if length(s) < str_len
		s = [repmat(' ', 1, str_len - length(s)) s];
		return

	end
else
	if length(s) < str_len
		s = [s repmat(' ', 1, str_len - length(s))];
		return

	end
end


if length(s) > str_len
	s = s(1:str_len);
	return
end