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
        function obj = initializeProblem(objPD)
            obj.initialize(objPD);
        end
        
        function solver(obj)
            obj.assembleKG();
            obj.applyConditions();
            obj.computeF();
            obj.solveSystem();
            obj.computeResults();
        end
    end
    
    methods (Access = private)
        function solveSystem(obj)
            [obj.u_method,obj.R] = solveSys(obj.vL,obj.vR,obj.uR,...
                obj.KG,obj.Fext);
        end
        
        function computeResults(obj)
            [obj.eps,obj.sig] = computeStrainStressBar(obj.n_d,...
                obj.n_el,obj.u_method,obj.Td,obj.x,obj.Tnod,mat,Tmat);
        end
        
        function initialize(obj, objPD)
            obj.H = objPD.H;
            obj.W = objPD.W;
            obj.B = objPD.B;
            obj.D1 = objPD.D1;
            obj.d1 = objPD.d1;
            obj.D2 = objPD.D2;
            obj.M = objPD.M;
            obj.x = objPD.x;
            obj.Tnod = objPD.Tnod;
            obj.fixNod = objPD.fixNod;
            obj.n_d = objPD.n_d;
            obj.n = objPD.n;
            obj.n_i = objPD.n_i;
            obj.n_dof = objPD.n_dof;
            obj.n_el = objPD.n_el;
            obj.n_nod = objPD.n_nod;
            obj.n_el_dof = objPD.n_el_dof;
            obj.Td = objPD.Td;
            obj.mat = objPD.mat;
            obj.Tmat = objPD.Tmat;
        end
        
        function asssembleKG(obj)
            obj.K_e = computeKelBar(obj.n_d,obj.n_el,obj.x,obj.Tnod,obj.mat...
                ,obj.Tmat);
            obj.KG = assemblyKG(obj.n_el,obj.n_el_dof,obj.n_dof,obj.Td,...
                obj.K_e);
        end
        
        function applyConditions(obj)
            [obj.vL,obj.vR,obj.uR] = applyCond(n_i,n_dof,fixNod);
        end
        
        function computeF(obj)
            F_bar = density_calc(x,mat, Tmat, obj.n_el, obj.Td, obj.Tnod);
            % this restricts it to the mentioned geometry. Won't solve it
            % for any structure. 
            [T,L,D,~,~,~] =  equilibrio_momentos(F_bar,...
                W_M,obj.H,obj.W);
            Fdata = computeFdata(W_M, L, D, T); 
            obj.Fext = computeF(obj.n_i,obj.n_dof, Fdata, F_bar);
        end
    end
    
    
end

