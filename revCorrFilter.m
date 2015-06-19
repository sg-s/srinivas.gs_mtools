% revCorrFilter.m
% extracts filter from input vector x and output vector y 
% using correlation based methods 
% 
% see section 5.2.3 of Kearney and Westwick for a full explanation
%
% briefly, we construct a toeplitz matrix of the stimulus autocorrelation and use that to divide the cross correlation, giving us the "true" filter. 
% 
% usage:
% K = revCorrFilter(x,y);
% K = revCorrFilter(x,y,'filter_length',300); % we want filters this long
% K = revCorrFilter(x,y,'reg',1); % regularise the toeplitz matrix, in units of matrix covriance
%
% created by Srinivas Gorur-Shandilya at 11:16 , 11 June 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function K = revCorrFilter(x,y, varargin)

% define defaults
filter_length = 300;
reg = NaN;

if ~nargin
    help [function-name]
    return
else
    if iseven(nargin)
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

% make sure filter_length makes sense
filter_length = floor(filter_length);
if filter_length < 10
	error('Very short filter length. Are you sure?')
elseif filter_length > length(x)/2
	error('Not enough data to compute filter of this length. Try decreasing filter length.')
end

% compute the Toeplitz matrix
phi_xx = xcorr2(x,x);
phi_xx = phi_xx(ceil(length(phi_xx)/2):end);
phi_xx = phi_xx(1:filter_length);
T = toeplitz(phi_xx); % this should be as diagonal as possible, but won't be if the input isn't perfectly uncorrelated white noise.

% determine condition parameter 
c = cond(T);
oldT = T;
if isnan(reg)
    if c < length(T)
    	% all OK
        r = 0; % no regularisation
    else
    	% use a binary search to find the best value to regularise by
    	rmin = 0;
    	rmax = 1/(2*eps);
    	r = c;
    	for i = 1:100
    		T = oldT + eye(length(T))*r;
    		c = cond(T);
    		if c < length(T)
    			% decrease r
    			rmax = r;
    			r = mean([rmin r]);
    		else
    			% increase r
    			rmin = r;
    			r = mean([rmax r]);
    		end
    		
    	end
    end
    T = oldT + eye(length(T))*r;
else
    T = (T + reg*eye(length(T)))*trace(T)/(trace(T) + reg*length(T));
end


% compute the cross-correlation
phi_xy = xcorr2(y,x);
phi_xy = phi_xy(ceil(length(phi_xy)/2):end);
phi_xy = phi_xy(1:filter_length);


K = T\phi_xy; % this is our initial estimate

return

% % compute the svd of the Hessian 
[U,S,V] = svd(T);
s = diag(S);


% compute the output variance contributed by each singular value
v = zeros(length(V),1);
for i = 1:length(v)
	v(i) = s(i)*((V(i,:)*K)^2);
end

% calculate the MDL cost
mdl = zeros(length(V),1);
output_variance = std(y)^2;
N = length(y);

for i = 1:length(mdl)
	mdl(i) = (1+ ((i * log(N))/N))*(output_variance - sum(v(1:i)));
end

keyboard



