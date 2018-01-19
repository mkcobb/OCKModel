tsNames = gettimeseriesnames(tsc);
errorNames   = tsNames(contains(tsNames,'fault','IgnoreCase',true));
warningNames = tsNames(contains(tsNames,'warning','IgnoreCase',true));

fprintf('Val | Error Name\n')
for ii = 1:length(errorNames)
  val = eval(sprintf('tsc.%s.data(end);',errorNames{ii}));
  name = errorNames{ii};
  fprintf(' %d  | %s\n',val,name)
end

fprintf('\nVal | Warning Name\n')
for ii = 1:length(warningNames)
  val = eval(sprintf('any(tsc.%s.data(:));',warningNames{ii}));
  name = warningNames{ii};
  fprintf(' %d  | %s\n',val,name)
end
