function cData = getColor(pts,lowerLim,upperLim,myColorMap)
xData = linspace(lowerLim,upperLim,size(myColorMap,1));
rData = myColorMap(:,1);
bData = myColorMap(:,2);
gData = myColorMap(:,3);
cData = [interp1(xData,myColorMap(:,1),pts');interp1(xData,myColorMap(:,2),pts');interp1(xData,myColorMap(:,3),pts')]';
end