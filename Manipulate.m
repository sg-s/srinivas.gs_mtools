% Manipulate.m
% Mathematica-stype model manipulation
% usage: 
%
% 	Manipulate(fname,p,stimulus);
% 	Manipulate(fname,p,stimulus,response,time)
%	Manipulate(fname,p,stimulus,response,time,plothere)
%
% where p is a structure containing the parameters of the model you want to manipulate 
% The function to be manipulated (fname) should conform to the following standard: 
% 	
% 	[r]=fname(time,stimulus,p,plothere);
%
% where time and stimulus are optional matrices that your function might need
% p is a structure containing the parameters you want to manipulate 
% and plothere is an optional list of axis handles you want fname to plot to. fname should know what to do with plothere, if supplied, and should not require it. 
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
% 
% Manipulate(fname,p,stimulus,response,time,plothere


function Manipulate(varargin)
switch nargin
case 0
	help Manipulate
	return
case 1
	error('Not enough input arguments. Must supply a second argument, which is a structure containing the parameters, and a third argument which is the stimulus')	
case 2
	error('Not enough input arguments. Must supply a third argument which is the stimulus/input to the model being manipulated')	
case 3 
	fname = varargin{1};
	p = varargin{2};
	stimulus = varargin{3};
	stimulus = stimulus(:);
	response = NaN*stimulus;
	time = 1:length(stimulus);
	plothere = [];
case 4
	fname = varargin{1};
	p = varargin{2};
	stimulus = varargin{3};
	response = varargin{4};
	stimulus = stimulus(:);
	response = response(:);
	time = 1:length(stimulus);
	plothere = [];
case 5
	fname = varargin{1};
	p = varargin{2};
	stimulus = varargin{3};
	response = varargin{4};
	time = varargin{5};
	stimulus = stimulus(:);
	response = response(:);
	plothere = [];
case 6
	fname = varargin{1};
	p = varargin{2};
	stimulus = varargin{3};
	response = varargin{4};
	time = varargin{5};
	plothere = varargin{6};
end

% check inputs
if ~isstruct(p)
	if isempty(p)
		p=getModelParameters(fname);

		% also read bounds from that file
		clear ub lb
		this_lb =[]; this_ub = [];
		ub = struct; lb = struct;
		% intelligently ask the model what the bounds for parameters are
		mn= char(fname);
		mn=which(mn);
		txt=fileread(mn);
		a = strfind(txt,'ub.');
		
		for i = 1:length(a)
			this_snippet = txt(a(i):length(txt));
			semicolons = strfind(this_snippet,';');
			this_snippet = this_snippet(1:semicolons(1));
			eval(this_snippet)
		end
		a = strfind(txt,'lb.');
		for i = 1:length(a)
			this_snippet = txt(a(i):length(txt));
			semicolons = strfind(this_snippet,';');
			this_snippet = this_snippet(1:semicolons(1));
			eval(this_snippet)
		end

		lb_vec = -Inf*ones(length(fieldnames(p)),1);
		ub_vec =  Inf*ones(length(fieldnames(p)),1);

		% assign 
		assign_these = fieldnames(lb);
		for i = 1:length(assign_these)
			assign_this = assign_these{i};
			eval(strcat('this_lb = lb.',assign_this,';'))
			lb_vec(find(strcmp(assign_this,fieldnames(p))))= this_lb;
		end
		assign_these = fieldnames(ub);
		for i = 1:length(assign_these)
			assign_this = assign_these{i};
			eval(strcat('this_ub = ub.',assign_this,';'))
			ub_vec(find(strcmp(assign_this,fieldnames(p))))= this_ub;
		end

		ub = ub_vec;
		lb = lb_vec;

		ub(isinf(ub)) = 1e4;
		lb(isinf(lb)) = -1e4;

	

	else
		error('Second argument should be a structure containing parameters')
	end
end

% remove trailing extention, if any.
if ~isempty(strfind(fname,'.m'))
	fname(strfind(fname,'.m'):end) = [];
end

if isempty(plothere)
	plotfig = figure('position',[50 250 900 740],'NumberTitle','off','IntegerHandle','off','Name','Manipulate.m','CloseRequestFcn',@QuitManipulateCallback,'Menubar','none');

	modepanel = uibuttongroup(plotfig,'Title','Mode','Units','normalized','Position',[.01 .95 .25 .05]);

	
	mode_time = uicontrol(modepanel,'Units','normalized','Position',[.01 .1 .5 .9], 'Style', 'radiobutton', 'String', 'Time Series','FontSize',10,'Callback',@update_plots);
	mode_fun = uicontrol(modepanel,'Units','normalized','Position',[.51 .1 .5 .9], 'Style', 'radiobutton', 'String', 'Function','FontSize',10,'Callback',@update_plots);


	plot_control_string = ['stimulus' argoutnames(fname)];
	for i = 3:length(plot_control_string)
		plot_control_string{i} = strcat('+',plot_control_string{i});
	end
	uicontrol(plotfig,'Units','normalized','Position',[.26 .93 .05 .05],'style','text','String','Plot')
	plot_control = uicontrol(plotfig,'Units','normalized','Position',[.31 .935 .15 .05],'style','popupmenu','String',plot_control_string,'Callback',@update_plots,'Tag','plot_control');
	

	if length(varargin) > 3
		uicontrol(plotfig,'Units','normalized','Position',[.46 .93 .09 .05],'style','text','String','Response vs.')
		plot_response_here = uicontrol(plotfig,'Units','normalized','Position',[.56 .935 .15 .05],'style','popupmenu','String',argoutnames(fname),'Callback',@update_plots,'Tag','plot_response_here');
	end


	show_stim = 1;
	plot_these = zeros(nargout(fname),1);
	plot_these(1) = 1; % stores which model outputs to plot
	[stimplot,respplot] = make_plots(1+sum(plot_these),show_stim);

end


Height = 440;
controlfig = figure('position',[1000 250 400 Height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off','CloseRequestFcn',@QuitManipulateCallback,'Name','Manipulate');
axis off

r1 = []; r2 = []; r3 = []; r4 = []; r5 = [];
[pp,valid_fields] = struct2mat(p);

if ~isempty(varargin{2})
	lb = (pp/2);
	ub = (pp*2);
	for i = 1:length(lb)
		if lb(i) == ub(i)
			lb(i) = 0;
			ub(i) = 1;
		end
		if lb(i) > ub(i)
			temp = ub(i);
			ub(i) = lb(i);
			lb(i) = temp;
		end
	end
	clear i
end

lbcontrol = [];
ubcontrol = [];
control = [];
controllabel = [];
nspacing = [];

if isempty(plothere)
	% plot the stimulus
	plot(stimplot,time,stimulus)
	title(stimplot,'Stimulus')
end

an = argoutnames(fname);
set(plot_response_here,'String',an(find(plot_these)));

RedrawSlider(NaN,NaN);
EvaluateModel2(stimplot,respplot,plot_these);




function [] = update_plots(src,event)
	% remove all the plots
	delete(stimplot)
	for i = 1:length(respplot)
		delete(respplot(i))
	end

	if strcmp(get(src,'Tag'),'plot_control')
		% ok. user wants to add/remove a plot. rebuild list of plots 
		if any(strfind(char(plot_control_string(get(src,'Value'))),'+'))
			% need to add this plot
			plot_control_string{get(src,'Value')} = strrep(plot_control_string{get(src,'Value')},'+','');
			if get(src,'Value') > 1
				plot_these(get(src,'Value')-1) = 1;
			else
				show_stim = 1;
			end
		else
			plot_control_string{get(src,'Value')} = strcat('+',plot_control_string{get(src,'Value')});
			if get(src,'Value') > 1
				plot_these(get(src,'Value')-1) = 0;
			else
				show_stim = 0;
			end
		end

		[stimplot,respplot] = make_plots(1+sum(plot_these),show_stim);;
		set(plot_control,'String',plot_control_string);
		EvaluateModel2(stimplot,respplot,plot_these);
		an = argoutnames(fname);
		set(plot_response_here,'String',an(find(plot_these)));
		

	elseif strcmp(get(src,'Tag'),'plot_response_here')
	end
end

function [stimplot,respplot] = make_plots(nplots,show_stim)
	stimplot = []; respplot = [];
	if show_stim
		stimplot = autoplot(nplots,1,1);
	end
	for i = 2:nplots
		respplot(i-1) = autoplot(nplots,i,1);
	end

	if nplots > 1
		% link plots
		linkaxes([stimplot respplot],'x');
	end
end


function  [] = QuitManipulateCallback(~,~)
	try
		delete(plotfig)
	catch
	end
	try
		delete(controlfig)
	catch
	end
end

function [] = EvaluateModel2(stimplot,respplot,plot_these)
	% replacement of Evaluate Model given the near-total rewrite of Manipualte
	if nargin(fname) == 2

		an = argoutnames(fname);
		% evalaute the model
		es = '[';
		for j = 1:length(an)
			es=strcat(es,'r',mat2str(j),',');
		end
		clear j
		es(end) = ']';
		es= strcat(es,'=',fname,'(stimulus,p);');
		eval(es);

		% clear all the axes
		for ip = 1:length(respplot)
			cla(respplot(ip))
		end

		% plot the response in the right place 
		permitted_plots = get(plot_response_here,'String');
		prh = get(plot_response_here,'Value');
		prh = permitted_plots(prh);

		% plot what is needed
		ti = 1;
		for ip = 1:length(an)
			if plot_these(ip)

				if strcmp(an{ip},prh{1})
					plot(respplot(ti),response,'k')
					hold(respplot(ti),'on')
					
				end

				eval(strcat('plot(respplot(ti),r',mat2str(ip),');'));
				eval(strcat('title(respplot(ti),',char(39),an{ip},char(39),')'));

				if strcmp(an{ip},prh{1})
					hold(respplot(ti),'off')
					% update title with r2
					rr = [];
					eval(strcat('rr=rsquare(response,r',mat2str(ip),');'))
					set(plotfig,'Name',strcat('r^2 = ',oval(rr)))
				else
					set(plotfig,'Name','Manipulate.m')
				end


				ti = ti+1;
			end
		end
		clear ti ip

		plot(stimplot,stimulus)
		title(stimplot,'Stimulus')


		
	else
		error('297 not coded')
	end		


	set(controlfig,'Name','Manipulate')

end

            
function [] = EvaluateModel()
	% try to figure out if the model we are evaluating requires a time vector 
	% get the XLim 
	if isempty(plothere)
		xl = get(stimplot,'XLim');
	end

	if nargin(fname) == 2
		if isempty(plothere)
			%disp('ignoring time')
			es = '[';
			for j = 1:nplots-1
				es=strcat(es,'r',mat2str(j),',');
			end
			clear j
			es(end) = ']';
			es= strcat(es,'=',fname,'(stimulus,p);');
			eval(es);
		else
			% clear all the axes
			for ip = 1:length(plothere)
				cla(plothere(ip))
			end
			es = strcat(fname,'(stimulus,p);');
			eval(es);
		end
		

	elseif nargin(fname) == 3
		%disp('assume time is required')
		if isempty(plothere)
			es = '[';
			for j = 1:nplots-1
				es=strcat(es,'r',mat2str(j),',');
			end
			clear j
			es(end) = ']';
			es= strcat(es,'=',fname,'(time,stimulus,p);');
			eval(es);
		else
			% clear all the axes
			for ip = 1:length(plothere)
				cla(plothere(ip))
			end
			es = strcat(fname,'(stimulus,p,plothere);');
			eval(es);
		end
	elseif nargin(fname) == 4
		% the function to be manipulated makes its own plot
		if ~isempty(plothere)
			% clear all the axes
			for ip = 1:length(plothere)
				cla(plothere(ip))
			end
			es = strcat(fname,'(time,stimulus,p,plothere);');
			eval(es);
		end
	else
		error('The function you are trying to manipulate has too many inputs, so I dont know what to do')
	end

	% label the plots using names from the function we are manipulating 
	try
		plotnames = argoutnames(fname);
	catch
	end

	if isempty(plothere)
		% update all the response plots
		for j = 1:length(respplot)
			cla(respplot(j));
			es='plot(respplot(j),time,r';
			es = strcat(es,mat2str(j),');');	
			try
				eval(es);
			catch
			end
			if xl(1) ~= 0
				set(respplot(j),'XLim',xl);
			end
			try
				title(respplot(j),plotnames{j});
			catch
				keyboard
			end
			hold(respplot(j),'on')
		end

		if any(~isnan(response))
			disp('398')
			keyboard
			rr = rsquare(response);
			set(plotfig,'Name',strcat('r^2 = ',oval(rr)))
		else
			% response is all NaNs. ignore
			set(plotfig,'Name','Manipulate.m')
		end
		
	end
	
		
	set(controlfig,'Name','Manipulate')
end

function [] = RedrawSlider(src,event)
	temp=whos('src');
	if ~strcmp(temp.class,'matlab.ui.control.UIControl')

		% draw for the first time
		f = fieldnames(p);
		f=f(valid_fields);

		for i = 1:length(lbcontrol)
			lb(i)=str2num(get(lbcontrol(i),'String'));
			ub(i)=str2num(get(ubcontrol(i),'String'));
		end
		clear i
		
		nspacing = Height/(length(f)+1);
		for i = 1:length(f)
			control(i) = uicontrol(controlfig,'Position',[70 Height-i*nspacing 230 20],'Style', 'slider','FontSize',12,'Callback',@SliderCallback,'Min',lb(i),'Max',ub(i),'Value',(lb(i)+ub(i))/2);
			try    % R2013b and older
			   addlistener(control(i),'ActionEvent',@SliderCallback);
			catch  % R2014a and newer
			   addlistener(control(i),'ContinuousValueChange',@SliderCallback);
			end
			% hat tip: http://undocumentedmatlab.com/blog/continuous-slider-callback
			thisstring = strkat(f{i},'=',mat2str(eval(strcat('p.',f{i}))));
			controllabel(i) = uicontrol(controlfig,'Position',[10 Height-i*nspacing 50 20],'style','text','String',thisstring);
			lbcontrol(i) = uicontrol(controlfig,'Position',[300 Height-i*nspacing 40 20],'style','edit','String',mat2str(lb(i)),'Callback',@RedrawSlider);
			ubcontrol(i) = uicontrol(controlfig,'Position',[350 Height-i*nspacing 40 20],'style','edit','String',mat2str(ub(i)),'Callback',@RedrawSlider);
		end
		clear i
	else
		% find the control that is being changed
		this_control=[find(lbcontrol==src) find(ubcontrol==src)];

		% change the upper and lower bounds of this slider
		set(control(this_control),'Min',str2num(get(lbcontrol(this_control),'String')));
		set(control(this_control),'Max',str2num(get(ubcontrol(this_control),'String')));

	end
end            

function  [] = SliderCallback(src,~)

	% figure out which slider was moved
	this_slider = find(control == src);

	% update the value
	f = fieldnames(p);
	f=f(valid_fields);
	
	thisval = get(control(this_slider),'Value');
	eval((strcat('p.',f{this_slider},'=thisval;')));
	thisstring = strkat(f{this_slider},'=',oval(eval(strcat('p.',f{this_slider})),2));

	% update the label
	controllabel(this_slider) = uicontrol(controlfig,'Position',[10 Height-this_slider*nspacing 50 20],'style','text','String',thisstring);

	% disable all the sliders while the model is being evaluated
	set(control,'Enable','off')
	set(controlfig,'Name','...')

	% evalaute the model and update the plot
	EvaluateModel2(stimplot,respplot,plot_these)

	% re-enable all the sliders
	set(control,'Enable','on')


end


end