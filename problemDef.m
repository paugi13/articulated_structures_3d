classdef problemDef < handle
    %UNTITLED2 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (Access = protected, Constant)
        % Earth's gravity
        % Value treated as public
        
        H = 0.9;
        W = 0.85;
        B = 3.2;
        D1 = 0.018; 
        d1 = 0.0075;
        D2 = 0.003;

        % Mass
        M = 150;
        W_M = 9.81*problemDef.M;
        
        x = [%     X      Y      Z
         2*problemDef.W,  -problemDef.W/2,     0; % (1)
         2*problemDef.W,   problemDef.W/2,     0; % (2)
         2*problemDef.W,     0,     problemDef.H; % (3)
           0,     0,     problemDef.H; % (4)
           0,    -problemDef.B,     problemDef.H; % (5)
           0,     problemDef.B,     problemDef.H; % (6)
           problemDef.W,     0,     problemDef.H; % (7)
];

            % Material properties
            I1 = pi/4*((problemDef.D1/2)^4-(problemDef.d1/2)^4);
            I2 = pi/4*(problemDef.D2/2)^4;
            mat = [% Young M.        Section A.    Density   
                           75000e6 ,  pi*((problemDef.D1/2)^2-...
                           (problemDef.d1/2)^2) , 3350 , problemDef.I1       ;  % Material (1)
                            147000e6,   pi*(problemDef.D2/2)^2   ,  950  , problemDef.I2     ;  % Material (2)
            ];

            % Material connectivities
            %  Tmat(e) = Row in mat corresponding to the material associated to element e 
            Tmat = [1;1;1;1;1;1;1;1;1;1;1;2;2;2;2;2;2
            ];


            % Nodal connectivities  
            %  Tnod(e,a) = global nodal number associated to node a of element e
        Tnod = [1 2; 1 3; 2 3; 3 5; 3 6; 3 7; 4 5; 4 6; 4 7; 5 7; 6 7; 1 4; 1 5; ...
            1 7; 2 4; 2 6; 2 7  
        ];     

        fixNod = [ 1 3 0;
            4 2 0;
            4 3 0;
            3 1 0;
            3 2 0;
            3 3 0;
        ];

        % Definition of nodes and DOFs (useful values for matrix calculus)

        n_d = size(problemDef.x,2);              % Number of dimensions
        n_i = problemDef.n_d;                    % Number of DOFs for each node
        n = size(problemDef.x,1);                % Total number of nodes
        n_dof = problemDef.n_i*problemDef.n;                % Total number of degrees of freedom
        n_el = size(problemDef.Tnod,1);            % Total number of elements
        n_nod = size(problemDef.Tnod,2);           % Number of nodes for each element
        n_el_dof = problemDef.n_i*problemDef.n_nod;         % Number of DOFs for each element

        Td = connectDOFs( problemDef.n_el,problemDef.n_nod,problemDef.n_i,problemDef.Tnod);    
    end
    
    %Only one public method is defined to prepare the object for other
    %purposes stored in other constructors like the articulated3Dproblem
    %one. 
    
%     methods (Access = public)
%         function obj = problemDef(H, W, B, D1, d1, D2, M, x, Tnod, fixNod,...
%                 n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof, mat, Tmat)
%             obj.getGeometry(H, W, B, D1, d1, D2, M, x, Tnod, fixNod, ...
%                 mat, Tmat);
%             obj.getNodes(n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof);
%             obj.connectivityDOFs(n_el,n_nod,n_i,Tnod);
%         end
%     end
%     
%     methods (Access = protected)
%         
%         function connectivityDOFs(obj, n_el,n_nod,n_i,Tnod)
%             obj.Td = connectDOFs( n_el,n_nod,n_i,Tnod);
%         end
%         
%         function getGeometry(obj, H, W, B, D1, d1, D2, M, x, Tnod, fixNod, ...
%                 mat, Tmat)
%             obj.H = H;
%             obj.W = W;
%             obj.B = B;
%             obj.D1 = D1;
%             obj.d1 = d1;
%             obj.D2 = D2;
%             obj.M = M;
%             obj.x = x;
%             obj.Tnod = Tnod;
%             obj.fixNod = fixNod;
%             obj.mat = mat;
%             obj.Tmat = Tmat;
%         end
%         
%         function getNodes(obj, n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof)
%             obj.n_d = n_d;
%             obj.n = n;
%             obj.n_i = n_i;
%             obj.n_dof = n_dof;
%             obj.n_el = n_el;
%             obj.n_nod = n_nod;
%             obj.n_el_dof = n_el_dof;
%         end
%         
%     end
end

