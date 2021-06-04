% exports all open figures disk
% usage:
% figlib.saveall
% 
function saveall(varargin)


options.Format = 'png';
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

			d = dbstack;
			try
				savename = [d(2).name '_' mat2str(all_figs(i).Number)];
			catch
				savename = mat2str(all_figs(i).Number);
			end
		end
	else
		savename = options.SaveName;
	end

	saveas(all_figs(i),[options.Location savename '.' ext],fmt)

	if make_pdf && ismac
		system(['pstopdf ' options.Location savename '.' ext])

	end

end