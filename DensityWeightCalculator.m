classdef DensityWeightCalculator < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        Fbar
    end
    
    properties (Access = private)
            x    
            mat  
            Tmat
            n_el 
            Td 
            Tnod
    end
    
    methods (Access = public)
        function obj = DensityWeightCalculator(cParams)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.init(cParams);
        end
        
        function calculateWeights(obj)
            j=1;
            F_bar_data = zeros(2*obj.n_el, 3);
            
            for i=1:obj.n_el
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = obj.getCoords(i);
                l_e = DensityWeightCalculator.calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e);
                W_bar = obj.weightCalculator(l_e, i);
                
                F_bar_data(j,:) = forceDataMatrix(obj, i, 3, W_bar);
                j = j+1;
                F_bar_data(j,:) = forceDataMatrix(obj, i, 6, W_bar);
                j = j+1;
            end
            obj.Fbar = F_bar_data;
        end
       
    end
    
    methods (Access = private)
    
        function init(obj, cParams)
           obj.x = cParams.x;
           obj.mat = cParams.mat;
           obj.Tmat = cParams.Tmat;
           obj.n_el = cParams.n_el;
           obj.Td = cParams.Td;
           obj.Tnod = cParams.Tnod;
        end
        
        function [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = getCoords(obj, i)
                x_1_e= obj.x(obj.Tnod(i,1),1);
                x_2_e= obj.x(obj.Tnod(i,2),1);
                y_1_e= obj.x(obj.Tnod(i,1),2);
                y_2_e= obj.x(obj.Tnod(i,2),2);
                z_1_e= obj.x(obj.Tnod(i,1),3);
                z_2_e= obj.x(obj.Tnod(i,2),3);
        end
        
        function W_bar = weightCalculator(obj, l_e, i)
            A = obj.mat(obj.Tmat(i),2);
            rho = obj.mat(obj.Tmat(i),3);
            W_bar = rho*A*l_e*9.81/2;
            
        end
        
        function F_bar_data = forceDataMatrix(obj, i, n, W_bar)
            F_bar_data = [obj.Td(i,n)/3 obj.Td(i,n) -W_bar];
        end
        
    
    end
    
    methods (Static)
        function l_e = calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e)
            l_e= sqrt((x_2_e-x_1_e)^2+(y_2_e-y_1_e)^2+(z_2_e-z_1_e)^2);
        end
    end
end

