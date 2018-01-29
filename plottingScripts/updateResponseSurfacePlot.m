if ~isvalid(hFig)
    hFig  = figure;
    axPAR = subplot(2,2,1);
    hSurfPAR = surf(widths,heights,meanPAR);
    xlabel(axPAR,'W')
    ylabel(axPAR,'H')
    zlabel(axPAR,'PAR')
    
    axNSE = subplot(2,2,2);
    hSurfNSE = surf(widths,heights,normalizedSpatialError);
    xlabel(axNSE,'W')
    ylabel(axNSE,'H')
    zlabel(axNSE,'NSE')
    
    axMCE = subplot(2,2,3);
    hSurfMCE = surf(widths,heights,momentBasedControlEnergy);
    xlabel(axMCE,'W')
    ylabel(axMCE,'H')
    zlabel(axMCE,'MCE')
    
    axCCE = subplot(2,2,4);
    hSurfCCE = surf(widths,heights,commandBasedControlEnergy);
    xlabel(axCCE,'W')
    ylabel(axCCE,'H')
    zlabel(axCCE,'CCE')
    
else
    hSurfPAR.ZData = meanPAR;
    hSurfNSE.ZData = normalizedSpatialError;
    hSurfMCE.ZData = momentBasedControlEnergy;
    hSurfCCE.ZData = commandBasedControlEnergy;
    drawnow
end