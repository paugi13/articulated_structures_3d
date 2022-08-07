classdef unitTesting < structureParameters
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties 
    end
    
    methods
        function testKGmatrix(obj)
        % Test to check stiffness matrix
        % As it is difficult to assign expected values, its symmetry is
        % checked instead. 
            if obj.KG ~= transpose(obj.KG)
                error('error: stiffness matrix not assembled properly');
            end
        end
        
        function testForces(obj)
            b = 0;
            for i=1:size(obj.R,1)
                if obj.R(i) > 1e-6
                    b = 1;
                end
            end
            assert(b == 0, 'Reaction forces are appearing');
        end
        
        function testDisplacements(u, obj)
            b=0;
           for i = 1:size(obj.u,1)
               if abs(obj.u(i)-u(i)) > 1e-6
                    b = 1;
                end
           end
           assert(b==0, 'Displacements are not well calculated');
        end
            
    end
end

