function [tsc,iter] = dataset2TSC(logsout)
% function to convert dataset to timeseries collection and compile the iter struct

if ~isempty(logsout)
    tsc = tscollection();
    signalNames = getElementNames(logsout);
    iterSignals = getIterationVariables;
    iter = {}; % Preallocate iter structure
    for ii = 1:length(signalNames)
        ts = get(logsout,signalNames{ii});
        ts = ts.Values;
        % if the signal we're considering is one of the iterative elements,
        % then add it to the iter object, otherwise add it to the tsc
        % object
        if any(contains(iterSignals,signalNames{ii}))
            % have to deal carefully with logged vectors
            if ndims(ts.Data) == 3
                iter.(ts.Name) = ts.data(:,:)';
            else
                iter.(ts.Name) = ts.data;
            end
        else
            if length(ts.time) == 1 % Constant quantites have a different length data vector
                set(ts,'Time',tsc.time,'Data',ts.data(1)*ones(size(tsc.time)));
            end
            tsc=addts(tsc,ts);
        end
    end
end

%     for ii = 1:length(signalNames)
%         ts = get(logsout,signalNames{ii});
%         if ismethod(ts,'numElements')
%             if ts.numElements>1
%                 fprintf('\nError: non-unique signal name: %s\n\n',signalNames{ii})
%                 for jj = 1:ts.numElements
%                     ts{jj}.BlockPath
%                 end
% %                 break
%             end
%         end
%         try
%             % If the signal is a constant, the time vector wil only be one
%             % element long.  Patch to fix that.
%             if length(ts.Values.Time)<2
%                 ts.Values = timeseries(...
%                     ts.Values.data(1)*ones(size(tsc.time)),...
%                     tsc.time,'Name',signalNames{ii}) ;
%             end
%             tsc = addts(tsc,ts.Values);
%         catch
%             %             sprintf('')
%         end
%     end

