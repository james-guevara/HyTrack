function [newTracklets, trackletIndices] = mergeTracklets( tracklets, assignments )
% [T,~,N] = size(tracklets);
% newAssignment = assignment;
% newTracklets = zeros(size(tracklets));
% counter = 1;
% for n=1:N
%     indexOne = n;
%     indexTwo = newAssignment(n);
%     if (indexTwo > N)
%         newTracklets(:,:,counter) = tracklets(:,:,indexOne);
%         counter = counter + 1;
%     else
%         trackletOne = tracklets(:,:,indexOne);
%         indsOne = find(trackletOne(:,1));
%         newTracklets(indsOne,:,counter) = trackletOne(indsOne,:);
%         trackletTwo = tracklets(:,:,indexTwo);
%         indsTwo = find(trackletTwo(:,1));
%         newTracklets(indsTwo,:,counter) = trackletTwo(indsTwo,:);
%         counter = counter + 1;
%     end
% end
% 
% newTracklets = newTracklets(:,:,1:counter-1);


[T,~,N] = size(tracklets);
trackletIndices = {};
newAssignments = assignments;
% Obtain indices for same tracklets
k = 1;
for n=1:N
    if (newAssignments(n) ~= 0)
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









end

