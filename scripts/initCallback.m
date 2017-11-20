% clc
close all

if p.verbose
    fprintf('\nInitializing model.\n')
end

% Move to the right directory
cd(fileparts(which('CDCJournalModel.slx')))
