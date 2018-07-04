function tsc = compileTSC(logsout)
% function to convert dataset to timeseries collection
tsc         = tscollection();   % Preallocate timeseries collection
if ~isempty(logsout)
    
    signalNames = getElementNames(logsout); % Get list of variables contained in logsout
    signalNames = unique(signalNames); % Filter out duplicates
    signalNames = signalNames(~cellfun(@isempty,signalNames)); % Filter out empty names
    
    for ii = 1:length(signalNames)
        sig = logsout.getElement(signalNames{ii});
        if  ismethod(sig,'numElements') && sig.numElements>1
            sig = sig{1};
        end
        ts = sig.Values;
        ts.UserData.Name = sig.Name;
        ts.UserData.BlockPath = sig.BlockPath;
        
        if length(ts.Time) == 1
            
            tsNew = timeseries(repmat(ts.Data,[length(tsc.Time),1]),tsc.Time,'Name',ts.Name);
            
            tsNew.UserData = ts.UserData;
            tsc = addts(tsc,tsNew);
        else
            tsc = addts(tsc,ts);
        end
        
    end
    
end
end
