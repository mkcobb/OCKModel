
initPositionGFC = tsc.positionGFC.data(1,:);

initVelocityGFC = tsc.velocityGFC.data(1,:);
initVAppWindGFC = tsc.vAppWindGFC.data(1,:);
initVWindGFC    = tsc.vWindGFC.data(1,:);

initvAppWindBFC = tsc.vAppWindBFC.data(1,:);
initVelocityBFC = [p.initVelocity 0 0];
initVWindBFC    = tsc.vWindBFC.data(1,:);

initFWingBFC    = tsc.FWingBFC.data(1,:);
initFWingBFC    = 5*initFWingBFC./sqrt(sum(initFWingBFC.^2));

initFRudderBFC    = tsc.FRudderBFC.data(1,:);
initFRudderBFC    = 5*initFRudderBFC./sqrt(sum(initFRudderBFC.^2));

bfx=tsc.BFX_GFC.data(1,:);
bfy=tsc.BFY_GFC.data(1,:);
bfz=tsc.BFZ_GFC.data(1,:);

subplot(1,2,1)
hold on
% plot the coordinate system
plot3([0 1],[0 0],[0 0],'Color','k')
plot3([0 0],[0 1],[0 0],'Color','k')
plot3([0 0],[0 0],[0 1],'Color','k')

% Plot the body fixed axes
h.bf=plot3([0 bfx(1)],[0 bfx(2)],[0 bfx(3)],'Color','m');
plot3([0 bfy(1)],[0 bfy(2)],[0 bfy(3)],'Color','m')
plot3([0 bfz(1)],[0 bfz(2)],[0 bfz(3)],'Color','m')

% Plot vectors 
plot3([0,initVWindGFC(1)   ],[0,initVWindGFC(2)   ],[0,initVWindGFC(3)   ],'Color','b')
plot3([0,initVelocityGFC(1)],[0,initVelocityGFC(2)],[0,initVelocityGFC(3)],'Color','r')
plot3([initVelocityGFC(1),initVelocityGFC(1)+initVAppWindGFC(1)],...
      [initVelocityGFC(2),initVelocityGFC(2)+initVAppWindGFC(2)],...
      [initVelocityGFC(3),initVelocityGFC(3)+initVAppWindGFC(3)],'Color','g');

view([75 30])
axis equal
xlabel('GFX')
ylabel('GFY')
zlabel('GFZ')
title('Ground Fixed System')
legend([h.bf],{'Body Fixed Axes'})

subplot(1,2,2)
hold on
plot3([0 1],[0 0],[0 0],'Color','m')
plot3([0 0],[0 1],[0 0],'Color','m')
plot3([0 0],[0 0],[0 1],'Color','m')
h.wind         = plot3([0,initVWindBFC(1)   ],[0,initVWindBFC(2)   ],[0,initVWindBFC(3)   ],'Color','b');
h.velocity     = plot3([0,initVelocityBFC(1)],[0,initVelocityBFC(2)],[0,initVelocityBFC(3)],'Color','r');
h.apparentWind = plot3([initVelocityBFC(1),initVelocityBFC(1)+initvAppWindBFC(1)],...
                       [initVelocityBFC(2),initVelocityBFC(2)+initvAppWindBFC(2)],...
                       [initVelocityBFC(3),initVelocityBFC(3)+initvAppWindBFC(3)],'Color','g');
h.fWing   = quiver3(0,0,0,initFWingBFC(1),initFWingBFC(2),initFWingBFC(3),'Color','c');
h.fRudder = quiver3(0,0,0,initFRudderBFC(1),initFRudderBFC(2),initFRudderBFC(3),'Color','k');
                   
view([-75 30])
axis equal
xlabel('BFX')
ylabel('BFY')
zlabel('BFZ')
title('Body Fixed System')
legend([h.wind h.velocity h.apparentWind h.fWing h.fRudder],{'Wind','Velocity','Apparent Wind','Force On Wing','Force on Rudder'})
