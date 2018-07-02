function [tsc,iter]=parseOutput(logsout)
% function to convert dataset to timeseries collection and compile the iter struct
tsc         = tscollection();   % Preallocate timeseries collection
iter        = {};               % Preallocate iter structure
if ~isempty(logsout)
    
    
    signalNames = getElementNames(logsout); % Get list of variables contained in logsout
    iterSignals = getIterationVariables;    % Get list of variables to store into the iter struct
    
    % Determine the iteration times and indices
    % Note that the output of the performance index has a unit delay on it.
    % Therefore the performance index at time step i is actually determined
    % by the individual component values at time step i-1.
    waypointUpdateTrigger   = getElement(logsout,'waypointUpdateTrigger');
    waypointUpdateTrigger   = waypointUpdateTrigger.Values;
    % waypointUpdateTrigger goes high on the first time step of a new
    % iteration.
    genericIndices          = (1:length(waypointUpdateTrigger.Time))'-1;
    iter.endIndices         = genericIndices(logical(waypointUpdateTrigger.Data));
    iter.startIndices       = iter.endIndices +1;
    iter.endTimes           = waypointUpdateTrigger.Time(iter.endIndices);
    iter.startTimes         = waypointUpdateTrigger.Time(iter.startIndices);
    
    for ii = 1:length(signalNames)
        try
        ts = get(logsout,signalNames{ii}); ts = ts.Values; % Get the single timeseries
        catch
        end
        % if the signal we're considering is one of the iterative elements,
        % then add it to the iter object, otherwise add it to the tsc
        % object
        if any(strcmp(iterSignals,signalNames{ii}))
            if length(ts.time) == 1 % Constant quantites have a different length data vector
                set(ts,'Time',tsc.time,'Data',repmat(ts.data(1,:),[length(tsc.time),1]));
            end
            try
                tsc = addts(tsc,ts);
            catch
            end
            if length(ts.Time) == length(waypointUpdateTrigger.Time)
                if strcmp(signalNames{ii},'performanceIndex')
                    % If we're logging the actual performance index, then
                    % we want the value one step later because of the
                    % aforementioned unit delay
                    set(ts,'Time',ts.Time(iter.startIndices),'Data',ts.Data(iter.startIndices));
                else
                    % If it's a component of the performance index then the
                    % indices calculated above (iter.endIndices) are correct.
                    set(ts,'Time',ts.Time(iter.endIndices),'Data',ts.Data(iter.endIndices,:));
                end
            end
            
            if ndims(ts.Data) == 3
                iter.(ts.Name) = ts.data(:,:)';
            else
                try
                    iter.(ts.Name) = ts.data;
                catch
                end
            end
        else
            if length(ts.time) == 1 % Constant quantites have a different length data vector
                set(ts,'Time',tsc.time,'Data',ts.data(1)*ones(size(tsc.time)));
            end
            try
                % Add the timeseries to the collection
                tsc = addts(tsc,ts);
            catch
            end
        end
        
    end
end