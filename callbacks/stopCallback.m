%%
if p.verbose
    evalTime=toc;
    fprintf('Simulation Complete:\n')
    fprintf('Total Real Time = %3f\n',evalTime);
    if exist('tout','var')
        fprintf('Total Sim  Time = %3f\n',tout(end));
        fprintf('Efficiency = Total Real Time / Total Sim Time = %s\n'...
            ,num2str(evalTime/tout(end)))
    end
end
%%
if ~exist('logsout','var')
    if exist('out.mat','file')==2
        if p.verbose
            fprintf('\nUnable to locate logsout in workspace.  Loading out.mat from file.\n')
        end
%         pause(300)
        load(fullfile(pwd,'out.mat'))
        if ~exist('logsout','var') && exist('tmp_raccel_logsout','var')
            if p.verbose
                fprintf('\nFile out.mat does not contain logsout variable, creating logsout from tmp_raccel_logsout variable.\n')
            end
           logsout = tmp_raccel_logsout; 
           clearvars tmp_raccel_logsout
        end
    else
        if p.verbose
            fprintf('\nUnable to locate logsout.  Exiting stopCallback.\n')
        end
        return
    end
end
clearvars tsc
if p.verbose
    fprintf('\nBuilding timeseries from simulation data.\n')
end
tsc = dataset2TSC(logsout);
if p.verbose
    fprintf('\nExtracting iteration data from timeseries collection.\n')
end
iter = parseIterations(tsc,p);
if p.verbose
    if ~tsc.simulationCompleteFlag.data(end)
        fprintf('\nSimulation failed:\n')
        readoutFaults
    else
        fprintf('\nSimulation successful:\n')
    end
end
if p.plotsOnOff
    plotOptimization
end

if p.saveOnOff
    if ~tsc.simulationCompleteFlag.data(end)
        sf='failed';
    else
        sf='succeeded';
    end
    if p.windVariant ==3
        if p.verbose
            fprintf('\nSaving simulation data: %s\n',p.saveFile)
        end
        
        save([p.savePath p.saveFile],...
            'p','iter','windData','-v7.3')
    elseif p.windVariant == 1
        fileName = fullfile(pwd,'data',sprintf('constantWind_%sIC.mat',p.ic));
        if p.verbose
            fprintf('\nSaving simulation data: %s\n',p.saveFile)
        end
        save([p.savePath p.saveFile],...
            'p','iter','windData','-v7.3')
    end
end
if p.verbose
    fprintf('Complete\n')
    if p.soundOnOff == 1
        load train
        sound(y,Fs)
    end
end


