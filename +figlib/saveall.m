% exports all open figures to .eps on the desktop
function saveall(fmt)

if nargin == 0
	fmt = 'epsc';
end

switch fmt
case 'epsc'
	ext = 'eps';
case 'png'
	ext = 'png';
otherwise
	error('Unknown format')
end


if ispc
	error('Will not work on windows')
end

all_figs = get(0,'Children');


for i = 1:length(all_figs)

	savename = all_figs(i).Name;

	if isempty(savename)
		savename = strlib.oval(all_figs(i).Number);
	end

	saveas(all_figs(i),['~/Desktop/ ' savename '.' ext],fmt)

end