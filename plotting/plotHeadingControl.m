function h = plotHeadingControl(varargin)
tsc = evalin('base','tsc');
if numel(varargin)
    lapNumber = varargin{1};

    times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
    tsc = getsampleusingtime(tsc,times(1),times(end));
end


if size(get(groot,'MonitorPositions'),1)>1
    h.fig = figure('units','normalized','position',[-1 0 1 0.9]);
else
    h.fig = figure('units','normalized','position',[0 0 1 0.9]);
end


h.ax1 = subplot(3,2,1);
h.heading  = plot(tsc.heading,'DisplayName','Heading');
grid on
set(gca,'FontSize',24)

h.ax2 = subplot(3,2,3);
h.desired  = plot(tsc.headingDes,'DisplayName','Desired');
grid on
set(gca,'FontSize',24)

h.ax3 = subplot(3,2,5);
h.setpoint = plot(tsc.headingSetpoint,'DisplayName','Setpoint');
grid on
legend
set(gca,'FontSize',24)


h.ax4 = subplot(3,2,2);
h.setpoint = plot(tsc.headingDes,'DisplayName','Setpoint');
grid on
legend
set(gca,'FontSize',24)

h.ax5 = subplot(3,2,4);
h.setpoint = plot(tsc.headingDesDot,'DisplayName','Setpoint');
grid on
legend
set(gca,'FontSize',24)

h.ax6 = subplot(3,2,6);
h.setpoint = plot(tsc.headingDesDDot,'DisplayName','Setpoint');
grid on
legend
set(gca,'FontSize',24)

linkaxes([h.ax1 h.ax2 h.ax3 h.ax4 h.ax5 h.ax6],'x')
