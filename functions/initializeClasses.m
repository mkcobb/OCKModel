function initializeClasses()
files = dir(fullfile(fileparts(which('OCKModel.slx')),'classdefs'));
files = files(contains({files(:).name},'@'));
for ii = 1:length(files)
    instName = eval(sprintf('%s.defaultInstanceName',files(ii).name(2:end)));
    evalin('base',sprintf('%s = %s;',instName,files(ii).name(2:end)))
end
end