function [iteration, tscc] = parseIterations(tsc)
indices = diff(tsc.currentIterationNumber.data);
times = [0; tsc.time([0;indices]==1);tsc.time(end)];
% Chop up the timeseries
for ii = length(times)-1:-1:1
    tscc{ii}      = getsampleusingtime(tsc,times(ii),times(ii+1));
    iteration.meanPAR(ii)               = tscc{ii}.meanPAR.data(end);
    iteration.instantaneousPAR(ii)      = tscc{ii}.instantaneousPAR.data(end);
    iteration.meanEnergy(ii)            = tscc{ii}.meanEnergy.data(end);
    iteration.instantaneousEnergy(ii)   = tscc{ii}.instantaneousEnergy.data(end);
    iteration.performanceIndex(ii)      = tscc{ii}.performanceIndex.data(end);
    iteration.totalSpatialError(ii)     = tscc{ii}.totalSpatialError.data(end);
    iteration.performanceIndexTrackingTerm(ii)     = tscc{ii}.performanceIndexTrackingTerm.data(end);
    iteration.basisParams(ii,:)         = tscc{ii}.basisParams.data(end,:);
    iteration.V(:,:,ii)                 = tscc{ii}.V.data(:,:,end);
    iteration.beta(:,:,ii)              = tscc{ii}.beta.data(:,:,end);
end

end