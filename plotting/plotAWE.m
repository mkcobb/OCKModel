
wingX = 0.5*p.refLengthWing * [1 -1 -1  1 1];
wingY = 0.5*p.wingSpan      * [1  1 -1 -1 1];
wingZ = [0 0 0 0 0];

rudderX = 0.5*p.refLengthRudder * [1 -1 -1  1 1]-p.wingSpan;
rudderY = [0 0 0 0 0];
rudderZ = 0.5*p.rudderSpan      * [1  1 -1 -1 1];

fuselageX = [wingX(3) rudderX(1)];
fuselageY = [0 0];
fuselageZ = [0 0];

[wingX  , wingY  , wingZ  ] = bfc2gfc(wingX,wingY,wingZ,pos,eul);
[rudderX, rudderY, rudderZ] = bfc2gfc(rudderX,rudderY,rudderZ,pos,eul);
[fuselageX, fuselageY, fuselageZ] = bfc2gfc(fuselageX,fuselageY,fuselageZ,pos,eul);

if ~isfield(h,'wing') 
    %% If everything has not been plotted once
    h.wing     = plot3(wingX   ,wingY   ,wingZ  , 'Color','k','LineWidth',1);
    h.rudder   = plot3(rudderX ,rudderY ,rudderZ, 'Color','k','LineWidth',1);
    h.fuselage = plot3(fuselageX,fuselageY,fuselageZ,'Color','k','LineWidth',1);
    
    % Plot projection onto planes
    shadowColor = 0.5*ones(1,5);
    h.wingShadowXY = fill3(...
        wingX,...
        wingY,...
        [0 0 0 0 0],shadowColor);
    h.wingShadowXZ = fill3(...
        wingX,...
        p.initPositionGFS(1)*[1 1 1 1 1],...
        wingZ,shadowColor);
    h.wingShadowYZ = fill3(...
        [0 0 0 0 0],...
        wingY,...
        wingZ,shadowColor);
    
    h.rudderShadowXY = fill3(...
        rudderX,...
        rudderY,...
        [0 0 0 0 0],shadowColor);
    h.rudderShadowXZ = fill3(...
        rudderX,...
        p.initPositionGFS(1)*[1 1 1 1 1],...
        rudderZ,shadowColor);
    h.rudderShadowYZ = fill3(...
        [0 0 0 0 0],...
        rudderY,...
        rudderZ,shadowColor);
    
    h.fuselageShadowXY = plot3(...
        fuselageX,...
        fuselageY,...
        [0 0],'Color',0.5*[1 1 1],...
        'LineWidth',1');
    h.fuselageShadowXZ = plot3(...
        fuselageX,...
        p.initPositionGFS(1)*[1 1],...
        fuselageZ,'Color',0.5*[1 1 1],...
        'LineWidth',1');
    h.fuselageShadowYZ = plot3(...
        [0 0],...
        fuselageY,...
        fuselageZ,'Color',0.5*[1 1 1],...
        'LineWidth',1');
else 
    %% Otherwise just update the data 
   h.wing.XData = wingX;
   h.wing.YData = wingY;
   h.wing.ZData = wingZ;
   
   h.rudder.XData = rudderX;
   h.rudder.YData = rudderY;
   h.rudder.ZData = rudderZ;
   
   h.fuselage.XData = fuselageX;
   h.fuselage.YData = fuselageY;
   h.fuselage.ZData = fuselageZ;
   
   h.wingShadowXY.XData = wingX;
   h.wingShadowXY.YData = wingY;
   
   h.wingShadowXZ.XData = wingX;
   h.wingShadowXZ.ZData = wingZ;
   
   h.wingShadowYZ.YData = wingY;
   h.wingShadowYZ.ZData = wingZ;
      
   h.rudderShadowXY.XData = rudderX;
   h.rudderShadowXY.YData = rudderY;
   
   h.rudderShadowXZ.XData = rudderX;
   h.rudderShadowXZ.ZData = rudderZ;
   
   h.rudderShadowYZ.YData = rudderY;
   h.rudderShadowYZ.ZData = rudderZ;
    
   
   h.fuselageShadowXY.XData = fuselageX;
   h.fuselageShadowXY.YData = fuselageY;
   
   h.fuselageShadowXZ.XData = fuselageX;
   h.fuselageShadowXZ.ZData = fuselageZ;
   
   h.fuselageShadowYZ.YData = fuselageY;
   h.fuselageShadowYZ.ZData = fuselageZ;
   
   
end


