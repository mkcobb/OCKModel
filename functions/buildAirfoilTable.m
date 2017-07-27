function aeroTable =  buildAirfoilTable()
files = dir(fullfile(pwd,'airfoil'));
[~,~,data]=xlsread(files(3).name);
aeroTable.Re = data{4,2};
jj=1;
while ~strcmpi(data{jj,1},'alpha')
    jj=jj+1;
end
data = cell2mat(data(jj+1:end,1:3));
aeroTable.alpha = data(:,1);
aeroTable.cl = data(:,2);
aeroTable.cd = data(:,3);
end