function signalNames = getIterationVariables()

% Performance index terms: all inputs and outputs of this block:
% 'CDCJournalModel/Controller/Performance Calculation/Term Selection Switches'
% handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Performance Calculation');
% inports  = find_system(handle,'FindAll','On','SearchDepth','0','BlockType','Variant Subsystem');

% Get the signals attached to variant subsystems in
% CDCJournalModel/Controller/Performance Calculation
blocks = find_system('CDCJournalModel/Controller/Optimization Controller/Performance Calculation','SearchDepth',1);
outportBlock = get(getSimulinkBlockHandle(blocks(strcmpi(get_param(blocks,'Name'),'performanceIndex'))));
addBlock = get(outportBlock.PortConnectivity.SrcBlock);
variantSubsystemBlocks = get([addBlock.PortConnectivity.SrcBlock]);
signalNames = [variantSubsystemBlocks.OutputSignalNames]';

% Iteration-varying terms: all outputs of the block:
% CDCJournalModel/Controller/Update Waypoints
handle   = getSimulinkBlockHandle('CDCJournalModel/Controller/Optimization Controller/Update Waypoints/');
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