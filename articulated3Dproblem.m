classdef Articulated3Dproblem < handle
    % Class that directly solves the problem
    
    
    properties (Access = public)
        % Properties to be used by external functions. For example, unit
        % testing class.
        KG
        R
        u_method
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
    
    %% Private access methods
    methods (Access = private)
        function init(obj, cParams)
            obj.var_struct = cParams;
        end
        
        function solveSystem(obj)
            s.vL = obj.vL;
            s.vR = obj.vR;
            s.uR = obj.uR;
            s.KG = obj.KG;
            s.Fext = obj.Fext;
            
            solver = SystemSolver(s);
            solver.solveSystem();
            obj.u_method = solver.u_solv;
            obj.R = solver.R_solv;
        end
        
        function computeResults(obj)
            s.n_d = obj.var_struct.n_d;
            s.n_el = obj.var_struct.n_el;
            s.u_method = obj.u_method;
            s.Td = obj.Td;
            s.x = obj.var_struct.x;     
            s.Tnod = obj.var_struct.Tnod;
            s.mat = obj.var_struct.mat;
            s.Tmat = obj.var_struct.Tmat;
            
            finalStrainStress = StrainStressComputer(s);
            finalStrainStress.computeStrainStress();
            
            obj.eps = finalStrainStress.eps_comp;
            obj.sig = finalStrainStress.sig_comp;
            
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
            s.n_dof = obj.var_struct.n_dof;
            s.fixNod = obj.var_struct.fixNod;
            
            boundarySetter = BoundaryConditionsSetter(s);
            boundarySetter.applyConditions();
            obj.vR = boundarySetter.v_R;
            obj.uR = boundarySetter.u_R;
            obj.vL = boundarySetter.v_L;
            
%             [obj.vL,obj.vR,obj.uR] = applyCond(obj.var_struct.n_i,...
%                 obj.var_struct.n_dof,obj.var_struct.fixNod);
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

