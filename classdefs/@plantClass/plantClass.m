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
        
        % Initial Conditions
        initialVelocity      = 28; % Initial straight line speed (BFX direction)
        initialTwistRate     = 0;  % Initial twist rate
        initialRadius        = 100;
        initialAzimuth       = 0;
        initialZenith       = 45; % deg
        initialRadiusRate        = 100;
        initialSpeed = 7; % Initial speed m/s in the BFX direction
        
        
        % Actuator Rate Limiters
        wingAngleRateLimit      = inf;      % degrees/sec
        rudderAngleRateLimit    = inf;      % degrees/sec
        
        
        
    end
    
    properties (Dependent = false) % Property value is stored in object
        refAreaWing                      % Wing reference area
        refAreaRudder                    % Rudder reference area
        rotationalInertia                % Moment inertia about body fixe z axis
        azimuthInitializationDirections  % Defines the grid of initialization points
        zenithInitializationDirections   % Defines the grid of initialization points
        initialTwist                        % Initial twist angle, compliment to velocity angle
        initialVelocityGFS                  % Initla velocity in ground fixe spherical coords
        aspectRatio                               % Aspect ratio of the main wing
        wingTable                        % Aerodynamic table for the main wing
        rudderTable                      % Aerodynamic table for the rudder
        initPositionGFS                  % Initial position in ground fixed spherical coordinates
    end
    
    methods
        function val = get.refAreaWing(obj)
            val = obj.refLengthWing*obj.wingSpan; % Reference area of wing
        end
        function val = get.refAreaRudder(obj)
            val = obj.refLengthRudder*obj.rudderSpan; % Reference area of wing
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
            val = aeroTable;
        end
        
        
        
        
    end
end

