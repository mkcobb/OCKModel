function initializeVariants
% This function creates model variant objects in the base workspace for the
% variant subsystems of the CDCJournalModel

%% Set up heading setpoint calculation variants
variants = {'PureCarrotFollowing','IterativeCarrotFollowing'};
% Create variant control variable in the workspace
evalin('base','VCHeadingSetpoint=1;')
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCHeadingSetpoint==%d'');',variants{ii},ii))
end

%% Set up performance index calculation variants
variants = {'MeanEnergy','PowerAugmentationRatio'};
% Create variant control variable in the workspace
evalin('base','VCEnergyTerm=2;')
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCEnergyTerm==%d'');',variants{ii},ii))
end

variants = {'SpatialError'};
% Create variant control variable in the workspace
evalin('base','VCSpatialErrorTerm=1;')
for ii = 1:length(variants)
    evalin('base',sprintf('variant%s=Simulink.Variant(''VCSpatialErrorTerm==%d'');',variants{ii},ii))
end

end