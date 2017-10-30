function tsc = dataset2TSC(logsout)
% function to convert dataset to timeseries collection
tsc = tscollection();
if ~isempty(logsout)
    signalNames = getElementNames(logsout);
    for ii = 1:length(signalNames)
        ts = get(logsout,signalNames{ii});
        if ismethod(ts,'numElements')
            if ts.numElements>1
                fprintf('\nError: non-unique signal name: %s\n\n',signalNames{ii})
                return
            end
        end
        try
            % If the signal is a constant, the time vector wil only be one
            % element long.  Patch to fix that.
            if length(ts.Values.Time)<2
               ts.Values = timeseries(...
                   ts.Values.data(1)*ones(size(tsc.time)),...
                   tsc.time,'Name',signalNames{ii}) ;
            end
            tsc = addts(tsc,ts.Values);
        catch 
            sprintf('')
        end
    end
    
end