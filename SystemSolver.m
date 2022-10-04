classdef SystemSolver < handle
    
    properties (Access = public)
        uSolv
        RSolv
    end
    
    properties (Access = private)
        vL
        vR
        uR
        KG
        Fext
        
        FExtL
        FExtR
        
        KRR
        KLL
        KLR
        KRL
        
        uL
    end
    
    methods (Access = public)
        function obj = SystemSolver(cParams)
            obj.init(cParams);
        end
        
        function solveSystem(obj)
            obj.forceMatrixDivider();
            obj.KGDivider();
            obj.mainSolver();
            obj.finalReactionsDisplacementsAssembler();
        end
      
    end
    
    
    methods (Access = private)
        function init(obj, cParams)
            obj.vL = cParams.vL;
            obj.vR = cParams.vR;
            obj.uR = cParams.uR;
            obj.KG = cParams.KG;
            obj.Fext = cParams.Fext;
        
        end
        
        function forceMatrixDivider(obj)
            free = size(obj.vL,1);
            rest = size(obj.vR,1);
            FextL = zeros(free, 1);
            FextR = zeros(rest, 1);

            for i = 1:rest
                FextR(i, 1) = obj.Fext(obj.vR(i,1),1);   
            end

            for i = 1:free
                FextL(i, 1) = obj.Fext(obj.vL(i,1),1);
            end
        obj.FExtL = FextL;
        obj.FExtR = FextR;
        end
        
        function KGDivider(obj)
            free = size(obj.vL, 1);
            rest = size(obj.vR, 1);
            KLL_f = zeros(free);
            KRR_f = zeros(rest);
            KRL_f = zeros(rest, free);
            KLR_f = zeros(free, rest);

            for i = 1:size(KLL_f, 1)
               for j = 1:size(KLL_f, 2) 
               KLL_f(i,j) = obj.KG(obj.vL(i),obj.vL(j));
               end
            end

            for i = 1:size(KRR_f, 1)
               for j = 1:size(KRR_f, 2) 
               KRR_f(i,j) = obj.KG(obj.vR(i),obj.vR(j));
               end
            end

            for i = 1:size(KRL_f, 1)
               for j = 1:size(KRL_f, 2) 
               KRL_f(i,j) = obj.KG(obj.vR(i),obj.vL(j));
               end
            end

            for i = 1:size(KLR_f, 1)
               for j = 1:size(KLR_f, 2) 
               KLR_f(i,j) = obj.KG(obj.vL(i),obj.vR(j));
               end
            end
            obj.KLL = KLL_f;
            obj.KRL = KRL_f;
            obj.KRR = KRR_f;
            obj.KLR = KLR_f;
        end
        
        function mainSolver(obj)
            vect = obj.FExtL - obj.KLR*obj.uR;
            c = input('Resolució per mètode iteratiu(1) o directe(2)?: ');

            switch c
                case 1
                    s.KLL = obj.KLL;
                    s.vect = vect;
                    itSolv = IterativeSolver(s);
                    itSolv.solveIterative();
                    obj.uL = itSolv.alphaX;
                case 2
                    s.KLL = obj.KLL;
                    s.vect = vect;
                    itSolv = DirectSolver(s);
                    itSolv.solveDirect();
                    obj.uL = itSolv.alphaX;
            end
        
        end
        
        function finalReactionsDisplacementsAssembler(obj)
            obj.RSolv = obj.KRR*obj.uR + obj.KRL*obj.uL - obj.FExtR;

            z = size(obj.vR, 1) + size(obj.vL, 1);
            u_void = zeros(z, 1);

            for i = 1:size(obj.vL, 1)
               u_void(obj.vL(i), 1) = obj.uL(i,1);
            end

            for i = 1:size(obj.vR, 1)
               u_void(obj.vR(i), 1) = obj.uR(i,1);
            end
            obj.uSolv = u_void;
        end
    
    end
end

