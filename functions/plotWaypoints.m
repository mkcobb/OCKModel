function [points,waypointBounds] = plotWaypoints(p,hax)
axes(hax)
[x,y,z]=sphere2cart(p.initPositionGFS(1)*ones(size(p.waypoints.thetaRad)),p.waypoints.thetaRad,p.waypoints.phiRad);
points = scatter3(x,y,z,'Marker','x','MarkerEdgeColor','r');
for ii = 1:length(p.waypoints.thetaRad)
   theta = [p.waypoints.thetaRad(ii)+p.waypointThetaTol p.waypoints.thetaRad(ii)+p.waypointThetaTol p.waypoints.thetaRad(ii)-p.waypointThetaTol p.waypoints.thetaRad(ii)-p.waypointThetaTol p.waypoints.thetaRad(ii)+p.waypointThetaTol];
   phi   = [p.waypoints.phiRad(ii)+p.waypointPhiTol     p.waypoints.phiRad(ii)-p.waypointPhiTol     p.waypoints.phiRad(ii)-p.waypointPhiTol     p.waypoints.phiRad(ii)+p.waypointPhiTol     p.waypoints.phiRad(ii)+p.waypointPhiTol];
   r     = p.initPositionGFS(1)*ones(1,length(theta));
   [x,y,z]=sphere2cart(r,theta,phi);
   waypointBounds(ii) = plot3(x,y,z,'Color','b');
end
end