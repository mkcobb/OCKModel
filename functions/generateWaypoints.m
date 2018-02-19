function [azimuthRad,elevationRad,zenithRad] = generateWaypoints(n,w,h,elev)
% Parameterize the curve based on lemniscate of Gerono.

psi = linspace((3/2)*pi,(3/2)*pi+2*pi,n);

% Calculate the lemniscate
azimuthDeg     = (w/2)*cos(psi); % Azimuth angle 
elevationDeg   = (h/2)*sin(2*psi)+elev; % Elevation angle

% Convert to Radians
azimuthRad     = azimuthDeg.*(pi/180);
elevationRad   = elevationDeg.*(pi/180);
zenithRad      = (pi/2)-elevationRad;
end