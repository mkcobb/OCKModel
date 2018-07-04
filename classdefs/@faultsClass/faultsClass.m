classdef faultsClass < handle
     properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'faults';
    end
    properties
        % Plant faults
        radiusEnable    = 1;
        radiusLow       = 1;
        radiusHigh      = 1000;
        
        azimuthEnable   = 1;
        azimuthLow      = -pi/2;
        azimuthHigh     = pi/2;
        
        zenithEnable    = 1;
        zenithLow       = -pi/2;
        zenithHigh      = pi/2;
        
        speedEnable    = 0;
        speedLow       = 0;
        speedHigh      = 100;
        
        wingStallEnable    = 0;
        wingStallLow       = -20;
        wingStallHigh      = 20;
        
        rudderStallEnable    = 0;
        rudderStallLow       = -20;
        rudderStallHigh      = 20;
        
        forceZEnable    = 1;
        forceZLow       = 0;
        forceZHigh      = inf;
        
        stabilizerSaturationEnable    = 1;

    end
    
    
    methods
        
    end
end