function [T,D,L,Fax,Faz] = suddenBurst(SB,x_cg,z_cg,D,L,W_T,W,H,T)
%UNTITLED Summary of this function goes here
%   Les posicions dels nodes es referencien respecte el pla de simetria de
%   l'ala delta i respecte els punts 1 i 2
if SB==1
    m=W_T/9.81;
    D=D*1.1;
    L=L*1.1;
    Faz=W-L;    % Resultant z force. 
    % Solving Fax resultant force. T' doesn't generate moment due to the
    % selected point of application
    syms Fax    
    eqn = D*H+Fax*z_cg+W_T*x_cg == (7/5)*L*W+Faz*x_cg;
    Fax = vpasolve(eqn,Fax);
    T=D+Fax;
end

%SB is an auxiliar variable whose function if to apply the sudden burst or
%not (different situations).
if SB~=1
    D=D;
    T=T;
    L=L;
    Fax=0;
    Faz=0;
end
end

