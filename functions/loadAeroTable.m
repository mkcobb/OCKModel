function aeroTable = loadAeroTable(fileName,clFitLimits,cdFitLimits,OE,AR)
% wingRudder = 'wing';
% files = dir(fullfile(fileparts(which('OCKModel.slx')),'hydrofoilLibrary',wingRudder));
% [~,~,data] = xlsread(fullfile(files(end).folder,files(end).name));
% aeroTable.fileName = files(3).name;
basePath = fileparts(which('OCKModel.slx'));
basePath = fullfile(basePath,'hydrofoilLibrary','library');

fileName = fullfile(basePath,fileName);

aeroTableRaw = readRawAeroData(fileName);
[row,col]=find(strcmpi(aeroTableRaw,'re'));
aeroTable.Re = aeroTableRaw{row,col+2}*10^aeroTableRaw{row,col+4};

[row,col]=find(strcmpi(aeroTableRaw,'for:'));
aeroTable.foilName = [aeroTableRaw{row,col+1} num2str(aeroTableRaw{row,col+2})];

[~,aeroTable.fileName] = fileparts(fileName);

[row,col]=find(strcmpi(aeroTableRaw,'alpha'));
aeroTable.alpha = [aeroTableRaw{row+2:end,col}]*(pi/180);
[row,col]=find(strcmpi(aeroTableRaw,'cl'));
aeroTable.cl    = [aeroTableRaw{row+2:end,col}];

% Lift Correction
aeroTable.cl = aeroTable.cl/(1+1/AR);

[row,col] = find(strcmpi(aeroTableRaw,'cd'));
aeroTable.cdUncorrected    = [aeroTableRaw{row+2:end,col}];

aeroTable.cl0   = aeroTable.cl(aeroTable.cdUncorrected == min(aeroTable.cdUncorrected));

% Drag Correction(s)
aeroTable.cd            = min(aeroTable.cdUncorrected)+((aeroTable.cl-aeroTable.cl0(1)).^2)./(pi*OE*AR);
aeroTable.cdPrandtl1    = aeroTable.cdUncorrected     +((aeroTable.cl.^2)/(pi*AR))*((AR+1)/(AR+2)).^2;
aeroTable.cdPrandtl2    = min(aeroTable.cdUncorrected)+((4*pi*aeroTable.alpha.^2)/(AR))*((1)/(1+2/AR))^2;
aeroTable.cdPrandtl3    = aeroTable.cdUncorrected     +((4*pi*aeroTable.alpha.^2)/(AR))*((1)/(1+2/AR))^2;
aeroTable.cdPrandtl4    = aeroTable.cdUncorrected     +((aeroTable.cl.^2)/(AR))*((1)/(1+2/AR))^2;

clStartAlpha    = clFitLimits(1);
clEndAlpha      = clFitLimits(2);
cdStartAlpha    = cdFitLimits(1);
cdEndAlpha      = cdFitLimits(2);

idx = 1:length(aeroTable.alpha);

alphaClCrop = aeroTable.alpha(idx(abs(clStartAlpha-aeroTable.alpha)==min(abs(clStartAlpha-aeroTable.alpha))):...
    idx(abs(clEndAlpha-aeroTable.alpha)==min(abs(clEndAlpha-aeroTable.alpha))));
clCrop    = aeroTable.cl(idx(abs(clStartAlpha-aeroTable.alpha)==min(abs(clStartAlpha-aeroTable.alpha))):...
    idx(abs(clEndAlpha-aeroTable.alpha)==min(abs(clEndAlpha-aeroTable.alpha))));
alphaCdCrop = aeroTable.alpha(idx(abs(cdStartAlpha-aeroTable.alpha)==min(abs(cdStartAlpha-aeroTable.alpha))):...
    idx(abs(cdEndAlpha-aeroTable.alpha)==min(abs(cdEndAlpha-aeroTable.alpha))));
cdCrop    = aeroTable.cd(idx(abs(cdStartAlpha-aeroTable.alpha)==min(abs(cdStartAlpha-aeroTable.alpha))):...
    idx(abs(cdEndAlpha-aeroTable.alpha)==min(abs(cdEndAlpha-aeroTable.alpha))));

pl=polyfit(alphaClCrop,clCrop,1);
aeroTable.kl1=pl(1);
aeroTable.kl0=pl(2);

pd = polyfit(alphaCdCrop,cdCrop,2);
aeroTable.kd2=pd(1);
aeroTable.kd1=pd(2);
aeroTable.kd0=pd(3);

aeroTable.clStartAlpha  = clStartAlpha;
aeroTable.clEndAlpha    = clEndAlpha;
aeroTable.cdStartAlpha  = cdStartAlpha;
aeroTable.cdEndAlpha    = cdEndAlpha;

end