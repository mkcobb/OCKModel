close all;clear;clc;bdclose all
tic
% Open the block diagram
open_system('CDCJournalModel.slx')

set_param('CDCJournalModel','PreloadFcn','');
set_param('CDCJournalModel','InitFcn','');
set_param('CDCJournalModel','StopFcn','stopCallback');

parameters
p.quietMode = 1;

p.thetaStart = 10;
p.thetaEnd   = 180;
p.nTheta     = 20;

p.phiStart   = 1;
p.phiEnd     = 12;
p.nPhi       = 11;

p.thetaVec = linspace(p.thetaStart,p.thetaEnd,p.nTheta);
p.phiVec   = linspace(p.phiStart,p.phiEnd,p.nPhi);


w=waitbar(0,'Starting simulation.');
for ii = 1:length(p.thetaVec)
    for jj = 1:length(p.phiVec)
        p.widthsVec(end+1) = p.thetaVec(ii);
        p.heightsVec(end+1) = p.phiVec(jj);
        p.waypoints = generateWaypoints(p.num,p.heightsVec(end),p.widthsVec(end),p.elev);
        sim('CDCJournalModel')
        [p.performanceIndex(end+1),p.errorName{end+1},p.errorIndex(end+1)] = calculatePerformanceIndex(p,tsc);
%         p.tsc{end+1}=tsc;
        waitbar(length(p.widthsVec)/(length(p.thetaVec)*length(p.phiVec)),w,'Progress');
        
    end
end

close(w);
clearvars ii jj w

fprintf('Design space grid complete, elapsed time: %s seconds.\n\n',num2str(toc))

plotGridResults
