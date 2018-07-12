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
        
        if ii == 1 % If this is the first timeseries to be added to the collection
            tsc = addts(tsc,ts);
        else % If this is not the first timeseries to be added to the collection
            if numel(tsc.time)~=numel(ts.time) % If the two time vectors are not equal lengths
                [~,idx] = max([numel(tsc.time) numel(ts.time)]); % Find the longest one
                
                if idx == 1 % If the collection has a longer time vector
                    % then resample the timeseries to the time vector of the
                    % collection
                    if length(ts.time)==1 % If the timeseries only has one data point
                        tsNew = timeseries([ts.data;ts.data],[ts.time(1) tsc.time(end)]);
                        tsNew = resample(tsNew,tsc.Time);
                        tsNew.Name = ts.Name;
                        tsc = addts(tsc,tsNew); % Add the new (resampled) timeseries to the collection
                    end
                else % If the timeseries has a longer time vector
                    % Then resample all timeseries in the collection to the
                    % time vector of the timeseries
                    names = tsc.gettimeseriesnames;
                    for jj = 1:numel(names)
                       
                    end
                end
            else
                
                tsc = addts(tsc,ts);
                
            end
        end
    end
    
end

