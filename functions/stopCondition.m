function stopContinue = stopCondition(p)
if length(p.widthsVec)<p.convergenceLim+1
    stopContinue = 1;
else
    stopContinue = 0;
%     [~,indicesToCheck] = min([length(p.widthsVec),length(p.heightsVec),p.convergenceLim]);
%     if sum(sum(abs(diff(p.widthsVec(end-indicesToCheck:end))))<p.thetaDistanceLim)<p.convergenceLim...
%             && sum(sum(abs(diff(p.heightsVec(end-indicesToCheck:end))))<p.phiDistanceLim)<p.convergenceLim
%         stopContinue = 0;
%     else
%         stopContinue = 1;
%     end
    
end
% stopContinue = 1;
end