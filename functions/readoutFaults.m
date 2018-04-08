function readoutFaults(p,tsc,iter)
signals = gettimeseriesnames(tsc);
faults = signals(contains(signals,'fault','IgnoreCase',true));
warnings = signals(contains(signals,'warning','IgnoreCase',true));

fprintf('\nFAULT READOUT\nValue | Description\n')
for ii = 1:length(faults)
    try
   fprintf('  %d   | %s\n',tsc.(faults{ii}).data(end),faults{ii}) 
    catch
    end
end

fprintf('\nWARNING READOUT\nValue | Description\n')
for ii = 1:length(warnings)
   fprintf('  %d   | %s\n',tsc.(warnings{ii}).data(end),warnings{ii}) 
end
end