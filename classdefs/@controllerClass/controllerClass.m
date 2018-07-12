classdef controllerClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'ctrl';
    end
    properties
        % Waypoints Settings
        ic                  = 'both';       % which set of initial conditions to use, if 'userspecified' then must set width and height manually in calling script
        num                 = 10^3;         % number of angles used to parameterize the path
        meanElevation       = 30;           % mean course elevation
        lookAheadPercent    = 0.025;        % percentage of total path length that the carrot is ahead
        localSearchPercent  = 0.025         % percentage of the course to search for the closest point on the path, centered on previous closest point.
        
        % Rudder Controller
        kr1  = 100; % Controller gain
        kr2  = 100; % Controller gain
        tauR = 0.0500;  % Ref model time const: 1/(tauR*s+1)^2
        
        numSettlingLaps = 3;                 % Number of laps before starting tether reel out
        numSimulationLaps = 20;               % Number of laps to run during reel out
        tetherReelOutFilterTimeConstant = 0.01; % Time constant used to filter reel out command 
        
        % Upper and lower distance limits for reel in/out
        reelLowerLim = 40;
        reelUpperLim = 100;
        reelInWingAlpha   = -0.035*180/pi; % Target angle of attack for wing on reel-in [deg]
        reelInRudderAlpha = 0 % Target angle of attack for rudder on reel-in [deg]
        reelInSpeed = 5;
        
    end
    
    properties (Dependent = false) % Property value is stored in object
        height                           % Initial course width
        width                            % Initial course height
        waypointAngles                   % Parametric angles which define waypoints
        localSearchIndexOffsetVector     % Angular distance to look ahead for the path following.
        lookAheadIndexOffset             % Number of indices ahead that the carrot is
        firstOptimizationIterationNum    % Have to calculate this because the if block doesn't accept "+" operator
    end
    
    methods
        function val = get.firstOptimizationIterationNum(obj)
            val = obj.numInitializationLaps+obj.numSettlingLaps+1;
        end
        function val = get.lookAheadIndexOffset(obj)
            val = round(obj.num*obj.lookAheadPercent);
        end
        function val = get.localSearchIndexOffsetVector(obj)
            val = 0:round(obj.num*obj.localSearchPercent);
        end
        function val = get.height(obj)
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
        end
        function val = get.width(obj)
            switch lower(obj.ic)
                case 'both'
                    val = 60;
                case 'wide'
                    val = 120;
                case 'short'
                    val = 30;
                otherwise
                    val = obj.width;
            end
        end
        function val = get.waypointAngles(obj)
            angles = linspace((3/2)*pi,(3/2)*pi+2*pi,obj.num+1);
            val = angles(1:end-1);
        end
    end
end