% removes NaNs from a vector
% 
% created by Srinivas Gorur-Shandilya at 11:25 , 19 June 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function x = nonnans(x)
x = x(~isnan(x));
x = x(:);