if evalin('base','p.verbose')
    evalTime=toc;
    simTime = tout(end);
    fprintf('Efficiency = %s\n',num2str(evalTime/simTime))
end

if ~exist('logsout','var')
    if evalin('base','p.verbose')
        fprintf('\nUnable to locate logsout.  Exiting stopCallback.\n')
    end
    return
else
    clearvars tsc
    if ~p.quietMode
        fprintf('\nBuilding timeseries from simulation data.\n')
    end
    tsc = dataset2TSC(logsout);
    if ~p.quietMode
        fprintf('\nExtracting iteration data from timeseries collection.\n')
    end
    [iter,tscc] = parseIterations(tsc);
    if ~p.quietMode
        if tsc.simulationCompleteFlag.data(end)
            fprintf('\nSimulation failed:\n')
            readoutFaults
        end
        if tsc.simulationCompleteFlag.data(end)
            plotOptimization
        end
    end
    
    if ~p.quietMode
        fprintf('\nSaving simulation data...')
    end
    
%     save(fullfile(pwd,'data',sprintf('%s.mat',datestr(datetime('now'),'hhMMss_ddmmyyyy'))),'tsc','p','tscc','iter')
    if ~p.quietMode
        fprintf('Complete\n')
    end
end

