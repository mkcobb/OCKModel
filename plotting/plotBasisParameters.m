function h = plotBasisParameters(varargin)
tsc = evalin('base','tsc');
iter = evalin('base','iter');
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

h.ax1Bottom = subplot(2,1,1);
h.azimuthVsTime  = plot(tsc.time,tsc.basisParams.data(:,1),...
    'DisplayName','Azimuth');
hold on
grid on
ylabel('Azimuth, [rad]')
% xlabel('Time. [s]')
set(gca,'FontSize',24)
h.ax1Top = axes('Position',h.ax1Bottom.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none','FontSize',24);
grid on
hold on
% xlabel('Iteration')
h.azimuthVsIteration = plot(iter.basisParams(:,1));

h.ax2Bottom = subplot(2,1,2);
h.zenithVsTime  = plot(tsc.time,tsc.basisParams.data(:,2),...
    'DisplayName','Zenith');
hold on
grid on
ylabel('Zenith, [rad]')
% xlabel('Time. [s]')
set(gca,'FontSize',24)
h.ax2Top = axes('Position',h.ax2Bottom.Position,...
    'XAxisLocation','top',...
    'YAxisLocation','right',...
    'Color','none','FontSize',24);
grid on
hold on
% xlabel('Iteration')
h.zenithVsIteration = plot(iter.basisParams(:,2));

linkaxes([h.ax1Bottom h.ax2Bottom],'x')
linkaxes([h.ax1Top h.ax2Top],'x')

linkaxes([h.ax1Bottom h.ax1Top],'y')
linkaxes([h.ax2Bottom h.ax2Top],'y')
