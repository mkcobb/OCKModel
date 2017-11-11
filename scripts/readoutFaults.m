tsNames = gettimeseriesnames(tsc);
tsNames = tsNames(contains(tsNames,'fault'));
fprintf('Val Name\n')
for ii = 1:length(tsNames)
  val = eval(sprintf('tsc.%s.data(end);',tsNames{ii}));
  name = tsNames{ii};
  fprintf(' %d  %s\n',val,name)
end
