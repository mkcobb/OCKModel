bdclose all
close all
clear
clc
warning off MATLAB:nearlySingularMatrix
parameters;

% Loading simulink model
if evalin('base','p.verbose')
    fprintf('\nLoading simulink model:\n%s\n',p.modelPath)
end
load_system(p.modelPath)

% Initial Condition
p.phiIC   = 7;
p.thetaIC = 150;

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
if evalin('base','p.verbose')
    fprintf('\nPerforming %s initialization simulations:\n',...
        num2str(length(p.phiInit)))
end
for ii = 1:length(p.performanceIndexInit)
    fprintf('%s/%s\n',num2str(ii),num2str(length(p.phiInit)))
    p.initWaypoints(ii) = generateWaypoints(p.num,p.phiInit(ii),p.thetaInit(ii),p.elev);
    p.XInit(ii,:) = [1 p.phiInit(ii) p.phiInit(ii)^2 p.thetaInit(ii) p.thetaInit(ii)^2];
    p.waypoints = p.initWaypoints(ii);
    sim('CDCJournalModel')
    [p.performanceIndexInit(ii) p.errorNameInit{ii} p.errorIndexInit(ii)] ...
        = calculatePerformanceIndex(p,tsc);
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
    fprintf('Running step %s\n',num2str(p.optIdx))
    p.waypoints = generateWaypoints(p.num,p.heightsVec(p.optIdx),p.widthsVec(p.optIdx),p.elev);
    p.optWaypoints(p.optIdx) = p.waypoints;
    sim('CDCJournalModel')
    [p.performanceIndexOpt(p.optIdx) p.errorNameOpt{p.optIdx} p.errorIndexOpt(p.optIdx)] ...
        = calculatePerformanceIndex(p,tsc);
    p = nextDesignPoint(p);
    p.optIdx = p.optIdx +1;
end

if evalin('base','p.verbose')
    fprintf('\nClosing simulink model:\n%s\n',p.modelPath)
end
close_system(p.modelPath)