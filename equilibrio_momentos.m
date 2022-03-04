function [Thrust,Lift,Drag,Weight,x_cg,z_cg] = equilibrio_momentos(F_bar,W_M,H,W)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
W_D = 0;
W_C = 0;
W_B = 0;
W_A = 0;

for i = 1:size(F_bar,1)
   
   if F_bar(i,1)==4||F_bar(i,1)==5||F_bar(i,1)==6
        W_D = W_D-F_bar(i,3);
   end
   if F_bar(i,1)==7
        W_C = W_C-F_bar(i,3);
   end 
   if F_bar(i,1)==3
        W_B = W_B-F_bar(i,3);
   end
   if F_bar(i,1)==1||F_bar(i,1)==2
        W_A = W_A-F_bar(i,3);
   end
end

% Calculus of forces appliying both equilibriums' equations. 
Lift = W_M+W_D+W_C+W_B+W_A;
Weight = Lift;
x_cg=(W_D*2*W+W_C*W+W_B*0+W_A*0)/Weight;
z_cg=(W_D*H+W_C*H+W_B*H+W_A*0)/Weight;


syms Thrust
eqn  = Thrust*H + W_C*W + W_D*2*W == (Lift)*(7/5)*W; 
Thrust = vpasolve(eqn, Thrust);
Drag = Thrust;
end