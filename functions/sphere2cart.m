function [x,y,z]=sphere2cart(r,theta,phi)
x=r.*cos(theta).*sin(phi);
y=r.*sin(theta).*sin(phi);
z=r.*cos(phi);
end