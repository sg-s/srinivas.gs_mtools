% sweetspot.m
% makes a colour map that goes from blue (too low) through green (nice) to red (too high)
% map = sweetspot(n)
% where n is the length of the colormap
% and map is the generated colourmap, a nx3 matrix
% 
% created by Srinivas Gorur-Shandilya at 4:16 , 12 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function map = sweetspot(n)

if ~nargin
	help sweetspot
	return
end

if n < 3
	n = 3;
end
n = floor(n);
if isnan(n)
	error('Input is NaN')
end

if iseven(n)
	n = n+1;
end

map = zeros(n,3);

% define reference points as B, G and R