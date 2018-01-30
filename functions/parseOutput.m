function [tsc,iter]=parseOutput(logsout)
% function to convert dataset to timeseries collection and compile the iter struct

if ~isempty(logsout)
   
    tsc         = tscollection();   % Preallocate timeseries collection
    iter        = {};               % Preallocate iter structure
    signalNames = getElementNames(logsout); % Get list of variables contained in logsout
    iterSignals = getIterationVariables;    % Get list of variables to store into the iter struct
    
    % Determine the iteration times and indices
    currentIterationNumber = getElement(logsout,'currentIterationNumber');
    currentIterationNumber = currentIterationNumber.Values;
    genericIndices  = (1:length(currentIterationNumber.Time))';
    iter.indices    = genericIndices(logical(diff(currentIterationNumber.Data)));
    iter.times      = currentIterationNumber.Time(iter.indices);
    
    for ii = 1:length(signalNames)

        ts = get(logsout,signalNames{ii}); ts = ts.Values; % Get the single timeseries

        % if the signal we're considering is one of the iterative elements,
        % then add it to the iter object, otherwise add it to the tsc
        % object
        if any(strcmp(iterSignals,signalNames{ii}))
            if length(ts.Time) == length(currentIterationNumber.Time)
                set(ts,'Time',ts.Time(iter.indices),'Data',ts.Data(iter.indices));
            end
            if ndims(ts.Data) == 3
                iter.(ts.Name) = ts.data(:,:)';
            else
                iter.(ts.Name) = ts.data;
            end
            
            

        else
            if length(ts.time) == 1 % Constant quantites have a different length data vector
                set(ts,'Time',tsc.time,'Data',ts.data(1)*ones(size(tsc.time)));
            end
            tsc = addts(tsc,ts);
        end
    end
end