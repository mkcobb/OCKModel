%%
if sim.verbose
    evalTime = toc;
    fprintf('Simulation Complete:\n')
    fprintf('Total Real Time = %3f\n',evalTime);
    if exist('tout','var')
        fprintf('Total Sim  Time = %3f\n',tout(end));
        fprintf('Efficiency = Total Real Time / Total Sim Time = %s\n'...
            ,num2str(evalTime/tout(end)))
    end
end
%%
if ~exist('logsout','var') % if logsout is missing in the workspace
    if exist('tmp_raccel_logsout','var')
        logsout = tmp_raccel_logsout;
    else
        if exist('out.mat','file')==2
            if sim.verbose
                fprintf('\nUnable to locate logsout in workspace.  Loading out.mat from file.\n')
            end
            load(fullfile(pwd,'out.mat'))
            if ~exist('logsout','var') && exist('tmp_raccel_logsout','var')
                if sim.verbose
                    fprintf('\nFile out.mat does not contain logsout variable, creating logsout from tmp_raccel_logsout variable.\n')
                end
                logsout = tmp_raccel_logsout;
                clearvars tmp_raccel_logsout
            end
        else
            if sim.verbose
                fprintf('\nUnable to locate logsout.  Exiting stopCallback.\n')
            end
            return
        end
    end
end
clearvars tsc
if sim.verbose
    fprintf('\nParsing simulation output.\n')
end

tsc = compileTSC(logsout);
iter = compileIter(tsc);

if sim.verbose
    readoutFaults(tsc)
end

% Save data
if sim.saveOnOff
    fileName = sim.saveFile;
    if sim.verbose
        fprintf('\nSaving simulation data: %s\n',fileName)
    end
    save([sim.savePath fileName],'tsc','sim','plant','env','faults','ctrl','-v7.3')
end

if sim.verbose
    fprintf('Complete\n')
    if sim.soundOnOff == 1
        load train
        sound(y,Fs)
    end
end



