% plot BFX
L=r/5;
% Plot polar unit vectors at the beginning of the simulation
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.rHatGFC.data(1,1)       ,L*tsc.rHatGFC.data(1,2)      ,L*tsc.rHatGFC.data(1,3),'Color','b')
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.thetaHatGFC.data(1,1)   ,L*tsc.thetaHatGFC.data(1,2)  ,L*tsc.thetaHatGFC.data(1,3),'Color','b')
quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.phiHatGFC.data(1,1)     ,L*tsc.phiHatGFC.data(1,2)    ,L*tsc.phiHatGFC.data(1,3),'Color','b')

% Plot polar unit vectors at the end of the simulation
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.rHatGFC.data(end,1)       ,L*tsc.rHatGFC.data(end,2)      ,L*tsc.rHatGFC.data(end,3),'Color','r')
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.thetaHatGFC.data(end,1)   ,L*tsc.thetaHatGFC.data(end,2)  ,L*tsc.thetaHatGFC.data(end,3),'Color','r')
quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.phiHatGFC.data(end,1)     ,L*tsc.phiHatGFC.data(end,2)    ,L*tsc.phiHatGFC.data(end,3),'Color','r')

