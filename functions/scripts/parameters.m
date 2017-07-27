p.rho = 1.225; % density of air kg/m^3
p.refLength = 1; % Chord length of airfoil
p.viscosity = 1.4207E-5; % Kinematic viscosity of air
p.refArea = p.refLength^2;
p.mass = 1; % Mass
p.momentArm = 1;  % Length of moment arm from for rudder
p.J = 1; % Rotational inertia about body fixed z axis

p.initPosition = [];
p.initVelocity = [];