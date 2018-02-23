close all
clearvars -except tscc p
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
cd(fileparts(workingDir))

% load(fullfile(pwd,'data','data.mat'))
% clc

plot(1:length(p.performanceIndexOpt),p.performanceIndexOpt,...
    'Marker','o','MarkerSize',10,'MarkerFaceColor','k',...
    'MarkerEdgeColor','k','Color','k')
xlabel('Iteration Number')
ylabel('Performance Index')
set(gca,'FontSize',36)


saveas(gcf,fullfile(pwd,'figures','Opt_performanceIndex.png'));
saveas(gcf,fullfile(pwd,'figures','Opt_performanceIndex.fig'));


figure
plot(1:length(p.meanPAROpt),p.meanPAROpt,...
    'Marker','o','MarkerSize',10,'MarkerFaceColor','k',...
    'MarkerEdgeColor','k','Color','k')
xlabel('Iteration Number')
ylabel('Mean PAR')
set(gca,'FontSize',36)


saveas(gcf,fullfile(pwd,'figures','Opt_PAR.png'));
saveas(gcf,fullfile(pwd,'figures','Opt_PAR.fig'));