bdclose all
close all
clear
clear mex
clc
warning off MATLAB:nearlySingularMatrix
clc

% Change to correct root directory
filePath = strsplit(fileparts(which(mfilename)),filesep);
filePath = fullfile(filePath{1:end-1});
if isunix && ~strcmpi(filePath(1),filesep)
    filePath = [filesep filePath];
end
cd(filePath)
addpath(genpath(pwd))
% Run/Load parameters
parameters; 

% Setting to turn animation saving on/off
saveAnimation = 1;
outFile = fullfile(pwd,'figures','optResponseSurf.gif');

% Create cell array to store timeseries data
tscc={};

% Loading simulink model
if evalin('base','p.verbose')
    fprintf('\nLoading simulink model:\n%s\n',p.modelPath)
end
load_system(p.modelPath)

% Initial Condition
p.phiIC   = 7;
p.thetaIC = 100;

% Initial fit point distances
p.phiInitSep   = 0.25;
p.thetaInitSep = 2.5;

% 9 Point Initialization
p.phiInit   = p.phiIC   + p.phiInitSep  *[0 0 1  0 -1 1  1 -1 -1];
p.thetaInit = p.thetaIC + p.thetaInitSep*[0 1 0 -1  0 1 -1  1 -1] ;

% 5 Point Initialization
p.phiInit   = p.phiIC   + p.phiInitSep  *[0 0 1  0 -1];
p.thetaInit = p.thetaIC + p.thetaInitSep*[0 1 0 -1  0] ;


p.performanceIndexInit = zeros(size(p.phiInit));

% Running initialization simulations
if evalin('base','p.verbose') % Notify the user
    fprintf('\nPerforming %s initialization simulations:\n',...
        num2str(length(p.phiInit)))
end
for ii = 1:length(p.performanceIndexInit)
    if evalin('base','p.verbose') % Notify the user
        fprintf('%s/%s\n',num2str(ii),num2str(length(p.phiInit)))
    end
    % Generate the next set of waypoints
    p.initWaypoints(ii) = generateWaypoints(p.num,p.phiInit(ii),p.thetaInit(ii),p.elev);
    p.XInit(ii,:) = [1 p.thetaInit(ii) p.thetaInit(ii)^2 p.phiInit(ii) p.phiInit(ii)^2 ];
    p.waypoints = p.initWaypoints(ii);
    % Run the simulation
    sim('CDCJournalModel')
    % Calculate the performance index
    [p.performanceIndexInit(ii),p.meanEnergyInit(ii),p.errorNameInit{ii},p.errorIndexInit(ii)] ...
        = calculatePerformanceIndex(p,tsc);
    [p.meanPARInit(ii),tsc] = calculatePowerAugmentationRatio(tsc);
    % Save the first result as the first element of tscc
    if ii == 1
        tscc{1}=tsc;
    end
    % Check to see if the last simulation faulted/failed, if so, exit
    if any(p.errorIndexInit)
        if evalin('base','p.verbose')
            fprintf('\nInitialization failed: %s\nExiting...\n',p.errorNameInit{ii})
        end
        return
    end
end

% Calculating next design point
if evalin('base','p.verbose')
    fprintf('\nPerforming initial surface fit.\n')
end
p=nextDesignPoint(p);


% Beginning optimization
if evalin('base','p.verbose')
    fprintf('\nBeginning optimization.\n')
end
p.optIdx = 1;

while stopCondition(p)
    % Output status message
    if p.verbose
        fprintf('Running step %s\n',num2str(p.optIdx))
    end
    % Generate a new set of waypoints
    p.waypoints = generateWaypoints(p.num,p.heightsVec(p.optIdx),p.widthsVec(p.optIdx),p.elev);
    p.optWaypoints(p.optIdx) = p.waypoints;
    % Run the simulation
    sim('CDCJournalModel')
    % Calculate the performance index
    [p.performanceIndexOpt(p.optIdx),p.meanEnergyOpt(p.optIdx),...
        p.errorNameOpt{p.optIdx},p.errorIndexOpt(p.optIdx)] ...
        = calculatePerformanceIndex(p,tsc);
    [p.meanPAROpt(p.optIdx),tsc] = calculatePowerAugmentationRatio(tsc);
    % Check to see that the the last simulation didn't fail
    if any(p.errorIndexOpt) % If it did, exit
        if evalin('base','p.verbose')
            fprintf('\nOptimization failed: %s\nExiting...\n',p.errorNameOpt{ii})
        end
        return
    end
    % Calculate the next course geometry
    p = nextDesignPoint(p);
    
    % Save animation of optimization
    if saveAnimation ==1
        frame = getframe(1);
        im = frame2im(frame);
        [imind,cm] = rgb2ind(im,256);
        % On the first loop, create the file. In subsequent loops, append.
        if p.optIdx==1
            imwrite(imind,cm,outFile,'gif','DelayTime',0,'loopcount',inf);
        else
            imwrite(imind,cm,outFile,'gif','DelayTime',1,'writemode','append');
        end
    end
    % Increment the counter
    p.optIdx = p.optIdx +1;
    % Append the timeseries data
    tscc{p.optIdx}=tsc;
end

if evalin('base','p.verbose')
    fprintf('\nClosing simulink model:\n%s\n',p.modelPath)
end
close_system(p.modelPath)

if evalin('base','p.verbose')
    fprintf('\nSaving data to\n%s\n',fullfile(pwd,'data','data.mat'))
end
save(fullfile(pwd,'data','data.mat'),'tscc','p')