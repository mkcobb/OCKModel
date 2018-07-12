function [x,y] = loadShapeFile(fileName)
% Go find the shape file for the wing
file = fullfile(fileparts(which('OCKModel.slx')),'hydrofoilLibrary','shapeFiles',fileName);
delimiter = ' ';
startRow = 2;
formatSpec = '%f%f%[^\n\r]';

%% Open the text file.
fileID = fopen(file,'r');

%% Read columns of data according to the format.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
x = dataArray{:,1};
y = dataArray{:,2};

end