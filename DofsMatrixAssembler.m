classdef DofsMatrixAssembler < handle
    %UNTITLED3 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Td
    end
    
    properties (Access = private)
        n_el
        n_nod
        n_i
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
            obj.n_el = cParams.n_el;
            obj.n_nod = cParams.n_nod;
            obj.n_i = cParams.n_i;
            obj.Tnod = cParams.Tnod;
        end
        
        function TdAssembler(obj)
            T_d = zeros(obj.n_el, obj.n_i*obj.n_nod);

            for i=1:obj.n_el
                T_d(i,:) = [obj.Tnod(i,1)*3-2 obj.Tnod(i,1)*3-1 ...
                    obj.Tnod(i,1)*3 obj.Tnod(i,2)*3-2 ...
                    obj.Tnod(i,2)*3-1 obj.Tnod(i,2)*3];
            end
            obj.Td = T_d;
        end
    end
end

