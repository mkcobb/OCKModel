function [iter] = parseIterations(tsc,p)
indices = diff(tsc.currentIterationNumber.data);

idx = 1:length(indices);
indices = idx(indices==1);

iter.times                  = tsc.time(indices);
iter.performanceIndex       = tsc.performanceIndex.data(indices);
iter.meanEnergy             = tsc.meanEnergy.data(indices);
iter.meanPAR                = tsc.meanPAR.data(indices);
iter.performanceIndexTrackingTerm     = tsc.performanceIndexTrackingTerm.data(indices);
iter.totalSpatialError      = tsc.normalizedSpatialError.data(indices);
iter.basisParams            = tsc.basisParams.data(indices,:);
iter.waypointAzimuths       = tsc.waypointsAzimuth.data(indices,:);
iter.waypointZeniths        = tsc.waypointsZenith.data(indices,:);
iter.beta                   = tsc.beta.data(:,:,indices);
end