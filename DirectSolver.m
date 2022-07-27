classdef DirectSolver < solver
    
    methods (Access = public)
        function uL = directsolver(obj)
            uL = obj.KLL\obj.vector;
        end
    end
end