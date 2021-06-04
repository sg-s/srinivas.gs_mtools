% makes a grid of axes useful for plotting
% things that exist on a matrix

function ax = gridAxes(varargin)

if isa(varargin{1},'matlab.ui.Figure')
	fig = varargin{1};
	varargin(1) = [];
else
	fig = gcf;
end


figure(fig)


N = varargin{1};

for i = 1:N-1
	for j = i+1:N
		idx = (j-2)*(N-1) + i;
		ax(i,j) = subplot(N-1,N-1, idx );
	end
end
