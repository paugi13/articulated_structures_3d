classdef unitTesting < articulated3Dproblem
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        K_G
        react
        U
    end
    
    methods
        function obj = unitTesting(artObj)
            obj.K_G = artObj.KG;
            obj.react = artObj.R;
            obj.U = artObj.u_method;
        end
        
        function testKGmatrix(obj)
        % Test to check stiffness matrix
        % As it is difficult to assign expected values, its symmetry is
        % checked instead. 
        load('test3_variable_u');
        b = 0;
        for i = 1:size(obj.K_G,1)
           for j = 1:size(obj.K_G,2)
                if abs(obj.K_G(i,j)-KG(i,j)) > 1e-6
                    b = 1;
                end
           end
        end
        assert(b==0, 'KG matrix has not been assembled correctly');
        end
        
        function testForces(obj)
            b = 0;
            for i=1:size(obj.react,1)
                if obj.react(i) > 1e-6
                    b = 1;
                end
            end
            assert(b == 0, 'Reaction forces are appearing');
        end
        
        function testDisplacements(obj)
            b=0;
            load('test3_variable_u');
           for i = 1:size(obj.U,1)
               if abs(obj.U(i)-u(i)) > 1e-6
                    b = 1;
                end
           end
           assert(b==0, 'Displacements are not well calculated');
        end
            
    end
end

