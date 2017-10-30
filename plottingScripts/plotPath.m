pathX = path(:,1);
pathY = path(:,2);
pathZ = path(:,3);

cData = getColor(powerFactor,minPAR,maxPAR,heatColorMap);
sData = 100*ones(size(pathX));

if ~isfield(h,'PAR')
    h.PAR=scatter3(pathX,pathY,pathZ,sData,cData,...
        'Marker','.');
else
    h.PAR.XData = pathX;
    h.PAR.YData = pathY;
    h.PAR.ZData = pathZ;
    h.PAR.CData = cData;
    h.PAR.SizeData = sData;
end