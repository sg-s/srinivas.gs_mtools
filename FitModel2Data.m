% FitModel2Data
% fits a model specified by a file that is of the following form:
% f = model(s,p)
% where 
% f is the output of the model (a 1D vector as long as s)
% s is a stimulus vector
% p is a structure with parameters
% 
% You can get p using GetModelParameters(model)
%
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


scale = 4;

switch nargin 
	case 0
		help FitModel2Data
		return
	case 1
		help FitModel2Data
		error('Not enough input arguments')
	case 2
		p0 = getModelParameters(char(modelname));
		[x0, param_names] = struct2mat(p0);
		f = fieldnames(p0);
		param_names = f(param_names);
	case 3
		if ~isstruct(p0)
			help FitModel2Data
			error('RTFM')
		else
			[x0, param_names] = struct2mat(p0);
			f = fieldnames(p0);
			param_names = f(param_names);
		end

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

default_x0 = struct2mat(p0);

% validate inputs
if ~isa(modelname,'function_handle')
	error('First argument is not a function handle')
end
if isstruct(data)
	if any(strcmp('stimulus',fieldnames(data))) && any(strcmp('response',fieldnames(data)))
	else
		help FitModel2Data
		error('RTFM')
	end
else
	help FitModel2Data
	error('RTFM')
end

if nargin < 4
	clear ub lb
	this_lb =[]; this_ub = [];
	ub = struct; lb = struct;
	% intelligently ask the model what the bounds for parameters are
	mn= char(modelname);
	mn=which(mn);
	txt=fileread(mn);
	a = strfind(txt,'ub.');
	
	for i = 1:length(a)
		this_snippet = txt(a(i):length(txt));
		semicolons = strfind(this_snippet,';');
		this_snippet = this_snippet(1:semicolons(1));
		try 
			eval(this_snippet)
		catch
		end
	end
	a = strfind(txt,'lb.');
	for i = 1:length(a)
		this_snippet = txt(a(i):length(txt));
		semicolons = strfind(this_snippet,';');
		this_snippet = this_snippet(1:semicolons(1));
		try 
			eval(this_snippet)
		catch
		end
	end

	lb_vec = -Inf*ones(length(x0),1);
	ub_vec =  Inf*ones(length(x0),1);

	% assign 
	assign_these = fieldnames(lb);
	for i = 1:length(assign_these)
		assign_this = assign_these{i};
		eval(strcat('this_lb = lb.',assign_this,';'))
		lb_vec(find(strcmp(assign_this,param_names)))= this_lb;
	end
	assign_these = fieldnames(ub);
	for i = 1:length(assign_these)
		assign_this = assign_these{i};
		eval(strcat('this_ub = ub.',assign_this,';'))
		ub_vec(find(strcmp(assign_this,param_names)))= this_ub;
	end

	ub = ub_vec;
	lb = lb_vec;

end



% global options
nsteps = 300;
nrep = 20;
psoptions = psoptimset('UseParallel',true, 'Vectorized', 'off','Cache','on','CompletePoll','on','Display','iter','MaxIter',nsteps,'MaxFunEvals',20000);
min_r2 = 0; % keep solving till we get here

if min_r2
	x = patternsearch(@(x) GeneralCostFunction(x,data,modelname,param_names),x0,[],[],[],[],lb,ub,psoptions);

	% keep crunching till we can fit the damn thing
	x = x0;
	
	for i = 1:nrep


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
		if length(data) == 1
			% only fit to one data set
			fp = modelname(data.stimulus,mat2struct(x,param_names));
			c = Cost2(data.response,fp);
		else
			% fit to multiple data sets at the same time
			c = NaN(length(data),1);
			w = zeros(length(data),1);
			for i = 1:length(data)
				fp = modelname(data(i).stimulus,mat2struct(x,param_names));
				c(i) = Cost2(data(i).response,fp);
				w(i) = sum(~isnan(data(i).response));
				w(i) = w(i)*std(~isnan(data(i).response));
			end
			% take a weighted average of the costs
			w = w/max(w);
			c = mean(c.*w);
		end

		if isnan(c)
			c = Inf;
		end

	end


% assign outputs
p = mat2struct(x,param_names);

% make a plot showing the fit, etc. 
figure, hold on
for i = 1:length(data)
	autoplot(length(data),i,1);
	hold on
	fp = modelname(data(i).stimulus,mat2struct(x,param_names));
	plot(data(i).response,'k')
	plot(fp,'r')
	% show r-square
	r2 = rsquare(fp,data(i).response);
	title(strcat('r^2=',oval(r2)))
	legend({'Data',char(modelname)})

	% fix the y scale
	ymax = 1.1*max(data(i).response(~isnan(data(i).response)));
	ymin = 0.9*min(data(i).response(~isnan(data(i).response)));
	set(gca,'YLim',[ymin ymax])
end
PrettyFig('plw=1.5;','lw=1.5;','fs=14;')

end
