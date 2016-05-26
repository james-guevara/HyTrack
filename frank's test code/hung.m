function [assignment,cost] = hung(tracklets,imgStack,windowSize)%detError)
trackNum=length(tracklets);
inf=-1.79769e+308 ;
costMat=zeros(2*trackNum);

%variables
Pinit=log(1/140);

for ii=1:2*trackNum
    for jj=1:2*trackNum
        if ii==jj && jj<=trackNum
           costMat(ii,jj)= inf;
        
        elseif ii<=trackNum && jj<=trackNum && ii~=jj
            costMat(ii,jj)=plink(tracklets(:,:,jj),tracklets(:,:,ii));
        
        elseif ii==(jj+trackNum)
            costMat(ii,jj)=Pinit;
        
        elseif ii+trackNum==jj
            costMat(ii,jj)=Pinit;
        elseif ii>trackNum && jj>trackNum
            costMat(ii,jj)=0;
        else
            costMat(ii,jj)=inf;
        end
        
    end
end

function plink = plink(track1,track2)
plink=0;
