classdef unitTesting < solver
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
    end
    
    methods
        function testKGmatrix(obj)
        % Test to check stiffness matrix
        % As it is difficult to assign expected values, its symmetry is
        % checked instead. 
            assert(obj.KG == obj.KG.');
        end
        
        function testForces(obj)
            
        end
    end
end

