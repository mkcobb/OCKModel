close all
clc
phi = linspace(3*pi/2,7*pi/2,100);
H = 10*(pi/180);
W = 100*(pi/180);

path = [W/2*cos(phi);...
    (H/2)*sin(2*phi)+pi/4];

normals = [ H*cos(2*phi);...
    (W/2)*sin(phi)];

% normals = [-normals(2,:);normals(1,:)]

normals = normals./sqrt(sum(normals.^2,1))

plot(path(1,:),path(2,:))
hold on
quiver(path(1,:),path(2,:),normals(1,:),normals(2,:))