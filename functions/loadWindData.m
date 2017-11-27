function windData = loadWindData
data=xlsread('windData.xls');
t=data(2:end,1)*60;
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
        windData = tscollection(ts);
    else
        windData = addts(windData,ts);
    end
end

end