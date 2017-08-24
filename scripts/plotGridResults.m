close all

fig = figure;
subplot(1,2,1)
gscatter(p.widthsVec',p.heightsVec',p.errorName')
xlabel('Theta, [deg]')
ylabel('Phi, [deg]')

subplot(1,2,2)
surf(reshape(p.widthsVec,[p.nTheta p.nPhi]),reshape(p.heightsVec,[p.nTheta p.nPhi]),reshape(p.performanceIndex,[p.nTheta p.nPhi]))
xlabel('Theta, [deg]')
ylabel('Phi, [deg]')
zlabel('Performance Index')

