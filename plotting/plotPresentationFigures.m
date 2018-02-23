% close all;clear;clc
%
%
% files = dir(fullfile(pwd,'data'));
% files = files(3:end);
%
% numIterations = 150;
% markerSize    = 10;
% colors  = {'k','b','r'};
% markers = {'o','x','d'};
% fontSize = 36;
% h.fig1 = figure;
% h.fig2 = figure;
% for ii = 1:length(files)
%    load(fullfile(files(ii).folder,files(ii).name))
%    startIndex = p.numSettlingLaps + p.numInitializationLaps + 1;
%    endIndex   = p.numSettlingLaps + p.numInitializationLaps + numIterations;
%
% %    figure(h.fig1)
% %    h.basisParams(ii) = plot(iter.basisParams(startIndex:endIndex,1)*180/pi,...
% %        iter.basisParams(startIndex:endIndex,2)*180/pi,...
% %        'MarkerEdgeColor',colors{ii},'MarkerFaceColor',colors{ii},...
% %        'Color',colors{ii},'MarkerSize',markerSize,'Marker',markers{ii});
% %    h.text(ii) = text(iter.basisParams(startIndex,1)*180/pi,...
% %        iter.basisParams(startIndex,2)*180/pi,'$\leftarrow$Start','FontSize',fontSize,...
% %        'Color',colors{ii});
% %    hold on
%
%    figure(h.fig2)
%    h.performanceIndex(ii) = plot(iter.performanceIndex,...
%        'MarkerEdgeColor',colors{ii},'MarkerFaceColor',colors{ii},...
%        'Color',colors{ii},'MarkerSize',markerSize,'Marker',markers{ii});
%    hold on
% end
%
%
% figure(h.fig1)
% grid on
% xlabel('Course Width, [deg]')
% ylabel('Course Height, [deg]')
% title('Evolution of Basis Parameters in Design Space')
% legend([h.basisParams(1),h.basisParams(2),h.basisParams(3)],...
%     'Initial Condition 1','Initial Condition 2','Initial Condition 3')
% set(gca,'FontSize',fontSize)
%
%
%
% figure(h.fig2)
% grid on
% xlabel('Iteration Number')
% ylabel('Performance Index')
% title('Performance Index Vs Iteration Number')
% h.legend2 = legend([h.performanceIndex(1),h.performanceIndex(2),h.performanceIndex(3)],...
%     {'Initial Condition 1','Initial Condition 2','Initial Condition 3'},...
%     'Location','southeast');
% xlim(get(gca,'XLim').*[1 0]+[0 endIndex])
% set(gca,'FontSize',fontSize)
%
% drawnow
%
% % saveas(h.fig1,fullfile(pwd,'figuresForPresentation','basisParameterEvolution.png'))
% % saveas(h.fig1,fullfile(pwd,'figuresForPresentation','basisParameterEvolution.fig'))
%
%
%
% saveas(h.fig2,fullfile(pwd,'figuresForPresentation','performanceIndexEvolution.png'))
% saveas(h.fig2,fullfile(pwd,'figuresForPresentation','performanceIndexEvolution.fig'))


%%
% close all
%
% % load(fullfile(pwd,'data','wide_succeeded_194412_28112017.mat'))
% outfile = fullfile(pwd,'figuresForPresentation','wholeOptmization.gif');
% startIndex = p.numSettlingLaps + p.numInitializationLaps+1;
% endIndex   = startIndex+20;
% el  = 90-iter.waypointZeniths*180/pi;
% az  = iter.waypointAzimuths*180/pi;
% el = [el(:,end) el];
% az = [az(:,end) az];
% h.lastPlot = plot(az(p.numSettlingLaps+1,:),el(p.numSettlingLaps+1,:),'Marker','o',...
%     'MarkerEdgeColor','r','MarkerFaceColor','r',...
%     'MarkerSize',15,'Color','r');
% hold on
% grid on
% xlabel('Waypoint Azimuth Angle, [deg]')
% ylabel('Waypoint Zenith Angle, [deg]')
% title('Iteration 1')
% set(gca,'FontSize',fontSize)
% xlim([min(min(az)) max(max(az))])
% ylim([min(min(el)) max(max(el))])
% for ii = startIndex:1:endIndex
% %     saveas(h.lastPlot,fullfile(pwd,'figuresForPresentation',sprintf('courseShape_%2d.png',ii-startIndex+1)))
% frame = getframe(1);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%
%
%     % On the first loop, create the file. In subsequent loops, append.
%     if ii==startIndex
%         imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',1);
%     else
%         imwrite(imind,cm,outfile,'gif','DelayTime',0.5,'writemode','append');
%     end
%
%     h.lastPlot.Color = 0.6 *[1 1 1];
%     h.lastPlot.Marker = 'none';
%     h.lastPlot = plot(az(ii,:),el(ii,:),'Marker','o',...
%     'MarkerEdgeColor','r','MarkerFaceColor','r',...
%     'MarkerSize',15,'Color','r');
%     title(sprintf('Iteration %d',ii-startIndex+2))
%
% end

