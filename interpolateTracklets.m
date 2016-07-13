function [newTracklets, trackletIndices] = interpolateTracklets( tracklets, assignments, state_interpolations, gpParams )
[T,~,N] = size(tracklets);
trackletIndices = {};
newAssignments = assignments;
% Obtain indices for same tracklets
k = 1;
for n=1:N
    if (newAssignments(n) ~= 0 && newAssignments(n) ~= n)
        indices = [];
        indices(1) = n;
        prevIndex  = newAssignments(n);
        counter   = 2;
        while (prevIndex < N)
            indices(counter) = prevIndex;
            prevIndex = newAssignments(prevIndex);
            newAssignments(indices(counter)) = 0;
            counter = counter + 1;
        end
        trackletIndices{k,1} = indices;
        k = k + 1;
    end
end
% Build new tracks
numTracks = length(trackletIndices);
newTracklets = zeros(T,2,numTracks);
for i=1:numTracks
    tmpIndices = trackletIndices{i};
    for j=1:length(tmpIndices)
        tmpTracklet = tracklets(:,:,tmpIndices(j));
        positionIndices = find(tmpTracklet(:,1));
        newTracklets(positionIndices,:,i) = tmpTracklet(positionIndices,:);
    end
end

S = size(state_interpolations,1);
counter = 1;
for i=1:numTracks
    tmpIndices = trackletIndices{i};
    if length(tmpIndices) > 1
        for j=1:length(tmpIndices)-1
            tmpIndex1 = tmpIndices(j); tmpIndex2 = tmpIndices(j+1);
            for k=counter:S
                if state_interpolations{k,1} == tmpIndex1 && state_interpolations{k,2} == tmpIndex2
                    tmpStates = state_interpolations{k,3};
                    if size(tmpStates,1) > 2
                        tracklet1 = tracklets(:,:,tmpIndex1); tracklet2 = tracklets(:,:,tmpIndex2);
                        inds1 = find(tracklet1(:,1)); tracklet1_end = inds1(end);
                        inds2 = find(tracklet2(:,1)); tracklet2_sta = inds2(1);
                        newTracklets(tracklet1_end+1:tracklet2_sta-1,:,i) = round(tmpStates(2:end-1,:));
                    end
                    counter = counter + 1;
                    break;
                end
            end
        end
    end
end

% Fill in tracklets (remaining holes)
[~,~,N] = size(newTracklets);
for n=1:N
    newTracklets(:,:,n) = interpolateTracklet(newTracklets(:,:,n),gpParams,newTracklets);
end




end
