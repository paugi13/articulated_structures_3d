classdef AllForceComputing < handle
   
    properties (Access = public)
         FextComplete
    end
    
    properties (Access = private)
       n_dof
       Fdata
       Fbar
    end
    
    methods (Access = public)
        function obj = AllForceComputing(cParams)
            obj.init(cParams);
        end
        
        function computeAllForces(obj)
            Fext = addMainForces(obj);
            obj. FextComplete = obj.addBarsWeights(Fext);
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.n_dof = cParams.n_dof;
            obj.Fdata = cParams.Fdata;
            obj.Fbar = cParams.Fbar;
        end
    
        function Fext = addMainForces(obj)
            Fext = zeros(obj.n_dof,1);

            for i=1:size(obj.Fdata,1)
            % The value is added again because of the bars' densities calculus, that
            % add themselves on the nodes. 
            dof = obj.Fdata(i,2); 
            val = obj.Fdata(i,3);
            Fext(dof) = Fext(dof) + val;
            end
        end
        
        function Fext = addBarsWeights(obj, Fext)
            %The same loop is repeated with the Fbar vector's dimensions. 
            for i=1:size(obj.Fbar,1)
            % The value is added again because of the bars' densities calculus, that
            % add themselves on the nodes. 
            dof = obj.Fbar(i,2);
            val = obj.Fbar(i,3);
            Fext(dof) = Fext(dof) + val;
            end
        end
         
    end
end

