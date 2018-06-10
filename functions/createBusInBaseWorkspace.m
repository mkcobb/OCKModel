function createBusInBaseWorkspace(busElementData,busName)

for ii = 1:length(busElementData)
    elems(ii) = Simulink.BusElement;
    elems(ii).Name = busElementData{ii,1};
    elems(ii).Dimensions = busElementData{ii,2};
    elems(ii).DimensionsMode = 'Fixed';
    elems(ii).DataType = 'double';
    elems(ii).SampleTime = -1;
    elems(ii).Complexity = 'real';
end
CONTROL = Simulink.Bus;
CONTROL.Elements = elems;
assignin('base',busName,CONTROL)

end