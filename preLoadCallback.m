% Change to the directory containing the model
cd(fileparts(which('CDCJournalModel.slx')))
% Add all subdirectories to the path
addpath(genpath(pwd));
% Load simulation parameters.
p = simulationParametersClass;