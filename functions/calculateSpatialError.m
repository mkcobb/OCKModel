function [totalError,normalizedError,individualErrors] = calculateSpatialError(p,tsc,varargin)
% varargin is a matrix containing weights which describe how much we care about the error at each point.
% note that since the simulation stops when the boat hits the spatial
% tolerance of the last waypoint, we dont want to penalize tracking error
% on the last waypoint since that error will always be equal to the
% specified spatial tracking tolerance.  That's why the weights vector
% should be shorter than the waypoints vector.

individualErrors=zeros(max(tsc.currentWaypointIndex.data)-1,1);

if isempty(varargin)
    weights = ones(length(individualErrors),1);
end

for i = 1:max(tsc.currentWaypointIndex.data)-1
    theta = tsc.theta.data(tsc.currentWaypointIndex.data==i|tsc.currentWaypointIndex.data==i+1);
    phi = tsc.phi.data(tsc.currentWaypointIndex.data==i|tsc.currentWaypointIndex.data==i+1);
    errors = ((theta-p.waypoints.thetaRad(i)).^2+(phi-p.waypoints.phiRad(i)).^2).^(1/2);
    individualErrors(i)= min(errors);
    
end
totalError = weights'*individualErrors;
if max(tsc.currentWaypointIndex.data)==p.num
    numberOfWaypointsReached = p.num-1;
else
    numberOfWaypointsReached = max(tsc.currentWaypointIndex.data);
end
normalizedError = totalError/(numberOfWaypointsReached*p.waypointThetaTol);
end