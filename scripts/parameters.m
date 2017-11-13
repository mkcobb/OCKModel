%% Independent Parameters

% Text output parameters
p.verbose = 1;

% Plotting Parameters
p.quietMode = 1;
p.waypointsOnOff = 1;

% RLS Settings
p.forgettingFactor = 0.8;
p.azimuthDistanceLim = 5;
p.zenithDistanceLim = 0.25;
p.azimuthPerturbationPeriod  = 3;
p.azimuthPerturbationGain    = 5;
p.zenithPerturbationPeriod   = 5;
p.zenithPerturbationGain     = 1;

% Optimization Settings
p.convergenceLim = 30;
p.numSettlingLaps = 3;
p.numInitializationLaps = 5;
p.numOptimizationLaps = 30;
% Optimization Initialization Settings
p.azimuthOffset = 2.5; % degrees
p.zenithOffset = 0.25; % degrees
p.azimuthInitializationDirections = [0 1  1 -1 -1];
p.zenithInitializationDirections  = [0 1 -1  1 -1];

% x={[1:p.numSettlingLaps],[p.numSettlingLaps+1:p.numSettlingLaps+1+p.numInitializationLaps-1],[p.numSettlingLaps+1+p.numInitializationLaps:p.numSettlingLaps+1+p.numInitializationLaps+p.numOptimizationLaps-1]}

% Controller
p.kr1  = 100;
p.kr2  = 100;
p.tauR = 0.04;  % Ref model time const: 1/(tauR*s+1)^2

% Waypoints
p.height = 7;
p.width  = 60;
p.num    = 40;
p.elev   = 45;
p.waypointAzimuthTol = 0.5*(pi/180);
p.wrapTolerance    = pi;
p.trackingErrorWeight = 3000;

% rHat Override
% 0: allow distance from origin to vary
% 1: hold lifting body to surface of the sphere
p.rHatOverride = 1;
p.gravityOnOff = 1;

% Simulation Time
p.T = inf;
p.Ts = 0.001; % Sample time

% Lifting Body
p.mass      = 60; % Mass
p.momentArm = 10;  % Length of moment arm for rudder

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

% Wind Conditions
p.vWind = 3;

% Initial Conditions
p.initPositionGFS   = [100 0  (45*pi/180)]; % Initial position in spherical coordinates
p.initVelocity      = 15; % Initial straight line speed (BFX direction)
p.initTwist         = 0*(pi/180); % Initial twist angle
p.initOmega         = 0; % Initial twist rate

% Actuator Rate Limiters
p.wingAngleRateLimit = 360; % degrees/sec
p.rudderAngleRateLimit = 10*360; % degrees/sec

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
p.waypointZenithTol   = p.waypointazimuthTol;
p.waypointAngles = linspace((3/2)*pi,(3/2)*pi+2*pi,p.num+1);
p.waypointAngles = p.waypointAngles(2:end);

% Aspect Ratio
p.AR = p.wingSpan/p.refLengthWing;

% Simulink model path
p.modelPath = which('CDCJournalModel.slx');

% Build Aerodynamic Tables
wingTable   = buildAirfoilTable(p,'wing');
rudderTable = buildAirfoilTable(p,'rudder');

% Useable power for this design
% https://en.wikipedia.org/wiki/Crosswind_kite_power
p.useablePower = (2/27)*p.rho*p.refAreaWing*wingTable.kl1*(max(wingTable.cl./wingTable.cd))^2*p.vWind^3;

% Empty arraysfor storing things when we run loops, not used in all scripts
p.widthsVec = [];
p.heightsVec= [];

p.performanceIndex = [];
p.errorIndex = [];
p.errorName = {};

p.meanPARInit=[];
p.performanceIndexInit=[];
p.meanEnergyInit =[];
p.errorIndexInit = [];
p.errorNameInit = {};

p.meanPAROpt=[];
p.performanceIndexOpt=[];
p.meanEnergyOpt =[];
p.errorIndexOpt = [];
p.errorNameOpt = {};




p.tsc={};
p.zenithInit = [];
p.azimuthInit = [];

p.XInit=[];
p.xOpt={};
p.Beta={};
p.V={};

p.gradientzenith=[];
p.gradientazimuth=[];






















