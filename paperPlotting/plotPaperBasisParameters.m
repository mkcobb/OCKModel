function h = plotPaperBasisParameters()
%% Create plots of the basis parameters under constant wind
files = dir(fullfile(pwd,'paperData','constantWind'));
files = files(3:end);
files = {files.name};
files = split(files,'.');
files = files(:,:,1);

colors = {'k',0.33*[1 1 1],0.66*[1 1 1]};



h.figure = createFigure();
h.figure.Name = 'BasisParameters_ConstantWind';
h.axTop  = subplot(2,1,1);
grid on
ylabel({'Azimuth Basis','Parameter, [deg]'})



h.axBottom = subplot(2,1,2);
grid on
ylabel({'Zenith Basis','Parameter, [deg]'})
xlabel(h.axTop,'Iteration Number, j')
xlabel(h.axBottom,'Time, t [min]')

hold(h.axTop,'on')
hold(h.axBottom,'on')

title(h.axTop,'Basis Parameters Vs Time and Iteration')
h.axTop.FontSize = 32;
h.axBottom.FontSize = 32;

for jj = 1:length(files)
    load(fullfile(pwd,'paperData','constantWind',files{jj}))
    name = strsplit(files{jj},'_');
    name = name{1};
    plot(iter.basisParams(:,1)*180/pi,'Parent',h.axTop,'LineWidth',1.5,'Color',colors{jj},'DisplayName',name)
    plot(iter.startTimes/60,iter.basisParams(:,2)*180/pi,'Parent',h.axBottom,'LineWidth',1.5,'Color',colors{jj})
end
legend(h.axTop,'Location','northeast','Orientation','Horizontal')
axis(h.axTop,'tight')
axis(h.axBottom,'tight')
end


