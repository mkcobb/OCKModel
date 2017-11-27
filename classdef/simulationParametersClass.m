classdef simulationParametersClass < handle
    properties (SetObservable)
        % Text output parameters
        verbose = 1;
        
        % Plotting Parameters
        plotsOnOff = 0;
        
        % Simulink animation parameters
        animationOnOff = 0;
        
        % Save simulation results
        saveOnOff = 0;
        
        % Turbulence
        turbulenceOnOff = 1;
        noiseSeeds = [23341 23342 23343 23344];
        
        % RLS Settings
        forgettingFactor = 0.9;
        azimuthPerturbationPeriod  = 3;
        azimuthPerturbationGain    = 1;
        zenithPerturbationPeriod   = 5;
        zenithPerturbationGain     = 0.1;
        
        % Rudder Controller
        kr1  = 100;
        kr2  = 100;
        tauR = 0.02;  % Ref model time const: 1/(tauR*s+1)^2
        
        % Waypoints
        ic = 'narrow'; % which set of initial conditions to use, narrow or wide
        num    = 40;
        elev   = 45;
        waypointAzimuthTol = 0.5*(pi/180);
        wrapTolerance    = pi;
        trackingErrorWeight = 10;
        
        % Initialization Grid Settings
        azimuthOffset = 2; % degrees
        zenithOffset = 0.5; % degrees
        
        % Optimization Settings
        convergenceLim = 30;
        numSettlingLaps = 5; % Must be at least 1 (I don't reccomend less than 3 though).
        numOptimizationLaps = 100;
        numInitializationLaps = 5; % 5 or 9 point initialization
        
        % Simulation Time
        T = inf;
        Ts = 0.001; % Sample time
        
        % Lifting Body
        mass      = 50; % Mass
        momentArm = 10; % Length of moment arm for rudder
        
        % Aerodynamic Parameters
        oswaldEfficiency  = 0.8;
        refLengthWing     = 1; % Chord length of airfoil
        wingSpan          = 5;
        refLengthRudder   = 1.5;
        rudderSpan        = 4;
        
        % Environmental
        rho       = 1.225; % density of air kg/m^3
        viscosity = 1.4207E-5; % Kinematic viscosity of air
        g         = 9.80665; % Acceleration due to gravity
        gravityOnOff = 1; % 0 turns gravity off
        
        % Wind Conditions
        vWind = 3;
        windDirection = 0;
        windAltitude = 146;
        
        % Initial Conditions
        initVelocity      = 15; % Initial straight line speed (BFX direction)
        initOmega         = 0; % Initial twist rate
        
        % Actuator Rate Limiters
        wingAngleRateLimit = inf; % degrees/sec
        rudderAngleRateLimit = inf; % degrees/sec
        
        % Airfoil lift/drag coefficient fitting limits
        wingClStartAlpha = -0.1;
        wingClEndAlpha   = 0.1;
        wingCdStartAlpha = -0.1;
        wingCdEndAlpha   = 0.1;
        rudderClStartAlpha = -0.1;
        rudderClEndAlpha   = 0.1;
        rudderCdStartAlpha = -0.1;
        rudderCdEndAlpha   = 0.1;
    end
    
    properties (Dependent)
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        J                                % Moment inertia about body fixe z axis
        height                           % Initial course width
        width                            % Initial course height
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
    end
    
    methods
        function val = get.refAreaWing(obj)
            val = obj.refLengthWing*obj.wingSpan; % Reference area of wing
        end
        function val = get.refAreaRudder(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of wing
        end
        function val = get.J(obj)
            val = (obj.mass*obj.wingSpan^2)/12; % Rotational inertia about body fixed z axis (approx with (ml^2)/12))
        end
        % somethinf in the next two is incorrect
        function val = get.height(obj)
            switch obj.ic
                case 'narrow'
                    val = 5;
                case 'wide'
                    val = 7;
                case 'above'
                    val = 8;
            end
        end
        function val = get.width(obj)
            switch obj.ic
                case 'narrow'
                    val = 20;
                case 'wide'
                    val = 80;
                case 'above'
                    val = 30;
            end
        end
        function val = get.waypointZenithTol(obj)
            val = obj.waypointAzimuthTol;
        end
        function val = get.waypointAngles(obj)
            val = linspace((3/2)*pi,(3/2)*pi+2*pi,obj.num+1);
            val = val(2:end);
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
            val = which('CDCJournalModel.slx');
        end
        function val = get.wingTable(obj)
            val =  buildAirfoilTable(obj,'wing');
        end
        function val = get.rudderTable(obj)
            
            val = buildAirfoilTable(obj,'rudder');
        end
        function val = get.useablePower(obj)
        %     % Useable power for this design
        %     % https://en.wikipedia.org/wiki/Crosswind_kite_power
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