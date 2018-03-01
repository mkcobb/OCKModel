function h = plotRudderAngle(varargin)
tsc = evalin('base','tsc');
if numel(varargin)
    lapNumber = varargin{1};
    times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
    tsc = getsampleusingtime(tsc,times(1),times(end));
end

h.figure = createFigure();

h.rudderAngle = plot(tsc.rudderAngleCommand);
hold on
grid on
h.rudderAngleUpperLimit = plot(tsc.rudderAngleUpperSaturation,'Color','r');
h.rudderAngleLowerLimit = plot(tsc.rudderAngleLowerSaturation,'Color','r');

end