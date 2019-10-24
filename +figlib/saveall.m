% exports all open figures to .eps on the desktop
function saveall(varargin)


options.Format = 'pdf';
options.Location = '~/Desktop/';
options.SaveName = 'auto';

options = corelib.parseNameValueArguments(options, varargin{:});


fmt = options.Format;


if ~strcmp(options.Location(end),filesep)
	options.Location = [options.Location filesep];
end

make_pdf = false;

switch fmt
case 'epsc'
	ext = 'eps';
case 'eps'
	ext = 'eps';
case 'png'
	ext = 'png';
case 'pdf'
	ext = 'eps';
	fmt = 'epsc';
	make_pdf = true;
otherwise
	error('Unknown format')
end


if ispc
	error('Will not work on windows')
end

all_figs = get(0,'Children');


for i = 1:length(all_figs)


	if strcmp(options.SaveName,'auto')
		savename = all_figs(i).Name;

		if isempty(savename)
			savename = strlib.oval(all_figs(i).Number);
		end
	else
		savename = options.SaveName;
	end

	saveas(all_figs(i),[options.Location savename '.' ext],fmt)

	if make_pdf && ismac
		system(['pstopdf ' options.Location savename '.' ext])

	end

end