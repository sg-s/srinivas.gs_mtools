% Manipulate.m
% Mathematica-stype model manipulation
% usage: 
% Manipulate(fname,p,stimulus,response,time)
% where p is a structure containing the parameters of the model you want to manipulate 
% The function to be manipulated (fname) should conform to the following standard: should accept two inputs, time and stimulus, and a third input which is a structure specifying parameters (p)
% x is the stimulus input
%
% and response is an optional reference output that will be plotted with the model output (useful if you want to manually tune some parameters to fit data)
% time is an optional time vector
% 
% Minimal Usage: 
% Manipulate(fname,p,stimulus);
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.


function [p] = Manipulate(fname,p,stimulus,response,time)
switch nargin
case 0
	help Manipulate
	return
case 1
	error('Not enough input arguments. Must supply a second argument, which is a structure containing the parameters, and a third argument which is the stimulus')	
case 2
	error('Not enough input arguments. Must supply a third argument which is the stimulus')	
case 3 
	stimulus = stimulus(:);
	response = NaN*stimulus;
	time = 1:length(stimulus);
case 4
	stimulus = stimulus(:);
	response = response(:);
	time = 1:length(stimulus);
case 5
	stimulus = stimulus(:);
	response = response(:);
end

plotfig = figure('position',[50 250 900 740],'NumberTitle','off','IntegerHandle','off','Name','Manipulate.m','CloseRequestFcn',@QuitManipulateCallback);

nplots= nargout(fname) + 1;

stimplot = autoplot(nplots,1,1);
for i = 2:nplots
	respplot(i-1) = autoplot(nplots,i,1);
end


% link plots
linkaxes([stimplot respplot],'x');
Height = 440;
controlfig = figure('position',[1000 250 400 Height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off','CloseRequestFcn',@QuitManipulateCallback);

r1 = []; r2 = []; r3 = []; r4 = []; r5 = [];
pp = struct2mat(p);
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
lbcontrol = [];
ubcontrol = [];
control = [];
controllabel = [];
nspacing = [];

% plot the stimulus
plot(stimplot,time,stimulus)

RedrawSlider(NaN,NaN);
EvaluateModel;


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

            
function [] = EvaluateModel()
	% try to figure out if the model we are evaluating requires a time vector 
	% get the XLim 
	xl = get(stimplot,'XLim');

	if nargin(fname) == 2
		% ignore time 
		es = '[';
		for j = 1:nplots-1
			es=strcat(es,'r',mat2str(j),',');
		end
		clear j
		es(end) = ']';
		es= strcat(es,'=',fname,'(stimulus,p);');
		eval(es);

	elseif nargin(fname) == 3
		% assume time is required 
		es = '[';
		for j = 1:nplots-1
			es=strcat(es,'r',mat2str(j),',');
		end
		clear j
		es(end) = ']';
		es= strcat(es,'=',fname,'(time,stimulus,p);');
		eval(es);
	else
		error('The function you are trying to manipualte has too many inputs, so I dont know what to do')
	end


	% update all the response plots
	for j = 1:length(respplot)
		cla(respplot(j));
		es='plot(respplot(j),time,r';
		es = strcat(es,mat2str(j),');');	
		eval(es);
		if xl(1) ~= 0
			set(respplot(j),'XLim',xl);
		end
	end

	
		
	
end

function [] = RedrawSlider(src,event)

	if isnan(src)

		% draw for the first time
		f = fieldnames(p);
		for i = 1:length(lbcontrol)
			lb(i)=str2num(get(lbcontrol(i),'String'));
			ub(i)=str2num(get(ubcontrol(i),'String'));
		end
		clear i
		
		nspacing = Height/(length(f)+1);
		for i = 1:length(f)
			control(i) = uicontrol(controlfig,'Position',[70 Height-i*nspacing 230 20],'Style', 'slider','FontSize',12,'Callback',@SliderCallback,'Min',lb(i),'Max',ub(i),'Value',(lb(i)+ub(i))/2);
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

function  [] = SliderCallback(src,ed)

	% figure out which slider was moved
	this_slider = find(control == src);

	% update the value
	f = fieldnames(p);
	thisval = get(control(this_slider),'Value');
	eval((strcat('p.',f{this_slider},'=thisval;')));
	thisstring = strkat(f{this_slider},'=',oval(eval(strcat('p.',f{this_slider})),2));

	% update the label
	controllabel(this_slider) = uicontrol(controlfig,'Position',[10 Height-this_slider*nspacing 50 20],'style','text','String',thisstring);



	% evalaute the model and update the plot
	EvaluateModel;

end


end