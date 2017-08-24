if ~exist('logsout','var')
    return
else
    tsc=dataset2TSC(logsout);
    [p.totalError,p.normalizedError,p.individualErrors] = calculateSpatialError(p,tsc);
    if ~p.quietMode
        plotSummaries
    end
end

