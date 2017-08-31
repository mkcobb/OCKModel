%% Independent Parameters

% Text output parameters
p.verbose = 1;

% Plotting Parameters
p.quietMode = 1;
p.waypointsOnOff = 1;

% RLS Settings
p.forgettingFactor = 0.99;
p.thetaDistanceLim = 3;
p.phiDistanceLim = 0.5;

% Optimization Settings
p.convergenceLim = 5;

% Controller
p.kr1  = 50;
p.kr2  = 50;
p.tauR = 0.05;

% Waypoints
p.height = 10;
p.width  = 160;
p.num    = 40;
p.elev   = 45;
p.waypointThetaTol = 0.5*(pi/180);
p.wrapTolerance    = pi;
p.trackingErrorWeight = 3000;

% rHat Override
% 0: allow distance from origin to vary
% 1: hold lifting body to surface of the sphere
p.rHatOverride = 1;
p.gravityOnOff = 1;

% Simulation Time
p.T = inf;

% Lifting Body
p.mass      = 75; % Mass
p.momentArm = 80;  % Length of moment arm from for rudder

% Aerodynamic Parameters
p.oswaldEfficiency  = 0.8;
p.refLengthWing     = 1; % Chord length of airfoil
p.wingSpan          = 5;
p.refLengthRudder   = 1.5;
p.rudderSpan        = 4;

% Environmental
p.rho       = 1.225; % density of air kg/m^3
p.viscosity = 1.4207E-5; % Kinematic viscosity of air
p.g         = 9.80665; % Acceleration due to gravity

% Initial Conditions
p.initPositionGFS   = [100 0  (45*pi/180)]; % Initial position in spherical coordinates
p.initVelocity      = 10; % Initial straight line speed (BFX direction)
p.initTwist         = 0*(pi/180); % Initial twist angle
p.initOmega         = 0; % Initial twist rate

% Actuator Rate Limiters
p.wingAngleRateLimit = 360; % degrees/sec
p.rudderAngleRateLimit = 360; % degrees/sec

% Airfoil lift/drag coefficient fitting limits
p.wingClStartAlpha = -0.1;
p.wingClEndAlpha   = 0.1;
p.wingCdStartAlpha = -0.1;
p.wingCdEndAlpha   = 0.1;
p.rudderClStartAlpha = -0.1;
p.rudderClEndAlpha   = 0.1;
p.rudderCdStartAlpha = -0.1;
p.rudderCdEndAlpha   = 0.1;

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
p.waypointPhiTol   = p.waypointThetaTol;

% Aspect Ratio
p.AR = p.wingSpan/p.refLengthWing;

% Simulink model path
p.modelPath = which('CDCJournalModel.slx');

% Build Aerodynamic Tables
wingTable   = buildAirfoilTable(p,'wing');
rudderTable = buildAirfoilTable(p,'rudder');

% Empty arraysfor storing things when we run loops, not used in all scripts
p.widthsVec = [];
p.heightsVec= [];

p.performanceIndex = [];
p.errorIndex = [];
p.errorName = {};

p.performanceIndexInit=[];
p.errorIndexInit = [];
p.errorNameInit = {};


p.performanceIndexOpt=[];
p.errorIndexOpt = [];
p.errorNameOpt = {};


p.meanEnergy =[];
p.tsc={};
p.phiInit = [];
p.thetaInit = [];

p.XInit=[];
p.xOpt={};
p.Beta={};
p.V={};






















