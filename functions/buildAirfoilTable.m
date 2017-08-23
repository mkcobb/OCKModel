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
aeroTable.cl    = data(:,2);
aeroTable.cl0   = aeroTable.cl(data(:,3)==min(data(:,3)));
aeroTable.cd    = min(data(:,3))+((aeroTable.cl-aeroTable.cl0).^2)./(pi*p.oswaldEfficiency*p.AR);

if strcmpi(wingRudder,'wing')
    idx=1:length(aeroTable.alpha);
    alphaClCrop = aeroTable.alpha(idx(abs(p.wingClStartAlpha-aeroTable.alpha)==min(abs(p.wingClStartAlpha-aeroTable.alpha))):...
        idx(abs(p.wingClEndAlpha-aeroTable.alpha)==min(abs(p.wingClEndAlpha-aeroTable.alpha)))); 
    clCrop    = aeroTable.cl(idx(abs(p.wingClStartAlpha-aeroTable.alpha)==min(abs(p.wingClStartAlpha-aeroTable.alpha))):...
        idx(abs(p.wingClEndAlpha-aeroTable.alpha)==min(abs(p.wingClEndAlpha-aeroTable.alpha)))); 
    alphaCdCrop = aeroTable.alpha(idx(abs(p.wingCdStartAlpha-aeroTable.alpha)==min(abs(p.wingCdStartAlpha-aeroTable.alpha))):...
        idx(abs(p.wingCdEndAlpha-aeroTable.alpha)==min(abs(p.wingCdEndAlpha-aeroTable.alpha)))); 
    cdCrop    = aeroTable.cd(idx(abs(p.wingCdStartAlpha-aeroTable.alpha)==min(abs(p.wingCdStartAlpha-aeroTable.alpha))):...
        idx(abs(p.wingCdEndAlpha-aeroTable.alpha)==min(abs(p.wingCdEndAlpha-aeroTable.alpha)))); 

    
    pl=polyfit(alphaClCrop,clCrop,1);
    aeroTable.kl1=pl(1);
    aeroTable.kl0=pl(2);
    
    pd = polyfit(alphaCdCrop,cdCrop,2);
    aeroTable.kd2=pd(1);
    aeroTable.kd1=pd(2);
    aeroTable.kd0=pd(3);
    
%     % Plot  Cl and Cd to check
%     figure
%     subplot(2,1,1)
%     plot(aeroTable.alpha , aeroTable.cl)
%     hold on
%     plot(aeroTable.alpha , pl(1).*aeroTable.alpha + pl(2))
%     title('Cl Vs Alpha')
%     subplot(2,1,2)
%     plot(aeroTable.alpha , aeroTable.cd)
%     hold on
%     plot(aeroTable.alpha , pd(1).*aeroTable.alpha.^2 + pd(2)*aeroTable.alpha + pd(3))
%     title('Cd Vs Alpha')
end
if strcmpi(wingRudder,'rudder')
    idx=1:length(aeroTable.alpha);
    alphaClCrop = aeroTable.alpha(idx(abs(p.rudderClStartAlpha-aeroTable.alpha)==min(abs(p.rudderClStartAlpha-aeroTable.alpha))):...
        idx(abs(p.rudderClEndAlpha-aeroTable.alpha)==min(abs(p.rudderClEndAlpha-aeroTable.alpha)))); 
    clCrop    = aeroTable.cl(idx(abs(p.rudderClStartAlpha-aeroTable.alpha)==min(abs(p.rudderClStartAlpha-aeroTable.alpha))):...
        idx(abs(p.rudderClEndAlpha-aeroTable.alpha)==min(abs(p.rudderClEndAlpha-aeroTable.alpha)))); 
    alphaCdCrop = aeroTable.alpha(idx(abs(p.rudderCdStartAlpha-aeroTable.alpha)==min(abs(p.rudderCdStartAlpha-aeroTable.alpha))):...
        idx(abs(p.rudderCdEndAlpha-aeroTable.alpha)==min(abs(p.rudderCdEndAlpha-aeroTable.alpha)))); 
    cdCrop    = aeroTable.cd(idx(abs(p.rudderCdStartAlpha-aeroTable.alpha)==min(abs(p.rudderCdStartAlpha-aeroTable.alpha))):...
        idx(abs(p.rudderCdEndAlpha-aeroTable.alpha)==min(abs(p.rudderCdEndAlpha-aeroTable.alpha)))); 

    
    pl=polyfit(alphaClCrop,clCrop,1);
    aeroTable.kl1=pl(1);
    aeroTable.kl0=pl(2);
    
    pd = polyfit(alphaCdCrop,cdCrop,2);
    aeroTable.kd2=pd(1);
    aeroTable.kd1=pd(2);
    aeroTable.kd0=pd(3);
    
%     % Plot  Cl and Cd to check
%     figure
%     subplot(2,1,1)
%     plot(aeroTable.alpha , aeroTable.cl)
%     hold on
%     plot(aeroTable.alpha , pl(1).*aeroTable.alpha + pl(2))
%     title('Cl Vs Alpha')
%     subplot(2,1,2)
%     plot(aeroTable.alpha , aeroTable.cd)
%     hold on
%     plot(aeroTable.alpha , pd(1).*aeroTable.alpha.^2 + pd(2)*aeroTable.alpha + pd(3))
%     title('Cd Vs Alpha')
end


end