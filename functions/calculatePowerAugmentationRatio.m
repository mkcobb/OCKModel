function [meanPAR,tsc] = calculatePowerAugmentationRatio(tsc)

PAR = (sqrt(sum(tsc.vAppWindBFC.data.^2,2))./sqrt(sum(tsc.vWindGFC.data.^2,2))).^3;
meanPAR = mean(PAR);
tsPAR = timeseries(PAR,tsc.Time,'Name','powerAugmentationRatio');
tsc=addts(tsc,tsPAR);
end