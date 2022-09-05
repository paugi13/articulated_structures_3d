classdef FdataAssembler < handle
    %Force matrix assembly for correct displacement calculus.
    
    properties (Access = public)
        Fdata
    end
    
    properties (Access = private)
        W_M 
        L 
        D 
        T
    end
    
    methods (Access = public)
        function obj = FdataAssembler(cParams)
            obj.init(cParams);
        end
        
        function forceMatrixAssembly(obj)
            obj.Fdata = obj.assembleMatrix();
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.W_M = cParams.W_M;
            obj.L = cParams.L;
            obj.D = cParams.D;
            obj.T = cParams.T;
        end
        function Fdata = assembleMatrix(obj)
            % C1: Node. C2: DOF. C3: Value
            Fdata = [1 3 -obj.W_M/2;
                2 6 -obj.W_M/2;
                3 9 obj.L/5;
                4 12 obj.L/5;
                5 15 obj.L/5;
                6 18 obj.L/5;
                7 21 obj.L/5;
                3 7 -obj.D/5;
                4 10 -obj.D/5;
                5 13 -obj.D/5;
                6 16 -obj.D/5;
                7 19 -obj.D/5;
                1 1 obj.T/2;
                2 4 obj.T/2;
                ];
        end
    end
end

