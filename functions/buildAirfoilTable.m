function aeroTable =  buildAirfoilTable(p,wingRudder)
wingRudder = lower(wingRudder);
files = dir(fullfile(pwd,wingRudder));
if ispc
    [~,~,data]=xlsread(fullfile(pwd,wingRudder,files(3).name));
    aeroTable.Re = data{4,2};
    jj=1;
    while ~strcmpi(data{jj,1},'alpha')
        jj=jj+1;
    end
    data = cell2mat(data(jj+1:end,1:3));
else
    files = files(3:end);
    for ii = 1:length(files)
        if ~strcmpi(files(ii).name(1),'.')
            data=csvread(fullfile(pwd,wingRudder,files(ii).name),11,0);
            fid = fopen(fullfile(pwd,wingRudder,files(ii).name));
            Re = textscan(fid, '%s','delimiter', '\n');
            fclose(fid);
            Re=strsplit(Re{1}{4},',');
            aeroTable.Re = str2double(Re{2});
        end
    end
end

aeroTable.alpha = data(:,1)*(pi/180);
aeroTable.cl  = data(:,2);
aeroTable.cl0 =aeroTable.cl(data(:,3)==min(data(:,3)));
aeroTable.cd  = min(data(:,3))+((aeroTable.cl-aeroTable.cl0).^2)./(pi*p.oswaldEfficiency*p.AR);

if strcmpi(wingRudder,'wing')
    idx=1:length(aeroTable.alpha);
    pl=polyfit(aeroTable.alpha(idx(aeroTable.cl==min(aeroTable.cl)):idx(aeroTable.cl==max(aeroTable.cl))),...
        aeroTable.cl(idx(aeroTable.cl==min(aeroTable.cl)):idx(aeroTable.cl==max(aeroTable.cl))),1);
    aeroTable.kl1=pl(1);
    aeroTable.kl0=pl(2);
    
    pd = polyfit(aeroTable.alpha,aeroTable.cd,2);
    aeroTable.kd2=pd(1);
    aeroTable.kd1=pd(2);
    aeroTable.kd0=pd(3);
end
if strcmpi(wingRudder,'rudder')
    % PLACE CURVE FITTING CODE FOR RUDDER HERE
end


end