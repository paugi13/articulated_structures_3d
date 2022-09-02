classdef ElementalStiffnessMat < handle
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        K_e
    end
    
    properties (Access = private)
        n_d
        n_el
        x
        mat
        Tmat
        Tnod
    end
    
    methods (Access = public)
        function obj = ElementalStiffnessMat(cParams)
            %UNTITLED Construct an instance of this class
            %   Detailed explanation goes here
            obj.init(cParams)
        end
        
        function computeKel(obj)
            Ke = zeros(2*obj.n_d, 2*obj.n_d, obj.n_el);
            for i=1:obj.n_el
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = obj.getCoords(i);
                l_e = obj.calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e);
                R_e = calculateRotMatrix(obj, x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e, l_e);
                Kel = KeCalc(obj, i, l_e);
                Ke(:,:,i) = K_e_Calc(obj, R_e, Kel);
            end
            
            obj.K_e = Ke;
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.n_d  = cParams.n_d;
            obj.n_el = cParams.n_el;
            obj.x    = cParams.x;
            obj.mat  = cParams.mat;
            obj.Tmat = cParams.Tmat;
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
        
        function l_e = calculateBarLength(obj, x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e)
            l_e= sqrt((x_2_e-x_1_e)^2+(y_2_e-y_1_e)^2+(z_2_e-z_1_e)^2);
        end
        
        function R_e = calculateRotMatrix(obj, x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e, l_e)
            R_e = 1/l_e*[x_2_e-x_1_e y_2_e-y_1_e z_2_e-z_1_e 0 0 0;
                            0 0 0 x_2_e-x_1_e y_2_e-y_1_e z_2_e-z_1_e
                    ];
        end
        
        function Kel = KeCalc(obj, i, l_e)
            material = obj.Tmat(i);
            young = obj.mat(material,1);
            area = obj.mat(material,2);
            Kel= young*area/l_e*[1 -1; -1 1];
        end
        
        function K_e = K_e_Calc(obj, R_e, Kel)
            K_e = R_e.'*Kel*R_e;
        end
    end
end
