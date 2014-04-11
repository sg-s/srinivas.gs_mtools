% Manipulate.m
% Mathematica-stype model manipulation
% usage: 
% Manipulate('function.m',p,x,R)
% where p is a structure containining the parameters of the model you want to manipulate 
% function should accept two inputs, time and x, and a third input which is a structure specifying parameters
% x is the stimulus input
% and R is an optional reference output that will be plotted with the model output
% 
% 
% created by Srinivas Gorur-Shandilya at 10:20 , 09 April 2014. Contact me at http://srinivas.gs/contact/
% 
% This work is licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. 
% To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.


function [p] = Manipulate(fname,p,x,R)
plotfig = figure('position',[50 250 900 740],'NumberTitle','off','IntegerHandle','off');
stimplot = subplot(2,1,1);
respplot = subplot(2,1,2);



% link plots
linkaxes([stimplot respplot],'x');
Height = 440;
controlfig = figure('position',[1000 250 400 Height], 'Toolbar','none','Menubar','none','NumberTitle','off','IntegerHandle','off');

r = [];
pp = struct2mat(p);
lb = abs(pp/2);
ub = abs(pp*2);
for i = 1:length(lb)
	if lb(i) == ub(i)
		lb(i) = 0;
		ub(i) = 1;
	end
end
clear i
lbcontrol = [];
ubcontrol = [];
control = [];
controllabel = [];
nspacing = [];

% plot the stimulus
plot(stimplot,x)

RedrawSlider;
EvaluateModel;


            
function [] = EvaluateModel()
	% get the XLim 
	xl = get(respplot,'XLim');
	eval(strcat('[r]=',fname,'(x,p);'));
	% update plot
	cla(respplot);
	figure(plotfig);
	axis(respplot); hold on;
	plot(R)
	plot(r,'r','LineWidth',2);
	hold off
	if xl(1) ~= 0
		set(respplot,'XLim',xl);
	end
end

function [] = RedrawSlider(eo,ed)
	% reset lower and upper bounds
	f = fieldnames(p);
	for i = 1:length(lbcontrol)
		lb(i)=str2num(get(lbcontrol(i),'String'));
		ub(i)=str2num(get(ubcontrol(i),'String'));
	end
	clear i

	delete(lbcontrol);
	delete(control);
	delete(ubcontrol);
	delete(controllabel);
	
	nspacing = Height/(length(f)+1);
	for i = 1:length(f)
		control(i) = uicontrol(controlfig,'Position',[70 Height-i*nspacing 230 20],'Style', 'slider','FontSize',12,'Callback',@SliderCallback,'Min',lb(i),'Max',ub(i),'Value',(lb(i)+ub(i))/2);
		thisstring = strkat(f{i},'=',mat2str(eval(strcat('p.',f{i}))));
		controllabel(i) = uicontrol(controlfig,'Position',[10 Height-i*nspacing 50 20],'style','text','String',thisstring);
		lbcontrol(i) = uicontrol(controlfig,'Position',[300 Height-i*nspacing 40 20],'style','edit','String',mat2str(lb(i)),'Callback',@RedrawSlider);
		ubcontrol(i) = uicontrol(controlfig,'Position',[350 Height-i*nspacing 40 20],'style','edit','String',mat2str(ub(i)),'Callback',@RedrawSlider);
	end
	clear i
end            

function  [] = SliderCallback(eo,ed)
	% update the value
	f = fieldnames(p);
	delete(controllabel)
	
	for i = 1:length(f)
		thisval = get(control(i),'Value');
		eval((strcat('p.',f{i},'=thisval;')));
		thisstring = strkat(f{i},'=',oval(eval(strcat('p.',f{i})),2));
		controllabel(i) = uicontrol(controlfig,'Position',[10 Height-i*nspacing 50 20],'style','text','String',thisstring);

	end
	clear i

	% evalaute the model and update the plot
	EvaluateModel;

end


end