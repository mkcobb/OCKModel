if evalin('base','p.verbose')
    evalTime=toc;
    simTime = tout(end);
    fprintf('Efficiency = %s\n',num2str(evalTime/simTime))
end

if ~exist('logsout','var')
    if evalin('base','p.verbose')
        fprintf('\nUnable to locate logsout.  Exiting stopCallback.\n')
    end
    return
else
    clearvars tsc
    tsc = dataset2TSC(logsout);
%     [p.totalError,p.normalizedError,p.individualErrors] = calculateSpatialError(p,tsc);
    if ~p.quietMode
        plotSummaries
    end
end

