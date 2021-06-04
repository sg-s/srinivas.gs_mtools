% highPass.m
% high pass filters a vector
% 
% created by Srinivas Gorur-Shandilya at 1:35 , 22 January 2016. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function y = highPass(x,varargin)


% defaults
Fs = 1e3; % in Hz
cut_off = 10; % in Hz
filter_order = 2;

if ~nargin
	help highPass
	return
else
	if rem(length(varargin),2)==0
		for ii = 1:2:length(varargin)-1
		temp = varargin{ii};
        if ischar(temp)
        	eval(strcat(temp,'=varargin{ii+1};'));
        end
    end
	else
    	error('Inputs need to be name value pairs')
    end
end

assert(isvector(x),'first argument should be a vector!')

df = designfilt('highpassiir','FilterOrder',filter_order,'PassbandFrequency',cut_off,'PassbandRipple',2,'SampleRate',Fs);

% estimate group delay
D = round(mean(grpdelay(df))); % filter delay in samples

y = filtfilt(df,[x; zeros(D,1)]); % Append D zeros to the input data
y = y(D+1:end); 