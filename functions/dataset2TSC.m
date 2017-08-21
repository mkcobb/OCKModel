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
%         if length(ts.Values.data)~=length(tsc.Time) &&...
%                 length(tsc.Time)~=0
%             ts.Values = resample(ts.Values,tsc.Time);

%         end
if strcmpi(ts.Values.Name,'roll')
end
        tsc = addts(tsc,ts.Values);
    end
    
end