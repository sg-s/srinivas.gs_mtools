% envelopePlot.m
% 
% created by Srinivas Gorur-Shandilya at 2:28 , 24 September 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [] = envelopePlot(t,X,varargin)

FaceColor = [.5 .5 .5];
EdgeColor = [0 0 0];
EdgeLineWidth = 3;
FaceLineWidth = 1;

if ~nargin
	help envelopePlot
	return
elseif nargin == 1
	X = t;
	t = 1:length(X);
else
    if iseven(length(varargin))
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



t = t(:);

assert(ndims(X)==2,'Input should be a matrix, i.e., 2 dimensions')

M = max(X');
m = min(X');

p = [m(:) NaN(length(m),1) M(:)];
p = p';
p = p(:);

T = repmat(t,1,3); T = T'; T = T(:);
plot(T,p,'Color',FaceColor,'LineWidth',FaceLineWidth)
hold on
% also plot some edges
plot(t,m,'Color',EdgeColor,'LineWidth',EdgeLineWidth)
plot(t,M,'Color',EdgeColor,'LineWidth',EdgeLineWidth)