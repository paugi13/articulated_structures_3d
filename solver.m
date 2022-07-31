classdef solver
% uL = KLL\(F_ext_L - KLR*uR);
    properties (Access = protected)
        KLL
        vector
        KG
    end
end
