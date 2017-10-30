
[sphereX,sphereY,sphereZ]=sphere;
sphereX = p.initPositionGFS(1)*sphereX;
sphereY = p.initPositionGFS(1)*sphereY;
sphereZ = p.initPositionGFS(1)*sphereZ;
h.hemisphere = surf(sphereX,sphereY,sphereZ);
% set(h.surf,'EdgeColor','none')
alpha(h.hemisphere,0.5)
clear sphereX sphereY sphereZ