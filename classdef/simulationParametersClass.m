classdef simulationParametersClass < handle
    properties (SetObservable)
        % Simulation Time
        T  = 1*60*60; % Total Simulation Time
        Ts = 0.002;  % Sample time
        
        % Output Settings (0 to turn off , 1 to turn on)
        verbose         = 1; % Text output to command window
        plotsOnOff      = 1; % Generate plots
        animationOnOff  = 0; % Generate animations
        saveOnOff       = 1; % Save data to the hard drive
        soundOnOff      = 0; % Turn on/off gong noise at end of simulation
        
        % Simulation Switches
        runMode     = 1; % 1 to run in optimization mode, 2 to use when gridding design space
        decimation  = 10; % Log data every N points
        modelName   = 'CDCJournalModel'; % Name of the model to run
        
        % Environmental Conditions Switches
        gravityOnOff    = 1; % 0 turns gravity off
        windVariant     = 1; % 1 for constant wind, 2 for Dr. Archers Data, 3 for NREL data
        vWind           = 7; % Mean wind speed (used when windVariant = 1)
        windDirection   = 0; % Wind heading in degrees
        turbulenceOnOff = 0; % 0 for off, 1 for on (0 sets wind speed to Dr. Archers data, linearly interpolated)
        windAltitude    = 146; % Must be one of the available altitudes from Dr. Archer's data
        noiseSeeds      = [23341 23342 23343 23344];  % Noise seeds used in white noise generators for von Karman turbulence
        rho             = 1.225;     % density of air kg/m^3
        viscosity       = 1.4207E-5; % Kinematic viscosity of air (I think this is only used in Reynolds number calculation)
        g               = 9.80665;   % Acceleration due to gravity
        
        % Performance Index Switches
        switchME   = 0; % Switch that turns on/off the Mean Energy term in the performance index
        switchPAR  = 1; % Switch that turns on/off the Power Augmentation Ratio term in the performance index
        switchSE   = 1; % Switch that turns on/off the Spatial Error term in the performance index
        switchCCE  = 0; % Switch that turns on/off the Command-Based Control Energy term in the performance index
        switchMCE  = 0; % Switch that turns on/off the Moment-BasedControl Energy term in the performance index
        switchCDCE = 0; % Switch that turns on/off the Command Derivative-Based Control Energy term in the performance index
        switchMDCE = 0; % Switch that turns on/off the Moment Derivative-Based Control Energy term in the performance index
        
        % Performance Index Weights
        weightME   = 1;     % Weight on Mean Energy in performance index
        weightPAR  = 1;     % Weight on Power Augmentation Ratio in performance index
        weightSE   = 40;    % Weight on Spatial Error in performance index
        weightCCE  = 1;     % Weight on Command-Based Control Energy
        weightMCE  = 1;     % Weight on Moment-Based Control Energy
        weightCDCE = 1;     % Weight on Command Derivative-Based Control Energy
        weightMDCE = 1;     % Weight on Moment Derivative-BAsed Control Energy

        % Optimization Settings
        updateTypeSwitch            = 2;    % 1 for Newton-based ILC update law, 2 for gradient-based ILC update law
        persistentExcitationSwitch  = 2;    % 1 for sin and cos, 2 for white noise
        numSettlingLaps             = 5;    % Must be at least 1 (I don't reccomend less than 3 though).
        numOptimizationLaps         = inf;  % Number of optimization iterations
        KLearningNewton             = .1;   % ILC learning gain for Newton-based update
        KLearningGradient           = 2;   % ILC learning gain for gradient-based update
        azimuthDistanceLim          = 4;    % Size of trust region
        zenithDistanceLim           = 0.5; % Size of trust region
        
        % RLS Settings
        numInitializationLaps   = 5;    % 5 or 9 point initialization
        forgettingFactor        = 0.97;    % Forgetting factor used in RLS response surface update
        azimuthOffset           = 1;    % degrees, initialization grid step size
        zenithOffset            = 0.5;  % degrees, initialization grid step size
        
        % Persistent Excitation Settings
        azimuthPerturbationPeriod  = 4;     % azimuth basis parameter perturbation amplitude
        zenithPerturbationPeriod   = 4;     % zenith basis parameter perturbation amplitude
        azimuthPerturbationGain    = 5;     % azimuth basis parameter period (not used in white noise implementation,cannot be zero)
        zenithPerturbationGain     = 0.5;   % zenith basis parameter period (not used in white noise implementation,cannot be zero)
        
        % Waypoints Settings
        ic                  = 'wide';       % which set of initial conditions to use, if 'userspecified' then must set width and height manually in calling script
        num                 = 10^3;         % number of angles used to parameterize the path
        elev                = 45;           % mean course elevation
        lookAheadPercent    = 0.025;          % percentage of total path length that the carrot is ahead
        localSearchPercent  = 0.05;          % percentage of the course to search for the closest point on the path, centered on previous closest point.
        
        % Rudder Controller
        kr1  = 100; % Controller gain
        kr2  = 100; % Controller gain
        tauR = 0.05;  % Ref model time const: 1/(tauR*s+1)^2
        
        % Lifting Body Physical Parameters
        mass      = 50; % Mass
        momentArm = 10; % Length of moment arm for rudder
        
        % Aerodynamic Parameters
        oswaldEfficiency  = 0.8; % For both wing and rudder
        refLengthWing     = 1; % Chord length of airfoil
        wingSpan          = 5; % Wing span
        refLengthRudder   = 1.5; % Rudder reference length (chord)
        rudderSpan        = 4; % Rudder span
        
        % Initial Conditions
        initVelocity      = 28; % Initial straight line speed (BFX direction)
        initOmega         = 0;  % Initial twist rate
        
        % Actuator Rate Limiters
        wingAngleRateLimit      = inf;      % degrees/sec
        rudderAngleRateLimit    = inf;      % degrees/sec
        
        % Airfoil lift/drag coefficient fitting limits
        % Defines the range of angles of attack over which we fit a line
        wingClStartAlpha    = -0.1;
        wingClEndAlpha      = 0.1;
        wingCdStartAlpha    = -0.1;
        wingCdEndAlpha      = 0.1;
        rudderClStartAlpha  = -0.1;
        rudderClEndAlpha    = 0.1;
        rudderCdStartAlpha  = -0.1;
        rudderCdEndAlpha    = 0.1;
        
        height                           % Initial course width
        width                            % Initial course height
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
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
        saveFile                         % File name of the resulting data file
        savePath                         % Path to the resulting data file
        windVariantName                  % String describing the wind variant
        initialWaypointAzimuths          % Initial vector of waypoint azimuths
        initialWaypointZeniths           % Initial vector of waypoint zeniths
        waypointToleranceArcLength       % Length of arch used to normalize the spatial tracking error term
        localSearchIndexOffsetVector     % Angular distance to look ahead for the path following.
        lookAheadIndexOffset             % Number of indices ahead that the carrot is
    end
    
    methods
        % Functions to set up the model configuration parameters
        function val = get.lookAheadIndexOffset(obj)
            val = round(obj.num*obj.lookAheadPercent);
        end
        function val = get.localSearchIndexOffsetVector(obj)
            val = -round(obj.num*obj.localSearchPercent):round(obj.num*obj.localSearchPercent);
        end
        
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
        
%         function val = get.waypointToleranceArcLength(obj)
%             lat1 = 0;
%             lon1 = 0;
%             lat2 = obj.waypointZenithTol;
%             lon2 = obj.waypointAzimuthTol;
%             a = sin((lat2-lat1)/2).^2 + cos(lat1) .* cos(lat2) .* sin((lon2-lon1)/2).^2;
%             % Ensure that a falls in the closed interval [0 1].
%             a(a < 0) = 0;
%             a(a > 1) = 1;
%             val = obj.initPositionGFS(1) * 2 * atan2(sqrt(a),sqrt(1 - a));
%         end
        
        % Functions to initialize the waypoints
        function set.height(obj,value)
            obj.height = value;
        end
        function set.width(obj,value)
            obj.width = value;
        end
        function val = get.height(obj)
            switch lower(obj.ic)
                case 'both'
                    val = 7.5;
                case 'wide'
                    val = 12;
                case 'short'
                    val = 6.5;
                case 'userspecified'
                    val = obj.height;
                otherwise
                    val = obj.height;
            end
        end
        function val = get.width(obj)
            switch lower(obj.ic)
                case 'both'
                    val = 90;
                case 'wide'
                    val = 100;
                case 'short'
                    val = 60;
                case 'userspecified'
                    val = obj.width;
                otherwise
                    val = obj.width;
            end
        end
        function val = get.waypointAngles(obj)
            val = linspace((3/2)*pi,(3/2)*pi+2*pi,obj.num);
%             val = val(2:end);
        end
%         function val = get.initialWaypointAzimuths(obj)
%            psi = obj.waypointAngles;
%            val = (pi/180)*(obj.width/2)*cos(psi);
%         end
%         function val = get.initialWaypointZeniths(obj)
%            psi = obj.waypointAngles;
%            val = -1*(pi/180)*obj.height*sin(psi).*cos(psi)+obj.elev*(pi/180);
%         end
        
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
           val = atan2(-obj.height,obj.width/2);
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
%         function val = get.azimuthDistanceLim(obj)
%             val = 3*obj.azimuthOffset;
%         end
%         function val = get.zenithDistanceLim(obj)
%             val = obj.zenithOffset;
%         end
    end
end