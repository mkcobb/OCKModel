function loadWindData
% This function looks in the current search path for files named
% 'archerWindData.xls' and 'NRELWindData.xlsx'.  If it finds them, it loads
% them into the base workspace in a structure called 'windData'.  If it
% doesn't find them it'll probably crash.

data = xlsread('archerWindData.xls'); % Load data
t = data(2:end,1)*60; % Get the time vector and convert it to seconds
altitudes = data(1,2:end); % Get the list of altitudes
data = data(2:end,2:end); % Get the actual speed measurements

for ii = 1:size(data,2)
    d = data(:,ii); % get one column of data (corresponding to one altitude)
    % Clean up nans in data
    nans = isnan(d); % find which elements are nan
    d(nans) = interp1(t(~nans), d(~nans), t(nans)); % replace them with interpolated data
    % Create timeseries object
    ts = timeseries(d,t,'Name',sprintf('altitude%2d',altitudes(ii)));
    % Add it to the timeseries collection
    if ii == 1
        windData.archer = tscollection(ts); % if it's the first time through the loop, create the timeseries collection
    else
        windData.archer = addts(windData.archer,ts); % otherwise, add it to the existing collection
    end
end

NREL = xlsread('NRELWindData.xlsx','G2:G1411'); % Load up the NREL data
windData.NREL = timeseries(NREL,0:60:60*(length(NREL)-1)); % Create the timeseries
windData.NRELLookupTable = [[0:60:60*(length(NREL)-1)]',NREL]; % Also store the data as a matrix form lookup table, which is more convenient sometimes in Simulink

% move it to the base work space
assignin('base','windData',windData);

end