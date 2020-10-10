classdef manual < ConstructableHandle

properties

    labels categorical = categorical(NaN);
    idx categorical
    
    RawData
    ReducedData

    DisplayFcn function_handle

    AllowNewClasses (1,1) logical = true


    MouseCallbackFcn function_handle

    handles struct

    ColorMap

    CurrentPoint (1,1) double = NaN
end % props

properties (Access = protected)
    DrawingClusters (1,1) logical = false;
end




methods 


    function self = manual(varargin)
        self = self@ConstructableHandle(varargin{:});  

    end


    function self = set.ReducedData(self, value)

        sz = size(value);

        assert(length(sz) == 2,'ReducedData must be 2D')
        assert(min(sz) == 2,'ReducedData must be 2D')

        if sz(1) == 2
            value = value';
        end
        N = size(value,1);

        self.ReducedData = value;

    end



    function self = set.idx(self, value)

        self.idx = value;
        
        d = dbstack;
        if any(strcmp({d.name},'manual.set.ReducedData'))
            
            return
        end

    end


    function set.CurrentPoint(self,value)

        assert(isscalar(value),'Value must be scalar')

        self.handles.CurrentPointReduced.XData = self.ReducedData(value,1);
        self.handles.CurrentPointReduced.YData = self.ReducedData(value,2);

        self.CurrentPoint = value;

    end 


end % methods 


end % classdef