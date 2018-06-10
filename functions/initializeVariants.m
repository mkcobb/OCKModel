function initializeVariants
% This function creates model variant objects in the base workspace for the
% variant subsystems of the CDCJournalModel
p = evalin('base','p');

switch p.runMode
    case {'optimization','baseline'}
        defaultHeadingSetpoint = 1;
    case 'spatialILC'
        defaultHeadingSetpoint = 2;
end
defaultEnergyTerm = 2;
defaultTrackingTerm = 1;

%% Set up heading setpoint calculation variants
variants = {'PureCarrotFollowing','IterativeCarrotFollowing'};
% Create variant control variable in the workspace
evalin('base',sprintf('VCHeadingSetpoint=%d;',defaultHeadingSetpoint))
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCHeadingSetpoint==%d'');',variants{ii},ii))
end

%% Set up performance index calculation variants
% Set up the energy/power term
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