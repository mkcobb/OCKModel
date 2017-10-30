close all
clearvars -except tscc p
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
cd(fileparts(workingDir))

load(fullfile(pwd,'data','data.mat'))
clc

fprintf('\nPlotting animation of a single iteration.\n')

outfile = fullfile(pwd,'figures','singleIteration.gif');


iterNum = 1;
tsc=tscc{iterNum};
frameRate = 10;

% Get the indices of the time stamps that we want to plot
[~,indices] = min(abs(bsxfun(@minus,0:1/frameRate:tsc.Time(end),tsc.time)));

pos = tsc.positionGFC.data(1,:);
eul = tsc.eul.data(1,:);
maxPAR = max(tsc.powerFactor.data);
minPAR = min(tsc.powerFactor.data);
nColors = 256;
heatColorMap = [linspace(0,1,nColors);zeros(1,nColors);linspace(1,0,nColors)]';
heatColorMap = [0 0 0;heatColorMap];


%%Plot a bunch of stuff
h.fig = figure;
plotHemisphere
hold on
plotAWE

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

% Begin animation loop
for ii = 1:length(indices)
    pos = tsc.positionGFC.data(indices(ii),:);
    eul = tsc.eul.data(indices(ii),:);
    path = tsc.positionGFC.data(1:indices(ii),:);
    powerFactor = tsc.powerFactor.data(1:indices(ii),:);
    plotAWE
    plotPath
    title(sprintf('t = %.2f [s]',tsc.time(indices(ii))),'FontSize',36,'Interpreter','Latex')
    drawnow
    
    frame = getframe(1);    
    im = frame2im(frame);
    [imind,cm] = rgb2ind(im,256);
    
 
    % On the first loop, create the file. In subsequent loops, append.
    if ii==1
        imwrite(imind,cm,outfile,'gif','DelayTime',0,'loopcount',inf);
    else
        imwrite(imind,cm,outfile,'gif','DelayTime',1/frameRate,'writemode','append');
    end
 
    
end
