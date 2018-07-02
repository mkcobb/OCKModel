classdef simulationParametersClass < handle
    properties
        % Simulation Time
        T  = 20*60; % Total Simulation Time
        Ts = 0.002;  % Sample time
        
        % Output Settings (0 to turn off , 1 to turn on)
        verbose         = 1; % Text output to command window
        plotsOnOff      = 1; % Generate plots
        animationOnOff  = 0; % Generate animations
        saveOnOff       = 1; % Save data to the hard drive
        soundOnOff      = 0; % Turn on/off gong noise at end of simulation
%         decimation      = 10; % Log data every N points
        
        % Simulation Switches
        runMode     = 'spatialILC'; % 'optimization','baseline', 'grid', or 'spatialILC'
        modelName   = 'OCKModel'; % Name of the model to run
        windVariant = 1;% 1 for constant wind, 2 for Dr. Archers Data, 3 for NREL data
                
        % Environmental Conditions Switches
        gravityOnOff    = 1; % 0 turns gravity off
        
        vFlow           = 7; % Mean wind speed (used when windVariant = 1)
        windDirection   = 0; % Wind heading in degrees
%         turbulenceOnOff = 0; % 0 for off, 1 for on (0 sets wind speed to Dr. Archers data, linearly interpolated)
%         windAltitude    = 146; % Must be one of the available altitudes from Dr. Archer's data
%         noiseSeeds      = [23341 23342 23343 23344];  % Noise seeds used in white noise generators for von Karman turbulence
        rho             = 1.225;     % density of air kg/m^3
        viscosity       = 1.4207E-5; % Kinematic viscosity of air (I think this is only used in Reynolds number calculation)
        g               = 9.80665;   % Acceleration due to gravity

        % Performance Index Weights
        weightME   = 1;     % Weight on Mean Energy in performance index
        weightPAR  = 1;     % Weight on Power Augmentation Ratio in performance index
        weightSE   = 10;    % Weight on Spatial Error in performance index

        % Optimization Settings
        updateTypeSwitch            = 2;    % 1 for Newton-based ILC update law, 2 for gradient-based ILC update law
        persistentExcitationSwitch  = 2;    % 1 for sin and cos, 2 for white noise
        
        KLearningNewton             = .1;   % ILC learning gain for Newton-based update
        KLearningGradient           = 0.01; % ILC learning gain for gradient-based update
        azimuthDistanceLim          = 6;    % Size of trust region
        zenithDistanceLim           = 1.5;  % Size of trust region
        
        % RLS Settings
        numInitializationLaps   = 5;    % 5 or 9 point initialization
        forgettingFactor        = 0.99;    % Forgetting factor used in RLS response surface update
        azimuthOffset           = 1;    % degrees, initialization grid step size
        zenithOffset            = 0.5;  % degrees, initialization grid step size
        
        % Persistent Excitation Settings
        azimuthPerturbationPeriod    = 4;     % azimuth basis parameter excitation period (when using sin/cos)
        zenithPerturbationPeriod     = 4;     % zenith basis parameter excitation period (when using sin/cos)
        azimuthPerturbationAmplitude = 2.5;   % azimuth basis parameter excitation amplitude 
        zenithPerturbationAmplitude  = 1;     % zenith basis parameter excitation amplitude 
        
        % Waypoints Settings
        ic                  = 'both';       % which set of initial conditions to use, if 'userspecified' then must set width and height manually in calling script
        num                 = 10^3;         % number of angles used to parameterize the path
        elev                = 45;           % mean course elevation
        lookAheadPercent    = 0.025;        % percentage of total path length that the carrot is ahead
        localSearchPercent  = 0.025         % percentage of the course to search for the closest point on the path, centered on previous closest point.
        
        % Rudder Controller
        kr1  = 100; % Controller gain
        kr2  = 100; % Controller gain
        tauR = 0.100;  % Ref model time const: 1/(tauR*s+1)^2
        
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
        initTwistRate     = 0;  % Initial twist rate
        
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
        
        % Spatial ILC 
        waypointPathIndices = [0.25 0.75];
        exponentialGainAmplitude = 0.25*pi/180;
        exponentialWidth = 60;
    end
    properties (Dependent = false) % Property value is not stored in object
        
    end
    properties (Dependent = false) % Property value is stored in object
        runModeSwitch                    % Switch used in simulation to determine what data gets passed
        numSettlingLaps                  % Must be at least 1 (I don't reccomend less than 3 though).
        numOptimizationLaps              % Number of optimization iterations
        height                           % Initial course width
        width                            % Initial course height

        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        J                                % Moment inertia about body fixe z axis
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
        localSearchIndexOffsetVector     % Angular distance to look ahead for the path following.
        lookAheadIndexOffset             % Number of indices ahead that the carrot is
        firstOptimizationIterationNum    % Have to calculate this because the if block doesn't accept "+" operator
        spatialILCWeightingMatrix
    end
    
    methods
        
        function val = get.spatialILCWeightingMatrix(obj)
            val = zeros(obj.num);
            weightVector = obj.exponentialGainAmplitude*exp(-(1:obj.num)/obj.exponentialWidth)';
            waypointPathIndicesClean = round(obj.waypointPathIndices*obj.num);
            for ii = 1:length(waypointPathIndicesClean)
                val(1:waypointPathIndicesClean(ii),waypointPathIndicesClean(ii)) = flip(weightVector(1:waypointPathIndicesClean(ii)));
            end
        end
        function val = get.firstOptimizationIterationNum(obj)
            val = obj.numInitializationLaps+obj.numSettlingLaps+1;
        end
        % Functions to set up the model configuration parameters
        function val = get.lookAheadIndexOffset(obj)
            val = round(obj.num*obj.lookAheadPercent);
        end
        function val = get.localSearchIndexOffsetVector(obj)
%             val = -round(obj.num*obj.localSearchPercent):round(obj.num*obj.localSearchPercent);
            val = 0:round(obj.num*obj.localSearchPercent);
        end
        
        function val = get.runModeSwitch(obj)
            switch lower(obj.runMode)
                case 'grid'
                    val = 2;
                otherwise
                    val = 1;
            end
        end
        
        function val = get.numSettlingLaps(obj)
            switch lower(obj.runMode)
                case 'baseline'
                    val = inf;
                case 'optimization'
                    val = 5;
                case 'grid'
                    val = 10;
                otherwise
                    val = 5;
            end
        end
        
        function val = get.numOptimizationLaps(obj)
            switch lower(obj.runMode)
                case 'baseline'
                    val = 0;
                case 'optimization'
                    val = inf;
                case 'grid'
                    val = 0;
                otherwise
                    val = 0;
            end
        end
        
        function val = get.numInitializationLaps(obj)
            val = 5;
        end
        
        % Functions to initialize the waypoints
        function val = get.height(obj)
            switch obj.runMode
                case {'optimization','baseline'}
                    switch lower(obj.ic)
                        case 'both'
                            val = 15;
                        case 'wide'
                            val = 5;
                        case 'short'
                            val = 20;
                        otherwise
                            val = obj.height;
                    end
                case 'spatialILC'
                    val = 10;
            end
        end
        function val = get.width(obj)
            switch obj.runMode
                case {'optimization','baseline'}
                    switch lower(obj.ic)
                        case 'both'
                            val = 90;
                        case 'wide'
                            val = 120;
                        case 'short'
                            val = 30;
                        otherwise
                            val = obj.width;
                    end
                case 'spatialILC'
                    val = 90;
            end
        end
        function val = get.waypointAngles(obj)
            angles = linspace((3/2)*pi,(3/2)*pi+2*pi,obj.num+1);
            val = angles(1:end-1);
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
                    val = 'Archer';
                case 3
                    val = 'NREL';
            end
        end
        function val = get.saveFile(obj)
            val = sprintf('%s_%s_%s_%s.mat',obj.ic,lower(obj.windVariantName),obj.runMode,datestr(now,'ddmm_hhMMss'));
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
    end
end