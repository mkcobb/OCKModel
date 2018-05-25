function plotPaperFigures(version)

close all
%% Plot how the performance index changes from iteration to iteration
h = plotPaperIterationVariation(version);
savePlot(h.figure,'instantaneousPowerAugmentation');
clear h

%% Plot the basis parameters
h = plotPaperBasisParameters(version);
savePlot(h.figure,'basisParameters');
clear h

%% Plot the constant wind performance index
h = plotPaperPerformanceIndices('constant',version);
for ii = 1:length(h)
    savePlot(h{ii}.figure,h{ii}.fileName);
end
clear h

%% Plot the wind profile
h.fig = plotPaperWindProfile();
savePlot(h.fig,'windProfile');
clear h

%% Plot the variable wind performance index
h = plotPaperPerformanceIndices('variable',version);
for ii = 1:length(h)
    savePlot(h{ii}.figure,h{ii}.fileName);
end

findfigs 

end