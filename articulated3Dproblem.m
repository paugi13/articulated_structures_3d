classdef articulated3Dproblem < problemDef
    %UNTITLED Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = private)
        KG
        K_e
        
        Fext
        
        R
        u_method
        
        eps
        sig
    end
    
    methods (Access = public)
        function obj = initializeProblem()
            
        end
        
        function solver(obj)
            obj.assembleKG();
            obj.applyConditions();
            obj.computeF();
            [obj.u_method,obj.R] = solveSys(vL,vR,uR,obj.KG,obj.Fext);
            [obj.eps,obj.sig] = computeStrainStressBar(n_d,...
                n_el,obj.u_method,Td,x,Tnod,mat,Tmat);
        end
       
        
    end
    
    methods (Access = private)
        
        function asssembleKG(obj)
            obj.K_e = computeKelBar(n_d,n_el,x,Tnod,mat,Tmat);
            obj.KG = assemblyKG(obj.n_el,obj.n_el_dof,obj.n_dof,obj.Td,...
                obj.K_e);
        end
        
        function applyConditions(obj)
            [obj.vL,obj.vR,obj.uR] = applyCond(n_i,n_dof,fixNod);
        end
        
        function computeF(obj)
            F_bar = density_calc(x,mat, Tmat, obj.n_el, obj.Td, obj.Tnod);
            [T,L,D,~,~,~] =  equilibrio_momentos(F_bar,...
                W_M,H,W);
            Fdata = computeFdata(W_M, L, D, T);
            obj.Fext = computeF(obj.n_i,obj.n_dof, Fdata, F_bar);
        end
    end
    
    
end

