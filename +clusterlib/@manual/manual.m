classdef manual < ConstructableHandle

properties

    labels@categorical = categorical({'Undefined'});
    idx@categorical
    
    RawData
    ReducedData

    DisplayFcn@function_handle

    AllowNewClasses@logical = true


    MouseCallback@function_handle

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

        self.idx = repmat(categorical({'Undefined'}),N,1);

    end



    function self = set.labels(self, value)
        self.labels = [value(:); categorical({'Undefined'})];
    end


end % methods 


end % classdef