classdef ForcesEquilibriumCalculator < handle
    %Class to calculate forces equilibrium with the principles of statics.
    
    properties (Access = public)
        T
        D
        L
    end
    
    properties (Access = private)
        Fbar
        Wm
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
            obj.Fbar = cParams.Fbar;
            obj.Wm = cParams.Wm;
            obj.H = cParams.H;
            obj.W = cParams.W;
        end
        
        function [W_A, W_B, W_C, W_D] = totalWeightDistributor(obj)
            W_D = 0;
            W_C = 0;
            W_B = 0;
            W_A = 0;

            for i = 1:size(obj.Fbar,1)

               if obj.Fbar(i,1)==4||obj.Fbar(i,1)==5||obj.Fbar(i,1)==6
                    W_D = W_D-obj.Fbar(i,3);
               end
               if obj.Fbar(i,1)==7
                    W_C = W_C-obj.Fbar(i,3);
               end 
               if obj.Fbar(i,1)==3
                    W_B = W_B-obj.Fbar(i,3);
               end
               if obj.Fbar(i,1)==1||obj.Fbar(i,1)==2
                    W_A = W_A-obj.Fbar(i,3);
               end
            end
        end
        
        function Lift = liftCalculator(obj, w)
            Lift = obj.Wm+w.W_D+w.W_C+w.W_B+w.W_A;
        end
        
        function [Drag, Thrust] = dragThrustCalculator(obj, w)
            syms Thrust
            eqn  = Thrust*obj.H + w.W_C*obj.W + w.W_D*2*obj.W == (obj.L)*(7/5)*obj.W; 
            Thrust = vpasolve(eqn, Thrust);
            Drag = Thrust;
        end
    end
end

