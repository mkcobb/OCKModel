close all

h.fig = createFigure()

plot(plant.wingTable.alpha,plant.wingTable.cdUncorrected,'DisplayName','Uncorrected')
hold on
grid on
plot(plant.wingTable.alpha,plant.wingTable.cd,'DisplayName','OswaldCorrection')
plot(plant.wingTable.alpha,plant.wingTable.cdPrandtl1,'DisplayName','Option 1')
plot(plant.wingTable.alpha,plant.wingTable.cdPrandtl2,'DisplayName','Option 2')
plot(plant.wingTable.alpha,plant.wingTable.cdPrandtl3,'DisplayName','Option 3')
plot(plant.wingTable.alpha,plant.wingTable.cdPrandtl4,'DisplayName','Option 4')

legend