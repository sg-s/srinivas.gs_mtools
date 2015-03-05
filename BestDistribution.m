% BestDistribution.m
% this function is meant to be optimised by FitModel2Data
% this function takes some parameters (in a structure called p)
% and generates a distribution from these parameters. the distribution generating
% function is called dist_gamma2 and is pretty general
% now, it takes samples from that distribution using pdfrnd
% and constructs a control time series
% this control time series is given to DeliverySystemModel, which returns a 
% prediction for the PID. we convert this back into a distribution, and report that
%
% FitModel2Data will use this to best match a distribution. 
% 
% created by Srinivas Gorur-Shandilya at 1:53 , 26 February 2015. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.

function [py,s] = BestDistribution(~,p)

% some global parameters
T = 60; 		% how long is your stimulus
dt = 1e-4; 		% sampling time for this simulation
tc = .1; 		% switching time
cx = 0:1e-3:5;  % control signal domain
px = 0:1e-3:5;  % PID domain

% set bounds
lb.mu1 = 0;
lb.mu2 = 0;
lb.sigma1 = 0;
lb.sigma2 = 0;
lb.xmin = 0;
lb.xmax = 0;
ub.xmin = 1;
ub.xmax = 1;
ub.mu1 = 5;
ub.mu2 = 5;
ub.sigma2 = 10;
ub.sigma1 = 10;


if isstruct(p)
	% generate distribution
	cy = dist_gauss2(cx,p);
	cy(isnan(cy)) = 0;

	% sample from distribution 
	n = floor(T/tc);
	stream = RandStream.getGlobalStream;
    load rand_state
    stream.State = savedState;
	s = repmat(pdfrnd(cx,cy,n),1,floor(tc/dt));
	s = s';
	s = s(:);
else
	s = p;
end

% get pid prediction
PID_pred = DeliverySystemModel_LN(s);

% get pid distribution 
[hy,hx] = hist(PID_pred,50);
py = interp1(hx,hy,px);
py(isnan(py)) = 0;
py = py/max(py);

% penalise bullshit distributions
py(py<eps) = 0;
if length(nonzeros(py)) < 10
	py = 0*py;
end
