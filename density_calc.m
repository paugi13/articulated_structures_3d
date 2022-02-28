function [F_bar_data] = density_calc(x,mat, Tmat, n_el, Td, Tn, n)
% Function that calculates bar weights and returns a matrix with the same
% format as Fdata. 

W_bar = zeros(n_el, 1);
j=1;
F_bar_data = zeros(2*n, 3);
for i=1:n_el
    x_1_e= x(Tn(i,1),1);
    x_2_e= x(Tn(i,2),1);
    y_1_e= x(Tn(i,1),2);
    y_2_e= x(Tn(i,2),2);
    z_1_e= x(Tn(i,1),3);
    z_2_e= x(Tn(i,2),3);
    l_e= sqrt((x_2_e-x_1_e)^2+(y_2_e-y_1_e)^2+(z_2_e-z_1_e)^2);
%     s_e=(y_2_e-y_1_e)/l_e;
%     c_e=(x_2_e-x_1_e)/l_e;
    W_bar(i,1) = mat(Tmat(i),2)*l_e*9.81/2;
    F_bar_data(j,:) = [Td(i,3)/3 Td(i,3) -W_bar(i,1)];  
    j = j+1;
    F_bar_data(j,:) = [Td(i,6)/3 Td(i,6) -W_bar(i,1)];
    j = j+1;
end

end

