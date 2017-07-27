function aeroTable =  buildRudderTable()
files = dir(fullfile(pwd,'rudder'));
[~,~,data]=xlsread(files(3).name);
aeroTable.Re = data{4,2};
jj=1;
while ~strcmpi(data{jj,1},'alpha')
    jj=jj+1;
end
data = cell2mat(data(jj+1:end,1:3));
aeroTable.beta = data(:,1)*(pi/180);
aeroTable.cl = data(:,2);
aeroTable.cd = data(:,3);
% note that rudder table isn't exactly symmetric, need to make sure zero
% beta gives zero cl.
aeroTable.cl = aeroTable.cl-aeroTable.cl(aeroTable.beta==0);
end