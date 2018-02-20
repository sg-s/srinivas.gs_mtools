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

% defaults 
force = false;
dirty = false;
filename = '';

assert(~ispc,'makePDF cannot run on a Windows computer')
filename = findFileToPublish;
if ~nargin
else
	% figure out which arguments are options and handle them
	for i = 1:nargin
		if strcmp(varargin{i},'-f') || strcmp(varargin{i},'--force') 
			force = true;
		elseif strcmp(varargin{i},'-d') || strcmp(varargin{i},'--dirty') 
			dirty = true;
		elseif ~any(strfind(varargin{i},'-')) 
			filename = varargin{i};
			if strcmp(filename(end-1:end),'.m')
				filename = [filename '.m'];
			end
		end
	end
	assert(exist(filename,'file') == 2,'Cant find the file you told me to compile');
end

orig_dir = cd;
close all 

% compile to .tex
options.showCode = false;
options.format = 'latex';
options.imageFormat= 'pdf';
options.figureSnapMethod=  'print';


% use a custom stylesheet, if it exists
a = dir('*.xsl');
switch length(a)
	case 0
		% no custom stylesheet
	case 1
		% use this!
		options.stylesheet = a.name;
	case 2
		error('Too many custom stylesheets in working directory. makePDF does not know what to do. Make sure there is only one .xsl file in the working directory.')
end

% check to make sure all changes are committed to git
[~,m] = unix('git status | grep "modified" | wc -l');
if str2double(m) > 0 && ~force
	error('You have unmodified files that have not been committed to your git repo. Cowardly refusing to proceed till you commit all files.')
end

% run publish to generate the .tex file
try
	f = publish(filename,options);
catch err
	if strcmp(err.identifier,'MATLAB:publish:DirNotWritable')
		if ismac
			disp('It looks like you dont have permissions to write to the target directory. This may be because of stupid fucking Dropbox fucking shit up. Attempting to fix...')
			a = strfind(err.message,'"');
			unix(['chflags -R nouchg '  err.message(a(1):a(2))]);
			f = publish(filename,options);
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
if ~dirty
	cleanPublish;
end
close all

f = strrep(f,'.tex','.pdf');

% archive this PDF in html/archive/ with the date and the git hash
if exist([fileparts(f) filesep 'archive'],'dir') ~= 7
	mkdir([fileparts(f) filesep 'archive'])
end

[~,archive_file_name] = fileparts(f);
[e,git_hash] = system('git rev-parse HEAD');
if e == 0
	archive_file_name = [archive_file_name '-' datestr(today) '-' git_hash(1:7) '.pdf'];
else
	warning('Could not read git hash -- PDF will be archived without the git hash')
	archive_file_name = [archive_file_name '-' datestr(today)  '.pdf'];
end
archive_file_name = [fileparts(f) filesep 'archive' filesep archive_file_name];

copyfile(f,archive_file_name);

% open the PDF
system(['open "' f '"']);

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