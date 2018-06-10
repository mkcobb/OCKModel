clear;clear mex;
% Change to the directory containing the model
cd(fileparts(which('CDCJournalModel.slx')))
% Add all subdirectories to the path
addpath(genpath(pwd));

if exist('out.mat','file')==2
    delete out.mat
end

if exist('CDCJournalModel.slxc','file')==2
    delete CDCJournalModel.slxc
end
% Load simulation parameters.
p = simulationParametersClass;
% Load up wind data
loadWindData;
% Initialize Variants
initializeVariants;
% Initialize Busses
initializeBusses;