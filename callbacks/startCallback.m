if p.verbose
    fprintf('\nStarting Model.\n')
    fprintf('Settings:')
    p
end

if p.verbose
    tic
end

% Switch to the right directory
cd(fileparts(which('CDCJournalModel.slx')))
