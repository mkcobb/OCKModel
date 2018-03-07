function h = plotTargetWaypoint(varargin)
tsc = evalin('base','tsc');
if numel(varargin)
    lapNumber = varargin{1};

    times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
    tsc = getsampleusingtime(tsc,times(1),times(end));
end


h.fig = createFigure();


ax1=subplot(3,1,1);
h.heading  = plot(tsc.time,tsc.targetWaypointIndex.data(:,1),'DisplayName','Index');
grid on
ylabel('Index')
set(gca,'FontSize',24)

ax2=subplot(3,1,2);
h.heading  = plot(tsc.time,tsc.targetWaypoint.data(:,1),'DisplayName','Azimuth');
grid on
ylabel('Azimuth, [rad]')
set(gca,'FontSize',24)

ax3=subplot(3,1,3);
h.desired  = plot(tsc.time,tsc.targetWaypoint.data(:,2),'DisplayName','Zenith');
grid on
ylabel('Zenith, [rad]')
set(gca,'FontSize',24)


linkaxes([ax1 ax2 ax3],'x')