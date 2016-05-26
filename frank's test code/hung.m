function [assignment,cost] = hung(tracklets,imgStack,windowSize)%detError)
t=size(tracklets);
trackNum=t(3);
% inf=-1.79769e+308 ;
costMat=zeros(2*trackNum);

%variables
Pinit=log(1/trackNum);
gpCov = [3.8438; -3.6444];
gpLik = -2.0525;
gpParameters.cov = gpCov;
gpParameters.lik = gpLik;



for ii=1:2*trackNum
    
    for jj=1:2*trackNum
     % jj
        if ii==jj && jj<=trackNum
           costMat(ii,jj)= -inf;
        
        elseif ii<=trackNum && jj<=trackNum && ii~=jj
            costMat(ii,jj)=plink(tracklets(:,:,jj),tracklets(:,:,ii),imgStack,windowSize,gpParameters);
        
        elseif ii==(jj+trackNum)
            costMat(ii,jj)=Pinit;
        
        elseif ii+trackNum==jj
            costMat(ii,jj)=Pinit;
        elseif ii>trackNum && jj>trackNum
            costMat(ii,jj)=0;
        else
            costMat(ii,jj)=-inf;
        end
        
    end
end

[assignment,cost] = munkres(costMat);

function plink = plink(track1,track2,imgStack,windowSize,gpParameters)
tmp1=find(track1(:,1));
tmp2=find(track2(:,1));
start=tmp1(1);
finish=tmp2(end);
gap=finish-start;
if gap<0 || gap>200
    plink=-inf;
else
    g1=averageTemplate(imgStack,track1,windowSize);
    g2=averageTemplate(imgStack,track2,windowSize);
    k=imagesAngle(g1,g2);
    
    
    trackletVelocity2 = getTrackletVelocity(track2);
    trackletData2= [track2 trackletVelocity2];
    [finalState, cov]=propagateState( track2(finish,:), finish, gap, gpParameters, trackletData2);
    var=cov(1);
    dist2=dist(finalState, track1(start,:));
    k2=normpdf(dist2,0,var);
    plink=k*k2;
end
end

function distance = dist(a,b)
        distance = sqrt((a(1)-b(1))^2 + (a(2)-b(2))^2);
    end



end













