classdef plantClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'plant';
    end
    properties
        
        % Lifting Body Physical Parameters
        mass      = 50; % Mass
        momentArm = 10; % Length of moment arm for rudder
        
        % Aerodynamic Parameters
        oswaldEfficiency  = 0.8; % For both wing and rudder
        
        refLengthWing     = 1; % Chord length of airfoil
        wingSpan          = 5; % Wing span
        
        refLengthRudder   = 1.5; % Rudder reference length (chord)
        rudderSpan        = 4; % Rudder span
        
        refLengthStabilizer = 1; % Horizontal stabilizer chord length
        stabilizerSpan      = 2; % Horizontal stabilizer span
        
        % Initial Conditions
        initialTwistRate     = 0;  % Initial twist rate
        initialRadius        = 100;
        initialAzimuth       = 0;
        initialZenith       = 45; % deg
        initialRadiusRate        = 0;
        initialSpeed = 20; % Initial speed m/s in the BFX direction
        
        % Actuator Rate Limiters
        wingAngleRateLimit      = inf;      % degrees/sec
        rudderAngleRateLimit    = inf;      % degrees/sec
        
        % Mass distribution
        fuselageMassRatio = 0.75; % Percent (expressed as ratio) of total system mass located in the fuselage
        forwardLength = 1; % how far forward of the wing the fuselage sticks (so total fuselage length is this plus momentArm)
    end
    
    properties (Dependent = false) % Property value is stored in object
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        refAreaStabilizer                % Horizontal stabilizer reference area
        wingThickness                    
        rudderThickness
        stabilizerThickness
        rotationalInertia                % Moment inertia about body fixe z axis
        azimuthInitializationDirections  % Defines the grid of initialization points
        zenithInitializationDirections   % Defines the grid of initialization points
        initialTwist                        % Initial twist angle, compliment to velocity angle
        initialVelocityGFS                  % Initla velocity in ground fixe spherical coords
        aspectRatio                               % Aspect ratio of the main wing
        wingTable                        % Aerodynamic table for the main wing
        rudderTable                      % Aerodynamic table for the rudder
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
        J                                % Moment inertia about body fixe z axis
        addedMassMultiplier              % This is not exactly added mass, need to multiply by fluid density
        addedInertiaMultiplier
        fuselageLength 
    end
    
    methods
        function val = get.fuselageLength(obj)
           val = obj.momentArm+obj.forwardLength; 
        end
        
        function val = get.J(obj)
            massMomentArm = 0.75*obj.mass*(obj.momentArm/obj.fuselageLength);
            massForwardLength = 0.75*obj.mass*(obj.forwardLength/obj.fuselageLength);
            inertiaMomentArm = (1/3)*massMomentArm*obj.momentArm^2;
            inertiaForwardLength = (1/3)*massForwardLength*obj.forwardLength^2;
            
            % Assume the rest of the mass is evenly divided among the three
            % aerodynamic surfaces (homogeneous airfoil density)
            
            volWing = obj.wingThickness*obj.refAreaWing;
            volRudder = obj.rudderThickness*obj.refAreaRudder;
            volStabilizer = obj.stabilizerThickness*obj.refAreaStabilizer;
            volTotal = volWing+volRudder+volStabilizer;
            
            massWing        = obj.mass*(1-obj.fuselageMassRatio)*volWing/volTotal;
            massRudder      = obj.mass*(1-obj.fuselageMassRatio)*volRudder/volTotal;
            massStabilizer  = obj.mass*(1-obj.fuselageMassRatio)*volStabilizer/volTotal;
            
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
        function val = get.rotationalInertia(obj)
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
        function val = get.initialTwist(obj)
            val = atan2(-controllerClass.height,controllerClass.width/2);
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
        function val = get.aspectRatio(obj)
            val = obj.wingSpan/obj.refLengthWing;
        end
        function val = get.wingTable(obj)
            wingRudder = 'wing';
            files = dir(fullfile(fileparts(which('OCKModel.slx')),'hydrofoilLibrary',wingRudder));
            
            [~,~,data] = xlsread(fullfile(files(end).folder,files(end).name));
            aeroTable.fileName = files(3).name;
            aeroTable.Re = data{4,2};
            jj = 1;
            while ~strcmpi(data{jj,1},'alpha')
                jj=jj+1;
            end
            data = cell2mat(data(jj+1:end,1:3));
            
            aeroTable.alpha = data(:,1)*(pi/180);
            aeroTable.cl    = data(:,2);
            aeroTable.cl0   = aeroTable.cl(data(:,3)==min(data(:,3)));
            aeroTable.cd    = min(data(:,3))+((aeroTable.cl-aeroTable.cl0).^2)./(pi*obj.oswaldEfficiency*obj.aspectRatio);
            
            wingClStartAlpha    = -0.1;
            wingClEndAlpha      = 0.1;
            wingCdStartAlpha    = -0.1;
            wingCdEndAlpha      = 0.1;
            
            idx = 1:length(aeroTable.alpha);
            
            alphaClCrop = aeroTable.alpha(idx(abs(wingClStartAlpha-aeroTable.alpha)==min(abs(wingClStartAlpha-aeroTable.alpha))):...
                idx(abs(wingClEndAlpha-aeroTable.alpha)==min(abs(wingClEndAlpha-aeroTable.alpha))));
            clCrop    = aeroTable.cl(idx(abs(wingClStartAlpha-aeroTable.alpha)==min(abs(wingClStartAlpha-aeroTable.alpha))):...
                idx(abs(wingClEndAlpha-aeroTable.alpha)==min(abs(wingClEndAlpha-aeroTable.alpha))));
            alphaCdCrop = aeroTable.alpha(idx(abs(wingCdStartAlpha-aeroTable.alpha)==min(abs(wingCdStartAlpha-aeroTable.alpha))):...
                idx(abs(wingCdEndAlpha-aeroTable.alpha)==min(abs(wingCdEndAlpha-aeroTable.alpha))));
            cdCrop    = aeroTable.cd(idx(abs(wingCdStartAlpha-aeroTable.alpha)==min(abs(wingCdStartAlpha-aeroTable.alpha))):...
                idx(abs(wingCdEndAlpha-aeroTable.alpha)==min(abs(wingCdEndAlpha-aeroTable.alpha))));
            
            
            pl=polyfit(alphaClCrop,clCrop,1);
            aeroTable.kl1=pl(1);
            aeroTable.kl0=pl(2);
            
            pd = polyfit(alphaCdCrop,cdCrop,2);
            aeroTable.kd2=pd(1);
            aeroTable.kd1=pd(2);
            aeroTable.kd0=pd(3);
            
            aeroTable.clStartAlpha  = wingClStartAlpha;
            aeroTable.clEndAlpha    = wingClEndAlpha;
            aeroTable.cdStartAlpha  = wingCdStartAlpha;
            aeroTable.cdEndAlpha    = wingCdEndAlpha;
            
            val = aeroTable;
        end
        
        function val = get.rudderTable(obj)
            wingRudder = 'rudder';
            files = dir(fullfile(fileparts(which('OCKModel.slx')),'hydrofoilLibrary',wingRudder));
            
            [~,~,data]=xlsread(fullfile(files(end).folder,files(end).name));
            aeroTable.fileName = files(3).name;
            aeroTable.Re = data{4,2};
            jj=1;
            while ~strcmpi(data{jj,1},'alpha')
                jj=jj+1;
            end
            data = cell2mat(data(jj+1:end,1:3));
            
            
            aeroTable.alpha = data(:,1)*(pi/180);
            aeroTable.cl    = data(:,2);
            aeroTable.cl0   = aeroTable.cl(data(:,3)==min(data(:,3)));
            aeroTable.cd    = min(data(:,3))+((aeroTable.cl-aeroTable.cl0).^2)./(pi*obj.oswaldEfficiency*obj.aspectRatio);
            
            wingClStartAlpha    = -0.1;
            wingClEndAlpha      = 0.1;
            wingCdStartAlpha    = -0.15;
            wingCdEndAlpha      = 0.15;
            
            idx = 1:length(aeroTable.alpha);
            
            alphaClCrop = aeroTable.alpha(idx(abs(wingClStartAlpha-aeroTable.alpha)==min(abs(wingClStartAlpha-aeroTable.alpha))):...
                idx(abs(wingClEndAlpha-aeroTable.alpha)==min(abs(wingClEndAlpha-aeroTable.alpha))));
            clCrop    = aeroTable.cl(idx(abs(wingClStartAlpha-aeroTable.alpha)==min(abs(wingClStartAlpha-aeroTable.alpha))):...
                idx(abs(wingClEndAlpha-aeroTable.alpha)==min(abs(wingClEndAlpha-aeroTable.alpha))));
            alphaCdCrop = aeroTable.alpha(idx(abs(wingCdStartAlpha-aeroTable.alpha)==min(abs(wingCdStartAlpha-aeroTable.alpha))):...
                idx(abs(wingCdEndAlpha-aeroTable.alpha)==min(abs(wingCdEndAlpha-aeroTable.alpha))));
            cdCrop    = aeroTable.cd(idx(abs(wingCdStartAlpha-aeroTable.alpha)==min(abs(wingCdStartAlpha-aeroTable.alpha))):...
                idx(abs(wingCdEndAlpha-aeroTable.alpha)==min(abs(wingCdEndAlpha-aeroTable.alpha))));
            
            
            pl=polyfit(alphaClCrop,clCrop,1);
            aeroTable.kl1=pl(1);
            aeroTable.kl0=pl(2);
            
            pd = polyfit(alphaCdCrop,cdCrop,2);
            aeroTable.kd2=pd(1);
            aeroTable.kd1=pd(2);
            aeroTable.kd0=pd(3);
            
            aeroTable.clStartAlpha  = wingClStartAlpha;
            aeroTable.clEndAlpha    = wingClEndAlpha;
            aeroTable.cdStartAlpha  = wingCdStartAlpha;
            aeroTable.cdEndAlpha    = wingCdEndAlpha;
            
            
            val = aeroTable;
        end
        
        function val = get.wingThickness(obj)
            val = regexp(obj.wingTable.fileName,'(naca\d{4}|n\d{4})','Match');
            val = val{1};
            val = obj.refLengthWing*str2double(val(end-1:end))/100;
        end
        
        function val = get.rudderThickness(obj)
            val = regexp(obj.rudderTable.fileName,'(naca\d{4}|n\d{4})','Match');
            val = val{1};
            val = obj.refLengthRudder*str2double(val(end-1:end))/100;
        end
        function val = get.stabilizerThickness(obj)
            val = regexp(obj.rudderTable.fileName,'(naca\d{4}|n\d{4})','Match');
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
        
    end
end

