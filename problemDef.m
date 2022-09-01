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
    
    methods (Access = protected)
        
        function connectivityDOFs(obj)
            obj.Td = connectDOFs(obj.n_el,obj.n_nod,obj.n_i,obj.Tnod);
        end
        
    end
end

