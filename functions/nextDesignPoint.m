function p = nextDesignPoint(p)
if numel(p.Beta) == 0 % Use this part during initialization
    
    % Do the surface fit
    p.V{1} = inv((p.XInit'*p.XInit));
    p.Beta{1} = p.V{1}*p.XInit'*p.performanceIndexInit';
        
    % Calculate optimal design point
    optimalWidth = -p.Beta{1}(4)/(2*p.Beta{1}(5));
    optimalHeight = -p.Beta{1}(2)/(2*p.Beta{1}(3));
    
    % Saturate optimal design point
    p.widthsVec(1)  = p.thetaInit(1) + max(-p.thetaDistanceLim ,min([p.thetaDistanceLim optimalWidth-p.thetaInit(1)]));
    p.heightsVec(1) = p.phiInit(1)   + max(-p.phiDistanceLim   ,min([p.phiDistanceLim   optimalHeight-p.phiInit(1) ]));
    %
    %     % Plotting (for debug purposes)
    %     figure
    %     scatter3(p.thetaInit',p.phiInit',p.performanceIndexInit',...
    %         200*ones(size(p.thetaInit')),repmat([1 0 0],numel(p.thetaInit'),1))
    %     hold on
    %     [phi,theta]=meshgrid(linspace(p.phiInit(1)-2*p.phiInitSep,p.phiInit(1)+2*p.phiInitSep),...
    %         linspace(p.thetaInit(1)-2*p.thetaInitSep,p.thetaInit(1)+2*p.thetaInitSep));
    %     J = p.Beta{1}(1)*ones(size(phi))+p.Beta{1}(2)*phi+p.Beta{1}(3)*phi.^2+...
    %         +p.Beta{1}(4)*theta+p.Beta{1}(5)*theta.^2;
    %     surf(theta,phi,J)
    %     scatter3(p.widthsVec(1),p.heightsVec(1),p.Beta{1}(1)+...
    %         p.Beta{1}(2)*p.heightsVec(1)+p.Beta{1}(3)*p.heightsVec(1).^2+...
    %         p.Beta{1}(4)*p.widthsVec(1)+p.Beta{1}(5)*p.widthsVec(1).^2,200,[0 1 0])
    %     xlabel('theta')
    %     ylabel('phi')
    %     zlabel('Performance Index')
else % Use this part during optimization
    p.xOpt{end+1} = [1 p.widthsVec(end) p.widthsVec(end)^2 p.heightsVec(end) p.heightsVec(end)^2];
    V=p.V{end};
    x=p.xOpt{end};
    p.V{end+1}    = (1/p.forgettingFactor)*(V-(V*x'*x*V)/(1+x*V*x'));
    p.Beta{end+1} = p.Beta{end}+(p.V{end}*p.xOpt{end}')*(p.performanceIndexOpt(end)-p.xOpt{end}*p.Beta{end});
    
    % Calculate optimal design point
    optimalWidth = -p.Beta{end}(4)/(2*p.Beta{end}(5));
    optimalHeight = -p.Beta{end}(2)/(2*p.Beta{end}(3));
    
    % Saturate optimal design point
    p.widthsVec(end+1)  = p.widthsVec(end) + max(-p.thetaDistanceLim ,min([p.thetaDistanceLim optimalWidth-p.widthsVec(end)]));
    p.heightsVec(end+1) = p.heightsVec(end)   + max(-p.phiDistanceLim   ,min([p.phiDistanceLim   optimalHeight-p.heightsVec(end) ]));
    
    
    % Plotting (for debug purposes)
    figure
    % Plot Initialization Points
    h.initPts  = scatter3(p.thetaInit',p.phiInit',p.performanceIndexInit',...
        200*ones(size(p.thetaInit')),repmat([0 0 1],numel(p.thetaInit'),1));
    hold on
    % Plot points which have been tested
    h.optPts = scatter3(p.widthsVec(1:end-1)',p.heightsVec(1:end-1)',p.performanceIndexOpt',...
        200*ones(size(p.widthsVec(1:end-1)')),repmat([1 0 0],numel(p.widthsVec(1:end-1)'),1));
    [phi,theta]=meshgrid(linspace(min([p.phiInit,p.heightsVec])-2*p.phiInitSep,max([p.phiInit,p.heightsVec])+2*p.phiInitSep),...
        linspace(min([p.thetaInit,p.widthsVec])-2*p.thetaInitSep,max([p.thetaInit,p.widthsVec])+2*p.thetaInitSep));
    J = p.Beta{end}(1)*ones(size(phi))+p.Beta{end}(2)*phi+p.Beta{end}(3)*phi.^2+...
        +p.Beta{end}(4)*theta+p.Beta{end}(5)*theta.^2;
    % Plot our best guess of the surface
    h.surf = surf(theta,phi,J);
    % Plot the next point to be tested
    h.nextPt = scatter3(p.widthsVec(end),p.heightsVec(end),p.Beta{end}(1)+...
        p.Beta{end}(2)*p.heightsVec(end)+p.Beta{end}(3)*p.heightsVec(end).^2+...
        p.Beta{end}(4)*p.widthsVec(end)+p.Beta{end}(5)*p.widthsVec(end).^2,200,[0 1 0]);
    xlabel('theta')
    ylabel('phi')
    zlabel('Performance Index')
    legend([h.initPts h.optPts h.surf h.nextPt],{'Init Points','Opt Points','Est. Surface','Next Pt'})
    sprintf('')
end

end