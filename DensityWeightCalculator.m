classdef DensityWeightCalculator < handle

    properties (Access = public)
        Fbar
    end
    
    properties (Access = private)
            x    
            mat  
            Tmat
            nEl 
            Td 
            Tnod
    end
    
    methods (Access = public)
        function obj = DensityWeightCalculator(cParams)
            obj.init(cParams);
        end
        
        function calculateWeights(obj)
            j=1;
            F_bar_data = zeros(2*obj.nEl, 3);
            
            for i=1:obj.nEl
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = obj.getCoords(i);
                s.x1 = x_1_e;
                s.x2 = x_2_e;
                s.y1 = y_1_e;
                s.y2 = y_2_e;
                s.z1 = z_1_e;
                s.z2 = z_2_e;
                bar = BarCalculator(s);
                bar.calculateParameters();
                W_bar = obj.weightCalculator(bar.L, i);
                
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
           obj.nEl = cParams.nEl;
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
    
end

