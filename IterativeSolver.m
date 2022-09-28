classdef IterativeSolver < handle
% uL = KLL\(F_ext_L - KLR*uR);

    properties (Access = public)
        alphaX
    end
    
    
    properties (Access = private)
        KLL
        vector
    end
    
    methods (Access = public)
        function obj = IterativeSolver(cParams)
            obj.init(cParams);
        end
        
        function solveIterative(obj)
            obj.alphaX = obj.solve();
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.KLL    = cParams.KLL;
            obj.vector = cParams.vect;
        end
        
        function alpha = solve(obj)
            alpha = pcg(obj.KLL, obj.vector);
        end
    end
    
    
    
end