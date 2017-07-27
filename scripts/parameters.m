p.rho       = 1.225; % density of air kg/m^3
p.refLength = 1; % Chord length of airfoil
p.viscosity = 1.4207E-5; % Kinematic viscosity of air
p.refArea   = p.refLength^2;
p.mass      = 100; % Mass
p.momentArm = 0.5;  % Length of moment arm from for rudder
p.J         = 1000; % Rotational inertia about body fixed z axis

p.initPosition  = [100 0                          (45*pi/180)   ]; % Initial position in spherical coordinates
p.initVelocity  = [0   5/(p.initPosition(1)*2*pi) 0             ]; % Initial velocity in spherical coordinates
p.initOmega     = 0;
p.initOmegaDot  = 0;
p.initOmegaDDot = 0;