function aeroTable =  buildRudderTable()
files = dir(fullfile(pwd,'rudder'));
if ispc
    [~,~,data]=xlsread(fullfile(pwd,'rudder',files(3).name));
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
            data=csvread(fullfile(pwd,'rudder',files(ii).name),11,0);
            fid = fopen(fullfile(pwd,'rudder',files(ii).name));
            Re = textscan(fid, '%s','delimiter', '\n');
            fclose(fid);
            Re=strsplit(Re{1}{4},',');
            aeroTable.Re = str2double(Re{2});
        end
    end
end

aeroTable.beta = data(:,1)*(pi/180);
aeroTable.cl = data(:,2);
aeroTable.cd = data(:,3);

end