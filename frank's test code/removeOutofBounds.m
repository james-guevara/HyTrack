function [ newTracklets ] = removeOutofBounds( oldTracklets )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
t=size(oldTracklets);
trackNum=t(3);

for ii=1:trackNum
    track=oldTracklets(:,:,ii);
    tmp1=find(track(:,1));
    if isempty(tmp1)
    
    end
end

end

