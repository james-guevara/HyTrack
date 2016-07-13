function newTracklet = interpolateTracklet( tracklet, gpParams, tracklets )
% Uses Gaussian process propagation to fill in gaps in tracklet.
trackletVelocities = getTrackletVelocities(tracklets);
trackletData = [tracklets trackletVelocities];
newTracklet = tracklet;
inds = find(newTracklet(:,1));
diffs = diff(inds);
gaps = find(diffs > 1);
numGaps = length(gaps);
while (numGaps > 0)
    gapStart = inds(gaps(1));
    gapLength = diffs(gaps(1));
    [finalState, stateCovariance, states] = propagateState(newTracklet(gapStart,:),gapStart,gapLength,gpParams,trackletData);
    newTracklet(gapStart+1:gapStart+gapLength-1,:) = states(2:end-1,:);
    inds = find(newTracklet(:,1));
    diffs = diff(inds);
    gaps = find(diffs>1);
    numGaps = length(gaps);
end





end

