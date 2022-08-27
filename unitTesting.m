classdef unitTesting < articulated3Dproblem
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        KG
        R
        u
    end
    
    methods
        function obj = testInitializer(artObj)
            obj.KG = artObj.KG;
            obj.R = artObj.R;
            obj.u = artObj.u;
        end
        
        function testKGmatrix(obj)
        % Test to check stiffness matrix
        % As it is difficult to assign expected values, its symmetry is
        % checked instead. 
        load('test3_variable_u');
        b = 0;
        for i = 1:size(KG,1)
           for j = 1:size(KG,2)
                if abs(obj.KG(i,j)-KG(i,j)) > 1e-6
                    b = 1;
                end
           end
        end
        assert(b==0, 'KG matrix has not been assembled correctly');
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
        
        function testDisplacements(obj)
            b=0;
            load('test3_variable_u');
           for i = 1:size(obj.u,1)
               if abs(obj.u(i)-u(i)) > 1e-6
                    b = 1;
                end
           end
           assert(b==0, 'Displacements are not well calculated');
        end
            
    end
end

