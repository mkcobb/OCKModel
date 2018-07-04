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
        viscosity       = 0.001; % approximate kinematic viscosity of seawater
        g               = 9.80665;   % Acceleration due to gravity

    end
    properties (Dependent = false) % Property value is not stored in object
        
    end
    methods
        
    end
end