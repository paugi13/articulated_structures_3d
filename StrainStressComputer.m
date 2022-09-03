classdef StrainStressComputer < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = public)
        eps_comp
        sig_comp
    end
    
    properties (Access = private)
        n_d
        n_el
        u_method
        Td
        x                
        Tnod
        mat
        Tmat
    end
    
    methods (Access = public)
        function obj = StrainStressComputer(cParams)
            obj.init(cParams);
        end
        
        function computeStrainStress(obj)
            R_e = zeros(2, 2*obj.n_d, obj.n_el);
            l_e = zeros(obj.n_el,1);
            E_e = zeros(obj.n_el,1);
            for i=1:obj.n_el
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = getCoords(obj, i);           
                l_e(i)= StrainStressComputer.calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, ...
                    z_1_e, z_2_e);
                R_e_aux = StrainStressComputer.calculateRotMatrix(x_1_e, x_2_e, y_1_e, y_2_e, ...
                    z_1_e, z_2_e, l_e(i));
               R_e(:,:,i)= R_e_aux;
               E_e(i) = obj.mat(obj.Tmat(i),1);
            end        
            u_e_global = displacementPerElementGlobal(obj);
            u_e_local = disPerElementLocal(obj, u_e_global, R_e);
            
            obj.epsSigCalculator(E_e, l_e, u_e_local)
        
        end
        
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.n_d = cParams.n_d;
            obj.n_el = cParams.n_el;
            obj.u_method = cParams.u_method;
            obj.Td = cParams.Td;
            obj.x = cParams.x;                
            obj.Tnod = cParams.Tnod;
            obj.mat = cParams.mat;
            obj.Tmat = cParams.Tmat;
        end
        
        function [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = getCoords(obj, i)
                x_1_e= obj.x(obj.Tnod(i,1),1);
                x_2_e= obj.x(obj.Tnod(i,2),1);
                y_1_e= obj.x(obj.Tnod(i,1),2);
                y_2_e= obj.x(obj.Tnod(i,2),2);
                z_1_e= obj.x(obj.Tnod(i,1),3);
                z_2_e= obj.x(obj.Tnod(i,2),3);
        end
        
        function u_global = displacementPerElementGlobal(obj)
            u_global = zeros(size(obj.Td,2), 1, obj.n_el);

            for i = 1:obj.n_el      %Line selector in Td
                for j = 1:size(obj.Td,2)    %Column selector in Td
                    u_global(j, 1, i) = obj.u_method(obj.Td(i, j), 1);
                end
            end
        end
        
        function u_local = disPerElementLocal(obj, u_global, R_e)

            u_local = zeros(2, 1, obj.n_el);
            %size(Td,2)
            for i = 1:obj.n_el
                u_local(:, 1, i) = R_e(:,:,i)*u_global(:,1,i);
            end
        end
        
        function epsSigCalculator(obj, E_e, l_e, u_e_local)
            eps = zeros(obj.n_el, 1);
            sig = zeros(obj.n_el, 1);

            for i = 1:obj.n_el
                eps(i,1) = 1/l_e(i)*[-1 1 ]*u_e_local(:, 1, i);
                sig(i,1) = E_e(i)*eps(i,1);
            end
        obj.eps_comp = eps;
        obj.sig_comp = sig;
        end

    end
    
    methods (Static)
        function l_e = calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e)
            l_e= sqrt((x_2_e-x_1_e)^2+(y_2_e-y_1_e)^2+(z_2_e-z_1_e)^2);
        end
        
        function R_e = calculateRotMatrix(x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e, l_e)
            R_e = 1/l_e*[x_2_e-x_1_e y_2_e-y_1_e z_2_e-z_1_e 0 0 0;
                            0 0 0 x_2_e-x_1_e y_2_e-y_1_e z_2_e-z_1_e
                    ];
        end
    
    end
end

