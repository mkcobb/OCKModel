function [xgfc,ygfc,zgfc]=bfc2gfc(xbfc,ybfc,zbfc,pos,eul)
R=eul2rotm(eul);
xgfc=zeros(size(xbfc));
ygfc=zeros(size(ybfc));
zgfc=zeros(size(zbfc));
for ii = 1:length(xbfc)
    rbfc=[xbfc(ii) ybfc(ii) zbfc(ii)]';
    rgfc = R*rbfc+pos';
    xgfc(ii) = rgfc(1);
    ygfc(ii) = rgfc(2);
    zgfc(ii) = rgfc(3);
    
end


end