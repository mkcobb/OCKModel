function plotPaperFigures()
close all

%% Plot the wind profile
h.fig = plotPaperWindProfile();
savePlot(h.fig,'windProfile');

h = plotPaperPerformanceIndices();

for ii = 1:length(h)

    savePlot(h{ii}.figure,h{ii}.fileName);

end

end