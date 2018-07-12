close all

%% Plot aerodynamics of wing
h = plotAirfoilParameters('w');
savePlot(h.fig,'WingAeroParameters');

%% Plot Lemniscates
h.fig = createFigure();
h.ax = plot3(tsc.positionGFC.data(:,1),...
    tsc.positionGFC.data(:,2),...
    tsc.positionGFC.data(:,3),...
    'LineWidth',2,...
    'Color','b');
grid on

axis equal
axis square
xlim([0 max(tsc.positionGFC.data(:,1))])
zlim([0 max(tsc.positionGFC.data(:,3))])
daspect([1 1 1])
xlabel('x [m]')
ylabel('y [m]')
zlabel('z [m]')
set(gca,'FontSize',24)

savePlot(h.fig,'Path')

%% Plot Spherical Position
h.fig = createFigure();

h.ax1 = subplot(3,1,1);
plot(tsc.time,tsc.positionGFS.data(:,1),...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel('Radius, [m]')
h.ax1.FontSize = 18;


h.ax2 = subplot(3,1,2);
plot(tsc.time,tsc.positionGFS.data(:,2)*180/pi,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel('Azimuth, [deg]')
h.ax2.FontSize = 18;


h.ax3 = subplot(3,1,3);
plot(tsc.time,tsc.positionGFS.data(:,3)*180/pi,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel('Zenith, [m]')
h.ax3.FontSize = 18;

linkaxes([h.ax1 h.ax2 h.ax3],'x')

savePlot(h.fig,'SpericalPosition');

%% Plot Tether Tension, Reel out and Power

h.fig = createFigure();

h.ax1 = subplot(3,1,1);
plot(tsc.time,tsc.radiusRate.data,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel({'Reel Out','Speed, [m/s]'})
h.ax1.FontSize = 18;


h.ax2 = subplot(3,1,2);
plot(tsc.time,tsc.tetherTension.data,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel({'Tether','Tension, [N]'})
h.ax2.FontSize = 18;


h.ax3 = subplot(3,1,3);
plot(tsc.time,tsc.powerEstimate.data,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel('Power, [W]')
h.ax3.FontSize = 18;

linkaxes([h.ax1 h.ax2 h.ax3],'x')

savePlot(h.fig,'PowerSummary');

%% Plot speed
h.fig = createFigure();

plot(tsc.time,tsc.BFXDot.data,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel({'Speed, [m/s]'})
set(gca,'FontSize',24)

savePlot(h.fig,'Speed')

% Plot energy generation

h.fig = createFigure();
plot(tsc.time,tsc.netEnergy.data*10^-6,...
    'LineWidth',2,...
    'Color','k')
grid on
xlabel('Time, t [s]')
ylabel({'Net Energy, [MJ]'})
set(gca,'FontSize',24)

savePlot(h.fig,'NetEnergy')
