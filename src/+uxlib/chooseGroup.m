% creates a UX element that allows you to choose from a list of items, or enter a new one 


function choice = chooseGroup(group_names)

if nargin == 0
	group_names = {};
end

d = dialog('Position',[300 300 550 150],'Name','Choose group name');

if ~isempty(group_names)
	uicontrol('Parent',d,'Style','popup','Units','normalized','Position',[.25 .5 .5 .25],'String',group_names,'Callback',@chooseGroup_callback,'FontSize',20);
end

uicontrol('Parent',d,'Style','edit','Units','normalized','Position',[.25 0.1 .5 .25],'String','','Callback',@chooseGroup_callback,'FontSize',20);



choice = 'default';

% Wait for d to close before running to completion
uiwait(d);

	function chooseGroup_callback(src,~)

		if strcmp(src.Style,'edit')
			choice = src.String;
		else
			idx = src.Value;
			popup_items = src.String;
			choice = char(popup_items(idx,:));
		end


	end


end