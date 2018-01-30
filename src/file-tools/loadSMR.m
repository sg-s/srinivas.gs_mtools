function [data,header] = loadSMR(filename)
% this is a wrapper-rewrite of an older function
% called SONImport that could load SMR files
% it was pretty hard to use and a number of baroque
% conventions, left open files, and had a number of 
% other issues
% I've slimmed it down, made some simplygind assumptions
% and removed a bunch of evals 
% -- Srinivas Gorur-Shandilya (https://srinivas.gs)
% original readme follows:
%
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% SONIMPORT copies all channels into a MAT-file
%
% Note: Use ImportSMR in the sigTOOL package in preference to SONImport
% unless you want data stored in the same way as with previous versions of
% the SON library.
%
% SONIMPORT(FID, {OPTIONS});
% where:
%         FID is the matlab file handle
%         OPTIONS if present, are a set of one or more arguments
%                   (see below)
% When present, OPTIONS must be the last input argument. Valid options
% are:
% 'ticks', 'microseconds', 'milliseconds' and 'seconds' cause times to
%    be scaled to the appropriate unit (seconds by default)in HEADER
% 'scale' - calls SONADCToDouble to apply the channel scale and offset to DATA
%    which will  be cast to double precision
% Other options will have no effect
%
% Returns 0 if successful, -1 otherwise
%
% SONIMPORT stores data in a Level 5 Version 6 compatible MAT-file that can
% be read on any MATLAB supported platform.
% SONIMPORT copies the FileHeader returned by SONFileHeader to the MAT-file
% then loads each channel in turn. The DATA and HEADER fields that would be
% returned by SONGETCHANNEL are then saved. The DATA vector, matrix or
% structure is saved as CHANX where X is the channel number e.g.
% CHAN1 for channel 1. The HEADER is saved as a structure named
% HEADX.
%
% Note that SONIMPORT loads each channel in turn but loads the entire
% channel. Very lengthy channels can cause an out-of-memory error,
% particularly when scaling waveform data to double precision. 
% SONIMPORT issues a warning when this happens and attempts to recover by
% calling
%   SONGETCHANNEL(FID, CHAN, 'MAT', 'MATFILENAME' {,OPTIONS})
% The waveform load routines (SONGETADCCHANNEL and SONGETREALWAVECHANNEL)
% will add the data for the specified channel block-by-block (or
% frame-by-frame) using low-level I/O without having all the data loaded at
% once. If this fails, an incomplete channel entry will be left corrupting
% the MAT-file. SONIMPORT then deletes the MAT-file and returns -1.
% The low-level I/O to the MAT-files has not yet been tested on the
% Mac or other big-endian platforms.
%
% Malcolm Lidierth 07/06
% Copyright © The Author & King's College London 2006

if ispc 
    fid = fopen(filename);
else
    fid = fopen(filename,'r','ieee-le');
end

% [pathname, ~] = fileparts(fopen(fid));
% if ~isempty(pathname)
%     pathname = [pathname filesep];
% end
% FileInfo = SONFileHeader(fid);

% get list of valid channels
c = SONChanList(fid);

% Import the data.
for i = length(c):-1:1
    chan=c(i).number;

    [data{i},header{i}] = SONGetChannel(fid, chan);

    % convert to double
    if ~isstruct(data{i}) && ~isempty(data{i})
    	data{i} = SONADCToDouble(data{i},header{i});
    end

end

fclose(fid);


