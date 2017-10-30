% clc
close all

% Check to see that we're in the right directory
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
cd(fileparts(workingDir))
