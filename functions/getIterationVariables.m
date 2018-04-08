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
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/ILC Basis Parameter Update/');
portHandles = get(handle,'PortHandle');
signalNames = vertcat(signalNames,get(portHandles.Outport(:),'PropagatedSignals'));
% Clean things up by dropping anyt empty cells
signalNames = signalNames(~[cellfun(@isempty,signalNames)]);

% Find any signals containing "basisparam" string
allSignalNames = evalin('base','getElementNames(logsout)');
signalsToAdd = allSignalNames(contains(allSignalNames,'basisparams','IgnoreCase',true));
% Only add them if they're not already in the list of signals
for ii = 1:length(signalsToAdd)
   if any(contains(signalNames,signalsToAdd{ii},'IgnoreCase',true))
       signalNames{end+1} = signalsToAdd{ii};
   end
end
end