classdef BoundaryConditionsSetter < handle
    % Class to apply the boundary conditions knowing the restricted DOFs
    
    properties (Access = public)
        v_R
        v_L
        u_R
    end
    
    properties (Access = private)
        n_dof
        fixNodes
    end
    
    methods (Access = public)
        function obj = BoundaryConditionsSetter(cParams)
            obj.init(cParams);
        end
        
        function applyConditions(obj)
         
            fixNod_global = globalDofSetter(obj);
            obj.restrictedDofVectorBuilder(fixNod_global);
            obj.v_L = zeros(obj.n_dof-size(obj.fixNodes,1), 1);         
            g = 1;
            for j = 1:obj.n_dof  
            g = discriminateVR(obj, j, g);  
            end

            % Vector with displacements of the fixed nodes. 
            obj.initializeUR();
            %Fer loop per casos diferents de 0

        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.n_dof = cParams.n_dof;
            obj.fixNodes = cParams.fixNod;
        end
        
        function fixNod_global = globalDofSetter(obj)
            r = size(obj.fixNodes, 1);
            c = size(obj.fixNodes, 2);
            fixNod_global = zeros(r, c);
            
            for i = 1:size(obj.fixNodes,1) 
                if obj.fixNodes(i,2) == 1
                    fixNod_global(i,2) = obj.fixNodes(i,1)*3-2;
                end

                if obj.fixNodes(i,2) == 2
                    fixNod_global(i,2) = obj.fixNodes(i,1)*3-1;
                end

                if obj.fixNodes(i,2) == 3
                    fixNod_global(i,2) = obj.fixNodes(i,1)*3;
                end
            end
        
        end
        
        function restrictedDofVectorBuilder(obj, fixNod_global)
            s_rest = size(fixNod_global,1);
            vRest = zeros(s_rest, 1);
            for i = 1:size(fixNod_global,1)
                vRest(i, 1)=fixNod_global(i,2);
            end
            obj.v_R = vRest;
        end
        
        function g = discriminateVR(obj, j, g)
            a = 0;
            for i=1:size(obj.v_R, 1)
                if j == obj.v_R(i,1)
                a = 1;
                end
            end
            if a == 0
                obj.v_L(g,1) = j;
                g=g+1;
            end    
        end
        
        function initializeUR(obj)
            obj.u_R = zeros(size(obj.fixNodes,1), 1);
        end
    end
end

