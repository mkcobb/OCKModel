classdef simulationClass < handle
    properties (Constant)
        % What to name the object in the workspace
        defaultInstanceName = 'sim';
    end
    properties
        
        % Simulation Time
        T  = inf; % Total Simulation Time
        Ts = 0.002;  % Sample time
        
        % Output Settings (0 to turn off , 1 to turn on)
        verbose         = 1; % Text output to command window
        plotsOnOff      = 1; % Generate plots
        animationOnOff  = 0; % Generate animations
        saveOnOff       = 1; % Save data to the hard drive
        soundOnOff      = 0; % Turn on/off gong noise at end of simulation
        %         decimation      = 10; % Log data every N points
        
        modelName   = 'OCKModel'; % Name of the model to run
        
    end
    properties (Dependent = false) % Property value is not stored in object
        
    end
    properties (Dependent = false) % Property value is stored in object
        runModeSwitch                    % Switch used in simulation to determine what data gets passed
        modelPath                        % Path to the model
        saveFile                         % File name of the resulting data file
        savePath                         % Path to the resulting data file
    end
    
    methods
        function val = get.runModeSwitch(obj)
            switch lower(obj.runMode)
                case 'grid'
                    val = 2;
                otherwise
                    val = 1;
            end
        end
        function val = get.savePath(obj)
            val = fullfile(fileparts(obj.modelPath),'output','data',filesep);
        end
        function val = get.saveFile(obj)
            val = sprintf('%s.mat',datestr(now,'ddmm_hhMMss'));
        end
        function val = get.modelPath(obj)
            val = which([obj.modelName '.slx']);
        end
    end
end