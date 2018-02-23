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


ax1=subplot(3,1,1);
h.heading  = plot(tsc.heading,'DisplayName','Heading');
hold on
grid on
ax2=subplot(3,1,2);
h.desired  = plot(tsc.headingDes,'DisplayName','Desired');
grid on
ax3=subplot(3,1,3);
h.setpoint = plot(tsc.headingSetpoint,'DisplayName','Setpoint');
grid on
legend
set(gca,'FontSize',24)
linkaxes([ax1 ax2 ax3],'x')
