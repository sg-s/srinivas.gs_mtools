% this function keeps track of the window position
% when we resize so that the next time we open it, 
% it opens in the same position

function resize(self,~,~)


if isempty(self.handles)
	return
end

p = self.handles.main_fig.Position;

setpref('clusterlib','ManualPosition',p);
