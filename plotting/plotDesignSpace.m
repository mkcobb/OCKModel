function h = plotDesignSpace(varargin)
tsc = evalin('base','tsc');
iter = evalin('base','iter');
if numel(varargin)
    lapNumber = varargin{1};

    times = tsc.time(tsc.currentIterationNumber.data==lapNumber);
    tsc = getsampleusingtime(tsc,times(1),times(end));
end

h.fig = createFigure();
scatter(iter.basisParams(:,1),iter.basisParams(:,2));
grid on
hold on
plot(iter.basisParams(:,1),iter.basisParams(:,2));
end