function ReCl = calculateReCl(plant,env)


ReCl = ((plant.refLengthWing)/(env.viscosity))*sqrt((2*env.g*plant.mass*env.rho)/(plant.refAreaWing));

end