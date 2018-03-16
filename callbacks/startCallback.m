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

% Check if the slprj file is on the path, if so, remove it.
% pathCell = regexp(path, pathsep, 'split');
% if ispc  % Windows is not case-sensitive
%   onPath = any(strcmpi(fullfile(pwd,'slprj'), pathCell));
% else
%   onPath = any(strcmp(fullfile(pwd,'slprj'), pathCell));
% end
% 
% Remove it from the path
% if onPath 
%     rmpath(fullfile(pwd,'slprj'));
% end
% 
% Delete the 
% if isdir(fullfile(pwd,'slprj'))
%     cmd_rmdir(fullfile(pwd,'slprj'));
% end