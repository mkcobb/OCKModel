 if p.verbose
    fprintf('\n--------------------------------\n' )
    fprintf('\nStarting Model.\n')
    fprintf('Settings:')
    p
   
    fprintf('\nEst. finish time: %s\n\n',datestr(datetime('now')+seconds(2240),'HH:MM'))
end

if p.verbose
    tic
end

% Switch to the right directory
cd(fileparts(which('CDCJournalModel.slx')))

clearvars logsout tmp_raccel_logsout