%%
% w = [80 75 85 80  80 75 72.5];
% h = [7  7  7  6.5 7.5 6.5 6.25];
% J = [2020 2100 1900 2100 1900 2190 2240];
% for ii = length(w):-1:1
%     X(ii,:) = [1 w(ii) w(ii)^2 h(ii) h(ii)^2];
% end
% C1 = inv((X(1:5,:)'*X(1:5,:)))*X(1:5,:)'*J(1:5)';
% C2 = inv((X(1:6,:)'*X(1:6,:)))*X(1:6,:)'*J(1:6)';
% C3 = inv((X(1:7,:)'*X(1:7,:)))*X(1:7,:)'*J(1:7)';
% w1Opt = -C1(2)/(2*C1(3));
% h1Opt = -C1(4)/(2*C1(5));
% w2Opt = -C2(2)/(2*C2(3));
% h2Opt = -C2(4)/(2*C2(5));
% w3Opt = -C3(2)/(2*C3(3));
% h3Opt = -C3(4)/(2*C3(5));
% 
% 
% x = linspace(0.95*min([wOpt w min([w1Opt w2Opt w3Opt])-(max(w)-wOpt)]),1.05*max([wOpt w]));
% y = linspace(0.95*min([hOpt h min([h1Opt h2Opt h3Opt])-(max(h)-hOpt)]),1.05*max([hOpt h]));
% [x,y] = meshgrid(x,y);
% J1Est = C1(1)+C1(2)*x+C1(3)*x.^2+C1(4)*y+C1(5)*y.^2;
% J2Est = C2(1)+C2(2)*x+C2(3)*x.^2+C2(4)*y+C2(5)*y.^2;
% J3Est = C3(1)+C3(2)*x+C3(3)*x.^2+C3(4)*y+C3(5)*y.^2;
% 
% figure
% 
% 
% for ii = 5:7
%     scat = scatter3(w(1:ii),h(1:ii),J(1:ii),'MarkerFaceColor','r','SizeData',4*72,'CData',[1 0 0]);
%     hold on
%     xlim([min(min(x)) max(max(x))])
%     ylim([min(min(y)) max(max(y))])
%     zlim([min(min([J1Est J2Est J3Est])) max(max([J1Est J2Est J3Est]))])
%     xlabel('Course Width, [deg]')
%     ylabel('Course Height, [deg]')
%     zlabel('Performance Index')
%     set(gca,'FontSize',fontSize)
%     view([70.9000   25.2000])
%     colormap winter
%     set(gcf,'PaperOrientation','Portrait')
%     if ii ==5
%         saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit1.png'))
%     end
%     switch ii
%         case 5
%             surface = surf(x,y,J1Est,'EdgeColor','none');
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit2.png'))
%             scat = scatter3(w1Opt,h1Opt,C1(1)+C1(2)*w1Opt+C1(3)*w1Opt.^2+C1(4)*h1Opt+C1(5)*h1Opt.^2,...
%                 'MarkerFaceColor','b','SizeData',4*72,'CData',[0 0 1]);
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit3.png'))
%             delete(surface)
%             delete(scat)
%         case 6
%             surface = surf(x,y,J2Est,'EdgeColor','none');
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit4.png'))
%             scat = scatter3(w2Opt,h2Opt,C2(1)+C2(2)*w2Opt+C2(3)*w2Opt.^2+C2(4)*h2Opt+C2(5)*h2Opt.^2,...
%                 'MarkerFaceColor','b','SizeData',4*72,'CData',[0 0 1]);
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit5.png'))
%             delete(surface)
%             delete(scat)
%             
%         case 7
%             surface = surf(x,y,J3Est,'EdgeColor','none');
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit6.png'))
%             scat = scatter3(w3Opt,h3Opt,C3(1)+C3(2)*w3Opt+C3(3)*w3Opt.^2+C3(4)*h3Opt+C3(5)*h3Opt.^2,...
%                 'MarkerFaceColor','b','SizeData',4*72,'CData',[0 0 1]);
%             saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit7.png'))
%            
%     end
%     
% 
% end

% saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit1.png'))
% 
% surface = surf(x,y,JEst,'EdgeColor','none');
% 
% % saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit2.png'))
% scat = scatter3(wOpt,hOpt,C1(1)+C1(2)*wOpt+C1(3)*wOpt.^2+C1(4)*hOpt+C1(5)*hOpt.^2,...
%     'MarkerFaceColor','r','SizeData',4*72,'CData',[1 0 0]);
% % saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit3.png'))
% 
% C2 = inv((X(1:6,:)'*X(1:6,:)))*X(1:6,:)'*J(1:6)';
% wOpt = -C2(2)/(2*C2(3));
% hOpt = -C2(4)/(2*C2(5));
% x = linspace(0.95*min([wOpt w wOpt-(max(w)-wOpt)]),1.05*max([wOpt w]));
% y = linspace(0.95*min([hOpt h hOpt-(max(h)-hOpt)]),1.05*max([hOpt h]));
% [x,y] = meshgrid(x,y);
% JEst = C2(1)+C2(2)*x+C2(3)*x.^2+C2(4)*y+C2(5)*y.^2;
% 
% scat = scatter3(w,h,J,'MarkerFaceColor','r','SizeData',4*72,'CData',[1 0 0]);
% hold on
% xlim([min(min(x)) max(max(x))])
% ylim([min(min(y)) max(max(y))])
% zlim([min(min(JEst)) max(max(JEst))])
% 
% xlabel('Course Width, [deg]')
% ylabel('Course Height, [deg]')
% zlabel('Performance Index')
% set(gca,'FontSize',fontSize)
% view([70.9000   25.2000])
% % saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit1.png'))
% 
% surface = surf(x,y,JEst,'EdgeColor','none');
% colormap winter
% % saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit2.png'))
% scat = scatter3(wOpt,hOpt,C1(1)+C1(2)*wOpt+C1(3)*wOpt.^2+C1(4)*hOpt+C1(5)*hOpt.^2,...
%     'MarkerFaceColor','r','SizeData',4*72,'CData',[1 0 0]);
% % saveas(gcf,fullfile(pwd,'figuresForPresentation','surfaceFit3.png'))



%%
% close all
% el  = pi/2-iter.waypointZeniths(1,:);
% az  = iter.waypointAzimuths(1,:);
% el = [el(:,end) el];
% az = [az(:,end) az];
% r=p.initPositionGFS(1);
% [waypointX,waypointY,waypointZ]=sph2cart(az,el,r*ones(size(az)));
% plotHemisphere
% h.hemisphere.CData=0.6*ones(size(h.hemisphere.CData));
% h.hemisphere.EdgeColor='none';
% hold on
% grid on
% scatter3(waypointX,waypointY,waypointZ,...
%     'MarkerEdgeColor','r','MarkerFaceColor','r')
%
% axis equal
% xlim([0 r])
% ylim(r*[-1 1])
% zlim([0 r])
% % axis vis3d
% view([80 20])
%
% xlabel('x position, [m]')
% ylabel('y position, [m]')
% zlabel('z position, [m]')
% set(gca,'FontSize',36)
%
% set(get(gca,'xlabel'),'rotation',-71);
%
%
% wingX = 0.5*p.refLengthWing * [1 -1 -1  1 1];
% wingY = 0.5*p.wingSpan      * [1  1 -1 -1 1];
% wingZ = [0 0 0 0 0];
%
% rudderX = 0.5*p.refLengthRudder * [1 -1 -1  1 1]-p.wingSpan;
% rudderY = [0 0 0 0 0];
% rudderZ = 0.5*p.rudderSpan      * [1  1 -1 -1 1];
%
% fuselageX = [wingX(3) rudderX(1)];
% fuselageY = [0 0];
% fuselageZ = [0 0];
%
% pos = tsc.positionGFC.getsampleusingtime(1).data;
% eul = tsc.eul.getsampleusingtime(1).data;
%
% plot3([0 pos(1)],[0 pos(2)],[0 pos(3)],'Color','k')
%
% [wingX  , wingY  , wingZ  ] = bfc2gfc(wingX,wingY,wingZ,pos,eul);
% [rudderX, rudderY, rudderZ] = bfc2gfc(rudderX,rudderY,rudderZ,pos,eul);
% [fuselageX, fuselageY, fuselageZ] = bfc2gfc(fuselageX,fuselageY,fuselageZ,pos,eul);
%
% h.wing     = plot3(wingX   ,wingY   ,wingZ  , 'Color','k','LineWidth',1);
% h.rudder   = plot3(rudderX ,rudderY ,rudderZ, 'Color','k','LineWidth',1);
% h.fuselage = plot3(fuselageX,fuselageY,fuselageZ,'Color','k','LineWidth',1);
%
%
%
%
%
%
%
phaseShift = linspace(1,1.05,4);
vertOffset = linspace(0,0.1,4);
for ii = length(phaseShift):-1:1
    close all
    x = linspace(0,4*pi);
    y    = vertOffset(ii)+0.6*cos(phaseShift(ii)*x)+0.2*x;
    yDes = 0.6*cos(x)+0.2*x;
    plot(x,y,'LineWidth',4,'Color','k')
    hold on
    plot(x,yDes,'LineWidth',4,'LineStyle','--','Color','k')
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    xlabel('Time')
    xlim([x(1) x(end)])
    set(gca,'FontSize',2*48)
    saveas(gcf,fullfile(pwd,'figuresForPresentation',sprintf('ILCTracking_%2d.png',ii)))
    
    figure
    plot(x,yDes-y,'LineWidth',4,'Color','k')
    ylim([-0.5 0.2])
    set(gca,'xtick',[])
    set(gca,'ytick',[])
    xlabel('Time')
    ylabel('Error')
    xlim([x(1) x(end)])
    set(gca,'FontSize',2*48)
    saveas(gcf,fullfile(pwd,'figuresForPresentation',sprintf('ILCError_%2d.png',ii)))

end












