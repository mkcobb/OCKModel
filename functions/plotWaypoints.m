function h = plotWaypoints(p,r,hax)
axes(hax)
[x,y,z]=sphere2cart(r*ones(size(p.thetaRad)),p.thetaRad,p.phiRad);
h.points = scatter3(x,y,z,'Marker','x','MarkerEdgeColor','r');
axis equal
end