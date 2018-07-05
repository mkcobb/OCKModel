function h = plotAirfoilParameters(wr)

% function to plot the parameters of a specified airfoil, either "wing" or
% "rudder"

wr=lower(wr);

switch wr
    case 'w'
        foilTable = evalin('base',sprintf('plant.%sTable','wing'));
        titleString = 'Wing : ';
    case 'r'
        foilTable = evalin('base',sprintf('plant.%sTable','rudder'));
        titleString = 'Rudder : ';
end

h.fig = createFigure;

h.ax1 = subplot(2,2,1);
plot(foilTable.alpha,foilTable.cl,'LineWidth',2)
grid on
hold on
plot(foilTable.alpha,foilTable.alpha*foilTable.kl1+foilTable.kl0)
axis tight
line(foilTable.clStartAlpha*[1 1],h.ax1.YLim)
line(foilTable.clEndAlpha*[1 1],h.ax1.YLim)
xlabel('$\alpha$')
ylabel('$C_L$')
h.ax1.FontSize = 24;


h.ax2 = subplot(2,2,2);
plot(foilTable.alpha,foilTable.cd,'LineWidth',2)
grid on
hold on
plot(foilTable.alpha,foilTable.alpha.^2*foilTable.kd2+foilTable.kd1*foilTable.alpha+foilTable.kd0)
axis tight
line(foilTable.cdStartAlpha*[1 1],h.ax2.YLim)
line(foilTable.cdEndAlpha*[1 1],h.ax2.YLim)
xlabel('$\alpha$')
ylabel('$C_D$')
h.ax2.FontSize = 24;

h.ax3 = subplot(2,2,3);
plot(foilTable.alpha,foilTable.cl./foilTable.cd,'LineWidth',2)
grid on
hold on
xlabel('$\alpha$')
ylabel('$C_L$ \ $C_D$')
h.ax3.FontSize = 24;

h.title = annotation('textbox', [0 0.9 1 0.1], ...
    'String', [titleString foilTable.fileName], ...
    'EdgeColor', 'none', ...
    'HorizontalAlignment', 'center',...
    'FontSize',24,...
    'Interpreter','none');

end