classdef StrainStressComputer < handle
    
    properties (Access = public)
        epsComp
        sigComp
    end
    
    properties (Access = private)
        nD
        nEl
        uMethod
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
            R_e = zeros(2, 2*obj.nD, obj.nEl);
            l_e = zeros(obj.nEl,1);
            E_e = zeros(obj.nEl,1);
            for i=1:obj.nEl
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = getCoords(obj, i);
                s.x1 = x_1_e;
                s.x2 = x_2_e;
                s.y1 = y_1_e;
                s.y2 = y_2_e;
                s.z1 = z_1_e;
                s.z2 = z_2_e;
                bar = BarCalculator(s);
                bar.calculateParameters();
%                 l_e(i)= StrainStressComputer.calculateBarLength(x_1_e, x_2_e, y_1_e, y_2_e, ...
%                     z_1_e, z_2_e);
%                 R_e_aux = StrainStressComputer.calculateRotMatrix(x_1_e, x_2_e, y_1_e, y_2_e, ...
%                     z_1_e, z_2_e, l_e(i));
               R_e(:,:,i)= bar.rotMat;
               E_e(i) = obj.mat(obj.Tmat(i),1);
            end        
            u_e_global = displacementPerElementGlobal(obj);
            u_e_local = disPerElementLocal(obj, u_e_global, R_e);
            
            obj.epsSigCalculator(E_e, l_e, u_e_local)
        
        end
        
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.nD = cParams.nD;
            obj.nEl = cParams.nEl;
            obj.uMethod = cParams.uMethod;
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
            u_global = zeros(size(obj.Td,2), 1, obj.nEl);

            for i = 1:obj.nEl      %Line selector in Td
                for j = 1:size(obj.Td,2)    %Column selector in Td
                    u_global(j, 1, i) = obj.uMethod(obj.Td(i, j), 1);
                end
            end
        end
        
        function u_local = disPerElementLocal(obj, u_global, R_e)

            u_local = zeros(2, 1, obj.nEl);
            %size(Td,2)
            for i = 1:obj.nEl
                u_local(:, 1, i) = R_e(:,:,i)*u_global(:,1,i);
            end
        end
        
        function epsSigCalculator(obj, E_e, l_e, u_e_local)
            eps = zeros(obj.nEl, 1);
            sig = zeros(obj.nEl, 1);

            for i = 1:obj.nEl
                eps(i,1) = 1/l_e(i)*[-1 1 ]*u_e_local(:, 1, i);
                sig(i,1) = E_e(i)*eps(i,1);
            end
        obj.epsComp = eps;
        obj.sigComp = sig;
        end

    end
    
end

