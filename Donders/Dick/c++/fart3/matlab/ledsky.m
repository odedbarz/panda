%                     --   leds   --
% color spec k=black, g=green, r=red
%
function ledsky(h,cmd,skydata)
    gray=[0.4 0.4 0.4];
    switch upper(cmd)
        case 'INIT'
            h = figure();
            plot(0,0,'o','LineWidth',2,...
                         'MarkerEdgeColor',gray,...
                         'MarkerFaceColor','r',...
                         'MarkerSize',10);
            hold on;
            axis([-1.0 1.0 -1.0 1.0]);
            axis off;
            axis square;
            set(gcf,'toolbar','no');      
            set(gcf,'menubar','no');
            set(gcf,'numbertitle','off');
            set(gcf,'resize','off');
            pos=get(gcf,'position');
            pos(3)=300;
            pos(4)=300;
            set(gcf,'position',pos);
            for i=6:11
                h = i*pi/6;
                x = [sin(h) -sin(h)];
                y = [cos(h) -cos(h)];
                plot(x,y,'k');
            end
            l=[0.1 0.2 0.45 0.72 1.0];
            for r=1:5
                for s=1:12
                    h = s*pi/6;
                    x = l(r)*sin(h);
                    y = l(r)*cos(h);
                    plot(x,y,'o','LineWidth',2,...
                                 'MarkerEdgeColor',gray,...
                                 'MarkerFaceColor','w',...
                                 'MarkerSize',6);
                end
            end
    end
end
% r=3;
% s=2;
% h = s*pi/6;
% x = l(r)*sin(h);
% y = l(r)*cos(h);
% plot(x,y,'o','LineWidth',4,...
%              'MarkerEdgeColor',green,...
%              'MarkerFaceColor',green,...
%              'MarkerSize',6);
% r=4;
% s=2;
% h = s*pi/6;
% x = l(r)*sin(h);
% y = l(r)*cos(h);
% dim = 0.75*green;
% plot(x,y,'o','LineWidth',4,...
%              'MarkerEdgeColor',dim,...
%              'MarkerFaceColor',dim,...
%              'MarkerSize',6);
%          
% hold off;
% 
