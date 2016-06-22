function newTracklet = combineTracklets( tracklet1, tracklet2 )
newTracklet = zeros(size(tracklet1));
inds1 = find(tracklet1(:,1));
inds2 = find(tracklet2(:,1));
newTracklet(inds1,:) = tracklet1(inds1,:);
newTracklet(inds2,:) = tracklet2(inds2,:);

% Interpolate
coord1 = newTracklet(inds1(end),:);
coord2 = newTracklet(inds2(1),:);
dist1 = coord1(1) - coord2(1);
dist2 = coord1(2) - coord2(2);
tmpCoord = coord1;
frameGap = inds2(1)-inds1(end);
for i=inds1(end)+1:inds2(1)-1
    if (dist1 > 0)
        tmpCoord(1) = tmpCoord(1) - dist1/frameGap;
    else
        tmpCoord(1) = tmpCoord(1) + abs(dist1)/frameGap;
    end
    if (dist2 > 0)
        tmpCoord(2) = tmpCoord(2) - dist2/frameGap;
    else
        tmpCoord(2) = tmpCoord(2) + abs(dist2)/frameGap;
    end
    newTracklet(i,:) = tmpCoord;

end


end

