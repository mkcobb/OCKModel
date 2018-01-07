function [iter] = parseIterations(tsc)
indices = diff(tsc.currentIterationNumber.data);
% times = [0; tsc.time(indices==1);tsc.time(end)];
idx = 1:length(indices);
indices = idx(indices==1)-2;

% % Chop up the timeseries
% for ii = length(times)-1:-1:1
%     tscc{ii}      = getsampleusingtime(tsc,times(ii),times(ii+1));
% end
iter.performanceIndex       = tsc.performanceIndex.data(indices);
iter.meanEnergy             = tsc.meanEnergy.data(indices);
iter.meanPAR                = tsc.meanPAR.data(indices);
iter.performanceIndexTrackingTerm     = tsc.performanceIndexTrackingTerm.data(indices);
iter.totalSpatialError      = tsc.totalSpatialError.data(indices);
iter.basisParams            = tsc.basisParams.data(indices,:);
iter.waypointAzimuths       = tsc.waypointsAzimuth.data(indices,:);
iter.waypointZeniths        = tsc.waypointsZenith.data(indices,:);
iter.beta                   = tsc.beta.data(:,:,indices);
end