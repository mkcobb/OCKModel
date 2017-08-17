function p = generateWaypoints(n,h,w,elev)
startPsi=(3/2)*pi;
endPsi = startPsi+2*pi;

% Parameterize the curve based on lemniscate of Gerono.
% Generate an extra point so that we can get rid of the first waypoint
% later
p.psi = linspace(startPsi,endPsi,n+1);

% Calculate the lemniscate
thetaDeg = (w/2)*cos(p.psi);
phiDeg   = h*sin(p.psi).*cos(p.psi)+elev;

% Discard the first waypoint
p.psi      = p.psi(2:end);
p.thetaDeg = thetaDeg(2:end);
p.phiDeg   = phiDeg(2:end);

% Convert to Radians for flexibility
p.thetaRad = p.thetaDeg.*(pi/180);
p.phiRad   = p.phiDeg.*(pi/180);
end