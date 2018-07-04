 if sim.verbose
    fprintf('\n--------------------------------\n' )
    fprintf('\nStarting Model.\n')
    tic
end

% Switch to the right directory
cd(fileparts(which([sim.modelName ,'.slx'])))

clearvars logsout tmp_raccel_logsout