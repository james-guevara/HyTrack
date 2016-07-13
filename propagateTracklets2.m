function [ newTracklets ] = propagateTracklets2( tracklets, trackletIndices, gpParameters, trackletData )
[T,~,N] = size(tracklets);
numInds = length(trackletIndices);
newTracklets = tracklets;
for n=1:numInds
    trackletIndex = trackletIndices(n);
    oldTracklet = tracklets(:,:,trackletIndex);
    timeIndices = find(oldTracklet(:,1));
    if timeIndices(1) > 1
        [prevState,prevCovariance,prevStates] = propagateStateGP(oldTracklet(timeIndices(1),:),timeIndices(1),1,gpParameters,trackletData); 
        oldTracklet(timeIndices(1)-1:-1:1,:) = prevStates(2:end,:);
    end
    if timeIndices(end) < T
        [finaState,finaCovariance,finaStates] = propagateStateGP(oldTracklet(timeIndices(end),:),timeIndices(end),T,gpParameters,trackletData);
        oldTracklet(timeIndices(end)+1:end,:) = finaStates(2:end,:);
    end
    newTracklets(:,:,trackletIndex) = oldTracklet;
end

end

