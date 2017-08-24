if p.waypointsOnOff
    waypointTimes      = tsc.time([diff(tsc.currentWaypointIndex.data);0]>0);
    waypointTimes(end) = tsc.time(end);
    hax=gca;
    for ii = 1:length(waypointTimes)
        line(waypointTimes(ii)*[1 1],hax.YLim,'Color', [1 0.78 0.80]);
        text(waypointTimes(ii),hax.YLim(2),num2str(ii))
    end
end