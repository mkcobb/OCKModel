function createBusInBaseWorkspace(busElementData,busName)

for ii = 1:size(busElementData,1)
    elems(ii) = Simulink.BusElement;
    elems(ii).Name = busElementData{ii,1};
    elems(ii).Dimensions = busElementData{ii,2};
    elems(ii).DimensionsMode = 'Fixed';
    elems(ii).DataType = busElementData{ii,3};
    elems(ii).SampleTime = -1;
    elems(ii).Complexity = 'real';
end


CONTROL = Simulink.Bus;
CONTROL.Elements = elems;
assignin('base',busName,CONTROL)

end