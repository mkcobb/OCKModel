%% Independent Parameters
% Controller
p.kr1=1;
p.kr2=1;
p.tauR = 0.05;

% Waypoints
p.height = 20;
p.width  = 90;
p.num    = 40;
p.elev   = 45;
p.waypointThetaTol = 1*(pi/180);
p.waypointPhiTol   = 1*(pi/180);
p.wrapTolerance    = pi;

% rHat Override
% 0: allow distance from origin to vary
% 1: hold lifting body to surface of the sphere
p.rHatOverride = 1;
p.gravityOnOff = 0;

% Simulation Time
p.T = 30;

% Lifting Body
p.mass      = 75; % Mass
p.momentArm = 1;  % Length of moment arm from for rudder

% Aerodynamic Parameters
p.oswaldEfficiency = 0.8;
p.refLengthWing = 1; % Chord length of airfoil
p.wingSpan = 5;
p.refLengthRudder = 0.75;
p.rudderSpan = 1;

% Environmental1/
p.rho       = 1.225; % density of air kg/m^3
p.viscosity = 1.4207E-5; % Kinematic viscosity of air
p.g         = 9.80665; % Acceleration due to gravity

% Initial Conditions
p.initPositionGFS  = [100 0  (45*pi/180)]; % Initial position in spherical coordinates
p.initVelocity  = 10; % Initial straight line speed (BFX direction)
p.initTwist     = 0*(pi/180); % Initial twist angle
p.initOmega     = 0; % Initial twist rate

%% Dependent parameters
p.refAreaWing     = p.refLengthWing*p.wingSpan; % Reference area of wing
p.J               = (p.mass*p.wingSpan^2)/12; % Rotational inertia about body fixed z axis (approx with (ml^2)/12))
p.refAreaRudder   = p.refLengthRudder*p.rudderSpan; % Ref aera of rudder

% Initial velocity in GFS
p.initVelocityGFS(1) = 0 ;
p.initVelocityGFS(2) = (p.initVelocity*cos( p.initTwist))/...
    (p.initPositionGFS(1)*sin(p.initPositionGFS(3)));
p.initVelocityGFS(3) = (p.initVelocity*sin(-p.initTwist))/(p.initPositionGFS(1));

% Waypoints
p.waypoints = generateWaypoints(p.num,p.height,p.width,p.elev);

% Aspect Ratio
p.AR = p.wingSpan/p.refLengthWing;

% Build Aerodynamic Tables
wingTable   = buildAirfoilTable(p,'wing');
rudderTable = buildAirfoilTable(p,'rudder');





















