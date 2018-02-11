clear
% Change to the directory containing the model
cd(fileparts(which('CDCJournalModel.slx')))
% Add all subdirectories to the path
addpath(genpath(pwd));

if exist('out.mat','file')==2
    delete out.mat
end
% Load simulation parameters.
p = simulationParametersClass;
% Load up wind data
loadWindData;