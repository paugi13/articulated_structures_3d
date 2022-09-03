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
        
        function assembleKG(obj)
            s.n_d = obj.n_d;
            s.n_el = obj.n_el;
            s.x = obj.x;
            s.Tnod = obj.Tnod;
            s.mat = obj.mat;
            s.Tmat = obj.Tmat;
            
            % Stiffness matrix for every element
            ke_comp = ElementalStiffnessMat(s);
            ke_comp.computeKel();
            obj.K_e = ke_comp.K_e;
            
            % Global stiffness matrix assembly
            s.n_el_dof = obj.n_el_dof;
            s.n_dof    = obj.n_dof;
            s.n_el     = obj.n_el;
            s.K_e      = obj.K_e;
            s.Td       = obj.Td;
            
            KG_assembler = KGassembler(s);
            KG_assembler.assembleMatrix();
            obj.KG = KG_assembler.Kg;
        end
        
        function applyConditions(obj)
            [obj.vL,obj.vR,obj.uR] = applyCond(obj.n_i,obj.n_dof,obj.fixNod);
        end
        
        function computeF(obj)
            s.x    = obj.x;
            s.mat  = obj.mat;
            s.Tmat = obj.Tmat;
            s.n_el = obj.n_el;
            s.Td   = obj.Td;
            s.Tnod = obj.Tnod;
            s.W_M = obj.W_M;
            s.H = obj.H;
            s.W = obj.W;
            s.n_i = obj.n_i;
            s.n_dof = obj.n_dof;
            
            weights_calculus = DensityWeightCalculator(s);
            weights_calculus.calculateWeights();
            F_bar = weights_calculus.Fbar;
           
            s.Fbar = F_bar;
            
            forcesCalc = ForcesEquilibriumCalculator(s);
            forcesCalc.calculator();
            T = forcesCalc.T;
            L = forcesCalc.L;
            D = forcesCalc.D;

            s.T = T;
            s.L = L;
            s.D = D;
            
            F_assembler = FdataAssembler(s);
            F_assembler.forceMatrixAssembly();
            Fdata = F_assembler.Fdata;
            s.Fdata = Fdata;
            
            totalForceAssembler = AllForceComputing(s);
            totalForceAssembler.computeAllForces();
            obj.Fext = totalForceAssembler.Fext_complete;
            
        end
        
        function plot3D(obj) 
            s.Tnod = obj.Tnod;
            s.u = obj.u_method;
            s.sig = obj.sig;
            s.x = obj.x;
            setPlot = PlotterClass(s);
            setPlot.plotResults();
        end
            
    end
  
end

