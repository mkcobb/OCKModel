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
if ~exist('logsout','var') % if logsout is missing in the workspace
    if exist('tmp_raccel_logsout','var')
        logsout = tmp_raccel_logsout;
    else
        if exist('out.mat','file')==2
            if p.verbose
                fprintf('\nUnable to locate logsout in workspace.  Loading out.mat from file.\n')
            end
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
end
clearvars tsc
if p.verbose
    fprintf('\nParsing simulation output.\n')
end

[tsc,iter] = parseOutput(logsout);

if p.verbose
    readoutFaults(p,tsc,iter)
end

% Save data
if p.saveOnOff
    fileName = p.saveFile;
    if p.verbose
        fprintf('\nSaving simulation data: %s\n',fileName)
    end
    save([p.savePath fileName],'p','iter','windData','tout','tsc','-v7.3')
end

if p.verbose
    fprintf('Complete\n')
    if p.soundOnOff == 1
        load train
        sound(y,Fs)
    end
end



