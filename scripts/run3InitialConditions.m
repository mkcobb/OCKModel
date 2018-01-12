close all;clear;clc;bdclose all;path(pathdef);
% For some incredibly frustrating reason, this is unable to read the
% out.mat file after running, but if I run the callback manually,
% everything is fine.
load_system('CDCJournalModel')
p.numOptimizationLaps = 300;
ICs = {'short'};
p.saveOnOff = 1;
p.windVariant = 1;
p.plotsOnOff = 0;
for ii = 1:length(ICs)
   p.ic = ICs{ii};
   sim('CDCJournalModel')
end