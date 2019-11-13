classdef manual < ConstructableHandle

properties

    labels@categorical = categorical(NaN);
    idx@categorical
    
    RawData
    ReducedData

    DisplayFcn@function_handle

    AllowNewClasses@logical = true


    MouseCallbackFcn@function_handle

    handles
end % props

properties (Access = protected)
    DrawingClusters@logical = false;
end

properties (SetAccess = protected)
    CurrentPoint@double = NaN
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

        self.idx = repmat(categorical(NaN),N,1);

    end



    function self = set.idx(self, value)

        self.idx = value;
        
        d = dbstack;
        if any(strcmp({d.name},'manual.set.ReducedData'))
            
            return
        end

    end


end % methods 


end % classdef