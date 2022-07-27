classdef IterativeSolver < solver
% uL = KLL\(F_ext_L - KLR*uR);

methods (Access = public)
    function uL = iterativeSolver(obj)
        uL = pcg(obj.KLL, obj.vector);
    end
        
end
    
end