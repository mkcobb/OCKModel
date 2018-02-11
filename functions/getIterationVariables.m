function signalNames = getIterationVariables()

% Performance index terms: all inputs and outputs of this block:
% 'CDCJournalModel/Controller/Performance Calculation/Term Selection Switches'
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Performance Calculation/Term Selection Switches');
inports  = find_system(handle,'FindAll','On','SearchDepth',1,'BlockType','Inport');
portHandles = get(handle,'PortHandle');
 % Get the names of the signals attached to those inports
signalNames = get(inports,'OutputSignalNames');
signalNames = vertcat(signalNames{:,1});
% Add the signal attached to the outputs
signalNames{end+1} = get(portHandles.Outport(:),'PropagatedSignals');
% Add them all to the structure called 'iter'

% Iteration-varying terms: all outputs of the block:
% CDCJournalModel/Controller/Update Waypoints
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Update Waypoints/');
portHandles = get(handle,'PortHandle');
signalNames = vertcat(signalNames,get(portHandles.Outport(:),'PropagatedSignals'));

end