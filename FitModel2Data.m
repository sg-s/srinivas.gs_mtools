% FitModel2Data
% fits a model specified by a file that is of the following form:
% f = model(s,p)
% where 
% f is the output of the model (a 1D vector as long as s)
% s is a stimulus vector
% p is a structure with parameters
% 
% to data
% 
% minimum usage:
% p = FitModel2Data(@modelname,data);
%
% % where data is a structure with the following fields:
% data.response
% data.stimulus
% 
% more options:
% p = FitModel2Data(@modelname,data,'p0',p0,'UseParallel',true,'nsteps',1000);
%
%
% created by Srinivas Gorur-Shandilya at 12:35 , 08 December 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
function p = FitModel2Data(modelname,data,varargin)

% defaults

% figure out if we should make a plot or not
make_plot = 0;

calling_func = dbstack;
being_published = 0;
if length(calling_func) == 1
	make_plot = 1;
end

switch nargin 
	case 0
		help FitModel2Data
		return
	case 1
		help FitModel2Data
		error('Not enough input arguments')
	case 2
		% minimum case

otherwise
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

% check if seed parameter structure is provided
if exist('p0','var')
else
	p0 = getModelParameters(char(modelname));
end
[x0, param_names] = struct2mat(p0);
f = fieldnames(p0);
param_names = f(param_names);
default_x0 = struct2mat(p0);
		

% check if bounds specified
if ~exist('ub','var')
	ub = struct;
	this_ub = [];

	% intelligently ask the model what the bounds for parameters are
	mn = char(modelname);
	mn = which(mn);
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

	ub_vec =  Inf*ones(length(x0),1);

	assign_these = fieldnames(ub);
	for i = 1:length(assign_these)
		assign_this = assign_these{i};
		eval(strcat('this_ub = ub.',assign_this,';'))
		ub_vec(find(strcmp(assign_this,param_names)))= this_ub;
	end

	ub = ub_vec;
end

if ~exist('lb','var')
	this_lb =[]; 
	lb = struct;

	% intelligently ask the model what the bounds for parameters are
	mn = char(modelname);
	mn = which(mn);
	txt=fileread(mn);
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

	% assign 
	assign_these = fieldnames(lb);
	for i = 1:length(assign_these)
		assign_this = assign_these{i};
		eval(strcat('this_lb = lb.',assign_this,';'))
		lb_vec(find(strcmp(assign_this,param_names)))= this_lb;
	end
	
	lb = lb_vec;

end

if ~exist('nsteps','var')
	nsteps = 300;
end

if ~exist('UseParallel','var')
	UseParallel = true;
end

if ~exist('Display','var')
	Display = 'iter';
end


% pattern search options
psoptions = psoptimset('UseParallel',UseParallel, 'Vectorized', 'off','Cache','on','CompletePoll','on','Display',Display,'MaxIter',nsteps,'MaxFunEvals',20000);


% search
x = patternsearch(@(x) GeneralCostFunction(x,data,modelname,param_names),x0,[],[],[],[],lb,ub,psoptions);



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
				w(i) = w(i)/std(data(i).response(~isnan(data(i).response)));
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

if make_plot
	hash = DataHash(data);
	figHandles = findall(0,'Type','figure');
	make_fig = 1;
	for i = 1:length(figHandles)
		if ~isempty(figHandles(i).Tag)
			if strcmp(figHandles(i).Tag,hash)
				make_fig = 0;
				figure(figHandles(i));
				clf(figHandles(i))
			end
		end
	end
	if make_fig
		temp = figure; hold on
		set(temp,'Tag',hash)
	end
end

% make a plot showing the fit, etc. 
if make_plot
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

end % this end is for the whole function 
