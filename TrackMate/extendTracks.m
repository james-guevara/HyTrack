function newTracklets = extendTracks( tracklets, imageStack, ~, ~)
windowSize = [6 6]; windowSearchSize = 4;
distanceThreshold = 3; intensityThreshold = .5; angleThreshold = .7;
% Extends the tracks obtained from TrackMate using correlation tracker.
[T,~,N] = size(tracklets);
newTracklets = tracklets;
for n=1:N
%     tmpTrack = tracklets(:,:,n);
%     inds = find(tmpTrack(:,1));
%     % if index of first position is greater than 1, track in reverse
%     if (inds(1) > 1)
%         initialCoord = tmpTrack(inds(1),:);
%     end
%     % if index of last position is less than T
%     if (inds(end) < T)
%         finalCoord = tmpTrack(inds(end),:);
%     end
    newTracklets(:,:,n) = trackBack(imageStack, tracklets, windowSize, ...
        distanceThreshold, intensityThreshold, angleThreshold, ...
        windowSearchSize, newTracklets(:,:,n));
    newTracklets(:,:,n) = trackForward(imageStack, tracklets, windowSize, ...
        distanceThreshold, intensityThreshold, angleThreshold, ...
        windowSearchSize, newTracklets(:,:,n));
    

end



end

