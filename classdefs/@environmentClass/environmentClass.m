classdef environmentClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'env';
        rho             = 1025;     % density of seawater
    end
    
    properties
        
        
        % Environmental Conditions Switches
        gravityOnOff    = 0; % 0 turns gravity off
        
        vFlow           = 1.5; % Mean wind speed (used when windVariant = 1)
        windDirection   = 0; % Wind heading in degrees
        %         turbulenceOnOff = 0; % 0 for off, 1 for on (0 sets wind speed to Dr. Archers data, linearly interpolated)
        %         windAltitude    = 146; % Must be one of the available altitudes from Dr. Archer's data
        %         noiseSeeds      = [23341 23342 23343 23344];  % Noise seeds used in white noise generators for von Karman turbulence
        
        viscosity       = 0.001; % approximate kinematic viscosity of seawater
        g               = 9.80665;   % Acceleration due to gravity
        
    end
    properties (Dependent = false) % Property value is not stored in object
        
    end
    
    
    methods
        
    end
end