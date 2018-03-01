function h = plotRudderAngle(varargin)
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

h.rudderAngle = plot(tsc.rudderAngleCommand);
hold on
grid on
h.rudderAngleUpperLimit = plot(tsc.rudderAngleUpperSaturation,'Color','r');
h.rudderAngleLowerLimit = plot(tsc.rudderAngleLowerSaturation,'Color','r');

end