%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date:
% Author/s:
%

clear;
close all;

%% INPUT DATA

% Geometric data
H = 0.9;
W = 0.85;
B = 3.2;
% d = ;
D1 = 0.018; 
d1 = 0.0075;
D2 = 0.003;

% Mass
M = 150;

% Other
g = 9.81;

%% PREPROCESS

% Nodal coordinates matrix 
%  x(a,j) = coordinate of node a in the dimension j
x = [%     X      Y      Z
         2*W,  -W/2,     0; % (1)
         2*W,   W/2,     0; % (2)
         2*W,     0,     H; % (3)
           0,     0,     H; % (4)
           0,    -B,     H; % (5)
           0,     B,     H; % (6)
           W,     0,     H; % (7)
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tnod = [1 2
        1 3
        2 3
        3 5
        3 6
        3 7
        4 5
        4 6
        4 7
        5 7
        6 7
        1 4
        1 5
        1 7
        2 4
        2 6
        2 7   
];     

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  --more columns can be added for additional material properties--

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

%% Definition of fixed nodes
% Suitable fixed nodes must be defined in order to limit every possible
% movement of the structure. 
fixNod = [1 3 0;
    4 2 0;
    4 3 0;
    3 1 0;
    3 2 0;
    3 3 0;
];
% 
% 1 1 0;
%     2 2 0;
%     3 3 0;
%     4 3 0;
%     5 2 0;
%     6 1 0
% Other possible combinations

%% Main structure parameters
n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tnod,1);            % Total number of elements
n_nod = size(Tnod,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 

%Compute forces including densities in momentum equations
W_M = 9.81*M;
Td = connectDOFs(n_el,n_nod,n_i,Tnod);
F_bar = density_calc(x,mat, Tmat, n_el, Td, Tnod);
[T,L,D,W_T,x_cg,z_cg, W_C, W_D] = equilibrio_momentos(F_bar,W_M,H,W);

% SUDDEN BURST
SB=1; %Number 1 activates the calculation for a sudden gust of wind
[T,D,L,Fax,Faz] = suddenBurst(SB,x_cg,z_cg,D,L,W_T,W,H,T, W_C, W_D);

ax = Fax/(W_T/9.81);
az = Faz/(W_T/9.81);
Fdata = [1 3 (-W_M/2)-(W_M/(2*9.81))*az;
    2 6 (-W_M/2)-(W_M/(2*9.81))*az;
    3 9 (L/5);
    4 12 (L/5);
    5 15 (L/5);
    6 18 (L/5);
    7 21 (L/5);
    3 7 (-D/5);
    4 10 (-D/5);
    5 13 (-D/5);
    6 16 (-D/5);
    7 19 (-D/5);
    1 1 (T/2)+(W_M/(2*9.81))*ax;
    2 4 (T/2)+(W_M/(2*9.81))*ax;
];



%% SOLVER
K_e = computeKelBar(n_d,n_el,x,Tnod,mat,Tmat);
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,K_e);
Fext = computeF(n_i,n_dof, Fdata, F_bar, ax ,az);
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);
[u,R] = solveSys(vL,vR,uR,KG,Fext);
[eps,sig, E_e, l_e] = computeStrainStressBar(n_d,n_el,u,Td,x,Tnod,mat,Tmat);

%% POSTPROCESS

% Critical stress for buckling.
cr_stress = pi^2*E_e.*mat(Tmat(:),4)./((l_e.^2).*mat(Tmat(:),2));

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u,sig,scale);


