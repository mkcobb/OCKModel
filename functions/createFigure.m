function fig = createFigure()
% Create blank, full-screen figure on the left hand monitor, if possible
if size(get(groot,'MonitorPositions'),1)>1
    fig = figure('units','normalized','position',[-1 0 1 0.9]);
else
    fig = figure('units','normalized','position',[0 0 1 0.9]);
end
end