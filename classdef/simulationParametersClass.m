classdef simulationParametersClass < handle
    properties (SetObservable)
        % Simulation Time
        T = 2*60*60; % Total Simulation Time
        Ts = 0.002;  % Sample time
        
        % Output Settings
        verbose         = 1; % Text output to command window
        plotsOnOff      = 1; % Generate plots
        animationOnOff  = 0; % Generate animations
        saveOnOff       = 1; % Save data to the hard drive
        soundOnOff      = 1;
        
        % Simulation Switches
        runMode                             = 1; % 1 to run in optimization mode, 2 to use when gridding design space
        gravityOnOff                        = 1; % 0 turns gravity off
        windVariant                         = 1; % 1 for constant wind, 2 for Dr. Archers Data, 3 for NREL data
        turbulenceOnOff                     = 0; % 0 for off, 1 for on (0 sets wind speed to Dr. Archers data, linearly interpolated)
        energyTermSwitch                    = 2; % Which energy term to use in performance index 1 for mean energy, 2 for mean PAR
        updateTypeSwitch                    = 1; % 1 for Newton-based ILC update law, 2 for gradient-based ILC update law
        persistentExcitationSwitch          = 2; % 1 for sin and cos, 2 for white noise
        controlEnergyTermSwitch             = 1; % 1 for moment-based control energy term, 2 for command-based control energy term
        controlEnergyDerivativeTermSwitch   = 1; % 1 for moment-based control energy derivative term, 2 for command-based control energy derivative term
        
        % Optimization Settings
        numSettlingLaps         = 5;    % Must be at least 1 (I don't reccomend less than 3 though).
        numOptimizationLaps     = inf;  % Number of optimization iterations
        numInitializationLaps   = 5;    % 5 or 9 point initialization
        
        % Performance Index Weights
        energyTrackingWeight    = 400;  % Weight on spatial tracking when mean energy is used in performance index
        PARTrackingWeight       = 400;  % Weight on spatial tracking when mean PAR is used in performance index
        controlEnergyWeight     = 0;    % Weight on control energy term of performance index
        controlEnergyDerivativeWeight = 0; % Weight on control energy derivative term of performance index
        
        % RLS Settings
        forgettingFactor    = 0.98; % Forgetting factor used in RLS response surface update
        azimuthOffset       = 3;    % degrees, initialization grid step size
        zenithOffset        = 0.5;  % degrees, initialization grid step size
        
        % Persistent Excitation Settings
        azimuthPerturbationPeriod  = 4; % azimuth basis parameter amplitude
        azimuthPerturbationGain    = 3; % azimuth basis parameter period (not used in white noise implementation)
        zenithPerturbationPeriod   = 4; % zenith basis parameter amiplitude
        zenithPerturbationGain     = 0.5; % zenith basis parameter period (not used in white noise implementation)
        
        % ILC Learning Gains
        KLearningNewton   = .3; % ILC learning gain for Newton-based update
        KLearningGradient = .2; % ILC learning gain for gradient-based update
        
        % Waypoints Settings
        ic      = 'userspecified'; % which set of initial conditions to use, narrow or wide
        num     = 40; % number of waypoints
        elev    = 45; % mean course elevation
        waypointAzimuthTol = 1*(pi/180); % Tolerance which defines when a waypoint has been reached
        userWidth  = 80; % User specified width, only used if ic = 'UserSpecified' (case insensitive)
        userHeight = 15; % User specified height, only used if ic = 'UserSpecified' (case insensitive)
        
        % Rudder Controller
        kr1  = 100; % Controller gain
        kr2  = 100; % Controller gain
        tauR = 0.02;  % Ref model time const: 1/(tauR*s+1)^2
        
        % Wind parameters
        vWind           = 7; % Mean wind speed (used when windVariant = 1)
        windDirection   = 0; % Wind heading in degrees
        windAltitude    = 146; % Must be one of the available altitudes from Dr. Archer's data
        noiseSeeds      = [23341 23342 23343 23344];  % Noise seeds used in white noise generators for von Karman turbulence
        
        % Data Logging Parameters
        decimation = 10; % Log data every N points
        
        % Lifting Body
        mass      = 50; % Mass
        momentArm = 10; % Length of moment arm for rudder
        
        % Aerodynamic Parameters
        oswaldEfficiency  = 0.8; % For both wing and rudder
        refLengthWing     = 1; % Chord length of airfoil
        wingSpan          = 5; % Wing span
        refLengthRudder   = 1.5; % Rudder reference length (chord)
        rudderSpan        = 4; % Rudder span
        
        % Environmental
        rho             = 1.225;     % density of air kg/m^3
        viscosity       = 1.4207E-5; % Kinematic viscosity of air
        g               = 9.80665;   % Acceleration due to gravity
        
        % Initial Conditions
        initVelocity      = 15; % Initial straight line speed (BFX direction)
        initOmega         = 0;  % Initial twist rate
        
        % Actuator Rate Limiters
        wingAngleRateLimit = inf;   % degrees/sec
        rudderAngleRateLimit = inf; % degrees/sec
        
        % Airfoil lift/drag coefficient fitting limits
        % Defines the range of angles of attack over which we fit a line
        wingClStartAlpha = -0.1;
        wingClEndAlpha   = 0.1;
        wingCdStartAlpha = -0.1;
        wingCdEndAlpha   = 0.1;
        rudderClStartAlpha = -0.1;
        rudderClEndAlpha   = 0.1;
        rudderCdStartAlpha = -0.1;
        rudderCdEndAlpha   = 0.1;
        
        % Initial Course Geometry
        height                           % Initial course width
        width                            % Initial course height
        
        modelName = 'CDCJournalModel';
    end
    
    properties (Dependent)
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        J                                % Moment inertia about body fixe z axis
        waypointZenithTol                % Waypoint zenith reached tolerance
        waypointAngles                   % Parametric angles which define waypoints
        azimuthInitializationDirections  % Defines the grid of initialization points
        zenithInitializationDirections   % Defines the grid of initialization points
        initTwist                        % Initial twist angle, compliment to velocity angle
        initVelocityGFS                  % Initla velocity in ground fixe spherical coords
        AR                               % Aspect ratio of the main wing
        modelPath                        % Path to the model
        wingTable                        % Aerodynamic table for the main wing
        rudderTable                      % Aerodynamic table for the rudder
        useablePower                     % Useable power for this design, defined from wikipedia
        azimuthDistanceLim               % Trust region for optimization update on azimuth basis param
        zenithDistanceLim                % Trust region for optimization update on zenith basis param
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
        saveFile                         % File name of the resulting data file
        savePath                         % Path to the resulting data file
        windVariantName                  % String describing the wind variant
        initialWaypointAzimuths          % Initial vector of waypoint azimuths
        initialWaypointZeniths           % Initial vector of waypoint zeniths
        waypointToleranceArcLength       % Length of arch used to normalize the spatial tracking error term
    end
    
    methods
        % Functions to set up the model configuration parameters
        function obj = set.runMode(obj,value)
            obj.runMode = value;
            switch value
                case 1 
                    % turn off logging to RAM for optimization mode
                    set_param(obj.modelName,'SignalLogging','off');
                    % turn on logging to hard drive for optimization mode
                    set_param(obj.modelName,'LoggingToFile','on');
                case 2 
                    % turn on logging to RAM for grid mode
                    set_param(obj.modelName,'SignalLogging','on');
                    % turn off logging to hard drive for grid mode
                    set_param(obj.modelName,'LoggingToFile','off');
            end
            set_param(obj.modelName,'SignalLoggingName','logsout');
            set_param(obj.modelName,'LoggingFileName','out.mat');
        end
        
        function val = get.waypointToleranceArcLength(obj)
            lat1 = 0;
            lon1 = 0;
            lat2 = obj.waypointZenithTol;
            lon2 = obj.waypointAzimuthTol;
            a = sin((lat2-lat1)/2).^2 + cos(lat1) .* cos(lat2) .* sin((lon2-lon1)/2).^2;
            % Ensure that a falls in the closed interval [0 1].
            a(a < 0) = 0;
            a(a > 1) = 1;
            val = obj.initPositionGFS(1) * 2 * atan2(sqrt(a),sqrt(1 - a));
        end
        
        % Functions to initialize the waypoints
        function val = get.height(obj)
            switch lower(obj.ic)
                case 'both'
                    val = 7.5;
                    obj.width = 90;
                case 'wide'
                    val = 12;
                    obj.width = 100;
                case 'short'
                    val = 6.5;
                    obj.width = 60;
                case 'userspecified'
                    val = obj.userHeight;
                    obj.width = obj.userWidth;
                otherwise
                    val = obj.height;
            end
        end
        function val = get.width(obj)
            switch lower(obj.ic)
                case 'both'
                    val = 90;
                    obj.height = 7.5;
                case 'wide'
                    val = 100;
                    obj.height = 12;
                case 'short'
                    val = 60;
                    obj.height = 6.5;
                case 'userspecified'
                    val = obj.userWidth;
                    obj.height = obj.userHeight;
                otherwise
                    val = obj.width;
            end
        end
        function val = get.waypointAngles(obj)
            val = linspace((3/2)*pi,(3/2)*pi+2*pi,obj.num+1);
            val = val(2:end);
        end
        function val = get.initialWaypointAzimuths(obj)
           psi = obj.waypointAngles;
           val = (pi/180)*(obj.width/2)*cos(psi);
        end
        function val = get.initialWaypointZeniths(obj)
           psi = obj.waypointAngles;
           val = -1*(pi/180)*obj.height*sin(psi).*cos(psi)+obj.elev*(pi/180);
        end
        
        % Functions for saving data
        function val = get.savePath(obj)
            val = fullfile(fileparts(obj.modelPath),'data',filesep);
        end
        
        function val = get.windVariantName(obj)
           switch obj.windVariant
               case 1
                   val = 'Constant';
               case 2
                   val = 'VonKarman';
               case 3
                   val = 'NREL';
           end
        end
        function val = get.saveFile(obj)
            switch obj.updateTypeSwitch
                case 1
                    learningGain = obj.KLearningNewton;
                otherwise
                    learningGain = obj.KLearningGradient;
            end
                    val = sprintf('%s_%s_ke%0.2f_%s.mat',obj.ic,obj.windVariantName,learningGain,datestr(now,'ddmm_hhMMss')); 
        end
        function val = get.refAreaWing(obj)
            val = obj.refLengthWing*obj.wingSpan; % Reference area of wing
        end
        function val = get.refAreaRudder(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of wing
        end
        function val = get.J(obj)
            val = (obj.mass*obj.wingSpan^2)/12; % Rotational inertia about body fixed z axis (approx with (ml^2)/12))
        end
        
        function val = get.waypointZenithTol(obj)
            val = obj.waypointAzimuthTol;
        end

        function val = get.azimuthInitializationDirections(obj)
            if obj. numInitializationLaps == 5 % 5 point initialization
                val = [0 1 -1 0  0];
            else
                val = [0 0  0 1 -1 1  1 -1 -1];
            end
        end
        function val = get.zenithInitializationDirections(obj)
            if obj. numInitializationLaps == 5 % 5 point initialization
                val  = [0 0 0  1 -1];
            else
                val=[0 1 -1 0  0 1 -1  1  1];
            end
        end
        function val = get.initTwist(obj)
            % Give the system an initial heading to point it straight at the first
            % waypoint (approximately)
            val = atan2((pi/180)*(obj.height*sin(obj.waypointAngles(1)).*cos(obj.waypointAngles(1))),...
                (pi/180)*(obj.width/2)*cos(obj.waypointAngles(1))); % Initial twist angle
        end
        function val = get.initPositionGFS(obj)
            val = [100 0  (obj.elev*pi/180)]; % Initial position in spherical coordinates
        end
        function val = get.initVelocityGFS(obj)
            % Initial velocity in GFS
            val(1) = 0 ;
            val(2) = (obj.initVelocity*cos( obj.initTwist))/...
                (obj.initPositionGFS(1)*sin(obj.initPositionGFS(3)));
            val(3) = (obj.initVelocity*sin(-obj.initTwist))/(obj.initPositionGFS(1));
        end
        function val = get.AR(obj)
            val = obj.wingSpan/obj.refLengthWing;
        end
        function val = get.modelPath(obj)
            val = which([obj.modelName '.slx']);
        end
        function val = get.wingTable(obj)
            val =  buildAirfoilTable(obj,'wing');
        end
        function val = get.rudderTable(obj)
            
            val = buildAirfoilTable(obj,'rudder');
        end
        function val = get.useablePower(obj)
            % Useable power for this design
            % https://en.wikipedia.org/wiki/Crosswind_kite_power
            val = (2/27)*obj.rho*obj.refAreaWing*obj.wingTable.kl1*(max(obj.wingTable.cl./obj.wingTable.cd))^2*obj.vWind^3;
        end
        function val = get.azimuthDistanceLim(obj)
            val = 3*obj.azimuthOffset;
        end
        function val = get.zenithDistanceLim(obj)
            val = obj.zenithOffset;
        end
    end
end