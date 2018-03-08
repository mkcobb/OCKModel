function plotPaperFigures()
close all
%% Plot the constant wind performance index
h = plotPaperPerformanceIndices('constant');
for ii = 1:length(h)
    savePlot(h{ii}.figure,h{ii}.fileName);
end
clear h

%% Plot the wind profile
h.fig = plotPaperWindProfile();
savePlot(h.fig,'windProfile');
clear h

%% Plot the variable wind performance index
h = plotPaperPerformanceIndices('variable');
for ii = 1:length(h)
    savePlot(h{ii}.figure,h{ii}.fileName);
end

end