clc
close all

% Check to see that we're in the right directory
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
startIndex = regexp(workingDir,[modelName,'.slx']);
fullDirPath = workingDir(1:startIndex-2);
if ~strcmp(pwd,fullDirPath) % If not then change it
    cd(fullDirPath)
end
clear

parameters

