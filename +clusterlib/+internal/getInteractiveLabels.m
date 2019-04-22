function [L, names] = getInteractiveLabels(ax_handle)

% figure out the original dataset-- this will be the biggest one



% get all data in this axis
all_data = ax_handle.Children;

data_size = zeros(length(all_data),1);

names = {};
group_idx = [];

for i = length(all_data):-1:1


	if ~isa(all_data(i),'matlab.graphics.chart.primitive.Line')
		continue
	end
	data_size(i) = length(all_data(i).XData);

	if isempty(all_data(i).Tag)
		continue
	end

	if ~any(strfind(all_data(i).Tag,'clusterlib::interactive'))
		continue
	end

	names{end+1} = (strrep(all_data(i).Tag,'clusterlib::interactive ',''));
	group_idx(end+1) = i;

end

[~,idx] = max(data_size);
X = all_data(idx).XData;
Y = all_data(idx).YData;

L = NaN*X;

for i = 1:length(names)

	this_X = all_data(group_idx(i)).XData;
	this_Y = all_data(group_idx(i)).YData;


	L(ismember(X,this_X) & ismember(Y,this_Y)) = group_idx(i);

end
