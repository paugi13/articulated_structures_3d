classdef PlotterClass < handle
    %Class made for plotting purposes
    
    properties (Constant)
        scale = 100;
    end
    properties (Access = private)
        nd
        X
        Y
        Z
        ux
        uy
        uz
        Tnod
        sig
    end
    
    methods (Access = public)
        function obj = PlotterClass(cParams)
            obj.init(cParams);
        end
        
        function plotResults(obj)
            PlotterClass.initializeFigure();
            obj.plotUndeformed();
            obj.plotDeformed();
            PlotterClass.setView();
            PlotterClass.addAxisTitle();
            obj.addColorbar();
        end
    end
    
    methods (Access = private)
        function init(obj, cParams)
            obj.nd = size(cParams.x,2);
            obj.X = cParams.x(:,1);
            obj.Y = cParams.x(:,2);
            obj.Z = cParams.x(:,3);
            obj.ux = cParams.u(1:obj.nd:end);
            obj.uy = cParams.u(2:obj.nd:end);
            obj.uz = cParams.u(3:obj.nd:end);
            obj.Tnod = cParams.Tnod;
            obj.sig = cParams.sig;
        end
        
        function plotUndeformed(obj)
            plot3(obj.X(obj.Tnod)',obj.Y(obj.Tnod)',obj.Z(obj.Tnod)'...
                ,'-k','linewidth',0.5);
        end
        
        function plotDeformed(obj)
        patch(obj.X(obj.Tnod)'+obj.scale*obj.ux(obj.Tnod)',obj.Y(obj.Tnod)'...
            +obj.scale*obj.uy(obj.Tnod)',obj.Z(obj.Tnod)'+obj.scale*obj.uz(obj.Tnod)'...
            ,[obj.sig';obj.sig'],'edgecolor','flat','linewidth',2);
        end
        
        function addColorbar(obj)
            cbar = colorbar('Ticks',linspace(min(obj.sig),max(obj.sig),5));
            title(cbar,{'Stress';'(Pa)'});
        end
        
    end
    
    methods (Static)
        function initializeFigure()
            figure
            hold on
            axis equal;
            colormap jet;
        end
        
        function setView()
            view(45,20);
        end
        
        function addAxisTitle()
%             scale = 100;
            xlabel('x (m)')
            ylabel('y (m)')
            zlabel('z (m)')

            % Add title
            title(sprintf('Deformed structure (scale = %g)', PlotterClass.scale));
        end
    end
    
end

