if p.verbose
    evalTime=toc;
    fprintf('Simulation Complete:\nEfficiency = Total Real Time / Total Sim Time = %s\n'...
        ,num2str(evalTime/tout(end)))
end

if ~exist('logsout','var')
    if p.verbose
        fprintf('\nUnable to locate logsout.  Exiting stopCallback.\n')
    end
    return
else
    clearvars tsc
    if p.verbose
        fprintf('\nBuilding timeseries from simulation data.\n')
    end
    tsc = dataset2TSC(logsout);
    if p.verbose
        fprintf('\nExtracting iteration data from timeseries collection.\n')
    end
    [iter,tscc] = parseIterations(tsc);
    if p.verbose
        if ~tsc.simulationCompleteFlag.data(end)
            fprintf('\nSimulation failed:\n')
            readoutFaults
        end
    end
    if p.plotsOnOff
        plotOptimization
    end
   
    if p.verbose
        fprintf('\nSaving simulation data...')
    end
    if p.saveOnOff
        save(fullfile(pwd,'data',...
            sprintf('%s.mat',datestr(datetime('now'),'hhMMss_ddmmyyyy'))),...
            'tsc','p','tscc','iter')
    end
    if p.verbose
        fprintf('Complete\n')
    end
end

