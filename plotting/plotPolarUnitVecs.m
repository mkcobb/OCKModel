% plot BFX
L=p.initPositionGFS(1)/5;
% Plot polar unit vectors at the beginning of the simulation
h.rUnitVecInit      = quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.rHatGFC.data(1,1)       ,L*tsc.rHatGFC.data(1,2)      ,L*tsc.rHatGFC.data(1,3)    ,'Color','b');
h.thetaUnitVecInit  = quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.thetaHatGFC.data(1,1)   ,L*tsc.thetaHatGFC.data(1,2)  ,L*tsc.thetaHatGFC.data(1,3),'Color','b');
h.phiUnitVecInit    = quiver3(tsc.positionGFC.data(1,1),tsc.positionGFC.data(1,2),tsc.positionGFC.data(1,3),L*tsc.phiHatGFC.data(1,1)     ,L*tsc.phiHatGFC.data(1,2)    ,L*tsc.phiHatGFC.data(1,3)  ,'Color','b');

% Plot polar unit vectors at the end of the simulation
h.rUnitVecFinal     = quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.rHatGFC.data(end,1)       ,L*tsc.rHatGFC.data(end,2)      ,L*tsc.rHatGFC.data(end,3)    ,'Color','r');
h.thetaUnitVecFinal = quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.thetaHatGFC.data(end,1)   ,L*tsc.thetaHatGFC.data(end,2)  ,L*tsc.thetaHatGFC.data(end,3),'Color','r');
h.phiUnitVecFinal   = quiver3(tsc.positionGFC.data(end,1),tsc.positionGFC.data(end,2),tsc.positionGFC.data(end,3),L*tsc.phiHatGFC.data(end,1)     ,L*tsc.phiHatGFC.data(end,2)    ,L*tsc.phiHatGFC.data(end,3)  ,'Color','r');

clear L