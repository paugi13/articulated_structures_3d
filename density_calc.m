function [outputArg1] = density_calc(x,mat, Tmat, n_el, Td,n)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
W_bar = zeros(n_el, 1);
F_bar_data = zeros(n, 3);
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
    W_bar(i,1) = mat(Tmat(i),2)*l_e*9.81;
    F_bar_data(i,:) = [i, Td(i,3), ];
end
end

