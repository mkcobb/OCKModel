close all
clearvars -except tscc p
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
cd(fileparts(workingDir))

% load(fullfile(pwd,'data','data.mat'))
clc

fprintf('\nPlotting animation of whole optimization.\n')

outfile = fullfile(pwd,'figures','wholeOptmization.gif');

frameRate = 10;
nColors = 256;
heatColorMap = [linspace(0,1,nColors);zeros(1,nColors);zeros(1,nColors)]';
heatColorMap = [0 0 0;heatColorMap];



% Plot a bunch of stuff
h.fig = figure;
plotHemisphere
hold on
h.hemisphere.EdgeColor = 'none';
h.hemisphere.CData = 0*ones(size(h.hemisphere.CData));

xlim(p.initPositionGFS(1)*[0 1])
ylim(p.initPositionGFS(1)*[-1 1])
zlim([0 p.initPositionGFS(1)])

axis square
axis fill
view([65 30])

xlabel('x, [m]',...
    'FontSize',24)
ylabel('y, [m]',...
    'FontSize',24)
zlabel('z, [m]',...
    'FontSize',24)

% Setup colorbar
for ii = 1:length(tscc)-1
    if ii ==1
        minPAR = min(tscc{ii}.powerFactor.data);
        maxPAR = max(tscc{ii}.powerFactor.data);
    else
        minPAR = min([min(tscc{ii}.powerFactor.data) minPAR]);
        maxPAR = max([max(tscc{ii}.powerFactor.data) maxPAR]);
    end
    
end



for ii = 1:length(tscc)-1
    tsc=tscc{ii};
    h.colorbar = colorbar;
    h.colorbarLabel = ylabel(h.colorbar,'PAR');
    h.colormap=colormap(heatColorMap);
    caxis([minPAR maxPAR])
    ticks = [h.colorbar.Ticks mean(tsc.powerFactor.data)];
    tickLabels = {h.colorbar.TickLabels{:}, 'Mean'};
    [ticks,sortIndex]=sort(ticks,'ascend');
    tickLabels = tickLabels(sortIndex);
    set(h.colorbar,'FontSize',24,'TickLabelInterpreter','Latex',...
        'Position',h.colorbar.Position+[-0.01 0 0.01 0],'Limits',[minPAR maxPAR],...
        'Ticks',ticks,'TickLabels',tickLabels)
    set(h.colorbarLabel,'Rotation',0,'Units','Normalized',...
        'Position',[0.5 1.07],'FontSize',24,'Interpreter','Latex',...
        'FontSize',30);
    
    
    path = tsc.positionGFC.data;
    powerFactor = tsc.powerFactor.data;
    
    cData = getColor(powerFactor,minPAR,maxPAR,heatColorMap);
    sData = 100*ones(size(path(:,1)));
    
    h.PAR=scatter3(path(:,1),path(:,2),path(:,3),sData,cData,...
        'Marker','.');
    title(sprintf('Iteration %2d ',ii),'FontSize',36,'Interpreter','Latex')
    drawnow
    % Save single frames
    saveas(h.fig,fullfile(pwd,'figures','animationFrames','png',sprintf('wholeOpt_%2d.png',ii)));
    saveas(h.fig,fullfile(pwd,'figures','animationFrames','fig',sprintf('wholeOpt_%2d.fig',ii)));
    frame = getframe(1);
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
    
    % On the first loop, create the file. In subsequent loops, append.
    if ii==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',0.5,'writemode','append');
    end
    delete(h.colorbar)
    delete(h.PAR);
    
    
end
