function F = rel2abs(F)
	
if ~java.io.File(F).isAbsolute
	F = fullfile(pwd,F);
end
