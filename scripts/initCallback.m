clc
close all
clear all
modelName = 'CDCJournalModel';
workingDir = which([modelName,'.slx']);
startIndex = regexp(workingDir,[modelName,'.slx']);
cd(workingDir(1:startIndex-2))
addpath(genpath(pwd));
clearvars -except modelName

wingTable   = buildAirfoilTable();
rudderTable = buildRudderTable();
parameters