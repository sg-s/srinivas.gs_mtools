% makePDF.m
% a wrapper for MATLAB's publish() function, it makes a PDF directly from the .tex that MATLAB creates and cleans up afterwards.
% needs pdflatex installed. Will not work on Windows.
% usage:
% makePDF  % automatically builds PDF from last modified .m file
% makePDF --dirty % or 
% makePDF -d      % leaves all auxillary files in the publish folder (.aux, .tex, etc.) 
% makePDF --force % or
% makePDF -f      % overrides warnings about git status
% makePDF -f -d filename.m % builds PDF from filename.m
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function [] = makePDF(varargin)


assert(~ispc,'makePDF cannot run on a Windows computer')

orig_dir = cd;
close all 

% defaults 
options.showCode = false;
options.format = 'latex';
options.imageFormat= 'pdf';
options.figureSnapMethod=  'print';
options.force = false;
options.dirty = false;
options.filename = '';

% validate and accept options
if iseven(length(varargin))
	for ii = 1:2:length(varargin)-1
	temp = varargin{ii};
    if ischar(temp)
    	if ~any(find(strcmp(temp,fieldnames(options))))
    		disp(['Unknown option: ' temp])
    		disp('The allowed options are:')
    		disp(fieldnames(options))
    		error('UNKNOWN OPTION')
    	else
    		options.(temp) = varargin{ii+1};
    	end
    end
end
elseif isstruct(varargin{1})
	% should be OK...
	options = varargin{1};
else
	error('Inputs need to be name value pairs')
end

if isempty(options.filename)
	options.filename = findFileToPublish;
end

publish_options = struct;
publish_options.showCode = options.showCode;
publish_options.format = options.format;
publish_options.imageFormat = options.imageFormat;
publish_options.figureSnapMethod = options.figureSnapMethod;

% use a custom stylesheet, if it exists
a = dir('*.xsl');
switch length(a)
	case 0
		% no custom stylesheet
	case 1
		% use this!
		publish_options.stylesheet = a.name;
	case 2
		error('Too many custom stylesheets in working directory. makePDF does not know what to do. Make sure there is only one .xsl file in the working directory.')
end

% check to make sure all changes are committed to git
[~,m] = unix('git status | grep "modified" | wc -l');
if str2double(m) > 0 & ~options.force
	error('You have unmodified files that have not been committed to your git repo. Cowardly refusing to proceed till you commit all files.')
end

% run publish to generate the .tex file
try
	f = publish(options.filename,publish_options);
catch err
	if strcmp(err.identifier,'MATLAB:publish:DirNotWritable')
		if ismac
			disp('It looks like you dont have permissions to write to the target directory. This may be because of stupid fucking Dropbox fucking shit up. Attempting to fix...')
			a = strfind(err.message,'"');
			unix(['chflags -R nouchg '  err.message(a(1):a(2))]);
			f = publish(options.filename,publish_options);
		end
	else
		error(err.message)
	end

end

if ismac
	% tell stupid MATLAB to get the path right
	[~,v] = unix('sw_vers -productVersion'); % Mac OS X specific
	v = str2double(v);
	path1 = getenv('PATH');
	if v < 10.11
		if isempty(strfind(path1,':/usr/texbin'))
			path1 = [path1 pathsep '/usr/texbin'];
		end
		setenv('PATH', path1);
	else
		if isempty(strfind(path1,':/Library/TeX/texbin'))
			path1 = [path1 pathsep '/Library/TeX/texbin'];
		end
		setenv('PATH', path1);
	end
end

% move to the correct directory
cd('html')

% convert the .tex to a PDF
system(['pdflatex "' f '"']);

% clean up
cd(orig_dir)
if ~options.dirty
	cleanPublish;
end
close all

f = strrep(f,'.tex','.pdf');

% archive this PDF in html/archive/ with the date and the git hash
if exist([fileparts(f) filesep 'archive'],'dir') ~= 7
	mkdir([fileparts(f) filesep 'archive'])
end

today_string = datestr(now);
today_string = today_string(1:11);

[~,archive_file_name] = fileparts(f);
[e,git_hash] = system('git rev-parse HEAD');
if e == 0
	archive_file_name = [archive_file_name '-' today_string '-' git_hash(1:7) '.pdf'];
else
	warning('Could not read git hash -- PDF will be archived without the git hash')
	archive_file_name = [archive_file_name '-' today_string  '.pdf'];
end
archive_file_name = [fileparts(f) filesep 'archive' filesep archive_file_name];

copyfile(f,archive_file_name);

% open the PDF
if ismac
	system(['open "' f '"']);
else
	try
		system(['xdg-open "' f '"']);
	catch
	end
	try
		system(['gvfs-open "' f '"']);
	catch
	end

	try
		system(['evince "' f '"']);
	catch
	end

	try
		system(['okular "' f '"']);
	catch
	end
end



	function filename = findFileToPublish()
		% run on the last modified file
		d = dir('*.m');

		% find the last modified file
		[~,idx] = max([d.datenum]);

		% name of file
		try
			filename = d(idx).name;
		catch
			error('MakePDF could not figure out which document you want to publish. Specify explicitly.')
		end

	end

end