% function to help you interactive
% cluster data. can be built on top of any 
% figure! 
% to get data out of this, use clusterlib.getInteractiveLabels
function interactive(src,~)


if nargin == 0
	fig_handle =  gcf;
else

	% figure out the figure that called this
	goon = true;
	while goon
		if isa(src.Parent,'matlab.ui.Figure')
			fig_handle = src.Parent;
			goon = false;
		else
			src = src.Parent;
		end
	end
end

% now find the likely axes that this needs to be applied to
% we will do this on the biggest axes by default
C = fig_handle.Children;
S = zeros(length(C),1);
for i = 1:length(C)
	if ~isa(C(i),'matlab.graphics.axis.Axes')
		continue
	end

	p = C(i).Position;
	S(i) = p(3)*p(4);
end

[~,idx]=max(S);
ax_handle = C(idx);

ifh = imfreehand(ax_handle);
p = getPosition(ifh);

% get all data in this axis
all_data = ax_handle.Children;
X = [];
Y = [];
existing_cluster_names = {};
n_groups = 0;
for i = length(all_data):-1:1

	existing_cluster_names{i} = '';

	if ~isa(all_data(i),'matlab.graphics.chart.primitive.Line')
		continue
	end
	X = [X all_data(i).XData];
	Y = [Y all_data(i).YData];

	if isempty(all_data(i).Tag)
		continue
	end

	if ~any(strfind(all_data(i).Tag,'clusterlib::interactive'))
		continue
	end

	existing_cluster_names{i} = (strrep(all_data(i).Tag,'clusterlib::interactive ',''));
	n_groups = n_groups + 1;
end


inp = inpolygon(X,Y,p(:,1),p(:,2));

% ask the user which group to put this in 
group_name = uxlib.chooseGroup(existing_cluster_names);
group_idx = find(strcmp(existing_cluster_names,group_name));

if isempty(group_idx)

	disp('new group')
	c = lines(100);
	C = c(n_groups+1,:);

	% put selected points in this group
	ph = plot(ax_handle,X(inp),Y(inp),'.','Color',C,'MarkerSize',20);
	ph.Tag = ['clusterlib::interactive ' group_name];

	ph.DisplayName = group_name;

else
	disp('adding to existing group...')

	all_data(group_idx).XData = [all_data(group_idx).XData X(inp)];
	all_data(group_idx).YData = [all_data(group_idx).YData Y(inp)];
end


% delete all cruft
rm_this = false(length(all_data),1);
for i = 1:length(all_data)
	if isa(all_data(i),'matlab.graphics.primitive.Group')
		rm_this(i) = true;
	end
end

delete(all_data(rm_this))

legend