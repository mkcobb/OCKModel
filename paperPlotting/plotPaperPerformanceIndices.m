function h = plotPaperPerformanceIndices(windType)
switch lower(windType)
    case 'constant'
        %% Create plots of the performance index under variable wind
        files = dir(fullfile(pwd,'paperData','constantWind'));
        files = files(3:end);
        files = {files.name};
        files = split(files,'.');
        files = files(:,:,1);

        colors = {'k',0.33*[1 1 1],0.66*[1 1 1]};
        
        thingsToPlot = {'performanceIndex','meanPAR'};
        
        h={};
        
        for jj = 1:length(thingsToPlot)
            %% Set things up initially
            h{end+1}.fileName   = sprintf('constantWind_%s',thingsToPlot{jj});
            h{end}.figure       = createFigure();
            % Create the top axes
            h{end}.axTop        = subplot(2,1,1,'FontSize',40);
            %         h{end}.axTop.Position = h{end}.axTop.Position+[0 0 0.05 0];
            grid on;   hold on; axis tight
            xlabel('Iteration Number, $j$')
            
            switch thingsToPlot{jj}
                case 'performanceIndex'
                    title('Performance Index Vs Iteration Number and Time')
                case 'meanPAR'
                    title('PAR Vs Iteration Number and Time')
            end
            
            switch thingsToPlot{jj}
                case 'performanceIndex'
                    ylabel({'Performance','Index'})
                case 'meanPAR'
                    ylabel('PAR')
            end
            
            % Create the bottom axes
            h{end}.axBottom   = subplot(2,1,2,'FontSize',40);
            grid on;   hold on; axis tight
            xlabel('Time, $t$ [min]')
            
            switch thingsToPlot{jj}
                case 'performanceIndex'
                    ylabel({'Performance','Index'})
                case 'meanPAR'
                    ylabel('PAR')
            end
            
            %% Rename the figure so that we can keep them all straight
            h{end}.figure.Name = sprintf('constant_%s',thingsToPlot{jj});
            
            h{end}.top.plot    = {};
            h{end}.bottom.plot = {};
            
            for kk = 1:length(files)
                %% Load the correct file
                load(fullfile(pwd,'paperData','constantWind',sprintf('%s.mat',files{kk})),'iter')
                %% Actually do the plotting
                h{end}.top.plot{end+1}       = plot(iter.(thingsToPlot{jj}),'Parent',h{end}.axTop,'DisplayName',files{kk});
                h{end}.bottom.plot{end+1}    = plot(iter.startTimes/60,iter.(thingsToPlot{jj}),'Parent',h{end}.axBottom,'DisplayName',files{kk});
                
                %% Format all the plots
                h{end}.top.plot{end}.Color = colors{kk};
                h{end}.top.plot{end}.LineWidth = 2;
                h{end}.axTop.XLim = [0 200];
                
                
                h{end}.bottom.plot{end}.Color = colors{kk};
                h{end}.bottom.plot{end}.LineWidth = 2;
                h{end}.axBottom.XLim = [0 35];
            end
            h{end}.legend = legend(h{end}.axTop,'Location','southeast','Orientation','horizontal');
            legendPosition = h{end}.legend.Position ;
            h{end}.legend.Position = [legendPosition(1), 0.5, legendPosition(3), legendPosition(4)];
            
        end
        
    case 'variable'
        %% Create plots of the performance index under variable wind
        files = dir(fullfile(pwd,'paperData','variableWind'));
        files = files(3:end);
        
        initConditions = {};
        for ii = 1:length(files)
            % Get the name of the initial condition
            ic = regexp(files(ii).name,'\_\D*\_','Match');
            ic = ic{1};
            initConditions{end+1} = ic(2:end-1);
        end
        initConditions = unique(initConditions);
        
        thingsToPlot = {'performanceIndex','meanPAR'};
        
        h={};
        
        for ii = 1:length(initConditions)
            for jj = 1:length(thingsToPlot)
                %% Set things up initially
                h{end+1}.name = initConditions{ii};
                h{end}.fileName = sprintf('%s_%s',initConditions{ii},thingsToPlot{jj});
                h{end}.figure = createFigure();
                % Create the top axes
                h{end}.axTop      = subplot(2,1,1,'FontSize',40);
                %         h{end}.axTop.Position = h{end}.axTop.Position+[0 0 0.05 0];
                grid on;   hold on; axis tight
                xlabel('Iteration Number, $j$')
                
                switch thingsToPlot{jj}
                    case 'performanceIndex'
                        title('Performance Index Vs Iteration Number and Time')
                    case 'meanPAR'
                        title('PAR Vs Iteration Number and Time')
                end
                
                switch thingsToPlot{jj}
                    case 'performanceIndex'
                        ylabel({'Performance','Index'})
                    case 'meanPAR'
                        ylabel('PAR')
                end
                
                % Create the bottom axes
                h{end}.axBottom   = subplot(2,1,2,'FontSize',40);
                grid on;   hold on; axis tight
                xlabel('Time, $t$ [min]')
                
                switch thingsToPlot{jj}
                    case 'performanceIndex'
                        ylabel({'Performance','Index'})
                    case 'meanPAR'
                        ylabel('PAR')
                end
                
                %% Rename the figure so that we can keep them all straight
                h{end}.figure.Name = sprintf('NREL_%s',initConditions{ii});
                
                %% Load the correct file
                load(fullfile(pwd,'paperData','variableWind',sprintf('NREL_%s_optimization.mat',initConditions{ii})),'iter')
                
                %% Actually do the plotting
                h{end}.top.plotOptimization       = plot(iter.performanceIndex,'Parent',h{end}.axTop,'DisplayName','Optimization');
                h{end}.bottom.plotOptimization    = plot(iter.startTimes/60,iter.performanceIndex,'Parent',h{end}.axBottom,'DisplayName','Baseline');
                
                %% Load the correct file
                load(fullfile(pwd,'paperData','variableWind',sprintf('NREL_%s_baseline.mat',initConditions{ii})),'iter')
                
                %% Actually do the plotting
                h{end}.top.plotBaseline       = plot(iter.performanceIndex,'Parent',h{end}.axTop,'DisplayName','Baseline');
                h{end}.bottom.plotBaseline    = plot(iter.startTimes/60,iter.performanceIndex,'Parent',h{end}.axBottom,'DisplayName','Baseline');
                axis tight
                
                %% Format all the plots
                h{end}.top.plotOptimization.Color = 'k';
                h{end}.top.plotOptimization.LineWidth = 2;
                
                h{end}.bottom.plotOptimization.Color = 'k';
                h{end}.bottom.plotOptimization.LineWidth = 2;
                
                h{end}.top.plotBaseline.Color = 0.5*[1 1 1];
                h{end}.top.plotBaseline.LineWidth = 2;
                
                h{end}.bottom.plotBaseline.Color = 0.5*[1 1 1];
                h{end}.bottom.plotBaseline.LineWidth = 2;
                h{end}.legend = legend(h{end}.axTop,'Location','southeast');
                legendPosition = h{end}.legend.Position ;
                h{end}.legend.Position = [legendPosition(1), 0.45, legendPosition(3), legendPosition(4)];
            end
        end
end
end