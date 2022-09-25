classdef KGassembler < handle
    
    properties (Access = public)
        Kg
    end
    
    properties (Access = private)
        n_el_dof 
        n_dof 
        n_el 
        K_e
        Td
        n_d
        x
        mat
        Tmat
        Tnod
    end
    
    methods (Access = public)
        function obj = KGassembler(cParams)
            obj.init(cParams);
        end
        
        function assembleMatrix(obj)
           Ke = zeros(2*obj.n_d, 2*obj.n_d, obj.n_el);
            for i=1:obj.n_el
                [x_1_e, x_2_e, y_1_e, y_2_e, z_1_e, z_2_e] = obj.getCoords(i);
                s.x1 = x_1_e;
                s.x2 = x_2_e;
                s.y1 = y_1_e;
                s.y2 = y_2_e;
                s.z1 = z_1_e;
                s.z2 = z_2_e;
                bar = BarCalculator(s);
                bar.calculateParameters();
                Kel = KeCalc(obj, i, bar);
                bar.getKe(Kel);
                Ke(:,:,i) = bar.KeBar;
            end
            
            obj.K_e = Ke; 
            
            
           KG = zeros(obj.n_dof, obj.n_dof);
            for e = 1:obj.n_el
                for i = 1:obj.n_el_dof
                    I = obj.Td(e,i);
                    for j = 1:obj.n_el_dof
                        J = obj.Td(e,j);
                        KG(I,J) = KG(I,J) + obj.K_e(i,j,e); 
                    end
                end
            end 
            
            obj.Kg = KG;
        end

    end

 
    methods (Access = private)
        function init(obj, cParams)
            obj.n_el_dof = cParams.n_el_dof;
            obj.n_dof = cParams.n_dof;
            obj.n_el = cParams.n_el;
            obj.Td = cParams.Td;
            obj.K_e = cParams.K_e;
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
        
        function Kel = KeCalc(obj, i, bar)
            material = obj.Tmat(i);
            young = obj.mat(material,1);
            area = obj.mat(material,2);
            Kel= young*area/bar.L*[1 -1; -1 1];
        end
        
    end
    
end

