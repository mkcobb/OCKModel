function [iter] = parseIterations(tsc)
% Function to extract the value of specific signals at the end of each
% iteration

% Get indices when the iteration number changes.
indices = diff(tsc.currentIterationNumber.data);
idx = 1:length(indices);
indices = idx(indices==1);
iter.times                  = tsc.time(indices);

% Performance index terms: all inputs and outputs of this block:
% 'CDCJournalModel/Controller/Performance Calculation/Term Selection Switches'
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Performance Calculation/Term Selection Switches');
inports  = find_system(handle,'FindAll','On','SearchDepth',1,'BlockType','Inport');
portHandles = get(handle,'PortHandle');
 % Get the names of the signals attached to those inports
signalNames = get(inports,'OutputSignalNames');
% Add the signal attached to the outputs
signalNames{end+1} = {get(portHandles.Outport(:),'PropagatedSignals')};
% Add them all to the structure called 'iter'
for ii = 1:length(signalNames)
    iter.(signalNames{ii}{1}) = tsc.(signalNames{ii}{1}).data(indices);
end

                        
% Iteration-varying terms: all outputs of the block:
% CDCJournalModel/Controller/Update Waypoints
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Update Waypoints/');
portHandles = get(handle,'PortHandle');
signalNames = get(portHandles.Outport(:),'PropagatedSignals');
% Add them all to the structure called 'iter'
for ii = 1:length(signalNames)
%     if size(tsc.(signalNames{ii}).data,2)>1
    iter.(signalNames{ii}) = tsc.(signalNames{ii}).data(indices,:);
%     end
%     else
%         iter.(signalNames{ii}) = tsc.(signalNames{ii}).data(indices,:)
%     end
end

end