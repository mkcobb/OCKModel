function initializeVariants
% This function creates model variant objects in the base workspace for the
% variant subsystems of the CDCJournalModel
p = evalin('base','p');

switch p.runMode
    case {'optimization','baseline'}
        defaultController = 1;
    case 'spatialILC'
        defaultController = 2;
end


%% Set up controller variants
variants = {'ControllerOptimization','ControllerSpatialILC'};
% Create variant control variable in the workspace
evalin('base',sprintf('VCController=%d;',defaultController))
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCController==%d'');',variants{ii},ii))
end

%% Set up performance index calculation variants
% (only if we're running the optimization controller)
% Set up the energy/power term
if defaultController == 1
    defaultEnergyTerm = 2;
    defaultTrackingTerm = 1;
    variants = {'MeanEnergy','PowerAugmentationRatio'};
    % Create variant control variable in the workspace
    evalin('base',sprintf('VCEnergyTerm=%d;',defaultEnergyTerm))
    for ii = 1:length(variants)
        evalin('base',sprintf('variant%s=Simulink.Variant(''VCEnergyTerm==%d'');',variants{ii},ii))
    end
    
    % Set up the path/waypoint tracking error term
    variants = {'SpatialError'};
    % Create variant control variable in the workspace
    evalin('base',sprintf('VCSpatialErrorTerm=%d;',defaultTrackingTerm))
    for ii = 1:length(variants)
        evalin('base',sprintf('variant%s=Simulink.Variant(''VCSpatialErrorTerm==%d'');',variants{ii},ii))
    end
end
end