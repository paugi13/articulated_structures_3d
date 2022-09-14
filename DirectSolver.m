classdef DirectSolver < handle
    
    properties (Access = public)
        alphaX
    end
    
    
    properties (Access = private)
        KLL
        vector
    end
    
    methods (Access = public)
        function obj = DirectSolver(cParams)
            obj.init(cParams);
        end
        
        function solveDirect(obj)
            obj.alphaX = obj.solve();
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.KLL    = cParams.KLL;
            obj.vector = cParams.vect;
        end
        
        function alpha = solve(obj)
            alpha = obj.KLL\obj.vector;
        end
    end
    
end

%uL = obj.KLL\obj.vector;