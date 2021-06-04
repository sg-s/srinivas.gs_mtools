function ISIraster(varargin)


if isa(varargin{1},'matlab.graphics.axis.Axes')
	ax = varargin{1};
	varargin(1) = [];
else
	ax = gca;
end



isis = veclib.nonnans(varargin{1});
varargin(1) = [];

spiketimes = cumsum(isis);
spiketimes = spiketimes(:);
spiketimes = [0; spiketimes];


neurolib.raster(ax,spiketimes,varargin{:})