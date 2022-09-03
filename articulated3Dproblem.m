classdef Articulated3Dproblem < handle
    % Class that directly solves the problem
    
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
        Td
    end
    
    properties (Access = private)
        var_struct
    end
    
    methods (Access = public)
        function obj = Articulated3Dproblem(cParams)
            obj.init(cParams);
        end
        
        function solver(obj)
            obj.connectDofs();
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
        function init(obj, cParams)
            obj.var_struct = cParams;
        end
        
        function solveSystem(obj)
            [obj.u_method,obj.R] = solveSys(obj.vL,obj.vR,obj.uR,...
                obj.KG,obj.Fext);
        end
        
        function computeResults(obj)
            [obj.eps,obj.sig] = computeStrainStressBar(obj.var_struct.n_d,...
                obj.var_struct.n_el,obj.u_method,obj.Td,obj.var_struct.x,...
                obj.var_struct.Tnod,obj.var_struct.mat,obj.var_struct.Tmat);
        end
        
        function connectDofs(obj)
            s.n_el = obj.var_struct.n_el;
            s.n_nod = obj.var_struct.n_nod;
            s.n_i = obj.var_struct.n_i;
            s.Tnod = obj.var_struct.Tnod;
            dofConnection = DofsMatrixAssembler(s);
            dofConnection.assembleTd();
            obj.Td = dofConnection.Td;
        end
        
        function assembleKG(obj)
            s.n_d = obj.var_struct.n_d;
            s.n_el = obj.var_struct.n_el;
            s.x = obj.var_struct.x;
            s.Tnod = obj.var_struct.Tnod;
            s.mat = obj.var_struct.mat;
            s.Tmat = obj.var_struct.Tmat;
            
            % Stiffness matrix for every element
            ke_comp = ElementalStiffnessMat(s);
            ke_comp.computeKel();
            obj.K_e = ke_comp.K_e;
            
            % Global stiffness matrix assembly
            s.n_el_dof = obj.var_struct.n_el_dof;
            s.n_dof    = obj.var_struct.n_dof;
            s.n_el     = obj.var_struct.n_el;
            s.K_e      = obj.K_e;
            s.Td       = obj.Td;
            
            KG_assembler = KGassembler(s);
            KG_assembler.assembleMatrix();
            obj.KG = KG_assembler.Kg;
        end
        
        function applyConditions(obj)
            [obj.vL,obj.vR,obj.uR] = applyCond(obj.var_struct.n_i,obj.var_struct.n_dof,obj.var_struct.fixNod);
        end
        
        function computeF(obj)
            s.x    = obj.var_struct.x;
            s.mat  = obj.var_struct.mat;
            s.Tmat = obj.var_struct.Tmat;
            s.n_el = obj.var_struct.n_el;
            s.Td   = obj.Td;
            s.Tnod = obj.var_struct.Tnod;
            s.W_M = obj.var_struct.W_M;
            s.H = obj.var_struct.H;
            s.W = obj.var_struct.W;
            s.n_i = obj.var_struct.n_i;
            s.n_dof = obj.var_struct.n_dof;
            
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
            s.Tnod = obj.var_struct.Tnod;
            s.u = obj.u_method;
            s.sig = obj.sig;
            s.x = obj.var_struct.x;
            setPlot = PlotterClass(s);
            setPlot.plotResults();
        end
            
    end
  
end

