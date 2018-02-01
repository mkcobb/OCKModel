function [tsc,iter]=parseOutput(logsout)
% function to convert dataset to timeseries collection and compile the iter struct
tsc         = tscollection();   % Preallocate timeseries collection
iter        = {};               % Preallocate iter structure
if ~isempty(logsout)
   

    signalNames = getElementNames(logsout); % Get list of variables contained in logsout
    iterSignals = getIterationVariables;    % Get list of variables to store into the iter struct
    
    % Determine the iteration times and indices
%     currentIterationNumber = getElement(logsout,'currentIterationNumber');
%     currentIterationNumber = currentIterationNumber.Values;
    waypointUpdateTrigger = getElement(logsout,'waypointUpdateTrigger');
    waypointUpdateTrigger = waypointUpdateTrigger.Values;
    performanceIndex = getElement(logsout,'performanceIndex');
    performanceIndex = performanceIndex.Values;
    
    figure
    ax1=subplot(2,1,1);
    plot(waypointUpdateTrigger.data)
    ax2=subplot(2,1,2);
    plot(performanceIndex.data)
    linkaxes([ax1 ax2],'x')
%     
    genericIndices  = (1:length(waypointUpdateTrigger.Time))';
    iter.indices    = genericIndices(logical(waypointUpdateTrigger.Data));
    iter.times      = waypointUpdateTrigger.Time(iter.indices);
    
    for ii = 1:length(signalNames)

        ts = get(logsout,signalNames{ii}); ts = ts.Values; % Get the single timeseries

        % if the signal we're considering is one of the iterative elements,
        % then add it to the iter object, otherwise add it to the tsc
        % object
        if any(strcmp(iterSignals,signalNames{ii}))
            if length(ts.Time) == length(waypointUpdateTrigger.Time)
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