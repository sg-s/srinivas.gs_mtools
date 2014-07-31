% Remove Point Defects from Waveform (1D). 
% removes large, single time point excursions from signal
% created by Srinivas Gorur-Shandilya at 20:59 , 21 December 2011. Contact
% me at http://srinivas.gs/contact/
function cleanx = RemovePointDefects(x)
switch nargin
case 0
	help RemovePointDefects
	return
end
x = squeeze(x);
dx = abs(diff(x));
dx(isnan(dx)) = 0;
try
    thresh = 5*mean(dx(1:1000));
catch
    thresh = 5*mean(dx);
end
cleanx = x;

% new algorithm, where we interpolate over bad points
badpoints = find(dx>thresh);
goodpoints = setdiff(1:length(x),badpoints);
cleanx(badpoints) = interp1(goodpoints,x(goodpoints),badpoints);

