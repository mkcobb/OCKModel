function cart = polar2cart(polar)
% convert a ground fixed polar vector to cartesian
cart = [0;0;0];
cart(1) = polar(1)*cos(polar(3))*cos(polar(2));
cart(2) = polar(1)*cos(polar(3))*sin(polar(2));
cart(3) = polar(1)*sin(polar(3));
end
