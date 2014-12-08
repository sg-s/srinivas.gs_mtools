% FitModel2Data
% fits a model specified by a file that is of the following form:
% f = model(s,p)
% where 
% f is the output of the model (a 1D vector as long as s)
% s is a stimulus vector
% p is a structure with parameters
% to data given by r
% minimum usage:
% p = FitModel2Data(@modelname,data,p0);
% more options:
% p = FitModel2Data(@modelname,data,p0,lb,ub);
% where data is a structure with the following fields:
% data.response
% data.stimulus
% data.time
% created by Srinivas Gorur-Shandilya at 12:35 , 08 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function p = FitModel2Data(modelname,data,p0,lb,ub);

default_x0 = struct2mat(p0);
scale = 4;

switch nargin 
	case 0
		help FitModel2Data
		return
	case {1,2}
		help FitModel2Data
		error('Not enough input arguments')
	case 3
		if ~isstruct(p0)
			help FitModel2Data
			error('RTFM')
		else
			[x0, param_names] = struct2mat(p0);
			f = fieldnames(p0);
			param_names = f(param_names);
		end
		lb = -Inf*ones(length(x0),1);
		ub = Inf*ones(length(x0),1);
	case 4
		error('Specify both upper and lower bounds')
	case 5
		if ~isstruct(p0)
			help FitModel2Data
			error('RTFM')
		else
			[x0, param_names] = struct2mat(p0);
			f = fieldnames(p0);
			param_names = f(param_names);
		end
		if ~isstruct(lb)
			help FitModel2Data
			error('RTFM')
		else
			lb = struct2mat(lb);
		end
		if ~isstruct(ub)
			help FitModel2Data
			error('RTFM')
		else
			ub = struct2mat(ub);
		end

end

% validate inputs


if ~isa(modelname,'function_handle')
	error('First argument is not a function handle')
end
if isstruct(data)
	if ~( find(strcmp('response', fieldnames(data))) && find(strcmp('stimulus', fieldnames(data))) )
		help FitModel2Data
		error('RTFM')
	end
else
	help FitModel2Data
	error('RTFM')
end

% global options
nsteps = 300;
psoptions = psoptimset('UseParallel',true, 'Vectorized', 'off','Cache','on','CompletePoll','on','Display','iter','MaxIter',nsteps,'MaxFunEvals',20000);
min_r2 = 0; % keep solving till we get here

if min_r2
	x = patternsearch(@(x) GeneralCostFunction(x,data,modelname,param_names),x0,[],[],[],[],lb,ub,psoptions);

	% keep crunching till we can fit the damn thing
	x = x0;
	
	for i = 1:nrep

		% specify new bounds
		lb = x/scale;
		ub = x*scale;
		% special bounds
		temp=ub(x<0);
		ub(x<0) = lb(x<0);
		lb(x<0) = temp; clear temp;
		if lb(3) < 0
			lb(3) = 0; 
		end
		if ub(3) > 1
			ub(3) = 1;
		end
		
		% make sure that p.s0 does not exceed the minimum value of the stimulus
		if ub(end) > min(stimulus)
			ub(end) = min(stimulus)-1e-5;
		end
		if lb(end) > ub(end)
			lb(end) = 0;
		end
		if x(end) > ub(end)
			x(end) = ub(end)/2;
		end

		% fit
		x = patternsearch(@(x)  GeneralCostFunction(x,data,modelname,param_names),x,[],[],[],[],lb,ub,psoptions);
		p = mat2struct(x);
		
		if isvector(stimulus)
			Rguess = modelname(stimulus,p);
		else
			for i = 1:size(stimulus,2)
				Rguess(:,i) = modelname(stimulus(:,i),p);
			end
			clear i
		end

		Rguess = abs(Rguess);

		if rsquare(Rguess(IgnoreInitial:end),data.response(IgnoreInitial:end)) > min_r2
			return
		else
			disp(oval(rsquare(Rguess(IgnoreInitial:end),data.response(IgnoreInitial:end)),4))
			fprintf('\n')
		end	

	end
else
	x = patternsearch(@(x) GeneralCostFunction(x,data,modelname,param_names),x0,[],[],[],[],lb,ub,psoptions);

end

	function c =  GeneralCostFunction(x,data,modelname,param_names)
		fp = modelname(data.stimulus,mat2struct(x,param_names));
		c = Cost2(data.response,fp);
		if isnan(c)
			c = Inf;
		end

	end


% assign outputs
p = mat2struct(x,param_names);

end
