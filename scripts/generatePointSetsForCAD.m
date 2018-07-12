% This script generates xyz points in a .sldcrv file that will form the
% outline of the wing, rudder and horizontal stabilizer.

%% Wing End 1 file
basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

wingFileName = 'wing1.sldcrv';

fileID = fopen(fullfile(basePath,wingFileName),'w');

[wingX,wingZ]=loadShapeFile(plant.wingShapeFileName);

% Scale to appropriate size
wingX = wingX*plant.refLengthWing-plant.refLengthWing/2;
wingZ = wingZ*plant.refLengthWing;
wingY = (plant.wingSpan/2)*ones(size(wingX)); % Offset in y direction to start sweep in CAD

% Convert to in
wingX = -39.3701*wingX; % Flip the x coordinate so that the leading edge is pointed towards +x dir
wingY = 39.3701*wingY;
wingZ = 39.3701*wingZ;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[wingX';wingY';wingZ']);
% fclose(fileID);

fclose('all');

%% Wing End 2 file
basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

wingFileName = 'wing2.sldcrv';

fileID = fopen(fullfile(basePath,wingFileName),'w');

[wingX,wingZ] = loadShapeFile(plant.wingShapeFileName);

% Scale to appropriate size
wingX = wingX*plant.refLengthWing-plant.refLengthWing/2;
wingZ = wingZ*plant.refLengthWing;
wingY = -(plant.wingSpan/2)*ones(size(wingX)); % Offset in y direction to start sweep in CAD

% Convert to in
wingX = -39.3701*wingX; % Flip the x coordinate so that the leading edge is pointed towards +x dir
wingY = 39.3701*wingY;
wingZ = 39.3701*wingZ;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[wingX';wingY';wingZ']);
% fclose(fileID);

fclose('all');


%% Rudder Tip File
rudderTipScaleFactor = 0.75;

basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

rudderFileName = 'rudderTip.sldcrv';

fileID = fopen(fullfile(basePath,rudderFileName),'w');

[rudderX,rudderY] = loadShapeFile(plant.rudderShapeFileName);

% Flip and shift so that it goes in -x direction
rudderX = -rudderX+1;

% Scale to appropriate size
rudderX = rudderTipScaleFactor*rudderX*plant.refLengthRudder;
rudderY = rudderTipScaleFactor*rudderY*plant.refLengthRudder;
rudderZ = zeros(size(rudderX))+plant.rudderSpan;

% Move backwards
rudderX = rudderX - plant.momentArm - rudderTipScaleFactor*plant.refLengthRudder/2;
% Convert to in
rudderX = 39.3701*rudderX;
rudderY = 39.3701*rudderY;
rudderZ = 39.3701*rudderZ;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[rudderX';rudderY';rudderZ']);
% fclose(fileID);

fclose('all');

%% Rudder Base File
rudderBaseScaleFactor = 1.75;

basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

rudderFileName = 'rudderBase.sldcrv';

fileID = fopen(fullfile(basePath,rudderFileName),'w');

[rudderX,rudderY]=loadShapeFile(plant.rudderShapeFileName);

% Flip and shift so that it goes in -x direction
rudderX = -rudderX+1;

% Scale to appropriate size
rudderX = rudderBaseScaleFactor*rudderX*plant.refLengthRudder;
rudderY = rudderBaseScaleFactor*rudderY*plant.refLengthRudder;
rudderZ = zeros(size(rudderX));

% Move backwards
rudderX = rudderX - plant.momentArm - rudderTipScaleFactor*plant.refLengthRudder/2;

% Convert to in
rudderX = 39.3701*rudderX;
rudderY = 39.3701*rudderY;
rudderZ = 39.3701*rudderZ;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[rudderX';rudderY';rudderZ']);
% fclose(fileID);

fclose('all');


%% Stabilizer Tip 1
basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

stabilizerFileName = 'stabilizerTip1.sldcrv';

fileID = fopen(fullfile(basePath,stabilizerFileName),'w');

[stabilizerX,stabilizerZ]=loadShapeFile(plant.stabilizerShapeFileName);

stabilizerX = -stabilizerX+1;

% Scale to appropriate size
stabilizerX = stabilizerX*plant.refLengthStabilizer; % Flip the direction so it points forward in CAD
stabilizerZ = stabilizerZ*plant.refLengthStabilizer;
stabilizerY = zeros(size(stabilizerX))+plant.stabilizerSpan/2;

% Convert to in
stabilizerX = 39.3701*stabilizerX;
stabilizerY = 39.3701*stabilizerY+6;
stabilizerZ = 39.3701*stabilizerZ;

% Move backwards
stabilizerX = stabilizerX - plant.momentArm*39.3071+(plant.refLengthStabilizer/2)*39.3071;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[stabilizerX';stabilizerY';stabilizerZ']);

fclose('all');

%% Stabilizer Tip 2
basePath = fullfile(fileparts(fileparts(which('OCKModel.slx'))),'CAD');

stabilizerFileName = 'stabilizerTip2.sldcrv';

fileID = fopen(fullfile(basePath,stabilizerFileName),'w');

[stabilizerX,stabilizerZ]=loadShapeFile(plant.stabilizerShapeFileName);

% Scale to appropriate size
stabilizerX = -stabilizerX*plant.refLengthStabilizer; % Flip the direction so it points forward in CAD
stabilizerZ = stabilizerZ*plant.refLengthStabilizer;
stabilizerY = zeros(size(stabilizerX))-plant.stabilizerSpan/2;


% Convert to in
stabilizerX = 39.3701*stabilizerX;
stabilizerY = 39.3701*stabilizerY-6;
stabilizerZ = 39.3701*stabilizerZ;

% Move backwards
stabilizerX = stabilizerX - plant.momentArm*39.3071+(plant.refLengthStabilizer/2)*39.3071;

% fileID = fopen('exp.txt','w');
fprintf(fileID,'%.2fin %.2fin %.2fin\r\n',[stabilizerX';stabilizerY';stabilizerZ']);

fclose('all');


