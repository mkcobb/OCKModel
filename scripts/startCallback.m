if p.verbose
    fprintf('\nStarting Model.\n')
end

if p.verbose
    tic
end

% Switch to the right directory
cd(fileparts(which('CDCJournalModel.slx')))