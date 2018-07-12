classdef plantClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'plant';
    end
    properties
        
        % Fuselage parameters
        fuselageMassRatio   = 0.75; % Percent of total system mass located in the fuselage
        forwardLength       = 1;    % How much of the fuselage sticks out in front
        fuselageRadius      = 0.25; % Fuselage is approximated as a cylinder
        momentArm           = 8;    % Length of moment arm for rudder
        
        % Wing parameters
        wingOswaldEfficiency    = 0.8;
        refLengthWing           = 2;    % Chord length of airfoil
        wingSpan                = 10;   % Wing span
        
        % Rudder parameters
        rudderOswaldEfficiency  = 0.8;
        refLengthRudder         = 0.75; % Rudder reference length (chord)
        rudderSpan              = 2.5;  % Rudder span
        
        % Horizontal stabilizer parameters
        stabilizerOswaldEfficiency  = 0.8;
        refLengthStabilizer         = 0.6; % Horizontal stabilizer chord length
        stabilizerSpan              = 2.5; % Horizontal stabilizer span
        
        % Initial Conditions
        initialTwistRate     = 0;  % Initial twist rate [deg/s]
        initialRadius        = 40;
        initialAzimuth       = 0;  % [deg]
        initialZenith        = 60; % [deg]
        initialRadiusRate    = 0;  % Initial rate of tether payout
        initialSpeed         = 9;  % Initial speed m/s in the BFX direction
        
        % Actuator Rate Limiters
        wingAngleRateLimit      = inf;      % degrees/sec
        rudderAngleRateLimit    = inf;      % degrees/sec
        
        % Wing table file name
        wingFileName = 'NACA 2415_T1_Re5.085_M0.00_N9.0.txt';
        wingShapeFileName = 'naca2415.dat';
        wingClFitLimits = [-0.05 0.2];
        wingCdFitLimits = [-0.05 0.2];
        
        % Wing table file name
        rudderFileName = 'NACA-0009 9.0% smoothed_T1_Re1.000_M0.00_N9.0.txt';
        rudderShapeFileName = 'n0009sm.dat';
        rudderClFitLimits = 0.15*[-1 1];
        rudderCdFitLimits = 0.15*[-1 1];
        

    end
    properties (Dependent = false) % Property value is stored in object
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        refAreaStabilizer                % Horizontal stabilizer reference area
        wingThickness                    % Thickness of wing (used in added mass estimation)
        rudderThickness                  % Thickness of rudder (user in added mass estimation)
        stabilizerThickness              % Thickness of stabilizer (user in added mass estimation)
        %         rotationalInertia                % Moment inertia about body fixe z axis
        %         azimuthInitializationDirections  % Defines the grid of initialization points
        %         zenithInitializationDirections   % Defines the grid of initialization points
        initialVelocityGFS               % Initla velocity in ground fixe spherical coords
        wingAspectRatio                  % Aspect ratio of the main wing
        rudderAspectRatio                % Aspect ratio of the rudder
        stabilizerAspectRatio            % Aspect ratio of the stabilizer
        wingTable                        % Aerodynamic table for the main wing
        rudderTable                      % Aerodynamic table for the rudder
        stabilizerTable                  % Aerodynamic table for the stabilizer
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
        J                                % Moment inertia about body fixe z axis
        addedMassMultiplier              % This is not exactly added mass, need to multiply by fluid density
        addedInertiaMultiplier           % Multiply this by fluid density to get added inertia about body fixed z axis
        fuselageLength                   % Total length of fuselage
        wingCrossSectionArea             % Cross sectional area of the wing
        rudderCrossSectionArea
        stabilizerCrossSectionArea
        wingVolume
        rudderVolume
        stabilizerVolume
        totalVolume                      % Total volume of the whole system
        aeroSurfacesVolume               % Volume of all aerodynamic surfaces
        mass                             % Total mass of system (calculated to give neutral buoyancy)
        stabilizerFileName
        stabilizerShapeFileName
        
        
    end
    
    methods
        function val = get.stabilizerFileName(obj)
            val = obj.rudderFileName;
        end
        function val = get.stabilizerShapeFileName(obj)
            val = obj.rudderShapeFileName;
        end
        function val = get.mass(obj) % estimate the mass necessary to be neutrally buoyant
            val = environmentClass.rho*obj.totalVolume;
        end
        function val = get.stabilizerCrossSectionArea(obj)
            val = obj.rudderCrossSectionArea;
        end
        function val = get.fuselageLength(obj)
            val = obj.momentArm+obj.forwardLength;
        end
        function val = get.wingVolume(obj)
            val = obj.wingCrossSectionArea*obj.wingSpan;
        end
        function val = get.rudderVolume(obj)
            val = obj.rudderCrossSectionArea*obj.rudderSpan;
        end
        function val = get.stabilizerVolume(obj)
            val = obj.stabilizerCrossSectionArea*obj.stabilizerSpan;
        end
        
        function val = get.aeroSurfacesVolume(obj)
            val = obj.wingVolume+obj.rudderVolume+obj.stabilizerVolume;
        end
        function val = get.totalVolume(obj)
            val = obj.aeroSurfacesVolume+pi*obj.fuselageRadius^2*obj.fuselageLength;
        end
        function val = get.J(obj)
            massMomentArm = 0.75*obj.mass*(obj.momentArm/obj.fuselageLength);
            massForwardLength = 0.75*obj.mass*(obj.forwardLength/obj.fuselageLength);
            inertiaMomentArm = (1/3)*massMomentArm*obj.momentArm^2;
            inertiaForwardLength = (1/3)*massForwardLength*obj.forwardLength^2;
            
            
            volTotal = obj.aeroSurfacesVolume;
            
            massWing        = obj.mass*(1-obj.fuselageMassRatio)*obj.wingVolume/volTotal;
            massRudder      = obj.mass*(1-obj.fuselageMassRatio)*obj.rudderVolume/volTotal;
            massStabilizer  = obj.mass*(1-obj.fuselageMassRatio)*obj.stabilizerVolume/volTotal;
            
            inertiaWing = (1/12)*massWing*obj.wingSpan^2;
            inertiaRudder = massRudder*(obj.momentArm+obj.refLengthRudder/2)^2;
            inertiaStabilizer = massStabilizer*(obj.momentArm+obj.refLengthStabilizer/2)^2;
            
            val = inertiaMomentArm+inertiaForwardLength+inertiaWing+inertiaRudder+inertiaStabilizer;
        end
        function val = get.refAreaWing(obj)
            val = obj.refLengthWing*obj.wingSpan; % Reference area of wing
        end
        function val = get.refAreaRudder(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of wing
        end
        function val = get.refAreaStabilizer(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of horizontal stabilizer
        end
        function val = get.initPositionGFS(obj)
            val = [100 0  (obj.elev*pi/180)]; % Initial position in spherical coordinates
        end
        function val = get.initialVelocityGFS(obj)
            % Initial velocity in GFS
            val(1) = 0 ;
            val(2) = (obj.initVelocity*cos( obj.initTwist))/...
                (obj.initPositionGFS(1)*sin(obj.initPositionGFS(3)));
            val(3) = (obj.initVelocity*sin(-obj.initTwist))/(obj.initPositionGFS(1));
        end
        function val = get.wingAspectRatio(obj)
            val = obj.wingSpan/obj.refLengthWing;
        end
        function val = get.rudderAspectRatio(obj)
            val = obj.rudderSpan/obj.refLengthRudder;
        end
        function val = get.stabilizerAspectRatio(obj)
            val = obj.stabilizerSpan/obj.refLengthStabilizer;
        end
        
        
        function val = get.rudderTable(obj)
            val = loadAeroTable(obj.rudderFileName,obj.rudderClFitLimits,...
                obj.rudderCdFitLimits,obj.rudderOswaldEfficiency,obj.rudderAspectRatio);
        end
        
        function val = get.stabilizerTable(obj)
            val = loadAeroTable(obj.rudderFileName,obj.rudderClFitLimits,...
                obj.rudderCdFitLimits,obj.stabilizerOswaldEfficiency,obj.stabilizerAspectRatio);
        end
        
        function val = get.wingThickness(obj)
            val = regexpi(obj.wingTable.fileName,'(naca\s?\d{4}|n\d{4})','Match');
            val = val{1};
            val = obj.refLengthWing*str2double(val(end-1:end))/100;
        end
        
        function val = get.rudderThickness(obj)
            val = regexpi(obj.rudderTable.fileName,'(naca\s?\d{4}|n\d{4}|naca-\d{4})','Match');
            val = val{1};
            val = obj.refLengthRudder*str2double(val(end-1:end))/100;
        end
        function val = get.stabilizerThickness(obj)
            val = regexpi(obj.rudderTable.fileName,'(naca\s?\d{4}|n\d{4}|naca-\d{4})','Match');
            val = val{1};
            val = obj.refLengthStabilizer*str2double(val(end-1:end))/100;
        end
        function val = get.addedMassMultiplier (obj)
            val =  pi*(...
                obj.wingSpan*(obj.wingThickness/2)^2+... % Term for wing
                obj.rudderSpan*(obj.rudderThickness/2)^2+... % Term for rudder
                obj.stabilizerSpan*(obj.stabilizerThickness/2)^2);   % Term for horizontal stablizer
        end
        function val = get.addedInertiaMultiplier(obj)
            val = pi*obj.rudderSpan*obj.momentArm^2*(obj.refLengthRudder/2)^2;
        end
        function val = get.wingCrossSectionArea(obj)
            [x,y] = loadShapeFile(obj.wingShapeFileName);
            x = obj.refLengthWing*x;
            y = obj.refLengthWing*y;
            val = polyarea(x,y);
        end
        
        function val = get.rudderCrossSectionArea(obj)
            [x,y] = loadShapeFile(obj.rudderShapeFileName);
            x = obj.refLengthRudder*x;
            y = obj.refLengthRudder*y;
            val = polyarea(x,y);
        end
        function val = get.wingTable(obj)
            val = loadAeroTable(obj.wingFileName,obj.wingClFitLimits,...
                obj.wingCdFitLimits,obj.wingOswaldEfficiency,obj.wingAspectRatio);
        end
    end
    
end

