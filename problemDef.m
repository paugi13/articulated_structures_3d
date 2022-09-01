classdef problemDef < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Constant)
        % Earth's gravity
        g = 9.81
    end
    
    properties (Access = private)
        % Problem's geommetry
        H
        W
        B
        D1 
        d1
        D2

        % Mass
        M
        
        % Weight's node app
        x
        Tnod
        fixNod
        mat
        Tmat
    end 
    
    properties (Access = protected)
        n_d              % Number of dimensions
        n_i              % Number of DOFs for each node
        n                % Total number of nodes
        n_dof            % Total number of degrees of freedom
        n_el             % Total number of elements
        n_nod            % Number of nodes for each element
        n_el_dof         % Number of DOFs for each element
        
        Td
    end
    
    %Only one public method is defined to prepare the object for other
    %purposes stored in other constructors like the articulated3Dproblem
    %one. 
    
    methods (Access = public)
        function obj = setProperties(H, W, B, D1, d1, D2, M, x, Tnod, fixNod,...
                n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof, mat, Tmat)
            obj.getGeommetry(H, W, B, D1, d1, D2, M, x, Tnod, fixNod, ...
                mat, Tmat);
            obj.getNodes(n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof);
            obj.connectivityDOFs(n_el,n_nod,n_i,Tnod);
        end
    end
    
    methods (Access = protected)
        
        function connectivityDOFs(n_el,n_nod,n_i,Tnod)
            obj.Td = connectDOFs(n_el,n_nod,n_i,Tnod);
        end
        
        function getGeommetry(H, W, B, D1, d1, D2, M, x, Tnod, fixNod, ...
                mat, Tmat)
            obj.H = H;
            obj.W = W;
            obj.B = B;
            obj.D1 = D1;
            obj.d1 = d1;
            obj.D2 = D2;
            obj.M = M;
            obj.x = x;
            obj.Tnod = Tnod;
            obj.fixNod = fixNod;
            obj.mat = mat;
            obj.Tmat = Tmat;
        end
        
        function getNodes(n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof)
            obj.n_d = n_d;
            obj.n = n;
            obj.n_i = n_i;
            obj.n_dof = n_dof;
            obj.n_el = n_el;
            obj.n_nod = n_nod;
            obj.n_el_dof = n_el_dof;
        end
        
    end
end

