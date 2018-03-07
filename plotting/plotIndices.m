function h = plotIndices()
tsc = evalin('base','tsc');

h.figure = createFigure();

h.axStartIndex = subplot(3,1,1);
h.startIndex = plot(tsc.startIndex);
grid on

h.axLocalIndex = subplot(3,1,2);
h.localIndex  = plot(tsc.localIndex);
grid on

h.axAbsoluteIndex = subplot(3,1,3);
h.localIndex  = plot(tsc.indexOfClosestPoint);
grid on

linkaxes([h.axStartIndex h.axLocalIndex h.axAbsoluteIndex],'x')

end
