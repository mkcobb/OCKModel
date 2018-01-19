function [azimuth,zenith] = generateWaypoints(n,h,w,elev)
% Parameterize the curve based on lemniscate of Gerono.
% Generate an extra point so that we can get rid of the first waypoint
% later
psi = linspace((3/2)*pi,(3/2)*pi+2*pi,n+1);

% Calculate the lemniscate
azimuthDeg = (w/2)*cos(psi); % Azimuth angle 
elevationDeg   = -1*h*sin(psi).*cos(psi)+elev; % Elevation angle

% Discard the first waypoint
psi      = psi(2:end);
azimuthDeg = azimuthDeg(2:end);
zenithDeg   = elevationDeg(2:end);

% Convert to Radians for flexibility
azimuthRad = azimuthDeg.*(pi/180);
elevationRad   = elevationDeg.*(pi/180);
end