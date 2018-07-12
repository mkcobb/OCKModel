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
        zenithLow       = 0;
        zenithHigh      = pi/2;
        
        speedEnable    = 0;
        speedLow       = 0;
        speedHigh      = 100;
        
        wingStallEnable    = 1;
        
        rudderStallEnable    = 1;
        
        stabilizerStallEnable = 1;
        
        tetherTensionEnable    = 1;
        tetherTensionLow       = 0;
        tetherTensionHigh      = inf;
        
        stabilizerSaturationEnable    = 1;

    end
    
    
    methods
        
    end
end