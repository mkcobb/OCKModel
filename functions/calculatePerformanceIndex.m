function [J,meanEnergy,errorName,errorIndex]=calculatePerformanceIndex(p,tsc)
% For some kind of nonsensical mechanical circumstance
if any(tsc.faultIndicatorPlant.data) || any(tsc.faultIndicatorController.data)
    J = 0;
    meanEnergy = 0;
    faultSigNames = tsc.gettimeseriesnames;
    faultSigNames = faultSigNames(contains(faultSigNames,'fault'));
    faultSigNames = faultSigNames(~contains(faultSigNames,'Indicator'));
    
    
    for ii = 1:length(faultSigNames)
        trueFalse = eval(sprintf('tsc.%s.data(end)',faultSigNames{ii}));
        if trueFalse
            errorIndex = ii;
            errorName = faultSigNames{ii};
            break
        end
    end
    if evalin('base','p.verbose')
        fprintf('\nFault detected:\n')
        readoutFaults
    end
else
    % Error vector indicates type of fault with sim
    errorIndex = 0;
    errorName = 'No Fault';
    % Calculate the performance index
    meanEnergy = tsc.meanEnergy.data(end);
    J = meanEnergy-p.trackingErrorWeight*p.normalizedError(end);
    
end



end