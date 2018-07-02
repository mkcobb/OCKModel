classdef controllerClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'ctrl';
    end
    properties
        
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
        waypointAngles                   % Parametric angles which define waypoints
        azimuthInitializationDirections  % Defines the grid of initialization points
        zenithInitializationDirections   % Defines the grid of initialization points
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
        
    end
end