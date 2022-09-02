classdef KGassembler < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Kg
    end
    
    properties (Access = private)
        n_el_dof 
        n_dof 
        n_el 
        K_e
        Td
    end
    
    methods (Access = public)
        function obj = KGassembler(cParams)
            obj.init(cParams);
        end
        
        function assembleMatrix(obj)
           KG = zeros(obj.n_dof, obj.n_dof);
            for e = 1:obj.n_el
                for i = 1:obj.n_el_dof
                    I = obj.Td(e,i);
                    for j = 1:obj.n_el_dof
                        J = obj.Td(e,j);
                        KG(I,J) = KG(I,J) + obj.K_e(i,j,e); 
                    end
                end
            end 
            
            obj.Kg = KG;
        end

    end
    
    
    methods (Access = private)
    
        function init(obj, cParams)
            obj.n_el_dof = cParams.n_el_dof;
            obj.n_dof = cParams.n_dof;
            obj.n_el = cParams.n_el;
            obj.Td = cParams.Td;
            obj.K_e = cParams.K_e;
        end
 
    end
end

