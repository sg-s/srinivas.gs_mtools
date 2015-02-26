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

function [py] = BestDistribution(~,p)

% some global parameters
T = 60; 		% how long is your stimulus
dt = 1e-3; 		% sampling time for this simulation
tc = .1; 		% switching time
cx = 0:0.01:5;  % control signal domain
px = 0:0.01:10; % PID domain

% generate distribution
cy = dist_gamma2(cx,p);

% sample from distribution 
n = floor(T/tc);
s = repmat(pdfrnd(cx,cy,n),1,floor(tc/dt));
s = s';
s = s(:);

% get pid prediction
PID_pred = DeliverySystemModel(s);

% get pid distribution 
[hy,hx] = hist(PID_pred,50);
py = interp1(hx,hy,px);
py(isnan(py)) = 0;
