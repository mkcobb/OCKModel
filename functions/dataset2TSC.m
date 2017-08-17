function tsc = dataset2TSC(logsout)
% function to convert dataset to timeseries collection
tsc = tscollection();
if ~isempty(logsout)
    signalNames = getElementNames(logsout);
    for ii = 1:length(signalNames)
        ts = get(logsout,signalNames{ii});
        if ismethod(ts,'numElements')
            if ts.numElements>1
                fprintf('\nError: non-unique signal names: %s\n\n',signalNames{ii})
                return
            end
        end
        tsc = addts(tsc,ts.Values);
    end
end

end