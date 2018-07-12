function initializeVariants
% This function creates model variant objects in the base workspace for the
% variant subsystems of the CDCJournalModel

defaultController = 2;

%% Set up controller variants
variants = {'OCKReelOut','OCKReelInOut'};
% Create variant control variable in the workspace
evalin('base',sprintf('VCController=%d;',defaultController))
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCController==%d'');',variants{ii},ii))
end

%% Set up environmental (flow speed) variants

defaultEnvironment = 1;

variants = {'Constant'};
% Create variant control variable in the workspace
evalin('base',sprintf('VCEnvironment=%d;',defaultEnvironment))
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCEnvironment==%d'');',variants{ii},ii))
end
end
