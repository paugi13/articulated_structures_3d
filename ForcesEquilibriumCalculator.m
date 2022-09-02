classdef ForcesEquilibriumCalculator < handle
    %Class to calculate forces equilibrium with the principles of statics.
    
    properties (Access = public)
        T
        D
        L
    end
    
    properties (Access = private)
        F_bar
        W_M
        H
        W         
    end
    
    methods (Access = public)
        function obj = ForcesEquilibriumCalculator(cParams)
            obj.init(cParams);
        end
        
        function calculator(obj)
            [w.W_A, w.W_B, w.W_C, w.W_D] = totalWeightDistributor(obj);

            % Calculus of forces appliying both equilibriums' equations. 
            obj.L = obj.liftCalculator(w);
            [obj.D, obj.T] = obj.dragThrustCalculator(w);
        end
        
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.F_bar = cParams.Fbar;
            obj.W_M = cParams.W_M;
            obj.H = cParams.H;
            obj.W = cParams.W;
        end
        
        function [W_A, W_B, W_C, W_D] = totalWeightDistributor(obj)
            W_D = 0;
            W_C = 0;
            W_B = 0;
            W_A = 0;

            for i = 1:size(obj.F_bar,1)

               if obj.F_bar(i,1)==4||obj.F_bar(i,1)==5||obj.F_bar(i,1)==6
                    W_D = W_D-obj.F_bar(i,3);
               end
               if obj.F_bar(i,1)==7
                    W_C = W_C-obj.F_bar(i,3);
               end 
               if obj.F_bar(i,1)==3
                    W_B = W_B-obj.F_bar(i,3);
               end
               if obj.F_bar(i,1)==1||obj.F_bar(i,1)==2
                    W_A = W_A-obj.F_bar(i,3);
               end
            end
        end
        
        function Lift = liftCalculator(obj, w)
            Lift = obj.W_M+w.W_D+w.W_C+w.W_B+w.W_A;
        end
        
        function [Drag, Thrust] = dragThrustCalculator(obj, w)
            syms Thrust
            eqn  = Thrust*obj.H + w.W_C*obj.W + w.W_D*2*obj.W == (obj.L)*(7/5)*obj.W; 
            Thrust = vpasolve(eqn, Thrust);
            Drag = Thrust;
        end
    end
end

