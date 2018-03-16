function h = plotBasisParameters(varargin)
tsc  = evalin('base','tsc');
iter = evalin('base','iter');
if numel(varargin)
    lapNumber = varargin{1};
    times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
    tsc = getsampleusingtime(tsc,times(1),times(end));
end

h.figure = createFigure();

h.axTop = subplot(2,1,1);
hold on
grid on
h.azimuthTop = stairs(iter.basisParams(:,1));
h.zenithTop  = stairs(iter.basisParams(:,2));

h.axBottom = subplot(2,1,2);
hold on
grid on
h.azimuthBottom = stairs(iter.startTimes,iter.basisParams(:,1));
h.zenithBottom  = stairs(iter.startTimes,iter.basisParams(:,2));

