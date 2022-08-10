%-------------------------------------------------------------------------%
% ASSIGNMENT 02
%-------------------------------------------------------------------------%
% Date: Pau Gil Corretger
% Author/s: 12/07/2022
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
W_M = 9.81*M;
% Other
g = 9.81;

%% PREPROCESS

tests = unitTesting;

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
Tnod = [1 2; 1 3; 2 3; 3 5; 3 6; 3 7; 4 5; 4 6; 4 7; 5 7; 6 7; 1 4; 1 5; ...
    1 7; 2 4; 2 6; 2 7  
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

%Fixed nodes for the structure to 'feel' the stresses. 

fixNod = [ 1 3 0;
    4 2 0;
    4 3 0;
    3 1 0;
    3 2 0;
    3 3 0;
];


%% SOLVER

n_d = size(x,2);              % Number of dimensions
n_i = n_d;                    % Number of DOFs for each node
n = size(x,1);                % Total number of nodes
n_dof = n_i*n;                % Total number of degrees of freedom
n_el = size(Tnod,1);            % Total number of elements
n_nod = size(Tnod,2);           % Number of nodes for each element
n_el_dof = n_i*n_nod;         % Number of DOFs for each element 


Td = connectDOFs(n_el,n_nod,n_i,Tnod);
K_e = computeKelBar(n_d,n_el,x,Tnod,mat,Tmat);
KG = assemblyKG(n_el,n_el_dof,n_dof,Td,K_e);

% UNIT TESTING 1: KG ASSEMBLY
tests.KG = KG;
tests.testKGmatrix();
% --------------------------- 

F_bar = density_calc(x,mat, Tmat, n_el, Td, Tnod);
[T,L,D,W_T,x_cg,z_cg] =  equilibrio_momentos(F_bar,W_M,H,W);

% suma_den = 0;
% for i=1:size(F_bar,1)
%    suma_den = suma_den + F_bar(i,3);
% end
% 
% ;
% L = W_M-suma_den;
% D = 7*L*W/(5*H);
% T = D;

Fdata = [1 3 -W_M/2;
    2 6 -W_M/2;
    3 9 L/5;
    4 12 L/5;
    5 15 L/5;
    6 18 L/5;
    7 21 L/5;
    3 7 -D/5;
    4 10 -D/5;
    5 13 -D/5;
    6 16 -D/5;
    7 19 -D/5;
    1 1 T/2;
    2 4 T/2;
];

Fext = computeF(n_i,n_dof, Fdata, F_bar);
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);
[u_method,R] = solveSys(vL,vR,uR,KG,Fext);
tests.u = u_method;

% UNIT TESTING 2: REACTIONS (TOTAL FORCE)
tests.R = R;
testForces(tests);
% ---------------------------------------



% UNIT TESTING 3: DISPLACEMENTS
testDisplacements(tests);
% ---------------------------------------




[eps,sig, E_e, l_e] = computeStrainStressBar(n_d,n_el,u_method,Td,x,Tnod,mat,Tmat);

%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u_method,sig,scale);


% Critical stress for buckling.
cr_stress = pi^2*E_e.*mat(Tmat(:),4)./((l_e.^2).*mat(Tmat(:),2));
cr_stress = cr_stress/(10^6);
sig = sig/(10^6);

xlswrite('table.xls', sig,'Hoja1', 'B2');
xlswrite('table.xls', cr_stress,'Hoja1', 'C2');


