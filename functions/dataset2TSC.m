function tsc = dataset2TSC(logsout)
% function to convert dataset to timeseries collection
tsc = tscollection();
if ~isempty(logsout)
    signalNames = getElementNames(logsout);
    for ii = 1:length(signalNames)
        ts = get(logsout,signalNames{ii});
        tsc = addts(tsc,ts.Values);
    end
end

end