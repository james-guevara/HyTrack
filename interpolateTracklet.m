function newTracklet = interpolateTracklet( tracklet, gpParams, tracklets )
% Uses Gaussian process propagation to fill in gaps in tracklet.
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
newTracklet = tracklet;
inds = find(newTracklet(:,1));
% diffs = diff(inds);
% gaps = inds(find(diffs>1));
% numGaps = length(gaps);
% while (numGaps > 0)
%     gapStart = inds(gaps(1));
%     gapLength = diffs(gaps(1));
%     [finalState, stateCovariance, states] = propagateState(newTracklet(gapStart,:),gapStart,gapLength,gpParams,trackletData);
%     newTracklet(gapStart+1:gapStart+gapLength-1,:) = states(2:end-1,:);
%     inds = find(newTracklet(:,1));
%     diffs = diff(inds);
%     gaps = find(diffs>1);
%     numGaps = length(gaps);
% end

indSta = inds(1);
indEnd = inds(end);
T = size(tracklets,1);
gaps = [];
counter = 1;
for t=indSta:indEnd
    if (tracklet(t,1) == 0 && tracklet(t,2) == 0)
        gaps(counter,1) = t;
        counter = counter + 1;
    end
end

2



end

