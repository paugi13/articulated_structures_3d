classdef DofsMatrixAssembler < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Td
    end
    
    properties (Access = private)
        nEl
        nNod
        nI
        Tnod
    end
    
    methods (Access = public)
        function obj = DofsMatrixAssembler(cParams)
            obj.init(cParams);
        end
        
        function assembleTd(obj)
            obj.TdAssembler();
        end
        
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.nEl = cParams.nEl;
            obj.nNod = cParams.nNod;
            obj.nI = cParams.nI;
            obj.Tnod = cParams.Tnod;
        end
        
        function TdAssembler(obj)
            T_d = zeros(obj.nEl, obj.nI*obj.nNod);

            for i=1:obj.nEl
                T_d(i,:) = [obj.Tnod(i,1)*3-2 obj.Tnod(i,1)*3-1 ...
                    obj.Tnod(i,1)*3 obj.Tnod(i,2)*3-2 ...
                    obj.Tnod(i,2)*3-1 obj.Tnod(i,2)*3];
            end
            obj.Td = T_d;
        end
    end
end

