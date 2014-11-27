% returns a gamma distribution, which is characterised by two parameters: theta and k
% usage: g = GammaDist(t,p)
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/. 
function g = GammaDist(t,p)
if ~nargin 
	help GammaDist
	return
end
g = (t.^(p.k-1)).*(exp(-t/p.theta));
g = g/((p.theta^p.k)*gamma(p.k));