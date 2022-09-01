% Main code for problem solving using object oriented approach.
% Results should be the same as the ones obtained through the imperative
% approach. Therefore all tests should pass. 

%mainGeometry = problemDef;
%% Numerical values

H = 0.9;
W = 0.85;
B = 3.2;
% d = ;
D1 = 0.018; 
d1 = 0.0075;
D2 = 0.003;

% Mass
M = 150;
W_M = 9.81*M;
% Other
g = 9.81;

x = [%     X      Y      Z
         2*W,  -W/2,     0; % (1)
         2*W,   W/2,     0; % (2)
         2*W,     0,     H; % (3)
           0,     0,     H; % (4)
           0,    -B,     H; % (5)
           0,     B,     H; % (6)
           W,     0,     H; % (7)
];

% Material properties
I1 = pi/4*((D1/2)^4-(d1/2)^4);
I2 = pi/4*(D2/2)^4;
mat = [% Young M.        Section A.    Density   
               75000e6 ,  pi*((D1/2)^2-(d1/2)^2) , 3350 , I1       ;  % Material (1)
                147000e6,   pi*(D2/2)^2   ,  950  , I2     ;  % Material (2)
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

n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tnod,1);            % Total number of elements
n_nod = size(Tnod,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 


%% Definition and solution of the problem

% mainGeometry contains the main information related to the problem
mainGeometry = setProperties(H, W, B, D1, d1, D2, M, x, Tnod, fixNod,...
                n_d, n_i, n, n_dof, n_el, n_nod, n_el_dof);
            
% articulated3Gproblem is created to actually SOLVE the problem.
problemSolver = initializeProblem(mainGeometry);
            

