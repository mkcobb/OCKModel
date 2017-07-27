%% Independent Parameters

% Simulation Time
p.T = 7;

% Lifting Body
p.mass      = 75; % Mass
p.momentArm = 1;  % Length of moment arm from for rudder

% Aerodynamic
p.refLengthWing = 1; % Chord length of airfoil
p.wingSpan = 5;
p.refLengthRudder = 0.75;
p.rudderSpan = 1;

% Environmental
p.rho       = 1.225; % density of air kg/m^3
p.viscosity = 1.4207E-5; % Kinematic viscosity of air
p.g         = 9.80665;

% Initial Conditions
p.initPosition  = [100 0                          (45*pi/180)   ]; % Initial position in spherical coordinates
p.initVelocity  = [0   0          -0.1]; % Initial velocity in spherical coordinates
p.initTwist     = pi/2;
p.initOmega     = 0;


%% Dependent parameters
p.refAreaWing   = p.refLengthWing*p.wingSpan;
p.J         = (p.mass*p.wingSpan^2)/12; % Rotational inertia about body fixed z axis (approx with (ml^2)/12))
p.refAreaRudder = p.refLengthRudder*p.rudderSpan;
