% formats a nice error message to display on assertion failure

function txt = errmsg(txt)

d = dbstack;


if length(d) > 1
	line2 = [ d(2).name ' >>>> ' txt ];
else
	line2 = [ txt  ];
end
line1 = repmat('-',1,length(line2)+3);

txt = [line1 newline newline line2 newline newline line1];
