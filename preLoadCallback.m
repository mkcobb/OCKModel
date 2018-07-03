clear;clear mex;
% Change to the directory containing the model
cd(fileparts(which('OCKModel.slx')))
% Add all subdirectories to the path
addpath(genpath(pwd));

if exist('out.mat','file')==2
    delete out.mat
end

if exist('OCKModel.slxc','file')==2
    delete OCKModel.slxc
end
% Load simulation parameters.
initializeClasses
% Load up wind data
loadFlowProfiles;
% Initialize Variants
initializeVariants;
% Initialize Busses
initializeBusses;