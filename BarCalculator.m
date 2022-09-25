classdef BarCalculator < handle

    properties (Access = public)
        L
        rotMat
        KeBar
    end
    
    properties (Access = private)
        x1
        x2
        y1
        y2
        z1
        z2
        Kel
    end
    
    methods (Access = public)
        function obj = BarCalculator(cParams)
            obj.init(cParams);
        end
        
        function getKe(obj, m)
            obj.getMatrix(m);
            obj.assembleKe();
        end
        
        function calculateParameters(obj)
            obj.calculateBarLength();
            obj.calculateRotMatrix();
        end
        
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.x1 = cParams.x1;
            obj.x2 = cParams.x2;
            obj.y1 = cParams.y1;
            obj.y2 = cParams.y2;
            obj.z1 = cParams.z1;
            obj.z2 = cParams.z2;
        end
        
        function getMatrix(obj, m)
            obj.Kel = m;
        end
        
        function calculateBarLength(obj)
            obj.L = sqrt((obj.x2-obj.x1)^2+(obj.y2-obj.y1)^2+(obj.z2-obj.z1)^2);
        end
        
        function calculateRotMatrix(obj)
            obj.rotMat = 1/obj.L*[obj.x2-obj.x1 obj.y2-obj.y1 obj.z2-obj.z1 0 0 0;
                            0 0 0 obj.x2-obj.x1 obj.y2-obj.y1 obj.z2-obj.z1
                    ];
        end
        
        function assembleKe(obj)
            obj.KeBar = obj.rotMat.'*obj.Kel*obj.rotMat;
        end
        
    
    end
end

