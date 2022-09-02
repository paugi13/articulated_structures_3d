classdef articulated3Dproblem < problemDef
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected)
        % Properties related to problem resolution
        KG
        K_e
        
        Fext
        
        R
        u_method
        
        eps
        sig
        
        vL
        vR
        uR
    end
    
    methods (Access = public)
%         function obj = articulated3Dproblem(objPD)
%             obj.initialize(objPD);
%         end
        
        function solver(obj)
            obj.assembleKG();
            obj.applyConditions();
            obj.computeF();
            obj.solveSystem();
            obj.computeResults();
        end
        
        function plotting(obj)
            obj.plot3D();
        end
    end
    
    methods (Access = private)
        function solveSystem(obj)
            [obj.u_method,obj.R] = solveSys(obj.vL,obj.vR,obj.uR,...
                obj.KG,obj.Fext);
        end
        
        function computeResults(obj)
            [obj.eps,obj.sig] = computeStrainStressBar(obj.n_d,...
                obj.n_el,obj.u_method,obj.Td,obj.x,obj.Tnod,obj.mat,obj.Tmat);
        end
            
        % Not possible because these properties could only be modified
        % through specific methods and now they are defined as constant for
        % all inheritant classes. 
%         function initialize(obj, objPD)
%             obj.H = objPD.H;
%             obj.W = objPD.W;
%             obj.B = objPD.B;
%             obj.D1 = objPD.D1;
%             obj.d1 = objPD.d1;
%             obj.D2 = objPD.D2;
%             obj.M = objPD.M;
%             obj.x = objPD.x;
%             obj.Tnod = objPD.Tnod;
%             obj.fixNod = objPD.fixNod;
%             obj.n_d = objPD.n_d;
%             obj.n = objPD.n;
%             obj.n_i = objPD.n_i;
%             obj.n_dof = objPD.n_dof;
%             obj.n_el = objPD.n_el;
%             obj.n_nod = objPD.n_nod;
%             obj.n_el_dof = objPD.n_el_dof;
%             obj.Td = objPD.Td;
%             obj.mat = objPD.mat;
%             obj.Tmat = objPD.Tmat;
%         end
        
        function assembleKG(obj)
            obj.K_e = computeKelBar(obj.n_d,obj.n_el,obj.x,obj.Tnod,obj.mat...
                ,obj.Tmat);
            obj.KG = assemblyKG(obj.n_el,obj.n_el_dof,obj.n_dof,obj.Td,...
                obj.K_e);
        end
        
        function applyConditions(obj)
            [obj.vL,obj.vR,obj.uR] = applyCond(obj.n_i,obj.n_dof,obj.fixNod);
        end
        
        function computeF(obj)
            F_bar = density_calc(obj.x,obj.mat, obj.Tmat, obj.n_el, obj.Td, obj.Tnod);
            % this restricts it to the mentioned geometry. Won't solve it
            % for any structure. 
            [T,L,D,~,~,~] =  equilibrio_momentos(F_bar,...
                obj.W_M,obj.H,obj.W);
            Fdata = computeFdata(obj.W_M, L, D, T); 
            obj.Fext = computeF(obj.n_i,obj.n_dof, Fdata, F_bar);
        end
        
        function plot3D(obj)
           scale = 100;
           plotBarStress3D(obj.x,obj.Tnod,obj.u_method,obj.sig,scale); 
        end
            
    end
  
end

