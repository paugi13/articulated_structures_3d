function Fext = computeF(n_i,n_dof,Fdata, Fbar, ax, az)
%--------------------------------------------------------------------------
% The function takes as inputs:
%   - Dimensions:  n_i         Number of DOFs per node
%                  n_dof       Total number of DOFs
%   - Fdata  External nodal forces [Nforces x 3]
%            Fdata(k,1) - Node at which the force is applied
%            Fdata(k,2) - DOF (direction) at which the force acts
%            Fdata(k,3) - Force magnitude in the corresponding DOF
%--------------------------------------------------------------------------
% It must provide as output:
%   - Fext  Global force vector [n_dof x 1]
%            Fext(I) - Total external force acting on DOF I
%--------------------------------------------------------------------------
% Hint: Use the relation between the DOFs numbering and nodal numbering to
% determine at which DOF in the global system each force is applied.

Fext = zeros(n_dof,1);

for i=1:size(Fdata,1)
% The value is added again because of the bars' densities calculus, that
% add themselves on the nodes. 
Fext(Fdata(i,2)) = Fext(Fdata(i,2)) + Fdata(i,3);
end

%The same loop is repeated with the Fbar vector's dimensions. 
for i=1:size(Fbar,1)
% The value is added again because of the bars' densities calculus, that
% add themselves on the nodes. 

Fext(Fbar(i,2)-2) = Fext(Fbar(i,2)-2) + (-Fbar(i,3)/9.81)*ax;
Fext(Fbar(i,2)) = Fext(Fbar(i,2)) + Fbar(i,3) - (-Fbar(i,3)/9.81)*az;
end