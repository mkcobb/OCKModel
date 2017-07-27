% plot BFX
L=r/5;
% Plot BFC unit vectors at the beginning of the simulation
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.BFX_GFC.data(1,1),L*tsc.BFX_GFC.data(1,2),L*tsc.BFX_GFC.data(1,3),'Color','m')
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.BFY_GFC.data(1,1),L*tsc.BFY_GFC.data(1,2),L*tsc.BFY_GFC.data(1,3),'Color','m')
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.BFZ_GFC.data(1,1),L*tsc.BFZ_GFC.data(1,2),L*tsc.BFZ_GFC.data(1,3),'Color','m')

% Plot BFC unit vectors at the end of the simulation
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.BFX_GFC.data(end,1),L*tsc.BFX_GFC.data(end,2),L*tsc.BFX_GFC.data(end,3),'Color','g')
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.BFY_GFC.data(end,1),L*tsc.BFY_GFC.data(end,2),L*tsc.BFY_GFC.data(end,3),'Color','g')
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.BFZ_GFC.data(end,1),L*tsc.BFZ_GFC.data(end,2),L*tsc.BFZ_GFC.data(end,3),'Color','g')
