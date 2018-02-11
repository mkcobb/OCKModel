function loadWindData
data = xlsread('archerWindData.xls');
t = data(2:end,1)*60;
altitudes = data(1,2:end);
data = data(2:end,2:end);
% windData = tscollection(timeseries(data(:,1),t,'Name',sprintf('altitude%d',altitudes(1))));
for ii = 1:size(data,2)
    d=data(:,ii);
    % Clean up nans in data
    nans=isnan(d);
    d(nans) = interp1(t(~nans), d(~nans), t(nans));
    % Create timeseries
    ts = timeseries(d,t,'Name',sprintf('altitude%2d',altitudes(ii)));
    % Add it to the collection
    if ii ==1
        windData.archer = tscollection(ts);
    else
        windData.archer = addts(windData.archer,ts);
    end
end

NREL = xlsread('NRELWindData.xlsx','G2:G1411');
windData.NREL = timeseries(NREL,0:60:60*(length(NREL)-1));
windData.NRELLookupTable = [[0:60:60*(length(NREL)-1)]',NREL];
% move it to the base work space
assignin('base','windData',windData);

end