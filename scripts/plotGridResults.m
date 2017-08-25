close all

fig = figure;
subplot(1,2,1)
gscatter(p.widthsVec',p.heightsVec',p.errorName')
xlabel('Theta, [deg]')
ylabel('Phi, [deg]')

subplot(1,2,2)
surf(reshape(p.widthsVec,[p.nPhi p.nTheta]),reshape(p.heightsVec,[p.nPhi p.nTheta ]),reshape(p.performanceIndex,[p.nPhi p.nTheta]))
xlabel('Theta, [deg]')
ylabel('Phi, [deg]')
zlabel('Performance Index')

saveas(fig,fullfile(pwd,'figures','designSpaceGrid.fig'))
saveas(fig,fullfile(pwd,'figures','designSpaceGrid.png'))

