% Check to see that we're in the right directory
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
cd(fileparts(workingDir))
addpath(genpath(fileparts(workingDir)));
parameters