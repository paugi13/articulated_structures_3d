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
L = 1;

% Mass
F = 1000;

%% PREPROCESS

% Nodal coordinates matrix 
%  x(a,j) = coordinate of node a in the dimension j
x = [%     X      Y      Z
         0 0 0
         0 L 0
         0 0 L
         0 L L 
         L L/2 L/2
];

% Nodal connectivities  
%  Tnod(e,a) = global nodal number associated to node a of element e
Tnod = [1 5
        2 5
        3 5
        4 5   
];     

% Material properties matrix
%  mat(m,1) = Young modulus of material m
%  mat(m,2) = Section area of material m
%  mat(m,3) = Density of material m
%  --more columns can be added for additional material properties--
mat = [% Young M.        Section A.    Density   
               75000e6 ,         0.0002       ,    3350       ;  % Material (1)
];

% Material connectivities
%  Tmat(e) = Row in mat corresponding to the material associated to element e 
Tmat = [1;1;1;1;1
];

Fdata = [5 15 -F
];

%

fixNod = [1 1 0;
    1 2 0;
    1 3 0;
    2 1 0;
    2 2 0;
    2 3 0;
    3 1 0;
    3 2 0;
    3 3 0;
    4 1 0;
    4 2 0;
    4 3 0;
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
F_bar = density_calc(x,mat, Tmat, n_el, Td, Tnod, n);
Fext = computeF(n_i,n_dof, Fdata, F_bar);
[vL,vR,uR] = applyCond(n_i,n_dof,fixNod);
[u,R] = solveSys(vL,vR,uR,KG,Fext);
[eps,sig, E_e, l_e] = computeStrainStressBar(n_d,n_el,u,Td,x,Tnod,mat,Tmat);

%% POSTPROCESS

% Plot deformed structure with stress of each bar
scale = 100; % Adjust this parameter for properly visualizing the deformation
plotBarStress3D(x,Tnod,u,sig,scale);

xlswrite('table.xls', R,'Hoja1', 'B2');
xlswrite('table.xls', fixNod(:,1),'Hoja1', 'C2');
xlswrite('table.xls', fixNod(:,2),'Hoja1', 'D2');
xlswrite('table.xls', sig,'Hoja1', 'F2');