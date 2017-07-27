
[sphereX,sphereY,sphereZ]=sphere;
sphereX=r*sphereX;
sphereY=r*sphereY;
sphereZ=r*sphereZ;
h.surf = surf(sphereX,sphereY,sphereZ);
set(h.surf,'EdgeColor','none')
alpha(h.surf,0.5)