classdef Articulated3Dproblem < handle
    % Class that directly solves the problem
    
    
    properties (Access = public)
        % Properties to be used by external functions. For example, unit
        % testing class.
        KG
        R
        uMethod
    end
    
    properties (Access = protected)
        % Properties related to problem resolution
        K_e
        
        Fext
        
        eps
        sig
        
        vL
        vR
        uR
        Td
    end
    
    properties (Access = private)
        varStruct
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
    
    %% Private access methods
    methods (Access = private)
        function init(obj, cParams)
            obj.varStruct = cParams;
        end
        
        function solveSystem(obj)
            s.vL = obj.vL;
            s.vR = obj.vR;
            s.uR = obj.uR;
            s.KG = obj.KG;
            s.Fext = obj.Fext;
            
            solver = SystemSolver(s);
            solver.solveSystem();
            obj.uMethod = solver.uSolv;
            obj.R = solver.RSolv;
        end
        
        function computeResults(obj)
            s.n_d = obj.varStruct.n_d;
            s.n_el = obj.varStruct.n_el;
            s.uMethod = obj.uMethod;
            s.Td = obj.Td;
            s.x = obj.varStruct.x;     
            s.Tnod = obj.varStruct.Tnod;
            s.mat = obj.varStruct.mat;
            s.Tmat = obj.varStruct.Tmat;
            
            finalStrainStress = StrainStressComputer(s);
            finalStrainStress.computeStrainStress();
            
            obj.eps = finalStrainStress.epsComp;
            obj.sig = finalStrainStress.sigComp;
            
        end
        
        function connectDofs(obj)
            s.n_el = obj.varStruct.n_el;
            s.n_nod = obj.varStruct.n_nod;
            s.n_i = obj.varStruct.n_i;
            s.Tnod = obj.varStruct.Tnod;
            dofConnection = DofsMatrixAssembler(s);
            dofConnection.assembleTd();
            obj.Td = dofConnection.Td;
        end
        
        function assembleKG(obj)
            s.n_d = obj.varStruct.n_d;
            s.n_el = obj.varStruct.n_el;
            s.x = obj.varStruct.x;
            s.Tnod = obj.varStruct.Tnod;
            s.mat = obj.varStruct.mat;
            s.Tmat = obj.varStruct.Tmat;
            
            % Global stiffness matrix assembly
            s.n_el_dof = obj.varStruct.n_el_dof;
            s.n_dof    = obj.varStruct.n_dof;
            s.n_el     = obj.varStruct.n_el;
            s.K_e      = obj.K_e;
            s.Td       = obj.Td;
            
            KG_assembler = KGassembler(s);
            KG_assembler.assembleMatrix();
            obj.KG = KG_assembler.Kg;
        end
        
        function applyConditions(obj)
            s.n_dof = obj.varStruct.n_dof;
            s.fixNod = obj.varStruct.fixNod;
            
            boundarySetter = BoundaryConditionsSetter(s);
            boundarySetter.applyConditions();
            obj.vR = boundarySetter.v_R;
            obj.uR = boundarySetter.u_R;
            obj.vL = boundarySetter.v_L;
        end
        
        function computeF(obj)
            s.x    = obj.varStruct.x;
            s.mat  = obj.varStruct.mat;
            s.Tmat = obj.varStruct.Tmat;
            s.n_el = obj.varStruct.n_el;
            s.Td   = obj.Td;
            s.Tnod = obj.varStruct.Tnod;
            s.Wm = obj.varStruct.W_M;
            s.H = obj.varStruct.H;
            s.W = obj.varStruct.W;
            s.n_i = obj.varStruct.n_i;
            s.n_dof = obj.varStruct.n_dof;
            
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
            
            fAssembler = FdataAssembler(s);
            fAssembler.forceMatrixAssembly();
            Fdata = fAssembler.Fdata;
            s.Fdata = Fdata;
            
            totalForceAssembler = AllForceComputing(s);
            totalForceAssembler.computeAllForces();
            obj.Fext = totalForceAssembler.FextComplete;
            
        end
        
        function plot3D(obj) 
            s.Tnod = obj.varStruct.Tnod;
            s.u = obj.uMethod;
            s.sig = obj.sig;
            s.x = obj.varStruct.x;
            setPlot = PlotterClass(s);
            setPlot.plotResults();
        end
            
    end
  
end

