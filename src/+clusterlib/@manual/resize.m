% this function keeps track of the window position
% when we resize so that the next time we open it, 
% it opens in the same position

function resize(self,~,~)


if isempty(self.handles)
	return
end

if ~isfield(self.handles,'main_fig')
	return
end


if ~isvalid(self.handles.main_fig)
	return
end

p = self.handles.main_fig.Position;

setpref('clusterlib','ManualPosition',p);
