function velocity = getTrackletVelocity( tracklet )
xCoords = tracklet(:,1);
yCoords = tracklet(:,2);
T = numel(xCoords);
inds = find(xCoords);
velocity = zeros(T,2);
% Only one track coordinate
if (numel(inds) < 2)
    return;
end
for i=inds(1):inds(end-1)
    velocity(i,1) = xCoords(i+1)-xCoords(i);
    velocity(i,2) = yCoords(i+1)-yCoords(i);
end

end

